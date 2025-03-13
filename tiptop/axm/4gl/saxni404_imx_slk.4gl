# Prog. Version..: '5.30.06-13.03.12(00001)'     #
# Pattern name...: 
# Descriptions...: g_imx二維屬性單身更改顏色后，需要更改子料件編號,服飾行業專用程式
# Date & Author..: 2011/09/29  #FUN-B90104  by huangrh
# Usage..........: 
# Memo:
#     
# Modify.........: No:FUN-C10002 12/02/02 By bart 作業編號pmn78帶預設值
# Modify.........: No:TQC-C20339 12/02/21 By lixiang BUG修改
# Modify.........: No:TQC-C20461 12/02/23 By lixiang oeb906為空時，賦'N'
# Modify.........: No:FUN-C20101 12/02/24 By qiaozy 增加aimt302_slk,aimt301_slk的信息
# Modify.........: No:TQC-C20348 12/02/27 By lixiang 修改服飾中子料件的商品策略和採購策略的控管
# Modify.........: No:MOD-C30217 12/03/12 By xjll    bug 修改
# Modify.........: No:FUN-C30130 12/04/12 By lixiang 採購單增加母單身pmnslk69欄位的賦值
# Modify.........: No:FUN-C30057 12/04/18 By linlin  服飾二維開發
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52             

DATABASE ds

GLOBALS "../../config/top.global"
GLOBALS "../4gl/s_slk.global"

#Usage..........: g_imx二維屬性單身更改顏色后，需要更改子料件編號,服飾行業專用程式
#                 如訂單使用此函數：CALL s_updcolor_slk(p_ac,p_ima01,g_oea.oea01,g_oeaslk[l_ac2].oeaslk03)
# Input Parameter: p_ac 當前所在的行--g_imx二維屬性單身，光標所在的行
#                  p_ima01            母料件編號
#                  p_keyvalue1        key值1--primary key value1，單據編號
#                  p_keyvalue2        key值2--primary key value2，母料件項次
#
FUNCTION s_updcolor_slk(p_ac,p_ima01,p_keyvalue1,p_keyvalue2)
  DEFINE p_ac                LIKE type_file.num5
  DEFINE p_ima01             LIKE ima_file.ima01
  DEFINE p_keyvalue1         LIKE type_file.chr20
  DEFINE p_keyvalue2         LIKE type_file.chr20
  DEFINE l_sql               STRING

   LET g_keyvalue1=p_keyvalue1
   LET g_keyvalue2=p_keyvalue2

   CASE g_prog
       WHEN "axmt410_slk"
            LET l_sql = "UPDATE oeb_file SET oeb04=?,oeb06=?,oeb07=?,oeb11=?,oeb906=? ",
                        " WHERE oeb04= ? ",
                        "   AND oeb01='",g_keyvalue1,"'",
                        "   AND oeb03 in (",
                        "                    SELECT oebi03 FROM oebi_file ",
                        "                     WHERE oebi01='",g_keyvalue1,"'",
                        "                       AND oebislk03='",g_keyvalue2,"')"
       WHEN "axmt400_slk"
            LET l_sql = "UPDATE oeb_file SET oeb04=?,oeb06=?,oeb07=?,oeb11=?,oeb906=? ",
                        " WHERE oeb04= ? ",
                        "   AND oeb01='",g_keyvalue1,"'",
                        "   AND oeb03 in (",
                        "                    SELECT oebi03 FROM oebi_file ",
                        "                     WHERE oebi01='",g_keyvalue1,"'",
                        "                       AND oebislk03='",g_keyvalue2,"')"
       WHEN "axmt420_slk"
            LET l_sql = "UPDATE oeb_file SET oeb04=?,oeb06=?,oeb07=?,oeb11=?,oeb906=? ",
                        " WHERE oeb04= ? ",
                        "   AND oeb01='",g_keyvalue1,"'",
                        "   AND oeb03 in (",
                        "                    SELECT oebi03 FROM oebi_file ",
                        "                     WHERE oebi01='",g_keyvalue1,"'",
                        "                       AND oebislk03='",g_keyvalue2,"')"
       WHEN "axmt810_slk"
            LET l_sql = "UPDATE oeb_file SET oeb04=?,oeb06=?,oeb07=?,oeb11=?,oeb906=? ",
                        " WHERE oeb04= ? ",
                        "   AND oeb01='",g_keyvalue1,"'",
                        "   AND oeb03 in (",
                        "                    SELECT oebi03 FROM oebi_file ",
                        "                     WHERE oebi01='",g_keyvalue1,"'",
                        "                       AND oebislk03='",g_keyvalue2,"')"
        WHEN "axmt700_slk"
            LET l_sql = "UPDATE ohb_file SET ohb04=?,ohb06=?,ohb07=?,ohb11=?,ohb61=? ",
                        " WHERE ohb04= ? ",
                        "   AND ohb01='",g_keyvalue1,"'",
                        "   AND ohb03 in (",
                        "                    SELECT ohbi03 FROM ohbi_file ",
                        "                     WHERE ohbi01='",g_keyvalue1,"'",
                        "                       AND ohbislk02='",g_keyvalue2,"')"
        WHEN "apmt420_slk"
            LET l_sql = "UPDATE pml_file SET pml04=?,pml041=?,pml190=?,pml191=? ",
                        " WHERE pml04= ? ",
                        "   AND pml01='",g_keyvalue1,"'",
                        "   AND pml02 in (",
                        "                    SELECT pmli02 FROM pmli_file ",
                        "                     WHERE pmli01='",g_keyvalue1,"'",
                        "                       AND pmlislk03='",g_keyvalue2,"')"
        WHEN "apmt540_slk"
            LET l_sql = "UPDATE pmn_file SET pmn04=?,pmn041=? ",
                        " WHERE pmn04= ? ",
                        "   AND pmn01='",g_keyvalue1,"'",
                        "   AND pmn02 in (",
                        "                    SELECT pmni02 FROM pmni_file ",
                        "                     WHERE pmni01='",g_keyvalue1,"'",
                        "                       AND pmnislk03='",g_keyvalue2,"')"
        WHEN "apmt590_slk"
            LET l_sql = "UPDATE pmn_file SET pmn04=?,pmn041=? ",
                        " WHERE pmn04= ? ",
                        "   AND pmn01='",g_keyvalue1,"'",
                        "   AND pmn02 in (",
                        "                    SELECT pmni02 FROM pmni_file ",
                        "                     WHERE pmni01='",g_keyvalue1,"'",
                        "                       AND pmnislk03='",g_keyvalue2,"')"

        WHEN "apmt110_slk"
            LET l_sql = "UPDATE rvb_file SET rvb05=?,rvb051=? ",
                        " WHERE rvb05= ? ",
                        "   AND rvb01='",g_keyvalue1,"'",
                        "   AND rvb02 in (",
                        "                    SELECT rvbi02 FROM rvbi_file ",
                        "                     WHERE rvbi01='",g_keyvalue1,"'",
                        "                       AND rvbislk02='",g_keyvalue2,"')"
        WHEN "axmt610_slk"
            LET l_sql = "UPDATE ogb_file SET ogb04=?,ogb06=?,ogb07=?,ogb11=?,ogb19=? ",
                        " WHERE ogb04= ? ",
                        "   AND ogb01='",g_keyvalue1,"'",
                        "   AND ogb03 in (",
                        "                    SELECT ogbi03 FROM ogbi_file ",
                        "                     WHERE ogbi01='",g_keyvalue1,"'",
                        "                       AND ogbislk02='",g_keyvalue2,"')"
        WHEN "axmt620_slk"
            LET l_sql = "UPDATE ogb_file SET ogb04=?,ogb06=?,ogb07=?,ogb11=?,ogb19=? ",
                        " WHERE ogb04= ? ",
                        "   AND ogb01='",g_keyvalue1,"'",
                        "   AND ogb03 in (",
                        "                    SELECT ogbi03 FROM ogbi_file ",
                        "                     WHERE ogbi01='",g_keyvalue1,"'",
                        "                       AND ogbislk02='",g_keyvalue2,"')"
        WHEN "axmt628_slk"
            LET l_sql = "UPDATE ogb_file SET ogb04=?,ogb06=?,ogb07=?,ogb11=?,ogb19=? ",
                        " WHERE ogb04= ? ",
                        "   AND ogb01='",g_keyvalue1,"'",
                        "   AND ogb03 in (",
                        "                    SELECT ogbi03 FROM ogbi_file ",
                        "                     WHERE ogbi01='",g_keyvalue1,"'",
                        "                       AND ogbislk02='",g_keyvalue2,"')"
        WHEN "axmt629_slk"
            LET l_sql = "UPDATE ogb_file SET ogb04=?,ogb06=?,ogb07=?,ogb11=?,ogb19=? ",
                        " WHERE ogb04= ? ",
                        "   AND ogb01='",g_keyvalue1,"'",
                        "   AND ogb03 in (",
                        "                    SELECT ogbi03 FROM ogbi_file ",
                        "                     WHERE ogbi01='",g_keyvalue1,"'",
                        "                       AND ogbislk02='",g_keyvalue2,"')"
        WHEN "axmt640_slk"
            LET l_sql = "UPDATE ogb_file SET ogb04=?,ogb06=?,ogb07=?,ogb11=?,ogb19=? ",
                        " WHERE ogb04= ? ",
                        "   AND ogb01='",g_keyvalue1,"'",
                        "   AND ogb03 in (",
                        "                    SELECT ogbi03 FROM ogbi_file ",
                        "                     WHERE ogbi01='",g_keyvalue1,"'",
                        "                       AND ogbislk02='",g_keyvalue2,"')"
        WHEN "artt212"
            LET l_sql = "UPDATE rux_file SET rux03=? ",
                        " WHERE rux03= ? ",
                        "   AND rux01='",g_keyvalue1,"'",
                        "   AND rux11s='",g_keyvalue2,"'"
        WHEN "artt256"
            LET l_sql = "UPDATE rup_file SET rup03=? ",
                        " WHERE rup03= ? ",
                        "   AND rup01='",g_keyvalue1,"'",
                        "   AND rup21s='",g_keyvalue2,"'"

        WHEN "apmt720_slk"
            LET l_sql = "UPDATE rvv_file SET rvv31=? ",
                        " WHERE rvv31= ? ",
                        "   AND rvv01='",g_keyvalue1,"'",
                        "   AND rvv02 in (",
                        "                    SELECT rvvi03 FROM rvvi_file ",
                        "                     WHERE rvvi01='",g_keyvalue1,"'",
                        "                       AND rvvislk02='",g_keyvalue2,"')"
        WHEN "apmt722_slk"
            LET l_sql = "UPDATE rvv_file SET rvv31=? ",
                        " WHERE rvv31= ? ",
                        "   AND rvv01='",g_keyvalue1,"'",
                        "   AND rvv02 in (",
                        "                    SELECT rvvi03 FROM rvvi_file ",
                        "                     WHERE rvvi01='",g_keyvalue1,"'",
                        "                       AND rvvislk02='",g_keyvalue2,"')"
#FUN-C20101-----ADD---------STR-----                        
        WHEN "aimt301_slk"
            LET l_sql = "UPDATE inb_file SET inb04=? ",
                        " WHERE inb04= ? ",
                        "   AND inb01='",g_keyvalue1,"'",
                        "   AND inb03 in (",
                        "                    SELECT inbi03 FROM inbi_file ",
                        "                     WHERE inbi01='",g_keyvalue1,"'",
                        "                       AND inbislk02='",g_keyvalue2,"')"
       WHEN "aimt302_slk"
            LET l_sql = "UPDATE inb_file SET inb04=? ",
                        " WHERE inb04= ? ",
                        "   AND inb01='",g_keyvalue1,"'",
                        "   AND inb03 in (",
                        "                    SELECT inbi03 FROM inbi_file ",
                        "                     WHERE inbi01='",g_keyvalue1,"'",
                        "                       AND inbislk02='",g_keyvalue2,"')"                  
       WHEN "aimt303_slk"
            LET l_sql = "UPDATE inb_file SET inb04=? ",
                        " WHERE inb04= ? ",
                        "   AND inb01='",g_keyvalue1,"'",
                        "   AND inb03 in (",
                        "                    SELECT inbi03 FROM inbi_file ",
                        "                     WHERE inbi01='",g_keyvalue1,"'",
                        "                       AND inbislk02='",g_keyvalue2,"')"
#FUN-C20101-----ADD---------END-----

#FUN-C30057----add---begin--
       WHEN "apmt580_slk"
            LET l_sql = "UPDATE pon_file SET pon04=?,pon041=?,pon06=?",
                        " WHERE pon04= ? ",
                        "   AND pon01'",g_keyvalue1,"'",
                        "   AND pon02 in (",
                        "                    SELECT poni02 FROM poni_file",
                        "                     WHERE poni01='",g_keyvalue1,"'",
                        "                       AND ponislk02='",g_keyvalue2,"')"
#FUN-C30057----add---end--

   END CASE 
   PREPARE s_updcolor_slk_pre FROM l_sql

   IF g_imx[p_ac].imx01 >=0 THEN
      CALL s_color_update_slk(p_ac,1,p_ima01)
   END IF
   IF g_imx[p_ac].imx02 >=0 THEN
      CALL s_color_update_slk(p_ac,2,p_ima01)
   END IF
   IF g_imx[p_ac].imx03 >=0 THEN
      CALL s_color_update_slk(p_ac,3,p_ima01)
   END IF
   IF g_imx[p_ac].imx04 >=0 THEN
      CALL s_color_update_slk(p_ac,4,p_ima01)
   END IF
   IF g_imx[p_ac].imx05 >=0 THEN
      CALL s_color_update_slk(p_ac,5,p_ima01)
   END IF
   IF g_imx[p_ac].imx06 >=0 THEN
      CALL s_color_update_slk(p_ac,6,p_ima01)
   END IF
   IF g_imx[p_ac].imx07 >=0 THEN
      CALL s_color_update_slk(p_ac,7,p_ima01)
   END IF
   IF g_imx[p_ac].imx08 >=0 THEN
      CALL s_color_update_slk(p_ac,8,p_ima01)
   END IF
   IF g_imx[p_ac].imx09 >=0 THEN
      CALL s_color_update_slk(p_ac,9,p_ima01)
   END IF
   IF g_imx[p_ac].imx10 >=0 THEN
      CALL s_color_update_slk(p_ac,10,p_ima01)
   END IF
   IF g_imx[p_ac].imx11 >=0 THEN
      CALL s_color_update_slk(p_ac,11,p_ima01)
   END IF
   IF g_imx[p_ac].imx12 >=0 THEN
      CALL s_color_update_slk(p_ac,12,p_ima01)
   END IF
   IF g_imx[p_ac].imx13 >=0 THEN
      CALL s_color_update_slk(p_ac,13,p_ima01)
   END IF
   IF g_imx[p_ac].imx14 >=0 THEN
      CALL s_color_update_slk(p_ac,14,p_ima01)
   END IF
   IF g_imx[p_ac].imx15 >=0 THEN
      CALL s_color_update_slk(p_ac,15,p_ima01)
   END IF

END FUNCTION

#更改子料件編號
FUNCTION s_color_update_slk(p_ac,p_index,p_ima01)
   DEFINE p_ac      LIKE type_file.num5
   DEFINE p_ima01   LIKE ima_file.ima01
   DEFINE p_index   LIKE type_file.num5
   DEFINE l_ima01   LIKE ima_file.ima01
   DEFINE l_ima01_t LIKE ima_file.ima01
   DEFINE l_ps      LIKE sma_file.sma46
   DEFINE l_ima02   LIKE ima_file.ima02
   DEFINE l_imc02   LIKE imc_file.imc02
   DEFINE l_ima913  LIKE ima_file.ima913
   DEFINE l_ima914  LIKE ima_file.ima914
   DEFINE l_obk02   LIKE obk_file.obk02
   DEFINE l_obk03   LIKE obk_file.obk03
   DEFINE l_obk05   LIKE obk_file.obk05
   DEFINE l_obk11   LIKE obk_file.obk11

   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN LET l_ps = ' ' END IF

   LET l_ima01 = p_ima01,l_ps,              #現在的子料件編號
                 g_imx[p_ac].color,l_ps,
                 g_imxtext[p_ac].detail[p_index].size

   LET l_ima01_t = p_ima01,l_ps,            #要更新的子料件編號
                 g_imx_t.color,l_ps,
                 g_imxtext[p_ac].detail[p_index].size

   SELECT ima02 INTO l_ima02 FROM ima_file WHERE ima01 = l_ima01
   SELECT imc02 INTO l_imc02 FROM imc_file WHERE imc01 = l_ima01
   CASE g_prog
       WHEN "axmt410_slk"
            SELECT oea03,oea23 INTO l_obk02,l_obk05 FROM oea_file WHERE oea01 = g_keyvalue1           
            SELECT obk03,obk11 INTO l_obk03,l_obk11 FROM obk_file 
               WHERE obk01 = l_ima01 AND obk02 = l_obk02 AND obk05 = l_obk05
            IF cl_null(l_obk11) THEN
               LET l_obk11 = 'N'
            END IF 
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima02,l_imc02,l_obk03,l_obk11,l_ima01_t
       WHEN "axmt400_slk"
            SELECT oea03,oea23 INTO l_obk02,l_obk05 FROM oea_file WHERE oea01 = g_keyvalue1
            SELECT obk03,obk11 INTO l_obk03,l_obk11 FROM obk_file  
               WHERE obk01 = l_ima01 AND obk02 = l_obk02 AND obk05 = l_obk05
            IF cl_null(l_obk11) THEN
               LET l_obk11 = 'N'
            END IF  
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima02,l_imc02,l_obk03,l_obk11,l_ima01_t
       WHEN "axmt420_slk"
            SELECT oea03,oea23 INTO l_obk02,l_obk05 FROM oea_file WHERE oea01 = g_keyvalue1
            SELECT obk03,obk11 INTO l_obk03,l_obk11 FROM obk_file  
               WHERE obk01 = l_ima01 AND obk02 = l_obk02 AND obk05 = l_obk05
            IF cl_null(l_obk11) THEN
               LET l_obk11 = 'N'
            END IF  
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima02,l_imc02,l_obk03,l_obk11,l_ima01_t
       WHEN "axmt810_slk"
            SELECT oea03,oea23 INTO l_obk02,l_obk05 FROM oea_file WHERE oea01 = g_keyvalue1
            SELECT obk03,obk11 INTO l_obk03,l_obk11 FROM obk_file  
               WHERE obk01 = l_ima01 AND obk02 = l_obk02 AND obk05 = l_obk05
            IF cl_null(l_obk11) THEN
               LET l_obk11 = 'N'
            END IF  
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima02,l_imc02,l_obk03,l_obk11,l_ima01_t
       WHEN "axmt700_slk" 
            SELECT oha03,oha23 INTO l_obk02,l_obk05 FROM oha_file WHERE oha01 = g_keyvalue1
            SELECT obk03,obk11 INTO l_obk03,l_obk11 FROM obk_file
               WHERE obk01 = l_ima01 AND obk02 = l_obk02 AND obk05 = l_obk05
            IF cl_null(l_obk11) THEN
               LET l_obk11 = 'N'
            END IF
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima02,l_imc02,l_obk03,l_obk11,l_ima01_t
       WHEN "apmt420_slk"
            SELECT ima913,ima914 INTO l_ima913,l_ima914 FROM ima_file WHERE ima01=l_ima01
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima02,l_ima913,l_ima914,l_ima01_t
       WHEN "apmt540_slk"
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima02,l_ima01_t
       WHEN "apmt590_slk"
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima02,l_ima01_t
       WHEN "apmt110_slk"
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima02,l_ima01_t
       WHEN "axmt610_slk"
            SELECT oga03,oga23 INTO l_obk02,l_obk05 FROM oga_file WHERE oga01 = g_keyvalue1
            SELECT obk03,obk11 INTO l_obk03,l_obk11 FROM obk_file
               WHERE obk01 = l_ima01 AND obk02 = l_obk02 AND obk05 = l_obk05
            IF cl_null(l_obk11) THEN
               LET l_obk11 = 'N'
            END IF
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima02,l_imc02,l_obk03,l_obk11,l_ima01_t
       WHEN "axmt620_slk"
            SELECT oga03,oga23 INTO l_obk02,l_obk05 FROM oga_file WHERE oga01 = g_keyvalue1
            SELECT obk03,obk11 INTO l_obk03,l_obk11 FROM obk_file
               WHERE obk01 = l_ima01 AND obk02 = l_obk02 AND obk05 = l_obk05
            IF cl_null(l_obk11) THEN
               LET l_obk11 = 'N'
            END IF
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima02,l_imc02,l_obk03,l_obk11,l_ima01_t
       WHEN "axmt628_slk"
            SELECT oga03,oga23 INTO l_obk02,l_obk05 FROM oga_file WHERE oga01 = g_keyvalue1
            SELECT obk03,obk11 INTO l_obk03,l_obk11 FROM obk_file
               WHERE obk01 = l_ima01 AND obk02 = l_obk02 AND obk05 = l_obk05
            IF cl_null(l_obk11) THEN
               LET l_obk11 = 'N'
            END IF
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima02,l_imc02,l_obk03,l_obk11,l_ima01_t
       WHEN "axmt629_slk"
            SELECT oga03,oga23 INTO l_obk02,l_obk05 FROM oga_file WHERE oga01 = g_keyvalue1
            SELECT obk03,obk11 INTO l_obk03,l_obk11 FROM obk_file
               WHERE obk01 = l_ima01 AND obk02 = l_obk02 AND obk05 = l_obk05
            IF cl_null(l_obk11) THEN
               LET l_obk11 = 'N'
            END IF
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima02,l_imc02,l_obk03,l_obk11,l_ima01_t
       WHEN "axmt640_slk"
            SELECT oga03,oga23 INTO l_obk02,l_obk05 FROM oga_file WHERE oga01 = g_keyvalue1
            SELECT obk03,obk11 INTO l_obk03,l_obk11 FROM obk_file
               WHERE obk01 = l_ima01 AND obk02 = l_obk02 AND obk05 = l_obk05
            IF cl_null(l_obk11) THEN
               LET l_obk11 = 'N'
            END IF
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima02,l_imc02,l_obk03,l_obk11,l_ima01_t
       OTHERWISE
            EXECUTE s_updcolor_slk_pre USING l_ima01,l_ima01_t
   END CASE   

   IF STATUS THEN
      CALL cl_err3("upd",'',g_keyvalue1,l_ima01_t,SQLCA.sqlcode,"","",1)
      LET g_success='N'
   END IF

END FUNCTION

# Usage..........:服飾版本母料件的二維屬性加載（顏色、尺寸） CALL s_set_text_slk(p_ima01)
# Input Parameter: p_ima01 母料件編號
FUNCTION s_settext_slk(p_ima01)
   DEFINE p_ima01     LIKE ima_file.ima01
   DEFINE l_ima151    LIKE ima_file.ima151
   DEFINE l_index     STRING
   DEFINE l_sql       STRING
   DEFINE l_i,l_j     LIKE type_file.num5
   DEFINE lc_agd02    LIKE agd_file.agd02
   DEFINE lc_agd02_2  LIKE agd_file.agd02
   DEFINE lc_agd03    LIKE agd_file.agd03
   DEFINE lc_agd03_2  LIKE agd_file.agd03
   DEFINE l_imx01     LIKE imx_file.imx01
   DEFINE l_imx02     LIKE imx_file.imx02
   DEFINE ls_value    STRING
   DEFINE ls_desc     STRING
   DEFINE l_repeat1   LIKE type_file.chr1,
          l_repeat2   LIKE type_file.chr1
   DEFINE l_colarray  DYNAMIC ARRAY OF RECORD
          color       LIKE type_file.chr50
                      END RECORD
   DEFINE l_agd04     LIKE agd_file.agd04

   SELECT ima151 INTO l_ima151 FROM ima_file
    WHERE ima01 = p_ima01 AND imaacti='Y' AND ima1010='1' #檢查料件
   IF l_ima151 = 'N' OR cl_null(l_ima151) THEN
      CALL cl_set_comp_visible("color,number,count",FALSE)
      FOR l_i = 1 TO 20
         LET l_index = l_i USING '&&'
         CALL cl_set_comp_visible("imx" || l_index,FALSE)
      END FOR
      RETURN
   ELSE
        CALL cl_set_comp_visible("color,number,count",TRUE)
   END IF

