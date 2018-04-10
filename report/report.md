In this project, we use finite element method(FEM) to analyze a homogeneous waveguide. The waveguide is cylindrical and assumed to be uniform (and infinitely long) in its longitudinal direction (z-direction). So the problem can be reduced to a two-dimensional one. It is known that in such a hollow metallic waveguide, there exist two sets of modes: TE and TM modes. (Since there is only one conductor, such a waveguide does not have a TEM mode.)

For TE modes, starting from Maxwell's equations and assuming that the fields propagate in the z-direction with a propagation constant $\beta$, we can derive the second order partial differential equation for $E_z$ as 

$$ \nabla_t^2 E_z + k_c^2 E_z = 0 \quad \text{in $\Omega$} $$

where $\Omega$ denotes the cross section of the waveguide. $\nabla_t^2$ denotes the two-dimensional Laplacian, which is $\nabla_t^2 = \frac{\partial^2}{\partial x^2} + \frac{\partial^2}{\partial y^2}$. And $k_c^2 = k^2 - \beta^2$ with $k = \omega \sqrt{\mu \epsilon}$. Obviously, once the cut-off wave number $k_c$ is found ( also the cut-off frequency $f_c = k_c/(2\pi \sqrt{\mu \epsilon})$ is found ), the propagation constant $\beta$ can be calculated for any frequency.

The boundary condition is 

$$E_z = 0 \quad \text{on $\Gamma$} $$ 

where $\Gamma$ denotes the conduction wall of the waveguide.

The analysis for the TM modes is similar. We have
$$ \nabla_t^2 H_z + k_c^2 H_z = 0 \quad \text{in $\Omega$} $$

$$\frac{\partial H_z}{\partial n}= 0 \quad \text{on $\Gamma$} $$ 