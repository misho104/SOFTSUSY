CP-safe Gravity Mediation + [SOFTSUSY](https://softsusy.hepforge.org/)
=========

### Authors

Original [SOFTSUSY](https://softsusy.hepforge.org/) by B. C. Allanach, P. Athron, M. Bernhardt, D. Grellscheid, M. Hanussek, C. H. Kom, P. Slavich, L. Tunstall, A. Voigt, and A. G. Williams.

Extension for CP-safe Gravity Mediation by [S. Iwamoto](http://github.com/misho104).

### References
 * SOFTSUSY
   * Comput. Phys. Commun. **143** (2002) 305-331 [[hep-ph/0104145](http://arxiv.org/abs/hep-ph/0104145)].
   * [arXiv:1311.7659](http://arxiv.org/abs/1311.7659).
   * Comput. Phys. Commun. **181** (2010) 232 [[0903.1805](http://arxiv.org/abs/0903.1805)].
   * Comput. Phys. Commun. **183** (2012) 785 [[1109.3735](http://arxiv.org/abs/1109.3735)].
   * http://softsusy.hepforge.org/
 * CP-safe Gravity Mediation
   * Iwamoto, Yanagida, Yokozaki, [arXiv:1407.4226](http://arxiv.org/abs/1407.4226).

### Introduction to git(hub) newbies

```sh
git clone https://github.com/misho104/SOFTSUSY.git
cd SOFTSUSY

# Now this is just the original SOFTSUSY 3.5.1.

git checkout cpsafe

# Now you are moved to the branch 'cpsafe'.
# Then, as usual,

./configure
make -j8

# Examples are in "cpsafe_test" directory

cd cpsafe_test
../softpoint.x leshouches < bp_14074226_1.in

# All the information of the modification is documented in readme.md.
```

### Usage
CP-safe gravity mediation can be accessed only by 'leshouches' mode of `softpoint.x`.
You can choose CP-safe model by setting `MODSEL 1` to `101`, where you cannot activate `MODSEL 3`, `4`, and `6` as RPV, NMSSM, or FLV for the model is not installed.

CP-safe gravity mediation model accepts only `SOFTSUSY`, `SMINPUTS`, `MINPAR`, `EXTPAR`, and  `EXTPARDELTA` blocks. **Behaviour under the presence of other blocks are not defined**, while no warnings are shown.
Required, and acceptable parameters are as follows:

* MINPAR
  * `1` : Universal scalar soft mass $$$m_0(M _ {\mathrm{INPUT}})$$$, which can be overwritten with `EXTPAR 21` to `49`. The soft masses which are not specified here nor in `EXTPAR` are set as the gravitino mass, which is determined by the B-term.
  * `2` : (required) Universal gaugino mass $$$M _ {1/2}(M_{\mathrm{INPUT}})$$$. `EXTPAR 1` to `3` can be used to overwrite it, but even though this parameter is required.
  * `3` : (required) $$$\tan\beta$$$
  * `4` : (required) $$$\mathop{\mathrm{sgn}}\mu$$$.
  * `5` is disactivated ($$$A_0$$$).
* EXTPAR
  * `0` : The INPUT scale $$$M_{\mathrm{INPUT}}$$$.
  * `1` to `3` : Gaugino masses at the INPUT scale.
  * `11` to `13` are disactivated ($$$A_{f_3}$$$).
  * `21` to `22` : $$$m^2 _ {H _ {\mathrm d}}$$$ and $$$m^2 _ {H _ {\mathrm d}}$$$ at $$$M_{\mathrm{INPUT}}$$$. Each cannot be set together with the corresponding parameter in ```EXTPARDELTA```.
  * `23` to `27` are not supported yet.
  * `31` to `36` and `41` to `49` : Sfermion masses, which overwrite `MINPAR 1`. Signs are preserved (`signedSqr`).
* EXTPARDELTA
  * `21` to `22` : Extra contribution to $$$m^2 _ {H _ {\mathrm d}}$$$ and $$$m^2 _ {H _ {\mathrm d}}$$$, i.e., they are set as $$$m_{3/2}^2$$$ + this parameter. Each cannot be set together with the corresponding parameter in ```EXTPAR```.

Finally, sfermion soft mass, and Higgs soft masses **squared** are determined as

```
sfermion =
  if specified in EXTPAR:
    EXTPAR
  else if specified in MINPAR:
    MINPAR
  else:
    gravitino mass

higgs-squared =
  if specified in EXTPAR (and EXTPARDELTA not set):
    EXTPAR
  else if EXTPARDELTA is set:
    gravitinomass^2 + EXTPARDELTA
  else if specified in MINPAR:
    MINPAR^2
  else:
    gravitino mass^2
```

### Internal implication
The internal parameters for `cpsafeSugraBcs` are stored in `pars` on `softpoint.cpp`.
They are:

* `1`-`3` : EXTPAR 1-3 ($$$M_i$$$)
* `5`     : MINPAR 1 ($$$m_0$$$)
* `6`     : MINPAR 2 ($$$M_{1/2}$$$)
* `21`-`49` : EXTPAR 21, 22, 31-36, 41-49.
* `51`, `52` : MINPARDELTA 21 and 22.
* `101`-`152` : flag whether `pars(x-100)` is set.

Here, `5` and `6` are used in `softpoint.cpp` to overwrite unspecified parameters, and not used in the subroutine `cpsafeSugraBcs`.