#抓取母料件多屬性資料
   LET l_sql = "SELECT DISTINCT(imx02),agd04 FROM imx_file,agd_file",
               " WHERE imx00 = '",p_ima01,"'",
               "   AND imx02=agd02",
               "   AND agd01 IN ",
               " (SELECT ima941 FROM ima_file WHERE ima01='",p_ima01,"')",
               " ORDER BY agd04"
   PREPARE s_f3_pre FROM l_sql
   DECLARE s_f2_cs CURSOR FOR s_f3_pre

   CALL g_imxtext.clear()
   FOREACH s_f2_cs INTO l_imx02,l_agd04
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET g_imxtext[1].detail[g_imxtext[1].detail.getLength()+1].size=l_imx02 CLIPPED
   END FOREACH

   LET l_sql = "SELECT DISTINCT(imx01),agd04 FROM imx_file,agd_file",
               " WHERE imx00 = '",p_ima01,"'",
               "   AND imx01=agd02",
               "   AND agd01 IN ",
               " (SELECT ima940 FROM ima_file WHERE ima01='",p_ima01,"')",
               " ORDER BY agd04"
   PREPARE s_colslk_pre FROM l_sql
   DECLARE s_colslk_cs CURSOR FOR s_colslk_pre

   CALL l_colarray.clear()
   FOREACH s_colslk_cs INTO l_imx01,l_agd04
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare2:',SQLCA.sqlcode,1) EXIT FOREACH
      END IF
      LET l_colarray[l_colarray.getLength()+1].color=l_imx01 CLIPPED
   END FOREACH

   FOR l_i = 1 TO l_colarray.getLength()
      LET g_imxtext[l_i].* = g_imxtext[1].*
      LET g_imxtext[l_i].color = l_colarray[l_i].color
   END FOR

   FOR l_i = 1 TO g_imxtext.getLength()
      LET lc_agd02 = g_imxtext[l_i].color CLIPPED
      LET ls_value = ls_value,lc_agd02,","
      SELECT agd03 INTO lc_agd03 FROM agd_file,ima_file
       WHERE agd01 = ima940 AND agd02 = lc_agd02
         AND ima01 = p_ima01
      LET ls_desc = ls_desc,lc_agd02,":",lc_agd03 CLIPPED,","
   END FOR
   CALL cl_set_combo_items("color",ls_value.subString(1,ls_value.getLength()-1),ls_desc.subString(1,ls_desc.getLength()-1))
   FOR l_i = 1 TO g_imxtext[1].detail.getLength()
      LET l_index = l_i USING '&&'
      LET lc_agd02_2 = g_imxtext[1].detail[l_i].size CLIPPED
      SELECT agd03 INTO lc_agd03_2 FROM agd_file,ima_file
       WHERE agd01 = ima941 AND agd02 = lc_agd02_2
         AND ima01 = p_ima01
      CALL cl_set_comp_visible("imx" || l_index,TRUE)
      CALL cl_set_comp_att_text("imx" || l_index,lc_agd03_2)
   END FOR
   FOR l_i = g_imxtext[1].detail.getLength()+1 TO 20
      LET l_index = l_i USING '&&'
      CALL cl_set_comp_visible("imx" || l_index,FALSE)
   END FOR
END FUNCTION

#Usage..........: 函數功能說明：此函數為母料件單身調用，用於帶出各個二維屬性對應的子料件的數量值，并儲存在g_imx中
#                               傳入參數：母料件編號，儲存子料件的表的表名,key列名以及key相應的值
#                 如訂單使用此函數：CALL s_fillimx_slk(p_ima01,g_oea.oea01,g_oeaslk[l_ac2].oeaslk03)                        
#
# Input Parameter: p_ima01            母料件編號
#                  p_keyvalue1        key值1--primary key value1，單據編號
#                  p_keyvalue2        key值2--primary key value2，母料件項次
#
FUNCTION s_fillimx_slk(p_ima01,p_keyvalue1,p_keyvalue2)
  DEFINE p_ima01             LIKE ima_file.ima01
  DEFINE p_keyvalue1         LIKE type_file.chr20
  DEFINE p_keyvalue2         LIKE type_file.chr20
  DEFINE l_ima151            LIKE ima_file.ima151
  DEFINE l_i,l_j,l_k         LIKE type_file.num5
  DEFINE l_sql               STRING

   SELECT ima151 INTO l_ima151 FROM ima_file
    WHERE ima01 = p_ima01 AND imaacti='Y'
   IF l_ima151 = 'N' OR cl_null(l_ima151) THEN
      RETURN
   END IF

   LET g_keyvalue1=p_keyvalue1
   LET g_keyvalue2=p_keyvalue2

   CASE g_prog
       WHEN "axmt410_slk"
            LET l_sql = "SELECT oeb12 FROM oeb_file,oebi_file ",
                        " WHERE oeb04= ?",
                        "   AND oeb01=oebi01 ",
                        "   AND oeb03=oebi03 ",
                        "   AND oebi01='",g_keyvalue1,"'",
                        "   AND oebislk03='",g_keyvalue2,"'"
       WHEN "axmt400_slk"
            LET l_sql = "SELECT oeb12 FROM oeb_file,oebi_file ",
                        " WHERE oeb04= ?",
                        "   AND oeb01=oebi01 ",
                        "   AND oeb03=oebi03 ",
                        "   AND oebi01='",g_keyvalue1,"'",
                        "   AND oebislk03='",g_keyvalue2,"'"
       WHEN "axmt420_slk"
            LET l_sql = "SELECT oeb12 FROM oeb_file,oebi_file ",
                        " WHERE oeb04= ?",
                        "   AND oeb01=oebi01 ",
                        "   AND oeb03=oebi03 ",
                        "   AND oebi01='",g_keyvalue1,"'",
                        "   AND oebislk03='",g_keyvalue2,"'"
       WHEN "axmt810_slk"
            LET l_sql = "SELECT oeb12 FROM oeb_file,oebi_file ",
                        " WHERE oeb04= ?",
                        "   AND oeb01=oebi01 ",
                        "   AND oeb03=oebi03 ",
                        "   AND oebi01='",g_keyvalue1,"'",
                        "   AND oebislk03='",g_keyvalue2,"'"
       WHEN "axmt700_slk"
            LET l_sql = "SELECT ohb12 FROM ohb_file,ohbi_file ",
                        " WHERE ohb04= ?",
                        "   AND ohb01=ohbi01 ",
                        "   AND ohb03=ohbi03 ",
                        "   AND ohbi01='",g_keyvalue1,"'",
                        "   AND ohbislk02='",g_keyvalue2,"'"
       WHEN "apmt420_slk"
            LET l_sql = "SELECT pml20 FROM pml_file,pmli_file ",
                        " WHERE pml04= ?",
                        "   AND pml01=pmli01 ",
                        "   AND pml02=pmli02 ",
                        "   AND pmli01='",g_keyvalue1,"'",
                        "   AND pmlislk03='",g_keyvalue2,"'"
       WHEN "apmt540_slk"
            LET l_sql = "SELECT pmn20 FROM pmn_file,pmni_file ",
                        " WHERE pmn04= ?",
                        "   AND pmn01=pmni01 ",
                        "   AND pmn02=pmni02 ",
                        "   AND pmni01='",g_keyvalue1,"'",
                        "   AND pmnislk03='",g_keyvalue2,"'"

       WHEN "apmt590_slk"
            LET l_sql = "SELECT pmn20 FROM pmn_file,pmni_file ",
                        " WHERE pmn04= ?",
                        "   AND pmn01=pmni01 ",
                        "   AND pmn02=pmni02 ",
                        "   AND pmni01='",g_keyvalue1,"'",
                        "   AND pmnislk03='",g_keyvalue2,"'"

       WHEN "apmt110_slk"
            LET l_sql = "SELECT rvb07 FROM rvb_file,rvbi_file ",
                        " WHERE rvb05= ?",
                        "   AND rvb01=rvbi01 ",
                        "   AND rvb02=rvbi02 ",
                        "   AND rvbi01='",g_keyvalue1,"'",
                        "   AND rvbislk02='",g_keyvalue2,"'"
       WHEN "axmt610_slk"
            LET l_sql = "SELECT ogb12 FROM ogb_file,ogbi_file ",
                        " WHERE ogb04= ?",
                        "   AND ogb01=ogbi01 ",
                        "   AND ogb03=ogbi03 ",
                        "   AND ogbi01='",g_keyvalue1,"'",
                        "   AND ogbislk02='",g_keyvalue2,"'"
       WHEN "axmt620_slk"
            LET l_sql = "SELECT ogb12 FROM ogb_file,ogbi_file ",
                        " WHERE ogb04= ?",
                        "   AND ogb01=ogbi01 ",
                        "   AND ogb03=ogbi03 ",
                        "   AND ogbi01='",g_keyvalue1,"'",
                        "   AND ogbislk02='",g_keyvalue2,"'"
       WHEN "axmt628_slk"
            LET l_sql = "SELECT ogb12 FROM ogb_file,ogbi_file ",
                        " WHERE ogb04= ?",
                        "   AND ogb01=ogbi01 ",
                        "   AND ogb03=ogbi03 ",
                        "   AND ogbi01='",g_keyvalue1,"'",
                        "   AND ogbislk02='",g_keyvalue2,"'"
       WHEN "axmt629_slk"
            LET l_sql = "SELECT ogb12 FROM ogb_file,ogbi_file ",
                        " WHERE ogb04= ?",
                        "   AND ogb01=ogbi01 ",
                        "   AND ogb03=ogbi03 ",
                        "   AND ogbi01='",g_keyvalue1,"'",
                        "   AND ogbislk02='",g_keyvalue2,"'"
       WHEN "axmt640_slk"
            LET l_sql = "SELECT ogb12 FROM ogb_file,ogbi_file ",
                        " WHERE ogb04= ?",
                        "   AND ogb01=ogbi01 ",
                        "   AND ogb03=ogbi03 ",
                        "   AND ogbi01='",g_keyvalue1,"'",
                        "   AND ogbislk02='",g_keyvalue2,"'"
      
       WHEN "artt212"
            LET l_sql = "SELECT rux06 FROM rux_file ",
                        " WHERE rux03= ?",
                        "   AND rux01='",g_keyvalue1,"'",
                        "   AND rux11s='",g_keyvalue2,"'"


       WHEN "artt256"
            LET l_sql = "SELECT rup12 FROM rup_file ",
                        " WHERE rup03= ?",
                        "   AND rup01='",g_keyvalue1,"'",

                        "   AND rup21s='",g_keyvalue2,"'"

       WHEN "apmt720_slk"
            LET l_sql = "SELECT rvv17 FROM rvv_file,rvvi_file ",
                        " WHERE rvv31= ?",
                        "   AND rvv01=rvvi01 ",
                        "   AND rvv02=rvvi02 ",
                        "   AND rvvi01='",g_keyvalue1,"'",
                        "   AND rvvislk02='",g_keyvalue2,"'"
       WHEN "apmt722_slk"
            LET l_sql = "SELECT rvv17 FROM rvv_file,rvvi_file ",
                        " WHERE rvv31= ?",
                        "   AND rvv01=rvvi01 ",
                        "   AND rvv02=rvvi02 ",
                        "   AND rvvi01='",g_keyvalue1,"'",
                        "   AND rvvislk02='",g_keyvalue2,"'"
#FUN-C20101-----ADD---STR-----                        
       WHEN "aimt301_slk"
            LET l_sql = "SELECT inb09 FROM inb_file,inbi_file ",
                        " WHERE inb04= ?",
                        "   AND inb01=inbi01 ",
                        "   AND inb03=inbi03 ",
                        "   AND inbi01='",g_keyvalue1,"'",
                        "   AND inbislk02='",g_keyvalue2,"'"
       WHEN "aimt302_slk"
            LET l_sql = "SELECT inb09 FROM inb_file,inbi_file ",
                        " WHERE inb04= ?",
                        "   AND inb01=inbi01 ",
                        "   AND inb03=inbi03 ",
                        "   AND inbi01='",g_keyvalue1,"'",
                        "   AND inbislk02='",g_keyvalue2,"'"                 
       WHEN "aimt303_slk"
            LET l_sql = "SELECT inb09 FROM inb_file,inbi_file ",
                        " WHERE inb04= ?",
                        "   AND inb01=inbi01 ",
                        "   AND inb03=inbi03 ",
                        "   AND inbi01='",g_keyvalue1,"'",
                        "   AND inbislk02='",g_keyvalue2,"'"
#FUN-C20101-----ADD----END------                        
#FUN-C30057-----ADD---STR-----                    
        WHEN "apmt580_slk"
            LET l_sql = "SELECT pon20 FROM pon_file,poni_file ",
                        " WHERE pon04= ?",
                        "   AND pon01=poni01 ",
                        "   AND pon02=poni02 ",
                        "   AND poni01='",g_keyvalue1,"'",
                        "   AND ponislk02='",g_keyvalue2,"'"
#FUN-C30057-----ADD---END-----   
  
   END CASE
   PREPARE s_getamount_slk_pre FROM l_sql

   CALL g_imx.clear()

   FOR l_k = 1 TO g_imxtext.getLength() #遍歷母料件二維屬性數組
      LET l_i=g_imx.getLength()+1
      LET g_imx[l_i].color = g_imxtext[l_k].color CLIPPED  #得到顏色屬性值
      FOR l_j = 1 TO g_imxtext[1].detail.getLength()
         CASE l_j
          WHEN 1
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx01
          WHEN 2
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx02
          WHEN 3
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx03
          WHEN 4
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx04
          WHEN 5
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx05
          WHEN 6
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx06
          WHEN 7
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx07
          WHEN 8
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx08
          WHEN 9
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx09
          WHEN 10
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx10
          WHEN 11
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx11
          WHEN 12
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx12
          WHEN 13
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx13
          WHEN 14
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx14
          WHEN 15
             CALL s_get_amount_slk(l_j,l_k,p_ima01) RETURNING g_imx[l_i].imx15
         END CASE

      END FOR
   END FOR
   FOR l_i =  g_imx.getLength() TO 1 STEP -1    #如果二維屬性單身的數量全部為零，刪除數據

      IF (g_imx[l_i].imx01 IS NULL OR g_imx[l_i].imx01 = 0) AND
         (g_imx[l_i].imx02 IS NULL OR g_imx[l_i].imx02 = 0) AND
         (g_imx[l_i].imx03 IS NULL OR g_imx[l_i].imx03 = 0) AND
         (g_imx[l_i].imx04 IS NULL OR g_imx[l_i].imx04 = 0) AND
         (g_imx[l_i].imx05 IS NULL OR g_imx[l_i].imx05 = 0) AND
         (g_imx[l_i].imx06 IS NULL OR g_imx[l_i].imx06 = 0) AND
         (g_imx[l_i].imx07 IS NULL OR g_imx[l_i].imx07 = 0) AND
         (g_imx[l_i].imx08 IS NULL OR g_imx[l_i].imx08 = 0) AND
         (g_imx[l_i].imx09 IS NULL OR g_imx[l_i].imx09 = 0) AND
         (g_imx[l_i].imx10 IS NULL OR g_imx[l_i].imx10 = 0) AND
         (g_imx[l_i].imx11 IS NULL OR g_imx[l_i].imx11 = 0) AND
         (g_imx[l_i].imx12 IS NULL OR g_imx[l_i].imx12 = 0) AND
         (g_imx[l_i].imx13 IS NULL OR g_imx[l_i].imx13 = 0) AND
         (g_imx[l_i].imx14 IS NULL OR g_imx[l_i].imx14 = 0) AND
         (g_imx[l_i].imx15 IS NULL OR g_imx[l_i].imx15 = 0)
         THEN
         IF g_prog <> 'artt212' THEN   #FUN-C20101 
          CALL g_imx.deleteElement(l_i)
         END IF #FUN-C20101
      END IF
   END FOR

END FUNCTION

#得到對應的子料件的數量
FUNCTION s_get_amount_slk(p_j,p_k,p_ima01)
    DEFINE l_sql     STRING
    DEFINE p_j       LIKE type_file.num5
    DEFINE p_k       LIKE type_file.num5
    DEFINE p_ima01   LIKE ima_file.ima01
    DEFINE l_ps      LIKE sma_file.sma46
    DEFINE l_qty     LIKE rvb_file.rvb07
    DEFINE l_ima01   LIKE ima_file.ima01
    DEFINE l_azw05   LIKE azw_file.azw05
    DEFINE l_dbs     LIKE type_file.chr21

    SELECT sma46 INTO l_ps FROM sma_file
    IF cl_null(l_ps) THEN
       LET l_ps=' '
    END IF
    LET l_ima01 = p_ima01,l_ps,g_imxtext[p_k].color,l_ps,g_imxtext[p_k].detail[p_j].size  #得到子料件編號

    EXECUTE s_getamount_slk_pre USING l_ima01 INTO l_qty

    IF cl_null(l_qty) THEN
       LET l_qty = 0
    END IF

    RETURN l_qty

END FUNCTION

# Usage..........:更新、刪除、新增子料件數據
# 
# Input Parameter: p_cmd  r:刪除
#                         a:新增
#                         u:修改
#                  p_ac 當前所在的行--g_imx二維屬性單身，光標所在的行
#                  p_ima01            母料件編號
#                  p_keyvalue1        單據編號
#                  p_keyvalue2        母料件項次

