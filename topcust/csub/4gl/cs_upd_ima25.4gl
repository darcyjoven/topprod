# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Program Name...: cs_upd_ima25.4gl
# Descriptions...: 变更料件单位，同步变更相关所有单位
# Usage..........: cs_upd_ima25(p_ima01,p_ima25,p_type)
# Input Parameter: p_ima01  变更的料号
#                  p_ima25  变更后的单位
#                  p_type   是否变更所有的单位
# Return Code....: 1	YES 变更所有单位，包括异动单据
#                  0	NO  仅变更料件单位
# Date & Author..: 16/08/03 By luoyb
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
FUNCTION cs_upd_ima25(p_ima01,p_ima25,p_type)
   DEFINE p_ima01       LIKE ima_file.ima01
   DEFINE p_ima25       LIKE ima_file.ima25
   DEFINE p_type        LIKE type_file.chr1
   DEFINE l_cnt         LIKE type_file.num5
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   LET l_cnt = 0 
   SELECT COUNT(*) INTO l_cnt FROM ima_file WHERE ima01 = p_ima01
   IF l_cnt = 0 THEN
      CALL cl_err('','asf-184',1)
      RETURN
   END IF  

   UPDATE ima_file set ima25 = p_ima25,
                       ima31 = p_ima25,
                       ima44 = p_ima25,
                       ima55 = p_ima25,
                       ima63 = p_ima25,
                       imaud02=p_ima25,
                       ima86 = p_ima25
    WHERE ima01 = p_ima01
   
   IF p_type = 0 THEN
      RETURN
   END IF 

###更新tlf
   UPDATE tlf_file SET tlf025 = p_ima25,
                       tlf035 = p_ima25,
                       tlf11  = p_ima25,
                       tlf12  = 1,
                       tlf60  = 1
    WHERE tlf01 = p_ima01

###更新img
   UPDATE img_file SET img09  = p_ima25,
                       img20  = 1,
                       img21  = 1
    WHERE img01 = p_ima01

###更新采购模块
  #请购单
   UPDATE pml_file SET pml07 = p_ima25,
                       pml08 = p_ima25,
                       pml86 = p_ima25,
                       pml09 = 1
    WHERE pml04 = p_ima01
  #采购单
   UPDATE pmn_file SET pmn07 = p_ima25,
                       pmn08 = p_ima25,
                       pmn86 = p_ima25,
                       pmn09 = 1
    WHERE pmn04 = p_ima01
  #收货单
   UPDATE rvb_file SET rvb90 = p_ima25,
                       rvb86 = p_ima25,
                       rvb90_fac = 1
    WHERE rvb05 = p_ima01
  #入库单
   UPDATE rvv_file SET rvv35 = p_ima25,
                       rvv35_fac = 1,
                       rvv86 = p_ima25
    WHERE rvv31 = p_ima01
  #询价单
   UPDATE pmx_file SET pmx09 = p_ima25
    WHERE pmx08 = p_ima01
  #采购合约
   UPDATE pon_file SET pon07 = p_ima25,
                       pon08 = p_ima25,
                       pon09 = 1,
                       pon121= 1,
                       pon86 = p_ima25
    WHERE pon04 = p_ima01
###更新出货模块
  #产品客户维护
   UPDATE obk_file SET obk07 = p_ima25
    WHERE obk01 = p_ima01
  #价格表
   UPDATE xmf_file SET xmf04 = p_ima25
    WHERE xmf03 = p_ima01
  #合约/订单
   UPDATE oeb_file SET oeb05 = p_ima25,
                       oeb05_fac = 1,
                       oeb916 = p_ima25
    WHERE oeb04 = p_ima01
  #出货通知/出货
   UPDATE ogb_file SET ogb05 = p_ima25,
                       ogb05_fac = 1,
                       ogb15 = p_ima25,
                       ogb15_fac = 1,
                       ogb916 = p_ima25
    WHERE ogb04 = p_ima01
  #开票单
   UPDATE omf_file SET omf17 = p_ima25,
                       omf916 = p_ima25
    WHERE omf13 = p_ima01
  #销退单
   UPDATE ohb_file SET ohb05 = p_ima25,
                       ohb05_fac = 1,
                       ohb15 = p_ima25,
                       ohb15_fac = 1,
                       ohb916 = p_ima25
    WHERE ohb04 = p_ima01
   
###更新产品结构模块
  #BOM
   UPDATE bmb_file SET bmb10 = p_ima25,
                       bmb10_fac = 1,
                       bmb10_fac2 = 1
    WHERE bmb03 = p_ima01
###更新工艺管理模块
  #料件工艺
   UPDATE ecb_file SET ecb45 = p_ima25 
    WHERE ecb01 = p_ima01
###更新生产管理模块
  #工单
   UPDATE sfa_file SET sfa12 = p_ima25,
                       sfa13 = 1,
                       sfa14 = p_ima25,
                       sfa15 = 1
    WHERE sfa03 = p_ima01
  #工单工艺追踪档
   UPDATE ecm_file SET ecm58 = p_ima25
    WHERE ecm03_par = p_ima01
  #RUN CARD 工艺追踪档
   UPDATE sgm_file SET sgm57 = p_ima25,
                       sgm58 = p_ima25
    WHERE sgm_par = p_ima01
  #入库单
   UPDATE sfv_file SET sfv08 = p_ima25
    WHERE sfv04 = p_ima01
  #发料单
   UPDATE sfs_file SET sfs05 = p_ima25
    WHERE sfs04 = p_ima01
   UPDATE sfe_file SET sfe17 = p_ima25
    WHERE sfe07 = p_ima01
###更新库存模块
  #杂收发
   UPDATE inb_file SET inb08 = p_ima25,
                       inb08_fac = 1
    WHERE inb04 = p_ima01
  #调拨单
   UPDATE imn_file SET imn09 = p_ima25,
                       imn21 = 1
    WHERE imn03 = p_ima01
END FUNCTION
