# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: p_data_mask_for_safety_prog.4gl
# Descriptions...: 因應個資法，cl_show_fld_cont有呼叫到個資新增的FUNCTION (cl_set_data_mask_detail)，
#                  安全機制程式不需要有個資功能，但因為cl_show_fld_cont有呼叫到，
#                  為了讓安全機制程式在link的時候不要出錯，因此新增這個空的程式
# Date & Author..: No:FUN-CA0016 12/12/28 By joyce

DATABASE ds
FUNCTION cl_set_data_mask_detail(pc_type)
   DEFINE pc_type   LIKE type_file.chr1
END FUNCTION
# No:FUN-CA0016