FUNCTION s_ins_slk(p_cmd,p_ac,p_ima01,p_keyvalue1,p_keyvalue2)
   DEFINE p_ac                LIKE type_file.num5
   DEFINE p_ima01             LIKE ima_file.ima01
   DEFINE p_cmd               LIKE type_file.chr1
   DEFINE p_keyvalue1         LIKE type_file.chr20
   DEFINE p_keyvalue2         LIKE type_file.chr20
   DEFINE l_sql1              STRING
   DEFINE l_sql2              STRING
   DEFINE l_sql3              STRING
   DEFINE l_sql4              STRING
   DEFINE l_sql5              STRING

   LET g_keyvalue1=p_keyvalue1
   LET g_keyvalue2=p_keyvalue2

   CASE g_prog
       WHEN 'axmt410_slk'
            LET l_sql1 = "SELECT count(*) FROM oeb_file,oebi_file ",
                        "  WHERE oeb04= ? ",
                        "   AND oebi01=oeb01",
                        "   AND oebi03=oeb03",
                        "   AND oebi01='",g_keyvalue1,"'",
                        "   AND oebislk03='",g_keyvalue2,"'"


            LET l_sql3 = "SELECT oebi03 FROM oeb_file,oebi_file ",
                        " WHERE oeb04= ? ",
                        "   AND oeb01=oebi01 ",
                        "   AND oeb03=oebi03 ",
                        "   AND oeb01='",g_keyvalue1,"'",
                        "   AND oebislk03='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM oeb_file ",
                        "  WHERE oeb01='",g_keyvalue1,"'",
                        "    AND oeb03=? "

            LET l_sql5 = " DELETE FROM oebi_file ",
                        "  WHERE oebi01='",g_keyvalue1,"'",
                        "    AND oebi03=? "

       WHEN 'axmt400_slk'
            LET l_sql1 = "SELECT count(*) FROM oeb_file,oebi_file ",
                        "  WHERE oeb04= ? ",
                        "   AND oebi01=oeb01",
                        "   AND oebi03=oeb03",
                        "   AND oebi01='",g_keyvalue1,"'",
                        "   AND oebislk03='",g_keyvalue2,"'"


            LET l_sql3 = "SELECT oebi03 FROM oeb_file,oebi_file ",
                        " WHERE oeb04= ? ",
                        "   AND oeb01=oebi01 ",
                        "   AND oeb03=oebi03 ",
                        "   AND oeb01='",g_keyvalue1,"'",
                        "   AND oebislk03='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM oeb_file ",
                        "  WHERE oeb01='",g_keyvalue1,"'",
                        "    AND oeb03=? "

            LET l_sql5 = " DELETE FROM oebi_file ",
                        "  WHERE oebi01='",g_keyvalue1,"'",
                        "    AND oebi03=? "

       WHEN 'axmt420_slk'
            LET l_sql1 = "SELECT count(*) FROM oeb_file,oebi_file ",
                        "  WHERE oeb04= ? ",
                        "   AND oebi01=oeb01",
                        "   AND oebi03=oeb03",
                        "   AND oebi01='",g_keyvalue1,"'",
                        "   AND oebislk03='",g_keyvalue2,"'"


            LET l_sql3 = "SELECT oebi03 FROM oeb_file,oebi_file ",
                        " WHERE oeb04= ? ",
                        "   AND oeb01=oebi01 ",
                        "   AND oeb03=oebi03 ",
                        "   AND oeb01='",g_keyvalue1,"'",
                        "   AND oebislk03='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM oeb_file ",
                        "  WHERE oeb01='",g_keyvalue1,"'",
                        "    AND oeb03=? "

            LET l_sql5 = " DELETE FROM oebi_file ",
                        "  WHERE oebi01='",g_keyvalue1,"'",
                        "    AND oebi03=? "

       WHEN 'axmt810_slk'
            LET l_sql1 = "SELECT count(*) FROM oeb_file,oebi_file ",
                        "  WHERE oeb04= ? ",
                        "   AND oebi01=oeb01",
                        "   AND oebi03=oeb03",
                        "   AND oebi01='",g_keyvalue1,"'",
                        "   AND oebislk03='",g_keyvalue2,"'"


            LET l_sql3 = "SELECT oebi03 FROM oeb_file,oebi_file ",
                        " WHERE oeb04= ? ",
                        "   AND oeb01=oebi01 ",
                        "   AND oeb03=oebi03 ",
                        "   AND oeb01='",g_keyvalue1,"'",
                        "   AND oebislk03='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM oeb_file ",
                        "  WHERE oeb01='",g_keyvalue1,"'",
                        "    AND oeb03=? "

            LET l_sql5 = " DELETE FROM oebi_file ",
                        "  WHERE oebi01='",g_keyvalue1,"'",
                        "    AND oebi03=? "

       WHEN 'axmt700_slk'
            LET l_sql1 = "SELECT count(*) FROM ohb_file,ohbi_file ",
                        "  WHERE ohb04= ? ",
                        "   AND ohbi01=ohb01",
                        "   AND ohbi03=ohb03",
                        "   AND ohbi01='",g_keyvalue1,"'",
                        "   AND ohbislk02='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT ohbi03 FROM ohb_file,ohbi_file ",
                        " WHERE ohb04= ? ",
                        "   AND ohb01=ohbi01 ",
                        "   AND ohb03=ohbi03 ",
                        "   AND ohb01='",g_keyvalue1,"'",
                        "   AND ohbislk02='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM ohb_file ",
                        "  WHERE ohb01='",g_keyvalue1,"'",
                        "    AND ohb03=? "

            LET l_sql5 = " DELETE FROM ohbi_file ",
                        "  WHERE ohbi01='",g_keyvalue1,"'",
                        "    AND ohbi03=? "

       WHEN 'apmt420_slk'
            LET l_sql1 = "SELECT count(*) FROM pml_file,pmli_file ",
                        "  WHERE pml04= ? ",
                        "   AND pmli01=pml01",
                        "   AND pmli02=pml02",
                        "   AND pmli01='",g_keyvalue1,"'",
                        "   AND pmlislk03='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT pmli02 FROM pml_file,pmli_file ",
                        " WHERE pml04= ? ",
                        "   AND pml01=pmli01 ",
                        "   AND pml02=pmli02 ",
                        "   AND pmli01='",g_keyvalue1,"'",
                        "   AND pmlislk03='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM pml_file ",
                        "  WHERE pml01='",g_keyvalue1,"'",
                        "    AND pml02=? "

            LET l_sql5 = " DELETE FROM pmli_file ",
                        "  WHERE pmli01='",g_keyvalue1,"'",
                        "    AND pmli02=? "
       WHEN 'apmt540_slk'
            LET l_sql1 = "SELECT count(*) FROM pmn_file,pmni_file ",
                        "  WHERE pmn04= ? ",
                        "    AND pmni01=pmn01",
                        "    AND pmni02=pmn02",
                        "    AND pmni01='",g_keyvalue1,"'",
                        "    AND pmnislk03='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT pmni02 FROM pmn_file,pmni_file ",
                        "  WHERE pmn04= ? ",
                        "    AND pmn01=pmni01 ",
                        "    AND pmn02=pmni02 ",
                        "    AND pmni01='",g_keyvalue1,"'",
                        "    AND pmnislk03='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM pmn_file ",
                        "  WHERE pmn01='",g_keyvalue1,"'",
                        "    AND pmn02=? "

            LET l_sql5 = " DELETE FROM pmni_file ",
                        "  WHERE pmni01='",g_keyvalue1,"'",
                        "    AND pmni02=? "

       WHEN 'apmt590_slk'
            LET l_sql1 = "SELECT count(*) FROM pmn_file,pmni_file ",
                        "  WHERE pmn04= ? ",
                        "    AND pmni01=pmn01",
                        "    AND pmni02=pmn02",
                        "    AND pmni01='",g_keyvalue1,"'",
                        "    AND pmnislk03='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT pmni02 FROM pmn_file,pmni_file ",
                        "  WHERE pmn04= ? ",
                        "    AND pmn01=pmni01 ",
                        "    AND pmn02=pmni02 ",
                        "    AND pmni01='",g_keyvalue1,"'",
                        "    AND pmnislk03='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM pmn_file ",
                        "  WHERE pmn01='",g_keyvalue1,"'",
                        "    AND pmn02=? "

            LET l_sql5 = " DELETE FROM pmni_file ",
                        "  WHERE pmni01='",g_keyvalue1,"'",
                        "    AND pmni02=? " 
      
       WHEN 'apmt110_slk'
            LET l_sql1 = "SELECT count(*) FROM rvb_file,rvbi_file ",
                        "  WHERE rvb05= ? ",
                        "    AND rvbi01=rvb01",
                        "    AND rvbi02=rvb02",
                        "    AND rvbi01='",g_keyvalue1,"'",
                        "    AND rvbislk02='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT rvbi02 FROM rvb_file,rvbi_file ",
                        "  WHERE rvb05= ? ",
                        "    AND rvb01=rvbi01 ",
                        "    AND rvb02=rvbi02 ",
                        "    AND rvbi01='",g_keyvalue1,"'",
                        "    AND rvbislk02='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM rvb_file ",
                        "  WHERE rvb01='",g_keyvalue1,"'",
                        "    AND rvb02=? "

            LET l_sql5 = " DELETE FROM rvbi_file ",
                        "  WHERE rvbi01='",g_keyvalue1,"'",
                        "    AND rvbi02=? "
       WHEN 'axmt610_slk'
            LET l_sql1 = "SELECT count(*) FROM ogb_file,ogbi_file ",
                        "  WHERE ogb04= ? ",
                        "    AND ogbi01=ogb01",
                        "    AND ogbi03=ogb03",
                        "    AND ogbi01='",g_keyvalue1,"'",
                        "    AND ogbislk02='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT ogbi03 FROM ogb_file,ogbi_file ",
                        "  WHERE ogb04= ? ",
                        "    AND ogb01=ogbi01 ",
                        "    AND ogb03=ogbi03 ",
                        "    AND ogbi01='",g_keyvalue1,"'",
                        "    AND ogbislk02='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM ogb_file ",
                        "  WHERE ogb01='",g_keyvalue1,"'",
                        "    AND ogb03=? "

            LET l_sql5 = " DELETE FROM ogbi_file ",
                        "  WHERE ogbi01='",g_keyvalue1,"'",
                        "    AND ogbi03=? "
       WHEN 'axmt620_slk'
            LET l_sql1 = "SELECT count(*) FROM ogb_file,ogbi_file ",
                        "  WHERE ogb04= ? ",
                        "    AND ogbi01=ogb01",
                        "    AND ogbi03=ogb03",
                        "    AND ogbi01='",g_keyvalue1,"'",
                        "    AND ogbislk02='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT ogbi03 FROM ogb_file,ogbi_file ",
                        "  WHERE ogb04= ? ",
                        "    AND ogb01=ogbi01 ",
                        "    AND ogb03=ogbi03 ",
                        "    AND ogbi01='",g_keyvalue1,"'",
                        "    AND ogbislk02='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM ogb_file ",
                        "  WHERE ogb01='",g_keyvalue1,"'",
                        "    AND ogb03=? "

            LET l_sql5 = " DELETE FROM ogbi_file ",
                        "  WHERE ogbi01='",g_keyvalue1,"'",
                        "    AND ogbi03=? "
       WHEN 'axmt628_slk'
            LET l_sql1 = "SELECT count(*) FROM ogb_file,ogbi_file ",
                        "  WHERE ogb04= ? ",
                        "    AND ogbi01=ogb01",
                        "    AND ogbi03=ogb03",
                        "    AND ogbi01='",g_keyvalue1,"'",
                        "    AND ogbislk02='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT ogbi03 FROM ogb_file,ogbi_file ",
                        "  WHERE ogb04= ? ",
                        "    AND ogb01=ogbi01 ",
                        "    AND ogb03=ogbi03 ",
                        "    AND ogbi01='",g_keyvalue1,"'",
                        "    AND ogbislk02='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM ogb_file ",
                        "  WHERE ogb01='",g_keyvalue1,"'",
                        "    AND ogb03=? "

            LET l_sql5 = " DELETE FROM ogbi_file ",
                        "  WHERE ogbi01='",g_keyvalue1,"'",
                        "    AND ogbi03=? "
       WHEN 'axmt629_slk'
            LET l_sql1 = "SELECT count(*) FROM ogb_file,ogbi_file ",
                        "  WHERE ogb04= ? ",
                        "    AND ogbi01=ogb01",
                        "    AND ogbi03=ogb03",
                        "    AND ogbi01='",g_keyvalue1,"'",
                        "    AND ogbislk02='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT ogbi03 FROM ogb_file,ogbi_file ",
                        "  WHERE ogb04= ? ",
                        "    AND ogb01=ogbi01 ",
                        "    AND ogb03=ogbi03 ",
                        "    AND ogbi01='",g_keyvalue1,"'",
                        "    AND ogbislk02='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM ogb_file ",
                        "  WHERE ogb01='",g_keyvalue1,"'",
                        "    AND ogb03=? "

            LET l_sql5 = " DELETE FROM ogbi_file ",
                        "  WHERE ogbi01='",g_keyvalue1,"'",
                        "    AND ogbi03=? "
       WHEN 'axmt640_slk'
            LET l_sql1 = "SELECT count(*) FROM ogb_file,ogbi_file ",
                        "  WHERE ogb04= ? ",
                        "    AND ogbi01=ogb01",
                        "    AND ogbi03=ogb03",
                        "    AND ogbi01='",g_keyvalue1,"'",
                        "    AND ogbislk02='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT ogbi03 FROM ogb_file,ogbi_file ",
                        "  WHERE ogb04= ? ",
                        "    AND ogb01=ogbi01 ",
                        "    AND ogb03=ogbi03 ",
                        "    AND ogbi01='",g_keyvalue1,"'",
                        "    AND ogbislk02='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM ogb_file ",
                        "  WHERE ogb01='",g_keyvalue1,"'",
                        "    AND ogb03=? "

            LET l_sql5 = " DELETE FROM ogbi_file ",
                        "  WHERE ogbi01='",g_keyvalue1,"'",
                        "    AND ogbi03=? "

       WHEN 'artt212'
            LET l_sql1 = "SELECT count(*) FROM rux_file ",
                        "  WHERE rux03= ? ",
                        "    AND rux01='",g_keyvalue1,"'",
                        "    AND rux11s='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT rux02 FROM rux_file ",
                        "  WHERE rux03= ? ",
                        "    AND rux01='",g_keyvalue1,"'",
                        "    AND rux11s='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM rux_file ",
                        "  WHERE rux01='",g_keyvalue1,"'",
                        "    AND rux02=? "

 
            LET l_sql5 = " DELETE FROM rux_file ",
                        "  WHERE rux01='",g_keyvalue1,"'",
                        "    AND rux02=? "

       WHEN 'artt256'
            LET l_sql1 = "SELECT count(*) FROM rup_file ",
                        "  WHERE rup03= ? ",
                        "    AND rup01='",g_keyvalue1,"'",
                        "    AND rup21s='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT rup02 FROM rup_file ",
                        "  WHERE rup03= ? ",
                        "    AND rup01='",g_keyvalue1,"'",
                        "    AND rup21s='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM rup_file ",
                        "  WHERE rup01='",g_keyvalue1,"'",
                        "    AND rup02=? "

            LET l_sql5 = " DELETE FROM rup_file ",
                        "  WHERE rup01='",g_keyvalue1,"'",
                        "    AND rup02=? "

       WHEN 'apmt720_slk'
            LET l_sql1 = "SELECT count(*) FROM rvv_file,rvvi_file ",
                        "  WHERE rvv31= ? ",
                        "    AND rvv01=rvvi01 AND rvv02=rvvi02",
                        "    AND rvvi01='",g_keyvalue1,"'",
                        "    AND rvvislk02='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT rvvi02 FROM rvv_file,rvvi_file ",
                        "  WHERE rvv31= ? ",
                        "    AND rvv01=rvvi01 AND rvv02=rvvi02",
                        "    AND rvvi01='",g_keyvalue1,"'",
                        "    AND rvvislk02='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM rvv_file ",
                        "  WHERE rvv01='",g_keyvalue1,"'",
                        "    AND rvv02=? "

            LET l_sql5 = " DELETE FROM rvvi_file ",
                        "  WHERE rvvi01='",g_keyvalue1,"'",
                        "    AND rvvi02=? "
       WHEN 'apmt722_slk'
            LET l_sql1 = "SELECT count(*) FROM rvv_file,rvvi_file ",
                        "  WHERE rvv31= ? ",
                        "    AND rvv01=rvvi01 AND rvv02=rvvi02",
                        "    AND rvvi01='",g_keyvalue1,"'",
                        "    AND rvvislk02='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT rvvi02 FROM rvv_file,rvvi_file ",
                        "  WHERE rvv31= ? ",
                        "    AND rvv01=rvvi01 AND rvv02=rvvi02",
                        "    AND rvvi01='",g_keyvalue1,"'",
                        "    AND rvvislk02='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM rvv_file ",
                        "  WHERE rvv01='",g_keyvalue1,"'",
                        "    AND rvv02=? "

            LET l_sql5 = " DELETE FROM rvvi_file ",
                        "  WHERE rvvi01='",g_keyvalue1,"'",
                        "    AND rvvi02=? "
#FUN-C20101------ADD----STR------                        

       WHEN 'aimt301_slk'
            LET l_sql1 = "SELECT count(*) FROM inb_file,inbi_file ",
                        "  WHERE inb04= ? ",
                        "   AND inbi01=inb01",
                        "   AND inbi03=inb03",
                        "   AND inbi01='",g_keyvalue1,"'",
                        "   AND inbislk02='",g_keyvalue2,"'"
            LET l_sql3 = "SELECT inbi03 FROM inb_file,inbi_file ",
                        " WHERE inb04= ? ",
                        "   AND inb01=inbi01 ",
                        "   AND inb03=inbi03 ",
                        "   AND inb01='",g_keyvalue1,"'",
                        "   AND inbislk02='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM inb_file ",
                        "  WHERE inb01='",g_keyvalue1,"'",
                        "    AND inb03=? "

            LET l_sql5 = " DELETE FROM inbi_file ",
                        "  WHERE inbi01='",g_keyvalue1,"'",
                        "    AND inbi03=? "
       WHEN 'aimt302_slk'
            LET l_sql1 = "SELECT count(*) FROM inb_file,inbi_file ",
                        "  WHERE inb04= ? ",
                        "   AND inbi01=inb01",
                        "   AND inbi03=inb03",
                        "   AND inbi01='",g_keyvalue1,"'",
                        "   AND inbislk02='",g_keyvalue2,"'"
            LET l_sql3 = "SELECT inbi03 FROM inb_file,inbi_file ",
                        " WHERE inb04= ? ",
                        "   AND inb01=inbi01 ",
                        "   AND inb03=inbi03 ",
                        "   AND inb01='",g_keyvalue1,"'",
                        "   AND inbislk02='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM inb_file ",
                        "  WHERE inb01='",g_keyvalue1,"'",
                        "    AND inb03=? "

            LET l_sql5 = " DELETE FROM inbi_file ",
                        "  WHERE inbi01='",g_keyvalue1,"'",
                        "    AND inbi03=? "                 
       WHEN 'aimt303_slk'
            LET l_sql1 = "SELECT count(*) FROM inb_file,inbi_file ",
                        "  WHERE inb04= ? ",
                        "   AND inbi01=inb01",
                        "   AND inbi03=inb03",
                        "   AND inbi01='",g_keyvalue1,"'",
                        "   AND inbislk02='",g_keyvalue2,"'"
            LET l_sql3 = "SELECT inbi03 FROM inb_file,inbi_file ",
                        " WHERE inb04= ? ",
                        "   AND inb01=inbi01 ",
                        "   AND inb03=inbi03 ",
                        "   AND inb01='",g_keyvalue1,"'",
                        "   AND inbislk02='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM inb_file ",
                        "  WHERE inb01='",g_keyvalue1,"'",
                        "    AND inb03=? "

            LET l_sql5 = " DELETE FROM inbi_file ",
                        "  WHERE inbi01='",g_keyvalue1,"'",
                        "    AND inbi03=? "
#FUN-C20101--------ADD---END----------                        
#FUN-C30057--------ADD---STR---------- 
  
        WHEN 'apmt580_slk'
            LET l_sql1 = "SELECT count(*) FROM pon_file,poni_file ",
                        "  WHERE pon04= ? ",
                        "   AND poni01=pon01",
                        "   AND poni02=pon02",
                        "   AND poni01='",g_keyvalue1,"'",
                        "   AND ponislk02='",g_keyvalue2,"'"

            LET l_sql3 = "SELECT poni02 FROM pon_file,poni_file ",
                        " WHERE pon04= ? ",
                        "   AND pon01=poni01 ",
                        "   AND pon02=poni02 ",
                        "   AND poni01='",g_keyvalue1,"'",
                        "   AND ponislk02='",g_keyvalue2,"'"

            LET l_sql4 = " DELETE FROM pon_file ",
                        "  WHERE pon01='",g_keyvalue1,"'",
                        "    AND pon02=? "

            LET l_sql5 = " DELETE FROM poni_file ",
                        "  WHERE poni01='",g_keyvalue1,"'",
                        "    AND poni02=? "                 
