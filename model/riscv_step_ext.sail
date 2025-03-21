/*=======================================================================================*/
/*  This Sail RISC-V architecture model, comprising all files and                        */
/*  directories except where otherwise noted is subject the BSD                          */
/*  two-clause license in the LICENSE file.                                              */
/*                                                                                       */
/*  SPDX-License-Identifier: BSD-2-Clause                                                */
/*=======================================================================================*/

/* The default implementation of hooks for the step() and main() functions. */

function ext_fetch_hook(f : FetchResult) -> FetchResult = {

  if (rvfi_dii_enabled | rvfi_ext_enabled) then {
    rvfi_zero_exec_packet();
    rvfi_inst_data[rvfi_order] = minstret;
    rvfi_pc_data[rvfi_pc_rdata] = zero_extend(get_arch_pc());
    rvfi_inst_data[rvfi_mode] = zero_extend(privLevel_to_bits(cur_privilege));
    rvfi_inst_data[rvfi_ixl] = zero_extend(misa[MXL]);


    match(f) {
      /* non-error cases: */
      F_RVC(h) => {
        rvfi_inst_data[rvfi_insn] = zero_extend(h);
      },
      F_Base(w) => {
        rvfi_inst_data[rvfi_insn] = zero_extend(w);
      },
      _ => ()
    };
  };

  f
}

function ext_pre_step_hook()  -> unit = ()

function ext_post_step_hook() -> unit = {
  /* record the next pc */
  rvfi_pc_data[rvfi_pc_wdata] = zero_extend(get_arch_pc())
}

function ext_reset() -> unit = ()
