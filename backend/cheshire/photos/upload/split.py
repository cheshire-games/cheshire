from pathlib import Path

import cv2
import numpy as np

from cheshire.logger import logger
from cheshire.photos.upload import mkdir_override, ALLOWED_EXTENSIONS


def split_images(input_path: Path, output_directory: Path) -> Path:
    output_directory: Path = output_directory / "split_images"
    mkdir_override(directory_path=output_directory)

    for file in Path(input_path).glob("*"):
        if file.suffix in ALLOWED_EXTENSIONS:
            logger.info(f"Splitting image {str(file)} to its distinct big objects")
            # Load the image
            source_image = cv2.imread(str(file))

            # Convert image to grayscale
            grayscale_image = cv2.cvtColor(source_image, cv2.COLOR_BGR2GRAY)

            # Save the image
            cv2.imwrite(
                str(output_directory / (file.stem + "_grayscale." + file.suffix)), grayscale_image
            )

            # Remove gaussian noise
            denoised_image = cv2.GaussianBlur(grayscale_image, (3, 3), 0)

            # Detect edges 160 and 210 : min and max thresholds. Look at the saved image after tweakings,
            # in order to find the right values.
            edges = cv2.Canny(denoised_image, 400, 600)

            # Save the image
            cv2.imwrite(str(output_directory / (file.stem + "_edges." + file.suffix)), edges)

            # Use erode and dilate to remove unwanted edges and close gaps of some edges. Again, tweak the kernel
            # values as needed

            # Erode will make the edges thinner. If the kernel size is big, some edges will be removed.
            # (1,1) will erode a little, (2,2) will erode more, (5,5) will erode even more...
            kernel = np.ones((1, 1), np.uint8)
            eroded_edges = cv2.erode(edges, kernel, iterations=10)

            # dilate will smooth the edges
            # (1,1) will dilate a little, (2,2) will dilate more, (5,5) will dilate even more...
            kernel = np.ones((3, 3), np.uint8)
            dilated_edges = cv2.dilate(eroded_edges, kernel, iterations=1)

            # Find contours
            # Use a copy of the image: findContours alters the image
            dilated_edges_copy = dilated_edges.copy()
            ret, thresh = cv2.threshold(dilated_edges_copy, 127, 255, 0)
            contours, hierarchy = cv2.findContours(thresh, cv2.RETR_TREE, cv2.CHAIN_APPROX_SIMPLE)
            # We could have used v2.RETR_EXTERNAL and CHAIN_APPROX_NONE too

            # Create a list containing only the contours parents from the hierarchy returned by findContours
            hierarchy_parents_only = [x[3] for x in hierarchy[0]]

            print("Number of contours found: ", len(contours))
            print("Number of hierarchies found: ", len(hierarchy_parents_only))

            # Now we will filter the contours. We select only the ones we need.
            selected_contours = list()
            selected_hierarchy = list()
            min_area = 100

            for index, contour in enumerate(contours):
                # Keep only contours having no parent (remove overlapping contours
                if hierarchy_parents_only[index] == -1:
                    # Keep only contours having an area greater than "min_area"
                    area = cv2.contourArea(contour)
                    if area > min_area:
                        selected_contours.append(contour)
                        selected_hierarchy.append(hierarchy[0][index])

            print("Number of selected contours: ", len(selected_contours))
            print("Number of selected hierarchies : ", len(selected_hierarchy))

            # Draw all contours on the source image (usefull for debugging, but change color (0, 0, 0) to something
            # else if the background is black too). -1 means drawing all contours, "(0, 255, 0)" for contours in
            # green color, "3" is the thickness of the contours
            source_image_with_contours = cv2.drawContours(
                source_image, selected_contours, -1, (0, 0, 0), 3
            )

            # Save the image
            cv2.imwrite(
                filename=str(output_directory / (file.stem + "_with_contours." + file.suffix)),
                img=source_image_with_contours,
            )

            # Now, extract each image
            for index, contour in enumerate(selected_contours):
                # Create mask where white is what we want, black otherwise
                mask = np.zeros_like(grayscale_image)

                # Draw filled contour in mask
                cv2.drawContours(mask, selected_contours, index, 255, -1)

                # Mask everything but the object we want to extract
                masked_image = cv2.bitwise_and(source_image, source_image, mask=mask)
                cv2.imwrite(str(output_directory / file.name), masked_image)

                # Determine the bounding box (minimum rectangle in which the object can fit)
                (y, x) = np.where(mask == 255)
                (top_y, top_x) = (np.min(y), np.min(x))
                (bottom_y, bottom_x) = (np.max(y), np.max(x))

                # Crop image (extract)
                extracted_image = masked_image[top_y : bottom_y + 1, top_x : bottom_x + 1]

                # Write to file
                cv2.imwrite(
                    filename=str(
                        output_directory / (file.stem + "_" + str(index) + "." + file.suffix)
                    ),
                    img=extracted_image,
                )
    return output_directory