#FUN-C30057--------ADD---END---------- 
   END CASE
   PREPARE s_getcount_slk_pre FROM l_sql1  #檢查是否存在
   PREPARE s_selkey_slk_pre   FROM l_sql3  #得到對應子料件的項次
   PREPARE s_delslk_slk_pre   FROM l_sql4  #刪除子料件
   PREPARE s_delslk_slk_pre2  FROM l_sql5  #刪除子料件


   IF g_imx[p_ac].imx01 >= 0 THEN
      CALL s_imx_ins_slk(p_ac,1,g_imx[p_ac].imx01,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx02 >=0 THEN
      CALL s_imx_ins_slk(p_ac,2,g_imx[p_ac].imx02,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx03 >=0 THEN
      CALL s_imx_ins_slk(p_ac,3,g_imx[p_ac].imx03,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx04 >=0 THEN
      CALL s_imx_ins_slk(p_ac,4,g_imx[p_ac].imx04,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx05 >=0 THEN
      CALL s_imx_ins_slk(p_ac,5,g_imx[p_ac].imx05,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx06 >=0 THEN
      CALL s_imx_ins_slk(p_ac,6,g_imx[p_ac].imx06,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx07 >=0 THEN
      CALL s_imx_ins_slk(p_ac,7,g_imx[p_ac].imx07,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx08 >=0 THEN
      CALL s_imx_ins_slk(p_ac,8,g_imx[p_ac].imx08,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx09 >=0 THEN
      CALL s_imx_ins_slk(p_ac,9,g_imx[p_ac].imx09,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx10 >=0 THEN
      CALL s_imx_ins_slk(p_ac,10,g_imx[p_ac].imx10,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx11 >=0 THEN
      CALL s_imx_ins_slk(p_ac,11,g_imx[p_ac].imx11,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx12 >=0 THEN
      CALL s_imx_ins_slk(p_ac,12,g_imx[p_ac].imx12,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx13 >=0 THEN
      CALL s_imx_ins_slk(p_ac,13,g_imx[p_ac].imx13,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx14 >=0 THEN
      CALL s_imx_ins_slk(p_ac,14,g_imx[p_ac].imx14,p_cmd,p_ima01)
   END IF
   IF g_imx[p_ac].imx15 >=0 THEN
      CALL s_imx_ins_slk(p_ac,15,g_imx[p_ac].imx15,p_cmd,p_ima01)
   END IF
END FUNCTION


FUNCTION s_imx_ins_slk(p_i,p_index,p_qty,p_cmd,p_ima01)
   DEFINE p_i           LIKE type_file.num5
   DEFINE p_index       LIKE type_file.num5
   DEFINE p_qty         LIKE type_file.num10
   DEFINE l_ima01       LIKE ima_file.ima01
   DEFINE p_ima01       LIKE ima_file.ima01
   DEFINE l_n           LIKE type_file.num5
   DEFINE p_cmd         LIKE type_file.chr1
   DEFINE l_key2        LIKE oebi_file.oebi03
   DEFINE l_max         LIKE type_file.num5
   DEFINE l_oea213      LIKE oea_file.oea213
   DEFINE l_oea211      LIKE oea_file.oea211
   DEFINE l_oha213      LIKE oha_file.oha213
   DEFINE l_oha211      LIKE oha_file.oha211
   DEFINE l_gec05       LIKE gec_file.gec05
   DEFINE l_gec07       LIKE gec_file.gec05
   DEFINE l_pmm21       LIKE pmm_file.pmm21
   DEFINE l_pmm22       LIKE pmm_file.pmm22
   DEFINE l_pmm43       LIKE pmm_file.pmm43
   DEFINE l_pmnslk25    LIKE pmnslk_file.pmnslk25
   DEFINE l_oga211      LIKE oga_file.oga211
   DEFINE l_oga213      LIKE oga_file.oga213
   DEFINE l_ohbslk32    LIKE ohbslk_file.ohbslk32
   DEFINE l_pmm09       LIKE pmm_file.pmm09
   DEFINE l_pmn24       LIKE pmn_file.pmn24
   DEFINE l_pmn25       LIKE pmn_file.pmn25
   DEFINE l_pmn20       LIKE pmn_file.pmn20 
   DEFINE l_rvv36       LIKE rvv_file.rvv36
   DEFINE l_rvv38       LIKE rvv_file.rvv38
   DEFINE l_rvv38t      LIKE rvv_file.rvv38t
   DEFINE l_rvv39       LIKE rvv_file.rvv39
   DEFINE l_rvv39t      LIKE rvv_file.rvv39t
   DEFINE l_rvu00       LIKE rvu_file.rvu00
   DEFINE l_rvu02       LIKE rvu_file.rvu02
   DEFINE l_rvu04       LIKE rvu_file.rvu04
   DEFINE l_rvu113      LIKE rvu_file.rvu113
   DEFINE l_rva00       LIKE rva_file.rva00
   DEFINE l_rva113      LIKE rva_file.rva113
   DEFINE l_rvb82       LIKE rvb_file.rvb82 
   DEFINE l_rvb85       LIKE rvb_file.rvb85
   DEFINE l_oea03       LIKE oea_file.oea03,  #TQC-C20339 add
          l_oea23       LIKE oea_file.oea23   #TQC-C20339 add
   DEFINE l_pmnslk69    LIKE pmnslk_file.pmnslk69     #FUN-C30130
   DEFINE l_pmn68       LIKE pmn_file.pmn68    #FUN-C30130 add
   DEFINE l_pmn69       LIKE pmn_file.pmn69    #FUN-C30130 add
   DEFINE l_pon07       LIKE pon_file.pon07    #FUN-C30130 add

#得到子料件編號
   CALL s_get_ima_slk(p_i,p_index,p_ima01) RETURNING l_ima01


   EXECUTE s_getcount_slk_pre USING l_ima01 INTO l_n

   IF l_n > 0 THEN                      #數據庫中有子料件的數據
      IF p_qty > 0 AND p_cmd='u' THEN   #修改子料件的數量

         CASE g_prog
             WHEN 'axmt410_slk'
                 SELECT oea213,oea211 INTO l_oea213,l_oea211 FROM oea_file WHERE oea01=g_keyvalue1
                 IF l_oea213='N' THEN
                    UPDATE oeb_file SET oeb12 =p_qty,
                                        oeb912=p_qty,
                                        oeb917=p_qty,
                                        oeb14=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty,t_azi04),
                                        oeb14t=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty*(1+ l_oea211/100),t_azi04)
                      WHERE oeb04=l_ima01
                        AND oeb01=g_keyvalue1
                        AND oeb03 in (
                                        SELECT oebi03 FROM oebi_file
                                         WHERE oebi01=g_keyvalue1
                                           AND oebislk03=g_keyvalue2)
                 ELSE
                    UPDATE oeb_file SET oeb12 =p_qty,
                                        oeb912=p_qty,
                                        oeb917=p_qty,
                                        oeb14t=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty,t_azi04),
                                        oeb14=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty/(1+ l_oea211/100),t_azi04)
                      WHERE oeb04=l_ima01
                        AND oeb01=g_keyvalue1
                        AND oeb03 in (
                                        SELECT oebi03 FROM oebi_file
                                         WHERE oebi01=g_keyvalue1
                                           AND oebislk03=g_keyvalue2)
                 END IF

             WHEN 'axmt400_slk'
                 SELECT oea213,oea211 INTO l_oea213,l_oea211 FROM oea_file WHERE oea01=g_keyvalue1
                 IF l_oea213='N' THEN
                    UPDATE oeb_file SET oeb12 =p_qty,
                                        oeb912=p_qty,
                                        oeb917=p_qty,
                                        oeb14=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty,t_azi04),
                                        oeb14t=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty*(1+ l_oea211/100),t_azi04)
                      WHERE oeb04=l_ima01
                        AND oeb01=g_keyvalue1
                        AND oeb03 in (
                                        SELECT oebi03 FROM oebi_file
                                         WHERE oebi01=g_keyvalue1
                                           AND oebislk03=g_keyvalue2)
                 ELSE
                    UPDATE oeb_file SET oeb12 =p_qty,
                                        oeb912=p_qty,
                                        oeb917=p_qty,
                                        oeb14t=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty,t_azi04),
                                        oeb14=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty/(1+ l_oea211/100),t_azi04)
                      WHERE oeb04=l_ima01
                        AND oeb01=g_keyvalue1
                        AND oeb03 in (
                                        SELECT oebi03 FROM oebi_file
                                         WHERE oebi01=g_keyvalue1
                                           AND oebislk03=g_keyvalue2)
                 END IF

             WHEN 'axmt420_slk'
                 SELECT oea213,oea211 INTO l_oea213,l_oea211 FROM oea_file WHERE oea01=g_keyvalue1
                 IF l_oea213='N' THEN
                    UPDATE oeb_file SET oeb12 =p_qty,
                                        oeb912=p_qty,
                                        oeb917=p_qty,
                                        oeb14=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty,t_azi04),
                                        oeb14t=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty*(1+ l_oea211/100),t_azi04)
                      WHERE oeb04=l_ima01
                        AND oeb01=g_keyvalue1
                        AND oeb03 in (
                                        SELECT oebi03 FROM oebi_file
                                         WHERE oebi01=g_keyvalue1
                                           AND oebislk03=g_keyvalue2)
                 ELSE
                    UPDATE oeb_file SET oeb12 =p_qty,
                                        oeb912=p_qty,
                                        oeb917=p_qty,
                                        oeb14t=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty,t_azi04),
                                        oeb14=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty/(1+ l_oea211/100),t_azi04)
                      WHERE oeb04=l_ima01
                        AND oeb01=g_keyvalue1
                        AND oeb03 in (
                                        SELECT oebi03 FROM oebi_file
                                         WHERE oebi01=g_keyvalue1
                                           AND oebislk03=g_keyvalue2)
                 END IF
                   
             WHEN 'axmt810_slk'
                 SELECT oea213,oea211 INTO l_oea213,l_oea211 FROM oea_file WHERE oea01=g_keyvalue1
                 IF l_oea213='N' THEN
                    UPDATE oeb_file SET oeb12 =p_qty,
                                        oeb912=p_qty,
                                        oeb917=p_qty,
                                        oeb14=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty,t_azi04),
                                        oeb14t=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty*(1+ l_oea211/100),t_azi04)
                      WHERE oeb04=l_ima01
                        AND oeb01=g_keyvalue1
                        AND oeb03 in (
                                        SELECT oebi03 FROM oebi_file
                                         WHERE oebi01=g_keyvalue1
                                           AND oebislk03=g_keyvalue2)
                 ELSE
                    UPDATE oeb_file SET oeb12 =p_qty,
                                        oeb912=p_qty,
                                        oeb917=p_qty,
                                        oeb14t=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty,t_azi04),
                                        oeb14=ROUND(ROUND(oeb13*oeb1006/100,t_azi03)*p_qty/(1+ l_oea211/100),t_azi04)
                      WHERE oeb04=l_ima01
                        AND oeb01=g_keyvalue1
                        AND oeb03 in (
                                        SELECT oebi03 FROM oebi_file
                                         WHERE oebi01=g_keyvalue1
                                           AND oebislk03=g_keyvalue2)
                 END IF
     
              WHEN 'axmt700_slk'
                 SELECT oha213,oha211 INTO l_oha213,l_oha211 FROM oha_file WHERE oha01=g_keyvalue1
                 IF l_oha213='N' THEN
                    UPDATE ohb_file SET ohb12 =p_qty,
                                        ohb16 =p_qty,
                                        ohb912=p_qty,
                                        ohb915=p_qty,
                                        ohb917=p_qty,
                                        ohb14 =ROUND(ohb13*p_qty*ohb1003/100,t_azi04),
                                        ohb14t=ROUND(ohb13*p_qty*ohb1003*(1+l_oha211/100)/100,t_azi04)
                     WHERE ohb04=l_ima01
                       AND ohb01=g_keyvalue1
                       AND ohb03 in (
                                       SELECT ohbi03 FROM ohbi_file
                                        WHERE ohbi01=g_keyvalue1
                                          AND ohbislk02=g_keyvalue2)

                 ELSE
                    UPDATE ohb_file SET ohb12 =p_qty,
                                        ohb16 =p_qty,
                                        ohb912=p_qty,
                                        ohb915=p_qty,
                                        ohb917=p_qty,
                                        ohb14t=ROUND(ohb13*p_qty*ohb1003/100,t_azi04),
                                        ohb14 =ROUND(ohb13*p_qty*ohb1003/(1+l_oha211/100)/100,t_azi04)
                     WHERE ohb04=l_ima01
                       AND ohb01=g_keyvalue1
                       AND ohb03 in (
                                       SELECT ohbi03 FROM ohbi_file
                                        WHERE ohbi01=g_keyvalue1
                                          AND ohbislk02=g_keyvalue2)
                 END IF

                   UPDATE ohb_file SET ohb12 =p_qty 
                    WHERE ohb04=l_ima01 
                      AND ohb01=g_keyvalue1
                      AND ohb03 in (
                                      SELECT ohbi03 FROM ohbi_file 
                                       WHERE ohbi01=g_keyvalue1
                                         AND ohbislk02=g_keyvalue2)
              WHEN 'apmt420_slk'

                    UPDATE pml_file SET pml20 =p_qty,
                                        pml82 =p_qty,
                                        pml87 =p_qty,
                                        pml88 =ROUND(pml31*p_qty,t_azi04),
                                        pml88t=ROUND(pml31t*p_qty,t_azi04)
                     WHERE pml04=l_ima01 
                       AND pml01=g_keyvalue1
                       AND pml02 in (
                                       SELECT pmli02 FROM pmli_file 
                                        WHERE pmli01=g_keyvalue1
                                          AND pmlislk03=g_keyvalue2)
              WHEN 'apmt540_slk'
                    SELECT pmm21,pmm43 INTO l_pmm21,l_pmm43 FROM pmm_file WHERE pmm01=g_keyvalue1
                    SELECT gec05,gec07 INTO l_gec05,l_gec07 FROM gec_file WHERE gec011='1'
                                                              AND gecacti='Y'
                                                              AND gec01=l_pmm21
                    IF l_gec07='Y' THEN
                       IF l_gec05 = 'T' THEN
                          UPDATE pmn_file SET pmn20 =p_qty,
                                              pmn82 =p_qty,
                                              pmn85 =p_qty,
                                              pmn87 =p_qty,
                                              pmn88 =ROUND(ROUND(pmn31t*p_qty,t_azi04)*(1 - l_pmm43/100),t_azi04),
                                              pmn88t=ROUND(ROUND(pmn31t*p_qty,t_azi04),t_azi04)
                           WHERE pmn04=l_ima01
                             AND pmn01=g_keyvalue1
                             AND pmn02 in (
                                             SELECT pmni02 FROM pmni_file
                                              WHERE pmni01=g_keyvalue1
                                                AND pmnislk03=g_keyvalue2)
                       ELSE
                          UPDATE pmn_file SET pmn20 =p_qty,
                                              pmn82 =p_qty,
                                              pmn85 =p_qty,
                                              pmn87 =p_qty,
                                              pmn88 =ROUND(ROUND(pmn31t*p_qty,t_azi04)/(1 + l_pmm43/100),t_azi04),
                                              pmn88t=ROUND(ROUND(pmn31t*p_qty,t_azi04),t_azi04)
                           WHERE pmn04=l_ima01
                             AND pmn01=g_keyvalue1
                             AND pmn02 in (
                                             SELECT pmni02 FROM pmni_file
                                              WHERE pmni01=g_keyvalue1
                                                AND pmnislk03=g_keyvalue2)
                       END IF
                    ELSE
                       UPDATE pmn_file SET pmn20 =p_qty,
                                           pmn82 =p_qty,
                                           pmn85 =p_qty,
                                           pmn87 =p_qty,
                                           pmn88 =ROUND(ROUND(pmn31*p_qty,t_azi04),t_azi04),
                                           pmn88t=ROUND(ROUND(pmn31*p_qty,t_azi04)*(1 + l_pmm43/100),t_azi04)
                        WHERE pmn04=l_ima01
                          AND pmn01=g_keyvalue1
                          AND pmn02 in (
                                          SELECT pmni02 FROM pmni_file
                                           WHERE pmni01=g_keyvalue1
                                             AND pmnislk03=g_keyvalue2)
                    END IF

              WHEN 'apmt590_slk'
                    SELECT pmm21,pmm43 INTO l_pmm21,l_pmm43 FROM pmm_file WHERE pmm01=g_keyvalue1
                    SELECT gec05,gec07 INTO l_gec05,l_gec07 FROM gec_file WHERE gec011='1'
                                                              AND gecacti='Y'
                                                              AND gec01=l_pmm21
                    IF l_gec07='Y' THEN
                       IF l_gec05 = 'T' THEN
                          UPDATE pmn_file SET pmn20 =p_qty,
                                              pmn82 =p_qty,
                                              pmn85 =p_qty,
                                              pmn87 =p_qty,
                                              pmn88 =ROUND(ROUND(pmn31t*p_qty,t_azi04)*(1 - l_pmm43/100),t_azi04),
                                              pmn88t=ROUND(ROUND(pmn31t*p_qty,t_azi04),t_azi04)
                           WHERE pmn04=l_ima01
                             AND pmn01=g_keyvalue1
                             AND pmn02 in (
                                             SELECT pmni02 FROM pmni_file
                                              WHERE pmni01=g_keyvalue1
                                                AND pmnislk03=g_keyvalue2)
                       ELSE
                          UPDATE pmn_file SET pmn20 =p_qty,
                                              pmn82 =p_qty,
                                              pmn85 =p_qty,
                                              pmn87 =p_qty,
                                              pmn88 =ROUND(ROUND(pmn31t*p_qty,t_azi04)/(1 + l_pmm43/100),t_azi04),
                                              pmn88t=ROUND(ROUND(pmn31t*p_qty,t_azi04),t_azi04)
                           WHERE pmn04=l_ima01
                             AND pmn01=g_keyvalue1
                             AND pmn02 in (
                                             SELECT pmni02 FROM pmni_file
                                              WHERE pmni01=g_keyvalue1
                                                AND pmnislk03=g_keyvalue2)
                       END IF
                    ELSE
                       UPDATE pmn_file SET pmn20 =p_qty,
                                           pmn82 =p_qty,
                                           pmn85 =p_qty,
                                           pmn87 =p_qty,
                                           pmn88 =ROUND(ROUND(pmn31*p_qty,t_azi04),t_azi04),
                                           pmn88t=ROUND(ROUND(pmn31*p_qty,t_azi04)*(1 + l_pmm43/100),t_azi04)
                        WHERE pmn04=l_ima01
                          AND pmn01=g_keyvalue1
                          AND pmn02 in (
                                          SELECT pmni02 FROM pmni_file
                                           WHERE pmni01=g_keyvalue1
                                             AND pmnislk03=g_keyvalue2)
                    END IF
              
              WHEN 'apmt110_slk'
                    SELECT pmm21,pmm43 INTO l_pmm21,l_pmm43 FROM pmm_file,rvbslk_file
                      WHERE pmm01=rvbslk04 AND rvbslk03=g_keyvalue2 AND rvbslk01=g_keyvalue1

                    SELECT gec05,gec07 INTO l_gec05,l_gec07 FROM gec_file WHERE gec011='1'
                                                              AND gecacti='Y'
                                                              AND gec01=l_pmm21
                    IF g_sma.sma115 = 'Y' THEN
                       LET l_rvb82 = p_qty
                       LET l_rvb85 = p_qty
                    ELSE
                       LET l_rvb82 = NULL
                       LET l_rvb85 = NULL 
                    END IF
                    IF l_gec07='Y' THEN
                       IF l_gec05 = 'T' THEN
                          UPDATE rvb_file SET rvb07 =p_qty,
                                              rvb31 =p_qty,
                                              rvb82 =l_rvb82,
                                              rvb85 =l_rvb85,
                                              rvb87 =p_qty,
                                              rvb88 =ROUND(rvb10t*p_qty(1 - l_pmm43/100),t_azi04),
                                              rvb88t=ROUND(rvb10t*p_qty,t_azi04)
                           WHERE rvb05=l_ima01
                             AND rvb01=g_keyvalue1
                             AND rvb02 in (
                                             SELECT rvbi02 FROM rvbi_file
                                              WHERE rvbi01=g_keyvalue1
                                                AND rvbislk02=g_keyvalue2)
                       ELSE
                          UPDATE rvb_file SET rvb07 =p_qty,
                                              rvb31 =p_qty,
                                              rvb82 =l_rvb82,
                                              rvb85 =l_rvb85,
                                              rvb87 =p_qty,
                                              rvb88 =ROUND(rvb10t*p_qty/(1 + l_pmm43/100),t_azi04),
                                              rvb88t=ROUND(rvb10t*p_qty,t_azi04)
                           WHERE rvb05=l_ima01
                             AND rvb01=g_keyvalue1
                             AND rvb02 in (
                                             SELECT rvbi02 FROM rvbi_file
                                              WHERE rvbi01=g_keyvalue1
                                                AND rvbislk02=g_keyvalue2)
                       END IF
                    ELSE
                       UPDATE rvb_file SET rvb07 =p_qty,
                                           rvb31 =p_qty,
                                           rvb82 =l_rvb82,
                                           rvb85 =l_rvb85,
                                           rvb87 =p_qty,
                                           rvb88 =ROUND(rvb10*p_qty,t_azi04),
                                           rvb88t=ROUND(rvb10*p_qty*(1 + l_pmm43/100),t_azi04)
                        WHERE rvb05=l_ima01
                          AND rvb01=g_keyvalue1
                          AND rvb02 in (
                                          SELECT rvbi02 FROM rvbi_file
                                           WHERE rvbi01=g_keyvalue1
                                             AND rvbislk02=g_keyvalue2)
                    END IF

              WHEN 'axmt610_slk'
                    SELECT oga211,oga213 INTO l_oga211,l_oga213 FROM oga_file WHERE oga01=g_keyvalue1 AND oga09='1'

                    IF l_oga213='N' THEN
                       UPDATE ogb_file SET ogb12 =p_qty,
                                           ogb16 =p_qty,
                                           ogb18 =p_qty,
                                           ogb912 =p_qty,
                                           ogb917 =p_qty,
                                           ogb14 =ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty,t_azi04),
                                           ogb14t=ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty*(1+ l_oga211/100),t_azi04)
                        WHERE ogb04=l_ima01
                          AND ogb01=g_keyvalue1
                          AND ogb03 in (
                                          SELECT ogbi03 FROM ogbi_file
                                           WHERE ogbi01=g_keyvalue1
                                             AND ogbislk02=g_keyvalue2)
                    ELSE
                       UPDATE ogb_file SET ogb12 =p_qty,
                                           ogb16 =p_qty,
                                           ogb18 =p_qty,
                                           ogb912 =p_qty,
                                           ogb917 =p_qty,
                                           ogb14t =ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty,t_azi04),
                                           ogb14=ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty/(1+ l_oga211/100),t_azi04)
                        WHERE ogb04=l_ima01
                          AND ogb01=g_keyvalue1
                          AND ogb03 in (
                                          SELECT ogbi03 FROM ogbi_file
                                           WHERE ogbi01=g_keyvalue1
                                             AND ogbislk02=g_keyvalue2)
                    END IF
              WHEN 'axmt620_slk'
                    SELECT oga211,oga213 INTO l_oga211,l_oga213 FROM oga_file WHERE oga01=g_keyvalue1 AND oga09='2'

                    IF l_oga213='N' THEN
                       UPDATE ogb_file SET ogb12 =p_qty,
                                           ogb16 =p_qty,
                                           ogb18 =p_qty,
                                           ogb912 =p_qty,
                                           ogb917 =p_qty,
                                           ogb14 =ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty,t_azi04),
                                           ogb14t=ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty*(1+ l_oga211/100),t_azi04)
                        WHERE ogb04=l_ima01
                          AND ogb01=g_keyvalue1
                          AND ogb03 in (
                                          SELECT ogbi03 FROM ogbi_file
                                           WHERE ogbi01=g_keyvalue1
                                             AND ogbislk02=g_keyvalue2)
                    ELSE
                       UPDATE ogb_file SET ogb12 =p_qty,
                                           ogb16 =p_qty,
                                           ogb18 =p_qty,
                                           ogb912 =p_qty,
                                           ogb917 =p_qty,
                                           ogb14t =ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty,t_azi04),
                                           ogb14=ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty/(1+ l_oga211/100),t_azi04)
                        WHERE ogb04=l_ima01
                          AND ogb01=g_keyvalue1
                          AND ogb03 in (
                                          SELECT ogbi03 FROM ogbi_file
                                           WHERE ogbi01=g_keyvalue1
                                             AND ogbislk02=g_keyvalue2)
                    END IF
              WHEN 'axmt628_slk'
                    SELECT oga211,oga213 INTO l_oga211,l_oga213 FROM oga_file WHERE oga01=g_keyvalue1 AND oga09='2'

                    IF l_oga213='N' THEN
                       UPDATE ogb_file SET ogb12 =p_qty,
                                           ogb16 =p_qty,
                                           ogb18 =p_qty,
                                           ogb912 =p_qty,
                                           ogb917 =p_qty,
                                           ogb14 =ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty,t_azi04),
                                           ogb14t=ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty*(1+ l_oga211/100),t_azi04)
                        WHERE ogb04=l_ima01
                          AND ogb01=g_keyvalue1
                          AND ogb03 in (
                                          SELECT ogbi03 FROM ogbi_file
                                           WHERE ogbi01=g_keyvalue1
                                             AND ogbislk02=g_keyvalue2)
                    ELSE
                       UPDATE ogb_file SET ogb12 =p_qty,
                                           ogb16 =p_qty,
                                           ogb18 =p_qty,
                                           ogb912 =p_qty,
                                           ogb917 =p_qty,
                                           ogb14t =ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty,t_azi04),
                                           ogb14=ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty/(1+ l_oga211/100),t_azi04)
                        WHERE ogb04=l_ima01
                          AND ogb01=g_keyvalue1
                          AND ogb03 in (
                                          SELECT ogbi03 FROM ogbi_file
                                           WHERE ogbi01=g_keyvalue1
                                             AND ogbislk02=g_keyvalue2)
                    END IF
              WHEN 'axmt629_slk'
                    SELECT oga211,oga213 INTO l_oga211,l_oga213 FROM oga_file WHERE oga01=g_keyvalue1 AND oga09='2'

                    IF l_oga213='N' THEN
                       UPDATE ogb_file SET ogb12 =p_qty,
                                           ogb16 =p_qty,
                                           ogb18 =p_qty,
                                           ogb912 =p_qty,
                                           ogb917 =p_qty,
                                           ogb14 =ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty,t_azi04),
                                           ogb14t=ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty*(1+ l_oga211/100),t_azi04)
                        WHERE ogb04=l_ima01
                          AND ogb01=g_keyvalue1
                          AND ogb03 in (
                                          SELECT ogbi03 FROM ogbi_file
                                           WHERE ogbi01=g_keyvalue1
                                             AND ogbislk02=g_keyvalue2)
                    ELSE
                       UPDATE ogb_file SET ogb12 =p_qty,
                                           ogb16 =p_qty,
                                           ogb18 =p_qty,
                                           ogb912 =p_qty,
                                           ogb917 =p_qty,
                                           ogb14t =ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty,t_azi04),
                                           ogb14=ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty/(1+ l_oga211/100),t_azi04)
                        WHERE ogb04=l_ima01
                          AND ogb01=g_keyvalue1
                          AND ogb03 in (
                                          SELECT ogbi03 FROM ogbi_file
                                           WHERE ogbi01=g_keyvalue1
                                             AND ogbislk02=g_keyvalue2)
                    END IF
              WHEN 'axmt640_slk'
                    SELECT oga211,oga213 INTO l_oga211,l_oga213 FROM oga_file WHERE oga01=g_keyvalue1 AND oga09='2'

                    IF l_oga213='N' THEN
                       UPDATE ogb_file SET ogb12 =p_qty,
                                           ogb16 =p_qty,
                                           ogb18 =p_qty,
                                           ogb912 =p_qty,
                                           ogb917 =p_qty,
                                           ogb14 =ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty,t_azi04),
                                           ogb14t=ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty*(1+ l_oga211/100),t_azi04)
                        WHERE ogb04=l_ima01
                          AND ogb01=g_keyvalue1
                          AND ogb03 in (
                                          SELECT ogbi03 FROM ogbi_file
                                           WHERE ogbi01=g_keyvalue1
                                             AND ogbislk02=g_keyvalue2)
                    ELSE
                       UPDATE ogb_file SET ogb12 =p_qty,
                                           ogb16 =p_qty,
                                           ogb18 =p_qty,
                                           ogb912 =p_qty,
                                           ogb917 =p_qty,
                                           ogb14t =ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty,t_azi04),
                                           ogb14=ROUND(ROUND(ogb13*ogb1006/100,t_azi03)*p_qty/(1+ l_oga211/100),t_azi04)
                        WHERE ogb04=l_ima01
                          AND ogb01=g_keyvalue1
                          AND ogb03 in (
                                          SELECT ogbi03 FROM ogbi_file
                                           WHERE ogbi01=g_keyvalue1
                                             AND ogbislk02=g_keyvalue2)
                    END IF

              WHEN 'artt212'

                    UPDATE rux_file SET rux06 =p_qty
                     WHERE rux03=l_ima01
                       AND rux01=g_keyvalue1
                       AND rux11s=g_keyvalue2 

              WHEN 'artt256'

                    UPDATE rup_file SET rup12 =p_qty,
                                        rup16 =p_qty,
                                        rup19 =p_qty
                     WHERE rup03=l_ima01
                       AND rup01=g_keyvalue1
                       AND rup21s=g_keyvalue2

              WHEN 'apmt720_slk'

                   SELECT rvv36,rvv38,rvv38t INTO l_rvv36,l_rvv38,l_rvv38t FROM rvv_file,rvvi_file
                     WHERE rvv01=g_keyvalue1 AND rvv31=l_ima01
                       AND rvv02=rvvi02 AND rvvi01=rvv01
                       AND rvvislk02=g_keyvalue2 

                   SELECT rva00 INTO l_rva00 FROM rva_file,rvu_file WHERE rva01 = rvu02 AND rvu01=g_keyvalue1
                   SELECT rvu00,rvu02,rvu04,rvu113 INTO l_rvu00,l_rvu02,l_rvu04,l_rvu113 FROM rvu_file WHERE rvu01=g_keyvalue1
                   IF cl_null(l_rvu02) THEN
                      LET l_rva00 = '2'
                   END IF
                   LET t_azi04=''
                   IF l_rva00 = '1' AND l_rvu00 = '3' THEN
                      SELECT azi04 INTO t_azi04 FROM azi_file
                          WHERE azi01 = l_rvu113
                   END IF
                   IF l_rva00 = '1' AND l_rvu00 <> '3' THEN
                      SELECT azi04 INTO t_azi04
                         FROM pmm_file,azi_file
                        WHERE pmm22=azi01
                          AND pmm01=l_rvv36
                          AND pmm18 <> 'X'
                   END IF
                   IF l_rva00 = '2' THEN
                      SELECT rva113 INTO l_rva113 FROM rva_file
                          WHERE rva01 = l_rvu02
                      SELECT azi04 INTO t_azi04 FROM azi_file
                          WHERE azi01 = l_rva113
                   END IF
                   IF cl_null(t_azi04) THEN
                      SELECT azi04 INTO t_azi04
                        FROM pmc_file,azi_file
                       WHERE pmc22=azi01
                         AND pmc01 = l_rvu04
                   END IF
                   IF cl_null(t_azi04) THEN LET t_azi04=0 END IF

                   LET l_rvv39=p_qty*l_rvv38
                   LET l_rvv39t=p_qty*l_rvv38t

                   CALL cl_digcut(l_rvv39,t_azi04)
                                     RETURNING l_rvv39
                   CALL cl_digcut(l_rvv39t,t_azi04)
                                     RETURNING l_rvv39t
              
                   CALL s_t720slk_rvv39(l_rvv36,l_rvv39,l_rvv39t,l_rvu04,l_rvu02)
                     RETURNING l_rvv39,l_rvv39t

                   UPDATE rvv_file SET rvv17=p_qty,
                                       rvv87=p_qty,
                                       rvv39=l_rvv39,
                                       rvv39t=l_rvv39t
                     WHERE rvv01=g_keyvalue1
                       AND rvv31=l_ima01   
                       AND rvv02 in (
                                     SELECT rvvi02 FROM rvvi_file
                                      WHERE rvvi01=g_keyvalue1
                                        AND rvvislk02=g_keyvalue2)

              WHEN 'apmt722_slk'
                   SELECT rvv36,rvv38,rvv38t INTO l_rvv36,l_rvv38,l_rvv38t FROM rvv_file,rvvi_file
                     WHERE rvv01=g_keyvalue1 AND rvv31=l_ima01
                       AND rvv02=rvvi02 AND rvvi01=rvv01
                       AND rvvislk02=g_keyvalue2

                   SELECT rva00 INTO l_rva00 FROM rva_file,rvu_file WHERE rva01 = rvu02 AND rvu01=g_keyvalue1
                   SELECT rvu00,rvu02,rvu04,rvu113 INTO l_rvu00,l_rvu02,l_rvu04,l_rvu113 FROM rvu_file WHERE rvu01=g_keyvalue1
                   IF cl_null(l_rvu02) THEN
                      LET l_rva00 = '2'
                   END IF
                   LET t_azi04=''
                   IF l_rva00 = '1' AND l_rvu00 = '3' THEN
                      SELECT azi04 INTO t_azi04 FROM azi_file
                          WHERE azi01 = l_rvu113
                   END IF
                   IF l_rva00 = '1' AND l_rvu00 <> '3' THEN
                      SELECT azi04 INTO t_azi04
                         FROM pmm_file,azi_file
                        WHERE pmm22=azi01
                       #  AND pmm01=l_rvvslk36   #MOD-C30217--mark
                          AND pmm01=l_rvv36      #MOD-C30217--add
                          AND pmm18 <> 'X'
                   END IF
                   IF l_rva00 = '2' THEN
                      SELECT rva113 INTO l_rva113 FROM rva_file
                          WHERE rva01 = l_rvu02
                      SELECT azi04 INTO t_azi04 FROM azi_file
                          WHERE azi01 = l_rva113
                   END IF
                   IF cl_null(t_azi04) THEN
                      SELECT azi04 INTO t_azi04
                        FROM pmc_file,azi_file
                       WHERE pmc22=azi01
                         AND pmc01 = l_rvu04
                   END IF
                   IF cl_null(t_azi04) THEN LET t_azi04=0 END IF

                   LET l_rvv39=p_qty*l_rvv38
                   LET l_rvv39t=p_qty*l_rvv38t

                   CALL cl_digcut(l_rvv39,t_azi04)
                                     RETURNING l_rvv39
                   CALL cl_digcut(l_rvv39t,t_azi04)
                                     RETURNING l_rvv39t

                   CALL s_t720slk_rvv39(l_rvv36,l_rvv39,l_rvv39t,l_rvu04,l_rvu02)
                     RETURNING l_rvv39,l_rvv39t

                   UPDATE rvv_file SET rvv17=p_qty,
                                       rvv87=p_qty,
                                       rvv39=l_rvv39,
                                       rvv39t=l_rvv39t
                     WHERE rvv01=g_keyvalue1
                       AND rvv31=l_ima01
                       AND rvv02 in (
                                     SELECT rvvi02 FROM rvvi_file
                                      WHERE rvvi01=g_keyvalue1
                                        AND rvvislk02=g_keyvalue2)
