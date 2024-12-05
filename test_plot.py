import numpy as np
import matplotlib.pyplot as plt
from pathlib import Path
from mpl_toolkits.mplot3d import Axes3D
from matplotlib.ticker import ScalarFormatter

# Load the data from the file (replace 'your_file.txt' with your actual file path)
#file_path = 'e_ph_interact_em_2.txt'
file_path = '/home/jairo/Documents/fortran_codes/Global_Foundries/heat_source_term.txt'
#file_path = 'em_ab.txt'

data = np.loadtxt(file_path)
data2=data*1.609e-19
# Reshape the data into 121 rows and 289 columns
rows, cols = 121, 289
reshaped_data = data2[:rows * cols].reshape((rows, cols))

# Create meshgrid for X and Y axes
x = np.arange(cols)
y = np.arange(rows)
X, Y = np.meshgrid(x, y)

# Create a 3D plot using the reshaped data as the Z-axis
fig = plt.figure(figsize=(10, 6))
ax = fig.add_subplot(111, projection='3d')

# Set scientific notation for the z-axis
ax.zaxis.set_major_formatter(ScalarFormatter(useMathText=True))
ax.zaxis.get_major_formatter().set_scientific(True)
ax.zaxis.get_major_formatter().set_powerlimits((-2, 2))


# Plot the surface using the reshaped data
ax.plot_surface(X, Y, reshaped_data, cmap='viridis')

# Labels and title
ax.set_xlabel('X-axis [nm]')
ax.set_ylabel('Y-axis [nm]')
ax.set_zlabel('Heat [Watts]')
ax.set_title('Heat source term')

# Show the plot
plt.show()