#FUN-C20101----ADD-----STR------                                        

             WHEN 'aimt301_slk'
                    IF NOT cl_null(g_inb_slk.inb08) THEN  LET p_qty=s_digqty(p_qty,g_inb_slk.inb08) END IF
                    
                    UPDATE inb_file SET inb09 =p_qty,
                                        inb16 =p_qty,
                                        inb904 =p_qty
                     WHERE inb04=l_ima01 
                       AND inb01=g_keyvalue1
                       AND inb03 in (
                                       SELECT inbi03 FROM inbi_file 
                                        WHERE inbi01=g_keyvalue1
                                          AND inbislk02=g_keyvalue2)
             WHEN 'aimt302_slk'
                    IF NOT cl_null(g_inb_slk.inb08) THEN  LET p_qty=s_digqty(p_qty,g_inb_slk.inb08) END IF
                    
                    UPDATE inb_file SET inb09 =p_qty,
                                        inb16 =p_qty,
                                        inb904 =p_qty
                     WHERE inb04=l_ima01 
                       AND inb01=g_keyvalue1
                       AND inb03 in (
                                       SELECT inbi03 FROM inbi_file 
                                        WHERE inbi01=g_keyvalue1
                                          AND inbislk02=g_keyvalue2)                               
             WHEN 'aimt303_slk'
                    IF NOT cl_null(g_inb_slk.inb08) THEN  LET p_qty=s_digqty(p_qty,g_inb_slk.inb08) END IF

                    UPDATE inb_file SET inb09 =p_qty,
                                        inb16 =p_qty,
                                        inb904 =p_qty
                     WHERE inb04=l_ima01
                       AND inb01=g_keyvalue1
                       AND inb03 in (
                                       SELECT inbi03 FROM inbi_file
                                        WHERE inbi01=g_keyvalue1
                                          AND inbislk02=g_keyvalue2)
#FUN-C20101---ADD----END---------
#FUN-C30057----ADD-----STR------                                            
             WHEN 'apmt580_slk'

                    UPDATE pon_file SET pon20 =p_qty,
                                        pon82 =p_qty,
                                        pon87 =p_qty,
                                        pon88 =ROUND(pon31*p_qty,t_azi04),
                                        pon88t=ROUND(pon31t*p_qty,t_azi04)
                     WHERE pon04=l_ima01 
                       AND pon01=g_keyvalue1
                       AND pon02 in (
                                       SELECT poni02 FROM poni_file 
                                        WHERE poni01=g_keyvalue1
                                          AND ponislk02=g_keyvalue2)
#FUN-C30057---ADD----END---------

         END CASE
      
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
         END IF
         IF g_prog = 'apmt540_slk' OR g_prog = 'apmt590_slk'  THEN
            EXECUTE s_selkey_slk_pre USING l_ima01 INTO l_key2
            LET l_pmn24=NULL
            LET l_pmn20=NULL
            SELECT pmn24,pmn25 INTO l_pmn24,l_pmn25 FROM pmn_file  WHERE pmn01 = g_keyvalue1 AND pmn02 = l_key2
            IF NOT cl_null(l_pmn24) THEN
               SELECT SUM(pmn20) INTO l_pmn20 FROM pmn_file WHERE pmn24=l_pmn24
                AND pmn25=l_pmn25 AND pmn16 <>'9'
               IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
               UPDATE pml_file SET pml21=l_pmn20
                   WHERE pml01=l_pmn24 AND pml02=l_pmn25
            END IF
         #FUN-C30130--add--begin---
            LET l_pmn68=NULL
            LET l_pmn69=NULL
            SELECT pmn68,pmn69 INTO l_pmn68,l_pmn69 FROM pmn_file  WHERE pmn01 = g_keyvalue1 AND pmn02 = l_key2
            IF NOT cl_null(l_pmn68) THEN
               SELECT SUM(pmn20/pmn62*pmn70) INTO l_pmn20 FROM pmn_file WHERE pmn68=l_pmn68          
                AND pmn69=l_pmn69 AND pmn16 <>'9'
               IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
               SELECT pon07 INTO l_pon07 FROM pon_file
                WHERE pon01 = l_pmn68 AND pon02 = l_pon69
               LET l_pmn20 = s_digqty(l_pmn20,l_pon07)
               UPDATE pon_file SET pon21=l_pmn20
                   WHERE pon01=l_pmn68 AND pon02=l_pmn69
            END IF 
         #FUN-C30130--add--end---
         END IF
      END IF

      IF p_cmd='r' OR (p_qty=0 AND p_cmd='u') THEN   #刪除子料件的數據

         EXECUTE s_selkey_slk_pre USING l_ima01 INTO l_key2
         IF g_prog = 'apmt540_slk' OR g_prog = 'apmt590_slk' THEN
            LET l_pmn24=NULL
            LET l_pmn25=NULL
            LET l_pmn20=NULL
            SELECT pmn24,pmn25 INTO l_pmn24,l_pmn25 FROM pmn_file  WHERE pmn01 = g_keyvalue1 AND pmn02 = l_key2
            IF NOT cl_null(l_pmn24) THEN
               SELECT SUM(pmn20) INTO l_pmn20 FROM pmn_file WHERE pmn24=l_pmn24
                  AND pmn25=l_pmn25 AND pmn16 <>'9' AND (pmn01<>g_keyvalue1 AND pmn02<>l_key2)
               IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
               IF l_pmn20=0 THEN
                  UPDATE pml_file SET pml21=l_pmn20,pml16='1'
                   WHERE pml01=l_pmn24 AND pml02=l_pmn25
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd",'',l_pmn24,l_pmn25,SQLCA.sqlcode,"","",1)
                      LET g_success = 'N'
                   END IF
               ELSE
                  UPDATE pml_file SET pml21=l_pmn20
                   WHERE pml01=l_pmn24 AND pml02=l_pmn25
                   IF SQLCA.sqlcode THEN
                      CALL cl_err3("upd",'',l_pmn24,l_pmn25,SQLCA.sqlcode,"","",1)
                      LET g_success = 'N'
                   END IF
               END IF
                UPDATE pmk_file SET pmk25='1'
                         WHERE pmk01=l_pmn24 AND pmk01 NOT IN
                         (SELECT pml01 FROM pml_file WHERE pml01=l_pmn24
                                       AND pml16 NOT IN ('1'))
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("upd",'',l_pmn24,'',SQLCA.sqlcode,"","",1)
                   LET g_success = 'N'
                END IF
            END IF
         #FUN-C30130--add--begin---
            LET l_pmn68=NULL
            LET l_pmn69=NULL
            SELECT pmn68,pmn69 INTO l_pmn68,l_pmn69 FROM pmn_file  WHERE pmn01 = g_keyvalue1 AND pmn02 = l_key2
            IF NOT cl_null(l_pmn68) THEN
               SELECT SUM(pmn20/pmn62*pmn70) INTO l_pmn20 FROM pmn_file WHERE pmn68=l_pmn68
                AND pmn69=l_pmn69 AND pmn16 <>'9'
               IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
               SELECT pon07 INTO l_pon07 FROM pon_file
                WHERE pon01 = l_pmn68 AND pon02 = l_pon69
               LET l_pmn20 = s_digqty(l_pmn20,l_pon07)
               IF l_pmn20=0 THEN
                  UPDATE pon_file SET pon21=l_pmn20,pon16 = '1'
                     WHERE pon01=l_pmn68 AND pon02=l_pmn69
               ELSE
                  UPDATE pon_file SET pon21=l_pmn20
                    WHERE pon01=l_pmn68 AND pon02=l_pmn69
               END IF
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd",'',l_pmn68,l_pmn69,SQLCA.sqlcode,"","",1)
                  LET g_success = 'N'
               END IF
               UPDATE pom_file SET pom25='1'
                WHERE pom01=l_pmn68 AND pom01 NOT IN
                          (SELECT pon01 FROM pon_file WHERE pon01=l_pmn68 
                             AND pon16 NOT IN ('1'))
               IF SQLCA.sqlcode THEN
                  CALL cl_err3("upd","pom_file",l_pmn68,"",SQLCA.sqlcode,"","update pom25 fail:",1)  
                  LET g_success = 'N' 
               END IF
            END IF
         #FUN-C30130--add--end---
         END IF
    
         EXECUTE s_delslk_slk_pre USING l_key2
         IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("del",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
         END IF

         IF g_prog !='artt212' AND g_prog !='artt256' THEN 
            EXECUTE s_delslk_slk_pre2 USING l_key2
            IF STATUS OR SQLCA.sqlerrd[3] = 0 THEN
               CALL cl_err3("del",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
            END IF
         END IF
      END IF
   ELSE            #數據庫中沒有子料件的數據
      IF p_qty > 0 AND (p_cmd='a' OR p_cmd='u') THEN    #新增子料件的數據
#存儲需要的新增的一筆子料件值的變量名稱：命名規則：g_+表名（去掉'_file'）+_slk
#                                                  如:g_oeb_slk,g_oebi_slk 其定義在s_slk.global，
#                                                                          類型為：RECORD LIKE oeb_file.*,RECORD LIKE oebi_file.*

         
         CASE g_prog
            WHEN 'axmt410_slk'
                 SELECT max(oeb03) INTO l_max FROM oeb_file
                   WHERE oeb01=g_keyvalue1
                 
                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF
                 
                 LET g_oeb_slk.oeb01=g_keyvalue1
                 LET g_oeb_slk.oeb03=l_max
                 LET g_oeb_slk.oeb04=l_ima01
                 SELECT ima02 INTO g_oeb_slk.oeb06 FROM ima_file WHERE ima01=g_oeb_slk.oeb04
               #TQC-C20339--add--begin-- 
                 SELECT oea03,oea23 INTO l_oea03,l_oea23 FROM oea_file WHERE oea01 = g_keyvalue1
                 SELECT obk11 INTO g_oeb_slk.oeb906 FROM obk_file WHERE obk01 = g_oeb_slk.oeb04
                                                                    AND obk02 = l_oea03
                                                                    AND obk05 = l_oea23            
               #TQC-C20339--add--end-- 
               #TQC-C20461--add--begin--
                 IF cl_null(g_oeb_slk.oeb906) THEN
                    LET g_oeb_slk.oeb906 = 'N' 
                 END IF 
               #TQC-C20461--add--end--
                 LET g_oeb_slk.oeb12=p_qty
                 LET g_oeb_slk.oeb912=p_qty
                 LET g_oeb_slk.oeb917=p_qty
                 
                 SELECT oea213,oea211 INTO l_oea213,l_oea211 FROM oea_file WHERE oea01=g_keyvalue1
                 IF l_oea213='N' THEN
                    LET g_oeb_slk.oeb14=g_oeb_slk.oeb917*g_oeb_slk.oeb13*g_oeb_slk.oeb1006/100
                    CALL cl_digcut(g_oeb_slk.oeb14,t_azi04)  RETURNING g_oeb_slk.oeb14
                    LET g_oeb_slk.oeb14t= g_oeb_slk.oeb14*(1+ l_oea211/100)
                    CALL cl_digcut(g_oeb_slk.oeb14t,t_azi04) RETURNING g_oeb_slk.oeb14t
                 ELSE
                    LET g_oeb_slk.oeb14t=g_oeb_slk.oeb917*g_oeb_slk.oeb13*g_oeb_slk.oeb1006/100
                    CALL cl_digcut(g_oeb_slk.oeb14t,t_azi04)  RETURNING g_oeb_slk.oeb14t
                    LET g_oeb_slk.oeb14= g_oeb_slk.oeb14t/(1+ l_oea211/100)
                    CALL cl_digcut(g_oeb_slk.oeb14,t_azi04) RETURNING g_oeb_slk.oeb14
                 END IF                

                 INSERT INTO oeb_file VALUES (g_oeb_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_oebi_slk.oebi01=g_keyvalue1
                 LET g_oebi_slk.oebi03=l_max
                 LET g_oebi_slk.oebislk02=p_ima01
                 LET g_oebi_slk.oebislk03=g_keyvalue2
                 INSERT INTO oebi_file VALUES (g_oebi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

            WHEN 'axmt400_slk'
                 SELECT max(oeb03) INTO l_max FROM oeb_file
                   WHERE oeb01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_oeb_slk.oeb01=g_keyvalue1
                 LET g_oeb_slk.oeb03=l_max
                 LET g_oeb_slk.oeb04=l_ima01
                 SELECT ima02 INTO g_oeb_slk.oeb06 FROM ima_file WHERE ima01=g_oeb_slk.oeb04
                 LET g_oeb_slk.oeb12=p_qty
                 LET g_oeb_slk.oeb912=p_qty
                 LET g_oeb_slk.oeb917=p_qty

                 SELECT oea213,oea211 INTO l_oea213,l_oea211 FROM oea_file WHERE oea01=g_keyvalue1
                 IF l_oea213='N' THEN
                    LET g_oeb_slk.oeb14=g_oeb_slk.oeb917*g_oeb_slk.oeb13*g_oeb_slk.oeb1006/100
                    CALL cl_digcut(g_oeb_slk.oeb14,t_azi04)  RETURNING g_oeb_slk.oeb14
                    LET g_oeb_slk.oeb14t= g_oeb_slk.oeb14*(1+ l_oea211/100)
                    CALL cl_digcut(g_oeb_slk.oeb14t,t_azi04) RETURNING g_oeb_slk.oeb14t
                 ELSE
                    LET g_oeb_slk.oeb14t=g_oeb_slk.oeb917*g_oeb_slk.oeb13*g_oeb_slk.oeb1006/100
                    CALL cl_digcut(g_oeb_slk.oeb14t,t_azi04)  RETURNING g_oeb_slk.oeb14t
                    LET g_oeb_slk.oeb14= g_oeb_slk.oeb14t/(1+ l_oea211/100)
                    CALL cl_digcut(g_oeb_slk.oeb14,t_azi04) RETURNING g_oeb_slk.oeb14
                 END IF

                 INSERT INTO oeb_file VALUES (g_oeb_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_oebi_slk.oebi01=g_keyvalue1
                 LET g_oebi_slk.oebi03=l_max
                 LET g_oebi_slk.oebislk02=p_ima01
                 LET g_oebi_slk.oebislk03=g_keyvalue2
                 INSERT INTO oebi_file VALUES (g_oebi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

            WHEN 'axmt420_slk'
                 SELECT max(oeb03) INTO l_max FROM oeb_file
                   WHERE oeb01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_oeb_slk.oeb01=g_keyvalue1
                 LET g_oeb_slk.oeb03=l_max
                 LET g_oeb_slk.oeb04=l_ima01
                 SELECT ima02 INTO g_oeb_slk.oeb06 FROM ima_file WHERE ima01=g_oeb_slk.oeb04
                 LET g_oeb_slk.oeb12=p_qty
                 LET g_oeb_slk.oeb912=p_qty
                 LET g_oeb_slk.oeb917=p_qty

                 SELECT oea213,oea211 INTO l_oea213,l_oea211 FROM oea_file WHERE oea01=g_keyvalue1
                 IF l_oea213='N' THEN
                    LET g_oeb_slk.oeb14=g_oeb_slk.oeb917*g_oeb_slk.oeb13*g_oeb_slk.oeb1006/100
                    CALL cl_digcut(g_oeb_slk.oeb14,t_azi04)  RETURNING g_oeb_slk.oeb14
                    LET g_oeb_slk.oeb14t= g_oeb_slk.oeb14*(1+ l_oea211/100)
                    CALL cl_digcut(g_oeb_slk.oeb14t,t_azi04) RETURNING g_oeb_slk.oeb14t
                 ELSE
                    LET g_oeb_slk.oeb14t=g_oeb_slk.oeb917*g_oeb_slk.oeb13*g_oeb_slk.oeb1006/100
                    CALL cl_digcut(g_oeb_slk.oeb14t,t_azi04)  RETURNING g_oeb_slk.oeb14t
                    LET g_oeb_slk.oeb14= g_oeb_slk.oeb14t/(1+ l_oea211/100)
                    CALL cl_digcut(g_oeb_slk.oeb14,t_azi04) RETURNING g_oeb_slk.oeb14
                 END IF

                 INSERT INTO oeb_file VALUES (g_oeb_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_oebi_slk.oebi01=g_keyvalue1
                 LET g_oebi_slk.oebi03=l_max
                 LET g_oebi_slk.oebislk02=p_ima01
                 LET g_oebi_slk.oebislk03=g_keyvalue2
                 INSERT INTO oebi_file VALUES (g_oebi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

            WHEN 'axmt810_slk'
                 SELECT max(oeb03) INTO l_max FROM oeb_file
                   WHERE oeb01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_oeb_slk.oeb01=g_keyvalue1
                 LET g_oeb_slk.oeb03=l_max
                 LET g_oeb_slk.oeb04=l_ima01
                 SELECT ima02 INTO g_oeb_slk.oeb06 FROM ima_file WHERE ima01=g_oeb_slk.oeb04
                 LET g_oeb_slk.oeb12=p_qty
                 LET g_oeb_slk.oeb912=p_qty
                 LET g_oeb_slk.oeb917=p_qty

                 SELECT oea213,oea211 INTO l_oea213,l_oea211 FROM oea_file WHERE oea01=g_keyvalue1
                 IF l_oea213='N' THEN
                    LET g_oeb_slk.oeb14=g_oeb_slk.oeb917*g_oeb_slk.oeb13*g_oeb_slk.oeb1006/100
                    CALL cl_digcut(g_oeb_slk.oeb14,t_azi04)  RETURNING g_oeb_slk.oeb14
                    LET g_oeb_slk.oeb14t= g_oeb_slk.oeb14*(1+ l_oea211/100)
                    CALL cl_digcut(g_oeb_slk.oeb14t,t_azi04) RETURNING g_oeb_slk.oeb14t
                 ELSE
                    LET g_oeb_slk.oeb14t=g_oeb_slk.oeb917*g_oeb_slk.oeb13*g_oeb_slk.oeb1006/100
                    CALL cl_digcut(g_oeb_slk.oeb14t,t_azi04)  RETURNING g_oeb_slk.oeb14t
                    LET g_oeb_slk.oeb14= g_oeb_slk.oeb14t/(1+ l_oea211/100)
                    CALL cl_digcut(g_oeb_slk.oeb14,t_azi04) RETURNING g_oeb_slk.oeb14
                 END IF

                 INSERT INTO oeb_file VALUES (g_oeb_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_oebi_slk.oebi01=g_keyvalue1
                 LET g_oebi_slk.oebi03=l_max
                 LET g_oebi_slk.oebislk02=p_ima01
                 LET g_oebi_slk.oebislk03=g_keyvalue2
                 INSERT INTO oebi_file VALUES (g_oebi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

            WHEN 'axmt700_slk'
                 SELECT max(ohb03) INTO l_max FROM ohb_file
                   WHERE ohb01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_ohb_slk.ohb01=g_keyvalue1
                 LET g_ohb_slk.ohb03=l_max
                 LET g_ohb_slk.ohb04=l_ima01
                 SELECT ima02 INTO g_ohb_slk.ohb06 FROM ima_file WHERE ima01=l_ima01
                 LET g_ohb_slk.ohb12=p_qty
                 LET g_ohb_slk.ohb912=p_qty
                 LET g_ohb_slk.ohb915=p_qty
                 LET g_ohb_slk.ohb917=p_qty
                 LET g_ohb_slk.ohb16=p_qty

                 INITIALIZE g_ohb_slk.ohb15 TO NULL   
                 SELECT img09 INTO g_ohb_slk.ohb15 FROM img_file
                  WHERE img01=g_ohb_slk.ohb04 
                    AND img02=g_ohb_slk.ohb09
                    AND img03=g_ohb_slk.ohb091
                    AND img04=g_ohb_slk.ohb092


                 IF NOT cl_null(g_ohb_slk.ohb31) THEN    
                    SELECT ohbslk32 INTO l_ohbslk32 FROM ohbslk_file WHERE ohbslk01=g_keyvalue1 AND ohbslk03=g_keyvalue2
                    SELECT ogb03 INTO g_ohb_slk.ohb32 FROM ogb_file,ogbi_file
                      WHERE ogb01=ogbi01 AND ogb03=ogbi03 
                        AND ogbi01=g_ohb_slk.ohb31 AND ogbislk02=l_ohbslk32
                        AND ogb04=l_ima01
                    SELECT ogb32 INTO g_ohb_slk.ohb34 FROM ogb_file WHERE ogb01=g_ohb_slk.ohb31 AND ogb03=g_ohb_slk.ohb32
                 END IF
          
                 SELECT oha213,oha211 INTO l_oha213,l_oha211 FROM oha_file WHERE oha01=g_keyvalue1
                 IF l_oha213 = 'N' THEN 
                    LET g_ohb_slk.ohb14 =g_ohb_slk.ohb917*g_ohb_slk.ohb13*g_ohb_slk.ohb1003/100
                    CALL cl_digcut(g_ohb_slk.ohb14,t_azi04)  RETURNING g_ohb_slk.ohb14   
                    LET g_ohb_slk.ohb14t=g_ohb_slk.ohb14*(1+l_oha211/100)
                    CALL cl_digcut(g_ohb_slk.ohb14t,t_azi04) RETURNING g_ohb_slk.ohb14t 
                  ELSE
                    LET g_ohb_slk.ohb14t=g_ohb_slk.ohb917*g_ohb_slk.ohb13*g_ohb_slk.ohb1003/100
                    CALL cl_digcut(g_ohb_slk.ohb14t,t_azi04) RETURNING g_ohb_slk.ohb14t
                    LET g_ohb_slk.ohb14 =g_ohb_slk.ohb14t/(1+l_oha211/100)
                    CALL cl_digcut(g_ohb_slk.ohb14,t_azi04)  RETURNING g_ohb_slk.ohb14
                 END IF

                 INSERT INTO ohb_file VALUES (g_ohb_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_ohbi_slk.ohbi01=g_keyvalue1
                 LET g_ohbi_slk.ohbi03=l_max
                 LET g_ohbi_slk.ohbislk01=p_ima01
                 LET g_ohbi_slk.ohbislk02=g_keyvalue2
                 INSERT INTO ohbi_file VALUES (g_ohbi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

            WHEN 'apmt420_slk'
                 SELECT max(pml02) INTO l_max FROM pml_file
                   WHERE pml01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_pml_slk.pml01=g_keyvalue1
                 LET g_pml_slk.pml02=l_max
                 LET g_pml_slk.pml04=l_ima01
                 SELECT ima02 INTO g_pml_slk.pml041 FROM ima_file WHERE ima01=g_pml_slk.pml04
                 LET g_pml_slk.pml20=p_qty
                 LET g_pml_slk.pml82=p_qty
                 LET g_pml_slk.pml87=p_qty
                 LET g_pml_slk.pml88 =cl_digcut(g_pml_slk.pml87*g_pml_slk.pml31,t_azi04)
                 LET g_pml_slk.pml88t=cl_digcut(g_pml_slk.pml87*g_pml_slk.pml31t,t_azi04)

                 INSERT INTO pml_file VALUES (g_pml_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_pmli_slk.pmli01=g_keyvalue1
                 LET g_pmli_slk.pmli02=l_max
                 LET g_pmli_slk.pmlislk02=p_ima01
                 LET g_pmli_slk.pmlislk03=g_keyvalue2
                 INSERT INTO pmli_file VALUES (g_pmli_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

            WHEN 'apmt540_slk'
                 SELECT max(pmn02) INTO l_max FROM pmn_file
                   WHERE pmn01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_pmn_slk.pmn01=g_keyvalue1
                 LET g_pmn_slk.pmn02=l_max
                 LET g_pmn_slk.pmn04=l_ima01
                 SELECT ima02,ima44 INTO g_pmn_slk.pmn041,g_pmn_slk.pmn80 FROM ima_file WHERE ima01=l_ima01
                 LET g_pmn_slk.pmn83=g_pmn_slk.pmn80
                 LET g_pmn_slk.pmn61=l_ima01
                 LET g_pmn_slk.pmn20=p_qty
                 LET g_pmn_slk.pmn82=p_qty
                 LET g_pmn_slk.pmn85=p_qty
                 LET g_pmn_slk.pmn87=p_qty

                 IF NOT cl_null(g_pmn_slk.pmn24) THEN
                    SELECT pmnslk25 INTO l_pmnslk25 FROM pmnslk_file
                     WHERE pmnslk01=g_keyvalue1 AND pmnslk02=g_keyvalue2
                    SELECT pml02 INTO g_pmn_slk.pmn25 FROM pml_file,pmli_file
                     WHERE pml01=pmli01
                       AND pml02=pmli02
                       AND pmli01=g_pmn_slk.pmn24 
                       AND pmlislk03=l_pmnslk25
                       AND pml04=l_ima01
                 END IF

               #FUN-C30130--add--begin--
                 IF g_smy.smy57[4,4]='Y' AND (NOT cl_null(g_pmn_slk.pmn68)) THEN
                    SELECT pmnslk69 INTO l_pmnslk69 FROM pmnslk_file
                      WHERE pmnslk01=g_keyvalue1 AND pmnslk02=g_keyvalue2 
                    SELECT pon02 INTO g_pmn_slk.pmn69 from pon_file,poni_file
                     WHERE pon01=poni01
                       AND pon02=poni02
                       AND poni01=g_pmn_slk.pmn68
                       AND ponislk02=l_pmnslk69
                       AND pon04=l_ima01     
                 END IF
               #FUN-C30130--add--end--
                 SELECT pmm21,pmm22,pmm43,pmm09 INTO l_pmm21,l_pmm22,l_pmm43,l_pmm09 FROM pmm_file WHERE pmm01=g_keyvalue1
                 SELECT pmh04 INTO g_pmn_slk.pmn06 FROM pmh_file
                        WHERE pmh01 = l_ima01 AND pmh02 = l_pmm09
                          AND pmh13 = l_pmm22
                          AND pmh21 = ' '
                          AND pmh22 = '1'
                          AND pmh23 = ' '
                          AND pmhacti = 'Y'

                 SELECT gec05,gec07 INTO l_gec05,l_gec07 FROM gec_file WHERE gec011='1'
                                                          AND gecacti='Y'
                                                          AND gec01=l_pmm21

                 LET g_pmn_slk.pmn88 =cl_digcut(g_pmn_slk.pmn87*g_pmn_slk.pmn31,t_azi04)
                 LET g_pmn_slk.pmn88t=cl_digcut(g_pmn_slk.pmn87*g_pmn_slk.pmn31t,t_azi04)
                 IF l_gec07='Y' THEN
                    IF l_gec05 = 'T' THEN
                       LET g_pmn_slk.pmn88 = g_pmn_slk.pmn88t * ( 1 - l_pmm43/100)
                       LET g_pmn_slk.pmn88 = cl_digcut( g_pmn_slk.pmn88 , t_azi04)
                    ELSE
                       LET g_pmn_slk.pmn88 = g_pmn_slk.pmn88t / ( 1 + l_pmm43/100)
                       LET g_pmn_slk.pmn88 = cl_digcut( g_pmn_slk.pmn88 , t_azi04)
                    END IF
                 ELSE
                    LET g_pmn_slk.pmn88t = g_pmn_slk.pmn88 * ( 1 + l_pmm43/100)
                    LET g_pmn_slk.pmn88t = cl_digcut( g_pmn_slk.pmn88t , t_azi04)
                 END IF
                 CALL s_schdat_pmn78(g_pmn_slk.pmn41,g_pmn_slk.pmn012,g_pmn_slk.pmn43,g_pmn_slk.pmn18,   #FUN-C10002
                                                 g_pmn_slk.pmn32) RETURNING g_pmn_slk.pmn78          #FUN-C10002
                 INSERT INTO pmn_file VALUES (g_pmn_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 IF NOT cl_null(g_pmn_slk.pmn24) THEN
                    SELECT SUM(pmn20) INTO l_pmn20 FROM pmn_file WHERE pmn24=g_pmn_slk.pmn24
                       AND pmn25=g_pmn_slk.pmn25 AND pmn16<>'9'
                    IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
                    UPDATE pml_file SET pml21=l_pmn20,pml16='2' WHERE pml01=g_pmn_slk.pmn24
                       AND pml02=g_pmn_slk.pmn25 
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("upd",'',g_pmn_slk.pmn24,g_pmn_slk.pmn25,SQLCA.sqlcode,"","",1)
                       LET g_success = 'N'
                    END IF
                    SELECT COUNT(*) INTO l_n FROM pmk_file WHERE pmk01=g_pmn_slk.pmn24 AND pmk25='1'
                    IF l_n=0 OR cl_null(l_n) THEN
                       UPDATE pmk_file SET pmk25='2' WHERE pmk01=g_pmn_slk.pmn24
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd",'',g_pmn_slk.pmn24,'',SQLCA.sqlcode,"","",1)
                          LET g_success = 'N'
                       END IF
                    END IF
                 END IF
               #FUN-C30130--add--begin--
                 IF NOT cl_null(g_pmn_slk.pmn68) THEN
                    SELECT SUM(pmn20/pmn62*pmn70) INTO l_pmn20 FROM pmn_file WHERE pmn68=g_pmn_slk.pmn68
                       AND pmn69=g_pmn_slk.pmn69 AND pmn16<>'9'
                    IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
                    SELECT pon07 INTO l_pon07 FROM pon_file 
                       WHERE pon01=g_pmn_slk.pmn68 AND pon02=g_pmn_slk.pmn69
                    LET l_pmn20 = s_digqty(l_pmn20,l_pon07)
                    UPDATE pon_file SET pon21 = l_pmn20,pon16='2'
                       WHERE pon01=g_pmn_slk.pmn68 AND pon02=g_pmn_slk.pmn69
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("upd",'',g_pmn_slk.pmn68,g_pmn_slk.pmn69,SQLCA.sqlcode,"","",1)
                       LET g_success = 'N'
                    END IF
                    SELECT COUNT(*) INTO l_n FROM pom_file WHERE pom01=g_pmn_slk.pmn68 AND pom25='1'
                    IF l_n=0 OR cl_null(l_n) THEN
                       UPDATE pom_file SET pom25 = '2' WHERE pom01=g_pmn_slk.pmn68 
                      IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd",'',g_pmn_slk.pmn68,'',SQLCA.sqlcode,"","",1)
                          LET g_success = 'N'
                       END IF
                    END IF
                 END IF 
               #FUN-C30130--add--end--
                 LET g_pmni_slk.pmni01=g_keyvalue1
                 LET g_pmni_slk.pmni02=l_max
                 LET g_pmni_slk.pmnislk02=p_ima01
                 LET g_pmni_slk.pmnislk03=g_keyvalue2
                 INSERT INTO pmni_file VALUES (g_pmni_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF


            WHEN 'apmt590_slk'
                 SELECT max(pmn02) INTO l_max FROM pmn_file
                   WHERE pmn01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_pmn_slk.pmn01=g_keyvalue1
                 LET g_pmn_slk.pmn02=l_max
                 LET g_pmn_slk.pmn04=l_ima01
                 SELECT ima02,ima44 INTO g_pmn_slk.pmn041,g_pmn_slk.pmn80 FROM ima_file WHERE ima01=l_ima01
                 LET g_pmn_slk.pmn83=g_pmn_slk.pmn80
                 LET g_pmn_slk.pmn61=l_ima01
                 LET g_pmn_slk.pmn20=p_qty
                 LET g_pmn_slk.pmn82=p_qty
                 LET g_pmn_slk.pmn85=p_qty
                 LET g_pmn_slk.pmn87=p_qty

                 IF NOT cl_null(g_pmn_slk.pmn24) THEN
                    SELECT pmnslk25 INTO l_pmnslk25 FROM pmnslk_file
                     WHERE pmnslk01=g_keyvalue1 AND pmnslk02=g_keyvalue2
                    SELECT pml02 INTO g_pmn_slk.pmn25 FROM pml_file,pmli_file
                     WHERE pml01=pmli01
                       AND pml02=pmli02
                       AND pmli01=g_pmn_slk.pmn24
                       AND pmlislk03=l_pmnslk25
                       AND pml04=l_ima01
                 END IF

               #FUN-C30130--add--begin--
                 IF g_smy.smy57[4,4]='Y' AND (NOT cl_null(g_pmn_slk.pmn68)) THEN
                    SELECT pmnslk69 INTO l_pmnslk69 FROM pmnslk_file
                      WHERE pmnslk01=g_keyvalue1 AND pmnslk02=g_keyvalue2
                    SELECT pon02 INTO g_pmn_slk.pmn69 FROM pon_file,poni_file
                     WHERE pon01=poni01 AND pon01=poni02
                       AND poni01=g_pmn_slk.pmn68
                       AND ponislk02 = l_pmnslk69
                       AND pon04=l_ima01
                 END IF
               #FUN-C30130--add--end--
                 SELECT pmm21,pmm22,pmm43,pmm09 INTO l_pmm21,l_pmm22,l_pmm43,l_pmm09 FROM pmm_file WHERE pmm01=g_keyvalue1
                 SELECT pmh04 INTO g_pmn_slk.pmn06 FROM pmh_file
                        WHERE pmh01 = l_ima01 AND pmh02 = l_pmm09
                          AND pmh13 = l_pmm22
                          AND pmh21 = ' '
                          AND pmh22 = '1'
                          AND pmh23 = ' '
                          AND pmhacti = 'Y'

                 SELECT gec05,gec07 INTO l_gec05,l_gec07 FROM gec_file WHERE gec011='1'
                                                          AND gecacti='Y'
                                                          AND gec01=l_pmm21

                 LET g_pmn_slk.pmn88 =cl_digcut(g_pmn_slk.pmn87*g_pmn_slk.pmn31,t_azi04)
                 LET g_pmn_slk.pmn88t=cl_digcut(g_pmn_slk.pmn87*g_pmn_slk.pmn31t,t_azi04)
                 IF l_gec07='Y' THEN
                    IF l_gec05 = 'T' THEN
                       LET g_pmn_slk.pmn88 = g_pmn_slk.pmn88t * ( 1 - l_pmm43/100)
                       LET g_pmn_slk.pmn88 = cl_digcut( g_pmn_slk.pmn88 , t_azi04)
                    ELSE
                       LET g_pmn_slk.pmn88 = g_pmn_slk.pmn88t / ( 1 + l_pmm43/100)
                       LET g_pmn_slk.pmn88 = cl_digcut( g_pmn_slk.pmn88 , t_azi04)
                    END IF
                 ELSE
                    LET g_pmn_slk.pmn88t = g_pmn_slk.pmn88 * ( 1 + l_pmm43/100)
                    LET g_pmn_slk.pmn88t = cl_digcut( g_pmn_slk.pmn88t , t_azi04)
                 END IF
                 
                 CALL s_schdat_pmn78(g_pmn_slk.pmn41,g_pmn_slk.pmn012,g_pmn_slk.pmn43,g_pmn_slk.pmn18,   #FUN-C10002
                                                 g_pmn_slk.pmn32) RETURNING g_pmn_slk.pmn78          #FUN-C10002
                 INSERT INTO pmn_file VALUES (g_pmn_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 IF NOT cl_null(g_pmn_slk.pmn24) THEN
                    SELECT SUM(pmn20) INTO l_pmn20 FROM pmn_file WHERE pmn24=g_pmn_slk.pmn24
                       AND pmn25=g_pmn_slk.pmn25 AND pmn16<>'9'
                    IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
                    UPDATE pml_file SET pml21=l_pmn20,pml16='2' WHERE pml01=g_pmn_slk.pmn24
                       AND pml02=g_pmn_slk.pmn25
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("upd",'',g_pmn_slk.pmn24,g_pmn_slk.pmn25,SQLCA.sqlcode,"","",1)
                       LET g_success = 'N'
                    END IF
                    SELECT COUNT(*) INTO l_n FROM pmk_file WHERE pmk01=g_pmn_slk.pmn24 AND pmk25='1'
                    IF l_n=0 OR cl_null(l_n) THEN
                       UPDATE pmk_file SET pmk25='2' WHERE pmk01=g_pmn_slk.pmn24
                       IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd",'',g_pmn_slk.pmn24,'',SQLCA.sqlcode,"","",1)
                          LET g_success = 'N'
                       END IF
                    END IF
                 END IF

               #FUN-C30130--add--begin--
                 IF NOT cl_null(g_pmn_slk.pmn68) THEN
                    SELECT SUM(pmn20/pmn62*pmn70) INTO l_pmn20 FROM pmn_file WHERE pmn68=g_pmn_slk.pmn68
                       AND pmn69=g_pmn_slk.pmn69 AND pmn16<>'9'
                    IF STATUS OR l_pmn20 IS NULL THEN LET l_pmn20 = 0 END IF
                    SELECT pon07 INTO l_pon07 FROM pon_file
                       WHERE pon01=g_pmn_slk.pmn68 AND pon02=g_pmn_slk.pmn69
                    LET l_pmn20 = s_digqty(l_pmn20,l_pon07)
                    UPDATE pon_file SET pon21 = l_pmn20,pon16='2'
                       WHERE pon01=g_pmn_slk.pmn68 AND pon02=g_pmn_slk.pmn69
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("upd",'',g_pmn_slk.pmn68,g_pmn_slk.pmn69,SQLCA.sqlcode,"","",1)
                       LET g_success = 'N'
                    END IF
                    SELECT COUNT(*) INTO l_n FROM pom_file WHERE pom01=g_pmn_slk.pmn68 AND pom25='1'
                    IF l_n=0 OR cl_null(l_n) THEN
                       UPDATE pom_file SET pom25 = '2' WHERE pom01=g_pmn_slk.pmn68
                      IF SQLCA.sqlcode THEN
                          CALL cl_err3("upd",'',g_pmn_slk.pmn68,'',SQLCA.sqlcode,"","",1)
                          LET g_success = 'N'
                       END IF
                    END IF
                 END IF 
               #FUN-C30130--add--end--

                 LET g_pmni_slk.pmni01=g_keyvalue1
                 LET g_pmni_slk.pmni02=l_max
                 LET g_pmni_slk.pmnislk02=p_ima01
                 LET g_pmni_slk.pmnislk03=g_keyvalue2
                 INSERT INTO pmni_file VALUES (g_pmni_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

            WHEN 'apmt110_slk'
                 SELECT max(rvb02) INTO l_max FROM rvb_file
                   WHERE rvb01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_rvb_slk.rvb01=g_keyvalue1
                 LET g_rvb_slk.rvb02=l_max
                 LET g_rvb_slk.rvb05=l_ima01
                 LET g_rvb_slk.rvb07=p_qty
                 LET g_rvb_slk.rvb31=p_qty
                 LET g_rvb_slk.rvb87=p_qty
                 SELECT ima02 INTO g_rvb_slk.rvb051 FROM ima_file WHERE ima01=g_rvb_slk.rvb05
                 IF g_sma.sma115 = 'Y' THEN
                    LET g_rvb_slk.rvb82 = p_qty
                    LET g_rvb_slk.rvb85 = p_qty
                 ELSE
                    LET g_rvb_slk.rvb82 = NULL
                    LET g_rvb_slk.rvb85 = NULL
                 END IF
                 SELECT pmm21,pmm43 INTO l_pmm21,l_pmm43 FROM pmm_file,rvbslk_file
                   WHERE pmm01=rvbslk04 AND rvbslk03=g_keyvalue2 AND rvbslk01=g_keyvalue1

                 SELECT gec05,gec07 INTO l_gec07,l_gec05 FROM gec_file WHERE gec011='1'
                                                           AND gecacti='Y'
                                                           AND gec01=l_pmm21

                 LET g_rvb_slk.rvb88 =cl_digcut(g_rvb_slk.rvb87*g_rvb_slk.rvb10,t_azi04)
                 LET g_rvb_slk.rvb88t=cl_digcut(g_rvb_slk.rvb87*g_rvb_slk.rvb10t,t_azi04)
                 IF l_gec07='Y' THEN
                    IF l_gec05 = 'T' THEN
                       LET g_rvb_slk.rvb88 = g_rvb_slk.rvb88t * ( 1 - l_pmm43/100)
                       LET g_rvb_slk.rvb88 = cl_digcut( g_rvb_slk.rvb88 , t_azi04)
                    ELSE
                       LET g_rvb_slk.rvb88 = g_rvb_slk.rvb88t / ( 1 + l_pmm43/100)
                       LET g_rvb_slk.rvb88 = cl_digcut( g_rvb_slk.rvb88 , t_azi04)
                    END IF
                 ELSE
                    LET g_rvb_slk.rvb88t = g_rvb_slk.rvb88 * ( 1 + l_pmm43/100)
                    LET g_rvb_slk.rvb88t = cl_digcut( g_rvb_slk.rvb88t , t_azi04)
                 END IF

                 INSERT INTO rvb_file VALUES (g_rvb_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_rvbi_slk.rvbi01=g_keyvalue1
                 LET g_rvbi_slk.rvbi02=l_max
                 LET g_rvbi_slk.rvbislk01=p_ima01
                 LET g_rvbi_slk.rvbislk02=g_keyvalue2
                 INSERT INTO rvbi_file VALUES (g_rvbi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF
            WHEN 'axmt610_slk'
                 SELECT max(ogb03) INTO l_max FROM ogb_file
                   WHERE ogb01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_ogb_slk.ogb01=g_keyvalue1
                 LET g_ogb_slk.ogb03=l_max
                 LET g_ogb_slk.ogb04=l_ima01
                 LET g_ogb_slk.ogb12=p_qty
                 LET g_ogb_slk.ogb16=p_qty
                 LET g_ogb_slk.ogb18=p_qty
                 LET g_ogb_slk.ogb912=p_qty
                 LET g_ogb_slk.ogb917=p_qty
                 SELECT ima02 INTO g_ogb_slk.ogb06 FROM ima_file WHERE ima01=l_ima01
                 SELECT obk03 INTO g_ogb_slk.ogb11 FROM obk_file,oga_file 
                   WHERE obk01=l_ima01 AND obk02=oga03 AND oga01=g_keyvalue1
                 IF NOT cl_null(g_ogb_slk.ogb31) THEN
                    SELECT oeb03 INTO g_ogb_slk.ogb32 FROM oeb_file,oebi_file
                     WHERE oeb01=oebi01 AND oeb03=oebi03
                       AND oeb01=g_ogb_slk.ogb31 AND oeb04=l_ima01
                       AND oebislk03=(SELECT ogbslk32 FROM ogbslk_file 
                                       WHERE ogbslk01=g_keyvalue1 AND ogbslk03=g_keyvalue2)

                    SELECT oeb37,oeb41,oeb42,oeb43,oeb44,oeb45,oeb46,oeb47,oeb48,oeb49,
                           oeb931,oeb932,oeb15,oeb1001,oeb1002,oeb1003,oeb1004,oeb1006,
                           oeb1007,oeb1008,oeb1009,oeb1010,oeb1011,oeb1012
                      INTO g_ogb_slk.ogb37,g_ogb_slk.ogb41,g_ogb_slk.ogb42,g_ogb_slk.ogb43,g_ogb_slk.ogb44,
                           g_ogb_slk.ogb45,g_ogb_slk.ogb46,g_ogb_slk.ogb47,g_ogb_slk.ogb48,g_ogb_slk.ogb49,
                           g_ogb_slk.ogb931,g_ogb_slk.ogb932,g_ogb_slk.ogb1003,g_ogb_slk.ogb1001,g_ogb_slk.ogb1002,
                           g_ogb_slk.ogb1005,g_ogb_slk.ogb1004,g_ogb_slk.ogb1006,g_ogb_slk.ogb1007,g_ogb_slk.ogb1008,
                           g_ogb_slk.ogb1009,g_ogb_slk.ogb1010,g_ogb_slk.ogb1011,g_ogb_slk.ogb1012
                      FROM oeb_file
                     WHERE oeb01=g_ogb_slk.ogb31 AND oeb03=g_ogb_slk.ogb32
                 END IF

                 SELECT oga211,oga213 INTO l_oga211,l_oga213 FROM oga_file WHERE oga01=g_keyvalue1 AND oga09='1'
                 IF l_oga213 = 'N' THEN
                    LET g_ogb_slk.ogb14 = s_amount_slk(g_ogb_slk.ogb917,g_ogb_slk.ogb13,g_ogb_slk.ogb1006,t_azi03)  
                    CALL cl_digcut(g_ogb_slk.ogb14,t_azi04)  RETURNING g_ogb_slk.ogb14
                    LET g_ogb_slk.ogb14t= g_ogb_slk.ogb14*(1+ l_oga211/100)
                    CALL cl_digcut(g_ogb_slk.ogb14t,t_azi04) RETURNING g_ogb_slk.ogb14t
                 ELSE
                    LET g_ogb_slk.ogb14t= s_amount_slk(g_ogb_slk.ogb917,g_ogb_slk.ogb13,g_ogb_slk.ogb1006,t_azi03) 
                    CALL cl_digcut(g_ogb_slk.ogb14t,t_azi04) RETURNING g_ogb_slk.ogb14t
                    LET g_ogb_slk.ogb14 = g_ogb_slk.ogb14t/(1+ l_oga211/100)
                    CALL cl_digcut(g_ogb_slk.ogb14,t_azi04)  RETURNING g_ogb_slk.ogb14
                 END IF

                 IF cl_null(g_ogb_slk.ogb37) THEN LET g_ogb_slk.ogb37=0 END IF
                 IF cl_null(g_ogb_slk.ogb47) THEN LET g_ogb_slk.ogb47=0 END IF
                 IF cl_null(g_ogb_slk.ogb44) THEN LET g_ogb_slk.ogb44='1' END IF
                 LET g_ogb_slk.ogb1005='1'
                 #FUN-C50097 ADD BEGIN-----
                 IF cl_null(g_ogb_slk.ogb50) THEN 
                   LET g_ogb_slk.ogb50 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb51) THEN 
                   LET g_ogb_slk.ogb51 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb52) THEN 
                   LET g_ogb_slk.ogb52 = 0
                 END IF     
                 IF cl_null(g_ogb_slk.ogb53) THEN 
                   LET g_ogb_slk.ogb53 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb54) THEN 
                   LET g_ogb_slk.ogb54 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb55) THEN 
                   LET g_ogb_slk.ogb55 = 0
                 END IF                                                   
                 #FUN-C50097 ADD END-------                  
                 INSERT INTO ogb_file VALUES (g_ogb_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_ogbi_slk.ogbi01=g_keyvalue1
                 LET g_ogbi_slk.ogbi03=l_max
                 LET g_ogbi_slk.ogbislk01=p_ima01
                 LET g_ogbi_slk.ogbislk02=g_keyvalue2
                 LET g_ogbi_slk.ogbiplant=g_plant
                 LET g_ogbi_slk.ogbilegal=g_legal
                 INSERT INTO ogbi_file VALUES (g_ogbi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF
            WHEN 'axmt620_slk'
                 SELECT max(ogb03) INTO l_max FROM ogb_file
                   WHERE ogb01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_ogb_slk.ogb01=g_keyvalue1
                 LET g_ogb_slk.ogb03=l_max
                 LET g_ogb_slk.ogb04=l_ima01
                 LET g_ogb_slk.ogb12=p_qty
                 LET g_ogb_slk.ogb16=p_qty
                 LET g_ogb_slk.ogb18=p_qty
                 LET g_ogb_slk.ogb912=p_qty
                 LET g_ogb_slk.ogb917=p_qty
                 SELECT ima02 INTO g_ogb_slk.ogb06 FROM ima_file WHERE ima01=l_ima01
                 SELECT obk03 INTO g_ogb_slk.ogb11 FROM obk_file,oga_file
                   WHERE obk01=l_ima01 AND obk02=oga03 AND oga01=g_keyvalue1
                 IF NOT cl_null(g_ogb_slk.ogb31) THEN
                    SELECT oeb03 INTO g_ogb_slk.ogb32 FROM oeb_file,oebi_file
                     WHERE oeb01=oebi01 AND oeb03=oebi03
                       AND oeb01=g_ogb_slk.ogb31 AND oeb04=l_ima01
                       AND oebislk03=(SELECT ogbslk32 FROM ogbslk_file
                                       WHERE ogbslk01=g_keyvalue1 AND ogbslk03=g_keyvalue2)

                    SELECT oeb37,oeb41,oeb42,oeb43,oeb44,oeb45,oeb46,oeb47,oeb48,oeb49,
                           oeb931,oeb932,oeb15,oeb1001,oeb1002,oeb1003,oeb1004,oeb1006,
                           oeb1007,oeb1008,oeb1009,oeb1010,oeb1011,oeb1012
                      INTO g_ogb_slk.ogb37,g_ogb_slk.ogb41,g_ogb_slk.ogb42,g_ogb_slk.ogb43,g_ogb_slk.ogb44,
                           g_ogb_slk.ogb45,g_ogb_slk.ogb46,g_ogb_slk.ogb47,g_ogb_slk.ogb48,g_ogb_slk.ogb49,
                           g_ogb_slk.ogb931,g_ogb_slk.ogb932,g_ogb_slk.ogb1003,g_ogb_slk.ogb1001,g_ogb_slk.ogb1002,
                           g_ogb_slk.ogb1005,g_ogb_slk.ogb1004,g_ogb_slk.ogb1006,g_ogb_slk.ogb1007,g_ogb_slk.ogb1008,
                           g_ogb_slk.ogb1009,g_ogb_slk.ogb1010,g_ogb_slk.ogb1011,g_ogb_slk.ogb1012
                      FROM oeb_file
                     WHERE oeb01=g_ogb_slk.ogb31 AND oeb03=g_ogb_slk.ogb32
                 END IF


                 SELECT oga211,oga213 INTO l_oga211,l_oga213 FROM oga_file WHERE oga01=g_keyvalue1 AND oga09='2'
                 IF l_oga213 = 'N' THEN
                    LET g_ogb_slk.ogb14 = s_amount_slk(g_ogb_slk.ogb917,g_ogb_slk.ogb13,g_ogb_slk.ogb1006,t_azi03)
                    CALL cl_digcut(g_ogb_slk.ogb14,t_azi04)  RETURNING g_ogb_slk.ogb14
                    LET g_ogb_slk.ogb14t= g_ogb_slk.ogb14*(1+ l_oga211/100)
                    CALL cl_digcut(g_ogb_slk.ogb14t,t_azi04) RETURNING g_ogb_slk.ogb14t
                 ELSE
                    LET g_ogb_slk.ogb14t= s_amount_slk(g_ogb_slk.ogb917,g_ogb_slk.ogb13,g_ogb_slk.ogb1006,t_azi03)
                    CALL cl_digcut(g_ogb_slk.ogb14t,t_azi04) RETURNING g_ogb_slk.ogb14t
                    LET g_ogb_slk.ogb14 = g_ogb_slk.ogb14t/(1+ l_oga211/100)
                    CALL cl_digcut(g_ogb_slk.ogb14,t_azi04)  RETURNING g_ogb_slk.ogb14
                 END IF
                 IF cl_null(g_ogb_slk.ogb14) THEN LET g_ogb_slk.ogb14=0 END IF
                 IF cl_null(g_ogb_slk.ogb14t) THEN LET g_ogb_slk.ogb14t=0 END IF
                 IF cl_null(g_ogb_slk.ogb37) THEN LET g_ogb_slk.ogb37=0 END IF
                 IF cl_null(g_ogb_slk.ogb47) THEN LET g_ogb_slk.ogb47=0 END IF
                 IF cl_null(g_ogb_slk.ogb44) THEN LET g_ogb_slk.ogb44='1' END IF
                 #FUN-C50097 ADD BEGIN-----
                 IF cl_null(g_ogb_slk.ogb50) THEN 
                   LET g_ogb_slk.ogb50 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb51) THEN 
                   LET g_ogb_slk.ogb51 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb52) THEN 
                   LET g_ogb_slk.ogb52 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb53) THEN 
                   LET g_ogb_slk.ogb53 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb54) THEN 
                   LET g_ogb_slk.ogb54 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb55) THEN 
                   LET g_ogb_slk.ogb55 = 0
                 END IF                                                      
                 #FUN-C50097 ADD END------- 
                 LET g_ogb_slk.ogb1005='1'
                 INSERT INTO ogb_file VALUES (g_ogb_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_ogbi_slk.ogbi01=g_keyvalue1
                 LET g_ogbi_slk.ogbi03=l_max
                 LET g_ogbi_slk.ogbislk01=p_ima01
                 LET g_ogbi_slk.ogbislk02=g_keyvalue2
                 LET g_ogbi_slk.ogbiplant=g_plant
                 LET g_ogbi_slk.ogbilegal=g_legal
                 INSERT INTO ogbi_file VALUES (g_ogbi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

            WHEN 'axmt628_slk'
                 SELECT max(ogb03) INTO l_max FROM ogb_file
                   WHERE ogb01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_ogb_slk.ogb01=g_keyvalue1
                 LET g_ogb_slk.ogb03=l_max
                 LET g_ogb_slk.ogb04=l_ima01
                 LET g_ogb_slk.ogb12=p_qty
                 LET g_ogb_slk.ogb16=p_qty
                 LET g_ogb_slk.ogb18=p_qty
                 LET g_ogb_slk.ogb912=p_qty
                 LET g_ogb_slk.ogb917=p_qty
                 SELECT ima02 INTO g_ogb_slk.ogb06 FROM ima_file WHERE ima01=l_ima01
                 SELECT obk03 INTO g_ogb_slk.ogb11 FROM obk_file,oga_file
                   WHERE obk01=l_ima01 AND obk02=oga03 AND oga01=g_keyvalue1
                 IF NOT cl_null(g_ogb_slk.ogb31) THEN
                    SELECT oeb03 INTO g_ogb_slk.ogb32 FROM oeb_file,oebi_file
                     WHERE oeb01=oebi01 AND oeb03=oebi03
                       AND oeb01=g_ogb_slk.ogb31 AND oeb04=l_ima01
                       AND oebislk03=(SELECT ogbslk32 FROM ogbslk_file
                                       WHERE ogbslk01=g_keyvalue1 AND ogbslk03=g_keyvalue2)

                    SELECT oeb37,oeb41,oeb42,oeb43,oeb44,oeb45,oeb46,oeb47,oeb48,oeb49,
                           oeb931,oeb932,oeb15,oeb1001,oeb1002,oeb1003,oeb1004,oeb1006,
                           oeb1007,oeb1008,oeb1009,oeb1010,oeb1011,oeb1012
                      INTO g_ogb_slk.ogb37,g_ogb_slk.ogb41,g_ogb_slk.ogb42,g_ogb_slk.ogb43,g_ogb_slk.ogb44,
                           g_ogb_slk.ogb45,g_ogb_slk.ogb46,g_ogb_slk.ogb47,g_ogb_slk.ogb48,g_ogb_slk.ogb49,
                           g_ogb_slk.ogb931,g_ogb_slk.ogb932,g_ogb_slk.ogb1003,g_ogb_slk.ogb1001,g_ogb_slk.ogb1002,
                           g_ogb_slk.ogb1005,g_ogb_slk.ogb1004,g_ogb_slk.ogb1006,g_ogb_slk.ogb1007,g_ogb_slk.ogb1008,
                           g_ogb_slk.ogb1009,g_ogb_slk.ogb1010,g_ogb_slk.ogb1011,g_ogb_slk.ogb1012
                      FROM oeb_file
                     WHERE oeb01=g_ogb_slk.ogb31 AND oeb03=g_ogb_slk.ogb32
                 END IF


                 SELECT oga211,oga213 INTO l_oga211,l_oga213 FROM oga_file WHERE oga01=g_keyvalue1 AND oga09='2'
                 IF l_oga213 = 'N' THEN
                    LET g_ogb_slk.ogb14 = s_amount_slk(g_ogb_slk.ogb917,g_ogb_slk.ogb13,g_ogb_slk.ogb1006,t_azi03)
                    CALL cl_digcut(g_ogb_slk.ogb14,t_azi04)  RETURNING g_ogb_slk.ogb14
                    LET g_ogb_slk.ogb14t= g_ogb_slk.ogb14*(1+ l_oga211/100)
                    CALL cl_digcut(g_ogb_slk.ogb14t,t_azi04) RETURNING g_ogb_slk.ogb14t
                 ELSE
                    LET g_ogb_slk.ogb14t= s_amount_slk(g_ogb_slk.ogb917,g_ogb_slk.ogb13,g_ogb_slk.ogb1006,t_azi03)
                    CALL cl_digcut(g_ogb_slk.ogb14t,t_azi04) RETURNING g_ogb_slk.ogb14t
                    LET g_ogb_slk.ogb14 = g_ogb_slk.ogb14t/(1+ l_oga211/100)
                    CALL cl_digcut(g_ogb_slk.ogb14,t_azi04)  RETURNING g_ogb_slk.ogb14
                 END IF
                 IF cl_null(g_ogb_slk.ogb14) THEN LET g_ogb_slk.ogb14=0 END IF
                 IF cl_null(g_ogb_slk.ogb14t) THEN LET g_ogb_slk.ogb14t=0 END IF
                 IF cl_null(g_ogb_slk.ogb37) THEN LET g_ogb_slk.ogb37=0 END IF
                 IF cl_null(g_ogb_slk.ogb47) THEN LET g_ogb_slk.ogb47=0 END IF
                 IF cl_null(g_ogb_slk.ogb44) THEN LET g_ogb_slk.ogb44='1' END IF
                 #FUN-C50097 ADD BEGIN-----
                 IF cl_null(g_ogb_slk.ogb50) THEN 
                   LET g_ogb_slk.ogb50 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb51) THEN 
                   LET g_ogb_slk.ogb51 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb52) THEN 
                   LET g_ogb_slk.ogb52 = 0
                 END IF    
                 IF cl_null(g_ogb_slk.ogb53) THEN 
                   LET g_ogb_slk.ogb53 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb54) THEN 
                   LET g_ogb_slk.ogb54 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb55) THEN 
                   LET g_ogb_slk.ogb55 = 0
                 END IF                                                   
                 #FUN-C50097 ADD END------- 
                 LET g_ogb_slk.ogb1005='1'
                 INSERT INTO ogb_file VALUES (g_ogb_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_ogbi_slk.ogbi01=g_keyvalue1
                 LET g_ogbi_slk.ogbi03=l_max
                 LET g_ogbi_slk.ogbislk01=p_ima01
                 LET g_ogbi_slk.ogbislk02=g_keyvalue2
                 LET g_ogbi_slk.ogbiplant=g_plant
                 LET g_ogbi_slk.ogbilegal=g_legal
                 INSERT INTO ogbi_file VALUES (g_ogbi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

            WHEN 'axmt629_slk'
                 SELECT max(ogb03) INTO l_max FROM ogb_file
                   WHERE ogb01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_ogb_slk.ogb01=g_keyvalue1
                 LET g_ogb_slk.ogb03=l_max
                 LET g_ogb_slk.ogb04=l_ima01
                 LET g_ogb_slk.ogb12=p_qty
                 LET g_ogb_slk.ogb16=p_qty
                 LET g_ogb_slk.ogb18=p_qty
                 LET g_ogb_slk.ogb912=p_qty
                 LET g_ogb_slk.ogb917=p_qty
                 SELECT ima02 INTO g_ogb_slk.ogb06 FROM ima_file WHERE ima01=l_ima01
                 SELECT obk03 INTO g_ogb_slk.ogb11 FROM obk_file,oga_file
                   WHERE obk01=l_ima01 AND obk02=oga03 AND oga01=g_keyvalue1
                 IF NOT cl_null(g_ogb_slk.ogb31) THEN
                    SELECT oeb03 INTO g_ogb_slk.ogb32 FROM oeb_file,oebi_file
                     WHERE oeb01=oebi01 AND oeb03=oebi03
                       AND oeb01=g_ogb_slk.ogb31 AND oeb04=l_ima01
                       AND oebislk03=(SELECT ogbslk32 FROM ogbslk_file
                                       WHERE ogbslk01=g_keyvalue1 AND ogbslk03=g_keyvalue2)

                    SELECT oeb37,oeb41,oeb42,oeb43,oeb44,oeb45,oeb46,oeb47,oeb48,oeb49,
                           oeb931,oeb932,oeb15,oeb1001,oeb1002,oeb1003,oeb1004,oeb1006,
                           oeb1007,oeb1008,oeb1009,oeb1010,oeb1011,oeb1012
                      INTO g_ogb_slk.ogb37,g_ogb_slk.ogb41,g_ogb_slk.ogb42,g_ogb_slk.ogb43,g_ogb_slk.ogb44,
                           g_ogb_slk.ogb45,g_ogb_slk.ogb46,g_ogb_slk.ogb47,g_ogb_slk.ogb48,g_ogb_slk.ogb49,
                           g_ogb_slk.ogb931,g_ogb_slk.ogb932,g_ogb_slk.ogb1003,g_ogb_slk.ogb1001,g_ogb_slk.ogb1002,
                           g_ogb_slk.ogb1005,g_ogb_slk.ogb1004,g_ogb_slk.ogb1006,g_ogb_slk.ogb1007,g_ogb_slk.ogb1008,
                           g_ogb_slk.ogb1009,g_ogb_slk.ogb1010,g_ogb_slk.ogb1011,g_ogb_slk.ogb1012
                      FROM oeb_file
                     WHERE oeb01=g_ogb_slk.ogb31 AND oeb03=g_ogb_slk.ogb32
                 END IF


                 SELECT oga211,oga213 INTO l_oga211,l_oga213 FROM oga_file WHERE oga01=g_keyvalue1 AND oga09='2'
                 IF l_oga213 = 'N' THEN
                    LET g_ogb_slk.ogb14 = s_amount_slk(g_ogb_slk.ogb917,g_ogb_slk.ogb13,g_ogb_slk.ogb1006,t_azi03)
                    CALL cl_digcut(g_ogb_slk.ogb14,t_azi04)  RETURNING g_ogb_slk.ogb14
                    LET g_ogb_slk.ogb14t= g_ogb_slk.ogb14*(1+ l_oga211/100)
                    CALL cl_digcut(g_ogb_slk.ogb14t,t_azi04) RETURNING g_ogb_slk.ogb14t
                 ELSE
                    LET g_ogb_slk.ogb14t= s_amount_slk(g_ogb_slk.ogb917,g_ogb_slk.ogb13,g_ogb_slk.ogb1006,t_azi03)
                    CALL cl_digcut(g_ogb_slk.ogb14t,t_azi04) RETURNING g_ogb_slk.ogb14t
                    LET g_ogb_slk.ogb14 = g_ogb_slk.ogb14t/(1+ l_oga211/100)
                    CALL cl_digcut(g_ogb_slk.ogb14,t_azi04)  RETURNING g_ogb_slk.ogb14
                 END IF
                 IF cl_null(g_ogb_slk.ogb14) THEN LET g_ogb_slk.ogb14=0 END IF
                 IF cl_null(g_ogb_slk.ogb14t) THEN LET g_ogb_slk.ogb14t=0 END IF
                 IF cl_null(g_ogb_slk.ogb37) THEN LET g_ogb_slk.ogb37=0 END IF
                 IF cl_null(g_ogb_slk.ogb47) THEN LET g_ogb_slk.ogb47=0 END IF
                 IF cl_null(g_ogb_slk.ogb44) THEN LET g_ogb_slk.ogb44='1' END IF
                 #FUN-C50097 ADD BEGIN-----
                 IF cl_null(g_ogb_slk.ogb50) THEN 
                   LET g_ogb_slk.ogb50 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb51) THEN 
                   LET g_ogb_slk.ogb51 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb52) THEN 
                   LET g_ogb_slk.ogb52 = 0
                 END IF  
                 IF cl_null(g_ogb_slk.ogb53) THEN 
                   LET g_ogb_slk.ogb53 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb54) THEN 
                   LET g_ogb_slk.ogb54 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb55) THEN 
                   LET g_ogb_slk.ogb55 = 0
                 END IF                                                     
                 #FUN-C50097 ADD END------- 
                 LET g_ogb_slk.ogb1005='1'
                 INSERT INTO ogb_file VALUES (g_ogb_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_ogbi_slk.ogbi01=g_keyvalue1
                 LET g_ogbi_slk.ogbi03=l_max
                 LET g_ogbi_slk.ogbislk01=p_ima01
                 LET g_ogbi_slk.ogbislk02=g_keyvalue2
                 LET g_ogbi_slk.ogbiplant=g_plant
                 LET g_ogbi_slk.ogbilegal=g_legal
                 INSERT INTO ogbi_file VALUES (g_ogbi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF
            WHEN 'axmt640_slk'
                 SELECT max(ogb03) INTO l_max FROM ogb_file
                   WHERE ogb01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_ogb_slk.ogb01=g_keyvalue1
                 LET g_ogb_slk.ogb03=l_max
                 LET g_ogb_slk.ogb04=l_ima01
                 LET g_ogb_slk.ogb12=p_qty
                 LET g_ogb_slk.ogb16=p_qty
                 LET g_ogb_slk.ogb18=p_qty
                 LET g_ogb_slk.ogb912=p_qty
                 LET g_ogb_slk.ogb917=p_qty
                 SELECT ima02 INTO g_ogb_slk.ogb06 FROM ima_file WHERE ima01=l_ima01
                 SELECT obk03 INTO g_ogb_slk.ogb11 FROM obk_file,oga_file
                   WHERE obk01=l_ima01 AND obk02=oga03 AND oga01=g_keyvalue1
                 IF NOT cl_null(g_ogb_slk.ogb31) THEN
                    SELECT oeb03 INTO g_ogb_slk.ogb32 FROM oeb_file,oebi_file
                     WHERE oeb01=oebi01 AND oeb03=oebi03
                       AND oeb01=g_ogb_slk.ogb31 AND oeb04=l_ima01
                       AND oebislk03=(SELECT ogbslk32 FROM ogbslk_file
                                       WHERE ogbslk01=g_keyvalue1 AND ogbslk03=g_keyvalue2)

                    SELECT oeb37,oeb41,oeb42,oeb43,oeb44,oeb45,oeb46,oeb47,oeb48,oeb49,
                           oeb931,oeb932,oeb15,oeb1001,oeb1002,oeb1003,oeb1004,oeb1006,
                           oeb1007,oeb1008,oeb1009,oeb1010,oeb1011,oeb1012
                      INTO g_ogb_slk.ogb37,g_ogb_slk.ogb41,g_ogb_slk.ogb42,g_ogb_slk.ogb43,g_ogb_slk.ogb44,
                           g_ogb_slk.ogb45,g_ogb_slk.ogb46,g_ogb_slk.ogb47,g_ogb_slk.ogb48,g_ogb_slk.ogb49,
                           g_ogb_slk.ogb931,g_ogb_slk.ogb932,g_ogb_slk.ogb1003,g_ogb_slk.ogb1001,g_ogb_slk.ogb1002,
                           g_ogb_slk.ogb1005,g_ogb_slk.ogb1004,g_ogb_slk.ogb1006,g_ogb_slk.ogb1007,g_ogb_slk.ogb1008,
                           g_ogb_slk.ogb1009,g_ogb_slk.ogb1010,g_ogb_slk.ogb1011,g_ogb_slk.ogb1012
                      FROM oeb_file
                     WHERE oeb01=g_ogb_slk.ogb31 AND oeb03=g_ogb_slk.ogb32
                 END IF


                 SELECT oga211,oga213 INTO l_oga211,l_oga213 FROM oga_file WHERE oga01=g_keyvalue1 AND oga09='2'
                 IF l_oga213 = 'N' THEN
                    LET g_ogb_slk.ogb14 = s_amount_slk(g_ogb_slk.ogb917,g_ogb_slk.ogb13,g_ogb_slk.ogb1006,t_azi03)
                    CALL cl_digcut(g_ogb_slk.ogb14,t_azi04)  RETURNING g_ogb_slk.ogb14
                    LET g_ogb_slk.ogb14t= g_ogb_slk.ogb14*(1+ l_oga211/100)
                    CALL cl_digcut(g_ogb_slk.ogb14t,t_azi04) RETURNING g_ogb_slk.ogb14t
                 ELSE
                    LET g_ogb_slk.ogb14t= s_amount_slk(g_ogb_slk.ogb917,g_ogb_slk.ogb13,g_ogb_slk.ogb1006,t_azi03)
                    CALL cl_digcut(g_ogb_slk.ogb14t,t_azi04) RETURNING g_ogb_slk.ogb14t
                    LET g_ogb_slk.ogb14 = g_ogb_slk.ogb14t/(1+ l_oga211/100)
                    CALL cl_digcut(g_ogb_slk.ogb14,t_azi04)  RETURNING g_ogb_slk.ogb14
                 END IF
                 IF cl_null(g_ogb_slk.ogb14) THEN LET g_ogb_slk.ogb14=0 END IF
                 IF cl_null(g_ogb_slk.ogb14t) THEN LET g_ogb_slk.ogb14t=0 END IF
                 IF cl_null(g_ogb_slk.ogb37) THEN LET g_ogb_slk.ogb37=0 END IF
                 IF cl_null(g_ogb_slk.ogb47) THEN LET g_ogb_slk.ogb47=0 END IF
                 IF cl_null(g_ogb_slk.ogb44) THEN LET g_ogb_slk.ogb44='1' END IF
                 #FUN-C50097 ADD BEGIN-----
                 IF cl_null(g_ogb_slk.ogb50) THEN 
                   LET g_ogb_slk.ogb50 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb51) THEN 
                   LET g_ogb_slk.ogb51 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb52) THEN 
                   LET g_ogb_slk.ogb52 = 0
                 END IF                                      
                 IF cl_null(g_ogb_slk.ogb53) THEN 
                   LET g_ogb_slk.ogb53 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb54) THEN 
                   LET g_ogb_slk.ogb54 = 0
                 END IF 
                 IF cl_null(g_ogb_slk.ogb55) THEN 
                   LET g_ogb_slk.ogb55 = 0
                 END IF 
                 #FUN-C50097 ADD END------- 
                 LET g_ogb_slk.ogb1005='1'
                 INSERT INTO ogb_file VALUES (g_ogb_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_ogbi_slk.ogbi01=g_keyvalue1
                 LET g_ogbi_slk.ogbi03=l_max
                 LET g_ogbi_slk.ogbislk01=p_ima01
                 LET g_ogbi_slk.ogbislk02=g_keyvalue2
                 LET g_ogbi_slk.ogbiplant=g_plant
                 LET g_ogbi_slk.ogbilegal=g_legal
                 INSERT INTO ogbi_file VALUES (g_ogbi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

            WHEN 'artt212'
                 SELECT max(rux02) INTO l_max FROM rux_file
                   WHERE rux01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_rux_slk.rux01=g_keyvalue1
                 LET g_rux_slk.rux02=l_max
                 LET g_rux_slk.rux03=l_ima01
                 LET g_rux_slk.rux06=p_qty
                 LET g_rux_slk.rux11s=g_keyvalue2
                 
                 INSERT INTO rux_file VALUES (g_rux_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

            WHEN 'artt256'
                 SELECT max(rup02) INTO l_max FROM rup_file
                   WHERE rup01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_rup_slk.rup01=g_keyvalue1
                 LET g_rup_slk.rup02=l_max
                 LET g_rup_slk.rup03=l_ima01
                 LET g_rup_slk.rup12=p_qty
                 LET g_rup_slk.rup16=p_qty
                 LET g_rup_slk.rup19=p_qty
                 LET g_rup_slk.rup20s=p_ima01
                 LET g_rup_slk.rup21s=g_keyvalue2

                 INSERT INTO rup_file VALUES (g_rup_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

            WHEN 'apmt720_slk'
                 SELECT rvvslk36,rvvslk38,rvvslk38t INTO l_rvv36,l_rvv38,l_rvv38t FROM rvvslk_file
                   WHERE rvvslk01=g_keyvalue1 
                     AND rvvslk02=g_keyvalue2

                 SELECT rva00 INTO l_rva00 FROM rva_file,rvu_file WHERE rva01 = rvu02 AND rvu01=g_keyvalue1
                 SELECT rvu00,rvu02,rvu04,rvu113 INTO l_rvu00,l_rvu02,l_rvu04,l_rvu113 FROM rvu_file WHERE rvu01=g_keyvalue1
                 IF cl_null(l_rvu02) THEN
                    LET l_rva00 = '2'
                 END IF
                 LET t_azi04=''
                 IF l_rva00 = '1' AND l_rvu00 = '3' THEN
                    SELECT azi04 INTO t_azi04 FROM azi_file
                        WHERE azi01 = l_rvu113
                 END IF
                 IF l_rva00 = '1' AND l_rvu00 <> '3' THEN
                    SELECT azi04 INTO t_azi04
                       FROM pmm_file,azi_file
                      WHERE pmm22=azi01
                     #  AND pmm01=l_rvvslk36   #MOD-C30217--mark
                        AND pmm01=l_rvv36      #MOD-C30217--add
                        AND pmm18 <> 'X'
                 END IF
                 IF l_rva00 = '2' THEN
                    SELECT rva113 INTO l_rva113 FROM rva_file
                        WHERE rva01 = l_rvu02
                    SELECT azi04 INTO t_azi04 FROM azi_file
                        WHERE azi01 = l_rva113
                 END IF
                 IF cl_null(t_azi04) THEN
                    SELECT azi04 INTO t_azi04
                      FROM pmc_file,azi_file
                     WHERE pmc22=azi01
                       AND pmc01 = l_rvu04
                 END IF
                 IF cl_null(t_azi04) THEN LET t_azi04=0 END IF

                 LET l_rvv39=p_qty*l_rvv38
                 LET l_rvv39t=p_qty*l_rvv38t

                 CALL cl_digcut(l_rvv39,t_azi04)
                                   RETURNING l_rvv39
                 CALL cl_digcut(l_rvv39t,t_azi04)
                                   RETURNING l_rvv39t

                 CALL s_t720slk_rvv39(l_rvv36,l_rvv39,l_rvv39t,l_rvu04,l_rvu02)
                   RETURNING l_rvv39,l_rvv39t

                 SELECT max(rvv02) INTO l_max FROM rvv_file
                   WHERE rvv01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_rvv_slk.rvv01=g_keyvalue1
                 LET g_rvv_slk.rvv02=l_max
                 LET g_rvv_slk.rvv31=l_ima01
                 LET g_rvv_slk.rvv17=p_qty
                 LET g_rvv_slk.rvv87=p_qty
                 LET g_rvv_slk.rvv39=l_rvv39
                 LET g_rvv_slk.rvv39t=l_rvv39t

                 INSERT INTO rvv_file VALUES (g_rvv_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_rvvi_slk.rvvi01=g_keyvalue1
                 LET g_rvvi_slk.rvvi02=l_max
                 LET g_rvvi_slk.rvvislk01=p_ima01
                 LET g_rvvi_slk.rvvislk02=g_keyvalue2
                 LET g_rvvi_slk.rvviplant=g_plant
                 LET g_rvvi_slk.rvvilegal=g_legal
                 INSERT INTO rvvi_file VALUES (g_rvvi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

            WHEN 'apmt722_slk'
                 SELECT rvvslk36,rvvslk38,rvvslk38t INTO l_rvv36,l_rvv38,l_rvv38t FROM rvvslk_file
                   WHERE rvvslk01=g_keyvalue1
                     AND rvvslk02=g_keyvalue2

                 SELECT rva00 INTO l_rva00 FROM rva_file,rvu_file WHERE rva01 = rvu02 AND rvu01=g_keyvalue1
                 SELECT rvu00,rvu02,rvu04,rvu113 INTO l_rvu00,l_rvu02,l_rvu04,l_rvu113 FROM rvu_file WHERE rvu01=g_keyvalue1
                 IF cl_null(l_rvu02) THEN
                    LET l_rva00 = '2'
                 END IF
                 LET t_azi04=''
                 IF l_rva00 = '1' AND l_rvu00 = '3' THEN
                    SELECT azi04 INTO t_azi04 FROM azi_file
                        WHERE azi01 = l_rvu113
                 END IF
                 IF l_rva00 = '1' AND l_rvu00 <> '3' THEN
                    SELECT azi04 INTO t_azi04
                       FROM pmm_file,azi_file
                      WHERE pmm22=azi01
                        AND pmm01=l_rvv36
                        AND pmm18 <> 'X'
                 END IF
                 IF l_rva00 = '2' THEN
                    SELECT rva113 INTO l_rva113 FROM rva_file
                        WHERE rva01 = l_rvu02
                    SELECT azi04 INTO t_azi04 FROM azi_file
                        WHERE azi01 = l_rva113
                 END IF
                 IF cl_null(t_azi04) THEN
                    SELECT azi04 INTO t_azi04
                      FROM pmc_file,azi_file
                     WHERE pmc22=azi01
                       AND pmc01 = l_rvu04
                 END IF
                 IF cl_null(t_azi04) THEN LET t_azi04=0 END IF

                 LET l_rvv39=p_qty*l_rvv38
                 LET l_rvv39t=p_qty*l_rvv38t

                 CALL cl_digcut(l_rvv39,t_azi04)
                                   RETURNING l_rvv39
                 CALL cl_digcut(l_rvv39t,t_azi04)
                                   RETURNING l_rvv39t

                 CALL s_t720slk_rvv39(l_rvv36,l_rvv39,l_rvv39t,l_rvu04,l_rvu02)
                   RETURNING l_rvv39,l_rvv39t

                 SELECT max(rvv02) INTO l_max FROM rvv_file
                   WHERE rvv01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_rvv_slk.rvv01=g_keyvalue1
                 LET g_rvv_slk.rvv02=l_max
                 LET g_rvv_slk.rvv31=l_ima01
                 LET g_rvv_slk.rvv17=p_qty
                 LET g_rvv_slk.rvv87=p_qty
                 LET g_rvv_slk.rvv39=l_rvv39
                 LET g_rvv_slk.rvv39t=l_rvv39t

                 INSERT INTO rvv_file VALUES (g_rvv_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_rvvi_slk.rvvi01=g_keyvalue1
                 LET g_rvvi_slk.rvvi02=l_max
                 LET g_rvvi_slk.rvvislk01=p_ima01
                 LET g_rvvi_slk.rvvislk02=g_keyvalue2
                 LET g_rvvi_slk.rvviplant=g_plant
                 LET g_rvvi_slk.rvvilegal=g_legal
                 INSERT INTO rvvi_file VALUES (g_rvvi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF
#FUN-C20101-----ADD------STR-----                 
             WHEN 'aimt301_slk'
                 SELECT max(inb03) INTO l_max FROM inb_file
                   WHERE inb01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF
                 IF NOT cl_null(g_inb_slk.inb08) THEN  LET p_qty=s_digqty(p_qty,g_inb_slk.inb08) END IF
                 LET g_inb_slk.inb01=g_keyvalue1
                 LET g_inb_slk.inb03=l_max
                 LET g_inb_slk.inb04=l_ima01
                 
                 LET g_inb_slk.inb09=p_qty
                 LET g_inb_slk.inb16=p_qty
                 LET g_inb_slk.inb904=p_qty

                 INSERT INTO inb_file VALUES (g_inb_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_inbi_slk.inbi01=g_keyvalue1
                 LET g_inbi_slk.inbi03=l_max
                 LET g_inbi_slk.inbislk01=p_ima01
                 LET g_inbi_slk.inbislk02=g_keyvalue2
                 INSERT INTO inbi_file VALUES (g_inbi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF
             WHEN 'aimt302_slk'
                 SELECT max(inb03) INTO l_max FROM inb_file
                   WHERE inb01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF
                 IF NOT cl_null(g_inb_slk.inb08) THEN  LET p_qty=s_digqty(p_qty,g_inb_slk.inb08) END IF
                 LET g_inb_slk.inb01=g_keyvalue1
                 LET g_inb_slk.inb03=l_max
                 LET g_inb_slk.inb04=l_ima01
                 
                 LET g_inb_slk.inb09=p_qty
                 LET g_inb_slk.inb16=p_qty
                 LET g_inb_slk.inb904=p_qty

                 INSERT INTO inb_file VALUES (g_inb_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF
                                   
                 LET g_inbi_slk.inbi01=g_keyvalue1
                 LET g_inbi_slk.inbi03=l_max
                 LET g_inbi_slk.inbislk01=p_ima01
                 LET g_inbi_slk.inbislk02=g_keyvalue2
                 INSERT INTO inbi_file VALUES (g_inbi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF 

             WHEN 'aimt303_slk'
                 SELECT max(inb03) INTO l_max FROM inb_file
                   WHERE inb01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF
                 IF NOT cl_null(g_inb_slk.inb08) THEN  LET p_qty=s_digqty(p_qty,g_inb_slk.inb08) END IF
                 LET g_inb_slk.inb01=g_keyvalue1
                 LET g_inb_slk.inb03=l_max
                 LET g_inb_slk.inb04=l_ima01

                 LET g_inb_slk.inb09=p_qty
                 LET g_inb_slk.inb16=p_qty
                 LET g_inb_slk.inb904=p_qty

                 INSERT INTO inb_file VALUES (g_inb_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_inbi_slk.inbi01=g_keyvalue1
                 LET g_inbi_slk.inbi03=l_max
                 LET g_inbi_slk.inbislk01=p_ima01
                 LET g_inbi_slk.inbislk02=g_keyvalue2
                 INSERT INTO inbi_file VALUES (g_inbi_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

#FUN-C20101-------ADD----END-------         
#FUN-C30057-----ADD------STR-----   
              WHEN 'apmt580_slk'
                 SELECT max(pon02) INTO l_max FROM pon_file
                   WHERE pon01=g_keyvalue1

                 IF cl_null(l_max) THEN
                    LET l_max=1
                 ELSE
                    LET l_max=l_max+1
                 END IF

                 LET g_pon_slk.pon01=g_keyvalue1
                 LET g_pon_slk.pon02=l_max
                 LET g_pon_slk.pon04=l_ima01
                 SELECT ima02 INTO g_pon_slk.pon041 FROM ima_file WHERE ima01=g_pon_slk.pon04
                 LET g_pon_slk.pon20=p_qty
                 LET g_pon_slk.pon82=p_qty
                 LET g_pon_slk.pon87=p_qty
                 LET g_pon_slk.pon88 =cl_digcut(g_pon_slk.pon87*g_pon_slk.pon31,t_azi04)
                 LET g_pon_slk.pon88t=cl_digcut(g_pon_slk.pon87*g_pon_slk.pon31t,t_azi04)

                 INSERT INTO pon_file VALUES (g_pon_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF

                 LET g_poni_slk.poni01=g_keyvalue1
                 LET g_poni_slk.poni02=l_max
                 LET g_poni_slk.ponislk03=p_ima01
                 LET g_poni_slk.ponislk02=g_keyvalue2
                 INSERT INTO poni_file VALUES (g_poni_slk.*)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins",'',g_keyvalue1,l_ima01,SQLCA.sqlcode,"","",1)
                    LET g_success = 'N'
                 END IF
#FUN-C30057-------ADD----END-------        
         END CASE

      END IF
   END IF
END FUNCTION



FUNCTION s_get_ima_slk(p_i,p_index,p_ima01)
   DEFINE p_i         LIKE type_file.num5
   DEFINE p_index     LIKE type_file.num5
   DEFINE l_ima01     LIKE ima_file.ima01
   DEFINE p_ima01     LIKE ima_file.ima01
   DEFINE l_ps        LIKE sma_file.sma46

   SELECT sma46 INTO l_ps FROM sma_file
   IF cl_null(l_ps) THEN LET l_ps = ' ' END IF

   LET l_ima01 = p_ima01,l_ps,
                 g_imx[p_i].color,l_ps,
                 g_imxtext[p_i].detail[p_index].size

   RETURN l_ima01
END FUNCTION

FUNCTION s_t720slk_rvv39(p_rvv36,p_rvv39,p_rvv39t,p_rvu04,p_rvu02)
  DEFINE    l_gec07   LIKE gec_file.gec07,     #含稅否
            l_gec05   LIKE gec_file.gec05,     #CHI-AC0016
            l_pmm43   LIKE pmm_file.pmm43,     #稅率
            p_rvv36   LIKE rvv_file.rvv36,     #採購單
            p_rvv39   LIKE rvv_file.rvv39,     #未稅金額
            p_rvv39t  LIKE rvv_file.rvv39t,    #含稅金額
            p_rvu04   LIKE rvu_file.rvu04,
            p_rvu02   LIKE rvu_file.rvu02
  DEFINE l_rva115     LIKE rva_file.rva115
  DEFINE l_rva00      LIKE rva_file.rva00
  DEFINE l_gec04      LIKE gec_file.gec04

  IF g_azw.azw04 = '2'  THEN
     SELECT gec04 INTO l_gec04 FROM gec_file,pmc_file
      WHERE gec01 = pmc47 AND pmc01 = p_rvu04
     LET p_rvv39t = p_rvv39 *(1 + l_gec04/100)
  ELSE
   #不使用單價*數量=金額, 改以金額回推稅率, 以避免小數位差的問題
    IF NOT cl_null(p_rvu02) THEN
       SELECT rva00,rva115,rva116 INTO l_rva00,l_rva115,l_pmm43
         FROM rva_file WHERE rva01 = p_rvu02
       IF l_rva00 = '2' THEN
          SELECT gec07,gec05 INTO l_gec07,l_gec05 FROM gec_file WHERE gec01 = l_rva115
       ELSE
          SELECT gec07,gec05,pmm43 INTO l_gec07,l_gec05,l_pmm43 FROM gec_file,pmm_file
           WHERE gec01 = pmm21
             AND pmm01 = p_rvv36
             AND gec011 = '1' #MOD-B40078 add
       END IF
    ELSE
        SELECT gec07,gec05,pmm43 INTO l_gec07,l_gec05,l_pmm43 FROM gec_file,pmm_file
          WHERE gec01 = pmm21
            AND pmm01 = p_rvv36
            AND gec011 = '1' #MOD-B40078 add
    END IF
  END IF

   IF SQLCA.SQLCODE = 100 THEN
      CALL cl_err('','mfg3192',0)
      SELECT gec07,gec05,gec04 INTO l_gec07,l_gec05,l_pmm43 FROM gec_file,pmc_file
       WHERE gec01 = pmc47
         AND pmc01 = p_rvu04
         AND gec011='1'  #進項
      IF cl_null(l_pmm43) THEN LET l_pmm43=0 END IF
   END IF
   IF l_gec07='Y' THEN
      IF l_gec05 = 'T' THEN
         LET p_rvv39 = p_rvv39t * ( 1 - l_pmm43/100)
         LET p_rvv39 = cl_digcut(p_rvv39 , t_azi04)
      ELSE
         LET p_rvv39 = p_rvv39t / ( 1 + l_pmm43/100)
         LET p_rvv39 = cl_digcut(p_rvv39 , t_azi04)
      END IF
   ELSE
      LET p_rvv39t = p_rvv39 * ( 1 + l_pmm43/100)
      LET p_rvv39t = cl_digcut( p_rvv39t , t_azi04)
   END IF

   RETURN p_rvv39,p_rvv39t
END FUNCTION

FUNCTION s_amount_slk(p_qty,p_price,p_rate,p_azi03)
DEFINE   p_qty       LIKE ogb_file.ogb12    #數量
DEFINE   p_price     LIKE ogb_file.ogb13    #單價(未折扣)
DEFINE   p_rate      LIKE ogb_file.ogb1006  #折扣率
DEFINE   p_azi03     LIKE azi_file.azi03    #單價位數
DEFINE   l_price     LIKE ogb_file.ogb13    #單價(已折扣)
DEFINE   l_amount    LIKE ogb_file.ogb14    #金額

    IF cl_null(p_rate) THEN
       LET p_rate = 100
    END IF
    LET l_price = cl_digcut(p_price*p_rate/100,p_azi03)
    LET l_amount= p_qty*l_price
    IF cl_null(l_amount) THEN
       LET l_amount = 0
    END IF
    RETURN l_amount
END FUNCTION

#TQC-C20348--add--begin--
#在顏色欄位後，進行這一行的判斷
FUNCTION s_chk_color_strategy(p_ac,p_item)
DEFINE p_ac    LIKE type_file.num5
DEFINE p_item  LIKE ima_file.ima01
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE l_flag  LIKE type_file.chr1
DEFINE l_error LIKE type_file.chr10
DEFINE i       LIKE type_file.num5

    LET l_error = ' '
    LET l_flag = 'Y'
    CALL s_showmsg_init() 
    FOR i=1 TO 15 
        CALL s_chk_color_prod(p_ac,i,p_item) RETURNING l_error,l_ima01
        IF NOT cl_null(l_error) THEN
           LET l_flag = 'N'
           CALL s_errmsg('',l_ima01,'','art-296',1)
        END IF  
    END FOR

    IF g_prog = "apmt420_slk" OR g_prog  = "apmt540_slk" THEN
       FOR i=1 TO 15 
           CALL s_chk_color_purc(p_ac,i,p_item) RETURNING l_error,l_ima01
           IF NOT cl_null(l_error) THEN
              LET l_flag = 'N'
              CALL s_errmsg('',l_ima01,'','mfg-227',1)
           END IF  
       END FOR
    END IF
    CALL s_showmsg()
    
    IF l_flag = 'N' THEN
       RETURN FALSE
    ELSE
       RETURN TRUE
    END IF
END FUNCTION

FUNCTION s_chk_color_prod(p_ac,i,p_item)
DEFINE p_ac    LIKE type_file.num5
DEFINE p_item  LIKE ima_file.ima01
DEFINE i       LIKE type_file.num5
DEFINE l_error LIKE type_file.chr10
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE p_qty   LIKE type_file.num10

    CASE i
       WHEN "1"
          LET p_qty = g_imx[p_ac].imx01
          CALL s_chk_prod_strategy(p_ac,1,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "2"
          LET p_qty = g_imx[p_ac].imx02
          CALL s_chk_prod_strategy(p_ac,2,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "3"
          LET p_qty = g_imx[p_ac].imx03
          CALL s_chk_prod_strategy(p_ac,3,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "4"
          LET p_qty = g_imx[p_ac].imx04
          CALL s_chk_prod_strategy(p_ac,4,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "5"
          LET p_qty = g_imx[p_ac].imx05
          CALL s_chk_prod_strategy(p_ac,5,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "6"
          LET p_qty = g_imx[p_ac].imx06
          CALL s_chk_prod_strategy(p_ac,6,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "7"
          LET p_qty = g_imx[p_ac].imx07
          CALL s_chk_prod_strategy(p_ac,7,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "8"
          LET p_qty = g_imx[p_ac].imx08
          CALL s_chk_prod_strategy(p_ac,8,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "9"
          LET p_qty = g_imx[p_ac].imx09
          CALL s_chk_prod_strategy(p_ac,9,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "10"
          LET p_qty = g_imx[p_ac].imx10
          CALL s_chk_prod_strategy(p_ac,10,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "11"
          LET p_qty = g_imx[p_ac].imx11
          CALL s_chk_prod_strategy(p_ac,11,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "12"
          LET p_qty = g_imx[p_ac].imx12
          CALL s_chk_prod_strategy(p_ac,12,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "13"
          LET p_qty = g_imx[p_ac].imx13
          CALL s_chk_prod_strategy(p_ac,13,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "14"
          LET p_qty = g_imx[p_ac].imx14
          CALL s_chk_prod_strategy(p_ac,14,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "15"
          LET p_qty = g_imx[p_ac].imx15
          CALL s_chk_prod_strategy(p_ac,15,p_item,p_qty) RETURNING  l_error,l_ima01
    END CASE
    RETURN l_error,l_ima01
END FUNCTION

FUNCTION s_chk_color_purc(p_ac,i,p_item)
DEFINE p_ac    LIKE type_file.num5
DEFINE p_item  LIKE ima_file.ima01
DEFINE i       LIKE type_file.num5
DEFINE l_error LIKE type_file.chr10
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE p_qty   LIKE type_file.num10

    LET l_error = ' '
    CASE i
       WHEN "1"
          LET p_qty = g_imx[p_ac].imx01
          CALL s_chk_purc_strategy(p_ac,1,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "2"
          LET p_qty = g_imx[p_ac].imx02
          CALL s_chk_purc_strategy(p_ac,2,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "3"
          LET p_qty = g_imx[p_ac].imx03
          CALL s_chk_purc_strategy(p_ac,3,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "4"
          LET p_qty = g_imx[p_ac].imx04
          CALL s_chk_purc_strategy(p_ac,4,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "5"
          LET p_qty = g_imx[p_ac].imx05
          CALL s_chk_purc_strategy(p_ac,5,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "6"
          LET p_qty = g_imx[p_ac].imx06
          CALL s_chk_purc_strategy(p_ac,6,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "7"
          LET p_qty = g_imx[p_ac].imx07
          CALL s_chk_purc_strategy(p_ac,7,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "8"
          LET p_qty = g_imx[p_ac].imx08
          CALL s_chk_purc_strategy(p_ac,8,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "9"
          LET p_qty = g_imx[p_ac].imx09
          CALL s_chk_purc_strategy(p_ac,9,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "10"
          LET p_qty = g_imx[p_ac].imx10
          CALL s_chk_purc_strategy(p_ac,10,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "11"
          LET p_qty = g_imx[p_ac].imx11
          CALL s_chk_purc_strategy(p_ac,11,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "12"
          LET p_qty = g_imx[p_ac].imx12
          CALL s_chk_purc_strategy(p_ac,12,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "13"
          LET p_qty = g_imx[p_ac].imx13
          CALL s_chk_purc_strategy(p_ac,13,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "14"
          LET p_qty = g_imx[p_ac].imx14
          CALL s_chk_purc_strategy(p_ac,14,p_item,p_qty) RETURNING  l_error,l_ima01
       WHEN "15"
          LET p_qty = g_imx[p_ac].imx15
          CALL s_chk_purc_strategy(p_ac,15,p_item,p_qty) RETURNING  l_error,l_ima01
    END CASE
    RETURN l_error,l_ima01
END FUNCTION

#判斷是否存在商品策略
#傳入值 p_item : 料號
FUNCTION s_chk_prod_strategy(p_ac,p_index,p_item,p_qty)
DEFINE p_item  LIKE ima_file.ima01
DEFINE l_rtz04 LIKE rtz_file.rtz04
DEFINE p_ac    LIKE type_file.num5
DEFINE p_index LIKE type_file.num5
DEFINE p_qty   LIKE type_file.num10
DEFINE l_n     LIKE type_file.num5
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE l_sql   STRING
DEFINE l_error LIKE type_file.chr10
    
    LET l_error = ' '
    IF (NOT cl_null(p_qty)) AND p_qty > 0 THEN 
       LET l_sql = " SELECT rtz04 FROM ",cl_get_target_table(g_plant,'rtz_file'),
                   " , ",cl_get_target_table(g_plant,'azw_file'),
                   " WHERE rtz01 = '",g_plant,"'",
                   "   AND rtz01 = azw01 AND azwacti = 'Y' "
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql
       CALL cl_parse_qry_sql(l_sql,g_plant) RETURNING l_sql
       PREPARE sel_rtz_pre1 FROM l_sql
       EXECUTE sel_rtz_pre1 INTO l_rtz04

       SELECT imx000 INTO l_ima01 FROM imx_file WHERE imx00 = p_item
                                     AND imx01 = g_imx[p_ac].color
                                     AND imx02 = g_imxtext[p_ac].detail[p_index].size 
       IF NOT cl_null(l_rtz04) THEN
          LET l_sql = " SELECT COUNT(*) ",
                      " FROM ",cl_get_target_table(g_plant,'rte_file'),
                      " WHERE rte01 = '",l_rtz04,"'",
                      "   AND rte03 = '",l_ima01,"' ",
                      "   AND rte07 = 'Y'"
          CALL cl_replace_sqldb(l_sql) RETURNING l_sql
          CALL cl_parse_qry_sql(l_sql,g_plant) RETURNING l_sql
          PREPARE sel_rte_pre1 FROM l_sql
          EXECUTE sel_rte_pre1 INTO l_n

          IF l_n = 0  THEN
             LET l_error = 'art-700'        #此料號不存在產品策略中，請檢查 arti120 設定!
          END IF
       END IF
    END IF
    RETURN l_error,l_ima01
END FUNCTION

#判斷是否存在採購策略
#傳入值 p_item : 料號
FUNCTION  s_chk_purc_strategy(p_ac,p_index,p_item,p_qty)   
DEFINE p_item  LIKE ima_file.ima01
DEFINE l_n     LIKE type_file.num5
DEFINE p_ac    LIKE type_file.num5
DEFINE p_index LIKE type_file.num5
DEFINE p_qty   LIKE type_file.num10
DEFINE l_ima01 LIKE ima_file.ima01
DEFINE l_sql   STRING
DEFINE l_error LIKE type_file.chr10
  
   LET l_error = ' '
   IF (NOT cl_null(p_qty)) AND p_qty > 0 THEN
      SELECT imx000 INTO l_ima01 FROM imx_file WHERE imx00 = p_item
                                                 AND imx01 = g_imx[p_ac].color
                                                 AND imx02 = g_imxtext[p_ac].detail[p_index].size
      LET l_sql = " SELECT COUNT(*) FROM ",cl_get_target_table(g_plant,'rty_file'),
                  " WHERE rty01 = '",g_plant,"'",
                  "   AND rty02 ='",l_ima01,"'",
                  "   AND rtyacti = 'Y'"
      CALL cl_replace_sqldb(l_sql) RETURNING l_sql
      CALL cl_parse_qry_sql(l_sql,g_plant) RETURNING l_sql
      PREPARE sel_num_pre1 FROM l_sql
      EXECUTE sel_num_pre1 INTO l_n
      IF l_n = 0 THEN
         LET l_error = 'art-229'    #料件編號必須存在於當前營運中心採購策略中且必須有效！
      END IF
   END IF
   RETURN l_error,l_ima01
END FUNCTION
#TQC-C20348--add--end--
#FUN-B90104
