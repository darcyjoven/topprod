# Prog. Version..: '5.30.06-13.03.12(00002)'     #
# Program name...: aici500_sub.4gl                                             
# Description....: 提供aici500.4gl使用的sub routine                            
# Date & Author..: NO:FUN-CA0022 12/10/16 By bart
# Modify.........: No.CHI-C90006 12/11/13 By bart 失效判斷
# Modify.........: No.FUN-CC0077 12/12/11 By Nicola 拉出來另單過單

DATABASE ds                                                                     
                                                                                
GLOBALS "../../config/top.global"                                                                                                  
GLOBALS "../4gl/aici500.global"

#-----------------------------------------------------------------------------#
#--------------------------產生工單/採購/發料單-------------------------------#
#-----------------------------------------------------------------------------#
define    l_cnt            LIKE type_file.num5,
    l_sql  STRING 
FUNCTION i500sub_process()
    DEFINE l_i  LIKE type_file.num5
    DEFINE l_dg LIKE type_file.num5
    DEFINE l_ecdicd01   LIKE ecd_file.ecdicd01
    DEFINE l_sql        STRING 
    WHENEVER ERROR CONTINUE

    FOR l_ac = 1 TO 50
        #只取有打勾勾的資料
        IF g_data[l_ac].sel = 'N' OR cl_null(g_data[l_ac].sel) THEN CONTINUE FOR END IF

        CALL g_process_msg[l_ac].sfb01.clear()
        CALL g_process_msg[l_ac].pmm01.clear()
        CALL g_process_msg[l_ac].sfp01.clear()
        LET g_process_msg[l_ac].rvv_msg = NULL

        LET g_process_msg[l_ac].rvv01 = g_data[l_ac].rvv01
        LET g_process_msg[l_ac].rvv02 = g_data[l_ac].rvv02
        
        #idc資料挑選不齊全的資料跳過
        IF NOT i500sub_chk_idc(g_data[l_ac].rvv02) THEN CONTINUE FOR END IF
        
        #處理委外工單資料 / 委外採購單資料 / 發料單資料--------------------#
        CALL i500sub_ecdicd01(g_data[l_ac].sfbiicd09) RETURNING l_ecdicd01
        
        LET l_dg = 0
        IF g_data[l_ac].imaicd04 = '2' THEN
        LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                    " WHERE item1 = ",g_data[l_ac].rvv02,
                    "   AND sel2 = 'Y' ",
                    "   AND icf05 = '1' ",
                    "   AND ima01 IS NOT NULL "
        PREPARE r406_bin_temp10 FROM l_sql
        DECLARE bin_count_cs10 CURSOR FOR r406_bin_temp10
        OPEN bin_count_cs10
        FETCH bin_count_cs10 INTO l_dg
        END IF
        
        CALL g_fac.clear()
        LET g_rec_b3 = 0
        LET g_fac_tot= 0
        LET l_ac3 = 0
        CALL g_process.clear()
        CASE
           WHEN l_ecdicd01 MATCHES '[34]' AND             #Multi Die
                g_data[l_ac].sfbiicd10 = 'Y'
                DELETE FROM icout_temp
                CALL i500sub_process1()
           WHEN g_data[l_ac].imaicd04 = '2' AND l_dg > 0  #down grade
                CALL i500sub_process2()
           OTHERWISE                                       #一般
                CALL i500sub_process3()
        END CASE
        UPDATE idv_file SET idv11=g_sfb.sfb01 
            WHERE idv01=g_idu.idu01 AND idv02=g_data[l_ac].rvv02
     END FOR
END FUNCTION

# Multi-Die委外工單
FUNCTION i500sub_process1()
   DEFINE l_oeb04     LIKE oeb_file.oeb04,
          l_imaicd08 LIKE imaicd_file.imaicd08,
          l_pcs       LIKE sfb_file.sfb08,
          l_dies      LIKE sfb_file.sfb08,
          l_i         LIKE type_file.num10
   DEFINE l_pmn01     LIKE pmn_file.pmn01
   DEFINE l_pmn02     LIKE pmn_file.pmn02
   DEFINE l_oeb01     LIKE oeb_file.oeb01
   DEFINE l_oeb03     LIKE oeb_file.oeb03
   DEFINE l_sfp   RECORD LIKE sfp_file.* 
   DEFINE l_o_prog STRING
   DEFINE l_sql    STRING 

   #串採購單生產資訊ico_file
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM ico_file
    WHERE ico02 = 0 AND ico01 IN
          (SELECT rvv36 FROM rvv_file
            WHERE rvv01 = g_data[l_ac].rvv01 
              AND rvv02 = g_data[l_ac].rvv02)
      AND ico03 = '8'

   IF g_cnt > 0 THEN
      #如果查到,檢查料號(ico07)及比率(ico04)是否有資料存在,如果不存在
      #出現錯誤訊息, 請user至採購單補比率(ico04)及料號(ico07)
      DECLARE ico_cs CURSOR FOR
       SELECT ico07,ico04 FROM ico_file
        WHERE ico02 = 0 AND ico01 IN
              (SELECT rvv36 FROM rvv_file
                WHERE rvv01 = g_data[l_ac].rvv01
                  AND rvv02 = g_data[l_ac].rvv02)
          AND ico07 IS NOT NULL
          AND ico04 IS NOT NULL AND ico04 > 0
          AND ico03 = '8'
      LET l_ac3 = 1
      FOREACH ico_cs INTO g_fac[l_ac3].*
          LET g_fac_tot = g_fac_tot + g_fac[l_ac3].fac
          LET l_ac3 = l_ac3 + 1
      END FOREACH
      CALL g_fac.deleteElement(l_ac3)
      LET g_rec_b3 = l_ac3 - 1

      IF g_rec_b3 = 0 THEN
         #沒維護比率
         CALL cl_getmsg('aic-125',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
         LET g_process_msg[l_ac].success = 'N'  
         RETURN
      END IF
   ELSE 
      CALL s_get_so(l_pmn01,l_pmn02) RETURNING l_oeb01,l_oeb03
      SELECT oeb04 INTO l_oeb04 FROM oeb_file
       WHERE oeb01=l_oeb01
         AND oeb03=l_oeb03
      IF cl_null(l_oeb04) THEN
         #無法串new code
         CALL cl_getmsg('aic-126',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
         LET g_process_msg[l_ac].success = 'N'  
         RETURN
      END IF

      DECLARE icw_cs CURSOR FOR
       SELECT icw03,icw19 FROM icw_file,icx_file
        WHERE icw01 = icx01 AND icw05 = l_oeb04 AND icw10 = 'Y'
          AND icw03 IS NOT NULL AND icw19 IS NOT NULL AND icw19 > 0
      LET l_ac3 = 1
      FOREACH ico_cs INTO g_fac[l_ac3].*
          LET g_fac_tot = g_fac_tot + g_fac[l_ac3].fac
          LET l_ac3 = l_ac3 + 1
      END FOREACH
      CALL g_fac.deleteElement(l_ac3)
      LET g_rec_b3 = l_ac3 - 1

      IF g_rec_b3 = 0 THEN
         #無法串new code
         CALL cl_getmsg('aic-126',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
         LET g_process_msg[l_ac].success = 'N'  
         RETURN
      END IF
   END IF
   SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
    WHERE imaicd00 = g_data[l_ac].rvv31

   LET l_sql = "SELECT SUM(qty1),SUM(qty2) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE item1 = ",g_data[l_ac].rvv02,
               "   AND sel2 = 'Y' "
   PREPARE r406_bin_temp11 FROM l_sql
   DECLARE bin_sum_cs11 CURSOR FOR r406_bin_temp11
   OPEN bin_sum_cs11
   FETCH bin_sum_cs11 INTO l_pcs,l_dies

   #先預設最後一筆
   LET g_process[g_rec_b3].* = g_data[l_ac].*
   LET g_process[g_rec_b3].sfb05 = g_fac[g_rec_b3].ima01
   LET g_process[g_rec_b3].sfb08 = l_dies

   FOR l_ac3 = 1 TO g_rec_b3 - 1
       LET g_process[l_ac3].* = g_data[l_ac].*
       LET g_process[l_ac3].sfb05 = g_fac[l_ac3].ima01
       LET g_process[l_ac3].sfb08 = l_dies * g_fac[l_ac3].fac / g_fac_tot
       LET l_i = g_process[l_ac3].sfb08 / 1
       IF g_process[l_ac3].sfb08  - l_i > 0 THEN  #強迫取整數位
          LET g_process[l_ac3].sfb08 = l_i + 1
       END IF

       #扣最後一筆(使最後差額全到最後一筆)
       LET g_process[g_rec_b3].sfb08 = g_process[g_rec_b3].sfb08 -
                                       g_process[l_ac3].sfb08
   END FOR

   LET g_success = 'Y'
   DELETE FROM icout_temp    
   FOR l_ac3 = 1 TO g_rec_b3
       CALL i500sub_icout_temp_gen()
       IF g_success = 'N' THEN RETURN END IF
   END FOR

   #產生委外工單資料
   BEGIN WORK
   FOR l_ac3 = 1 TO g_rec_b3
       CALL i500sub_ins_sfb()       # 1.產生委外工單單頭(sfb_file)
       IF g_success = 'N' THEN EXIT FOR END IF

       CALL i500sub_ins_sfa()       # 2.產生委外工單單身(sfa_file)
       IF g_success = 'N' THEN EXIT FOR END IF
       LET g_process_msg[l_ac].sfb01[l_ac3] = g_sfb.sfb01
   END FOR
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      FOR l_ac3 = 1 TO g_process_msg[l_ac].sfb01.getLength()
          CALL g_process_msg[l_ac].sfb01.clear()
      END FOR
      ROLLBACK WORK
      RETURN
   END IF

   FOR l_ac3 = 1 TO g_rec_b3
       LET g_sfb.sfb01 = g_process_msg[l_ac].sfb01[l_ac3]
       CALL i500sub_sfb_confirm()   # 3.處理委外工單確認(含產生委外採購單資料)
       CALL i500sub_sfp_gen()       # 4.產生發料單

       IF NOT cl_null(g_process_msg[l_ac].sfp01[l_ac3]) THEN #有發料單才往下執行
          SELECT * INTO g_sfp.*,g_sfq.*,g_sfs.* FROM sfp_file,sfq_file,sfs_file
           WHERE sfp01 = g_process_msg[l_ac].sfp01[l_ac3]
             AND sfp01 = sfq01 AND sfq01 = sfs01
          IF SQLCA.sqlcode = 100 THEN CONTINUE FOR END IF

          LET g_success = 'Y'
          BEGIN WORK
          CALL i500sub_icaout('1')  # 5.處理icaout
          IF g_success = 'Y' THEN
             COMMIT WORK
          ELSE
             ROLLBACK WORK CONTINUE FOR
          END IF

         #檢查有發料單存在否,若存在則自動過帳
         IF NOT cl_null(g_process_msg[l_ac].sfp01[l_ac3]) THEN
            BEGIN WORK
            CALL i501sub_y_chk(g_process_msg[l_ac].sfp01[l_ac3],NULL)
            IF g_success = "Y" THEN
               CALL i501sub_y_upd(g_process_msg[l_ac].sfp01[l_ac3],NULL,TRUE)
                 RETURNING l_sfp.*
            END IF
            
            LET l_o_prog = g_prog
            CASE l_sfp.sfp06
               WHEN "1" LET g_prog='asfi511'
               WHEN "2" LET g_prog='asfi512'
               WHEN "3" LET g_prog='asfi513'
               WHEN "4" LET g_prog='asfi514'
               WHEN "6" LET g_prog='asfi526'
               WHEN "7" LET g_prog='asfi527'
               WHEN "8" LET g_prog='asfi528'
               WHEN "9" LET g_prog='asfi529'
            END CASE
            
            IF g_success = "Y" THEN
               CALL i501sub_s('1',l_sfp.sfp01,TRUE,'N')
            END IF
            LET g_prog = l_o_prog
            
            IF g_success='Y' THEN
               COMMIT WORK
            ELSE
               ROLLBACK WORK
            END IF
         END IF
       END IF
   END FOR
END FUNCTION

# DG委外工單
FUNCTION i500sub_process2()
   DEFINE l_pcs          LIKE sfb_file.sfb08,
          l_dies         LIKE sfb_file.sfb08,
          l_ima01        LIKE ima_file.ima01,
          l_ecdicd01     LIKE ecd_file.ecdicd01
   DEFINE l_sfbiicd08_b  LIKE sfbi_file.sfbiicd08
   DEFINE l_sfp   RECORD LIKE sfp_file.* 
   DEFINE l_o_prog STRING
   DEFINE l_sql    STRING

   CALL i500sub_ecdicd01(g_data[l_ac].sfbiicd09) RETURNING l_ecdicd01

   LET g_cnt = 0
   LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE item1 = ",g_data[l_ac].rvv02,
               "   AND sel2 = 'Y' ",
               "   AND icf05 <> '1' "
   PREPARE r406_bin_temp21 FROM l_sql
   DECLARE bin_count_cs21 CURSOR FOR r406_bin_temp21
   OPEN bin_count_cs21
   FETCH bin_count_cs21 INTO g_cnt
   IF g_cnt <> 0 THEN
      LET l_ac3 = 1
      LET g_process[l_ac3].* = g_data[l_ac].*
      IF l_ecdicd01 = '2' THEN
         LET l_sql = "SELECT SUM(qty1),SUM(qty2) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " WHERE item1 = ",g_data[l_ac].rvv02,
                     "   AND sel2 = 'Y' ",
                     "   AND icf05 <> '1' "
         PREPARE r406_bin_temp12 FROM l_sql
         DECLARE bin_sum_cs12 CURSOR FOR r406_bin_temp12
         OPEN bin_sum_cs12
         FETCH bin_sum_cs12 INTO g_process[l_ac3].sfb08,g_process[l_ac3].sfbiicd06
      ELSE
         LET l_sql = "SELECT SUM(qty1),SUM(qty2) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " WHERE item1 = ",g_data[l_ac].rvv02,
                     "   AND sel2 = 'Y' ",
                     "   AND icf05 <> '1' "
         PREPARE r406_bin_temp13 FROM l_sql
         DECLARE bin_sum_cs13 CURSOR FOR r406_bin_temp13
         OPEN bin_sum_cs13
         FETCH bin_sum_cs13 INTO g_process[l_ac3].sfb06,g_process[l_ac3].sfbiicd08
      END IF
   ELSE
      LET l_ac3 = 0
   END IF

   LET l_sql = "SELECT ima01,sfbiicd08_b,SUM(qty1),SUM(qty2) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE item1 = ",g_data[l_ac].rvv02,
               "   AND sel2 = 'Y' ",
               "   AND icf05 <> '1' ",
               "   AND ima01 IS NOT NULL",
               "  GROUP BY ima01,sfbiicd08_b"
   PREPARE r406_bin_temp23 FROM l_sql
   DECLARE dg_cs CURSOR FOR r406_bin_temp23
   
   LET l_ac3 = l_ac3 + 1
   FOREACH dg_cs INTO l_ima01,l_sfbiicd08_b,l_pcs,l_dies
      LET g_process[l_ac3].* = g_data[l_ac].*

      LET g_process[l_ac3].sfb05 = l_ima01
      LET g_process[l_ac3].sfbiicd08 = l_sfbiicd08_b
      IF l_ecdicd01 = '2' THEN
         LET g_process[l_ac3].sfb08 = l_pcs
         LET g_process[l_ac3].sfbiicd06 = l_dies
      ELSE
         LET g_process[l_ac3].sfb08 = l_dies
         LET g_process[l_ac3].sfbiicd06 = l_pcs
      END IF
      LET l_ac3 = l_ac3 + 1
   END FOREACH
   CALL g_process.deleteElement(l_ac3)
   LET g_rec_b3 = l_ac3 - 1
   IF g_rec_b3 = 0 THEN RETURN END IF

   #產生委外工單資料
   LET g_success = 'Y'
   BEGIN WORK
   FOR l_ac3 = 1 TO g_rec_b3
       CALL i500sub_ins_sfb()       # 1.產生委外工單單頭(sfb_file)
       IF g_success = 'N' THEN EXIT FOR END IF
       CALL i500sub_ins_sfa()       # 2.產生委外工單單身(sfa_file)
       IF g_success = 'N' THEN EXIT FOR END IF
       LET g_process_msg[l_ac].sfb01[l_ac3] = g_sfb.sfb01
   END FOR
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      FOR l_ac3 = 1 TO g_process_msg[l_ac].sfb01.getLength()
          CALL g_process_msg[l_ac].sfb01.clear()
      END FOR
      ROLLBACK WORK
      RETURN
   END IF

   FOR l_ac3 = 1 TO g_rec_b3
       CALL i500sub_sfb_confirm()   # 3.處理委外工單確認(含產生委外採購單資料)
       CALL i500sub_sfp_gen()       # 4.產生發料單

       IF NOT cl_null(g_process_msg[l_ac].sfp01[l_ac3]) THEN #有發料單才往下執行
          SELECT * INTO g_sfp.*,g_sfq.*,g_sfs.* FROM sfp_file,sfq_file,sfs_file
           WHERE sfp01 = g_process_msg[l_ac].sfp01[l_ac3]
             AND sfp01 = sfq01
             AND sfq01 = sfs01
          IF SQLCA.sqlcode = 100 THEN CONTINUE FOR END IF

          LET g_success = 'Y'
          BEGIN WORK
          CALL i500sub_icaout('2')  # 5.處理icaout
          IF g_success = 'Y' THEN
             COMMIT WORK
          ELSE
             ROLLBACK WORK CONTINUE FOR
          END IF
         #檢查有發料單存在否,若存在則自動過帳
         IF NOT cl_null(g_process_msg[l_ac].sfp01[l_ac3]) THEN
            BEGIN WORK
            CALL i501sub_y_chk(g_process_msg[l_ac].sfp01[l_ac3],NULL)
            IF g_success = "Y" THEN
               CALL i501sub_y_upd(g_process_msg[l_ac].sfp01[l_ac3],NULL,TRUE)
                 RETURNING l_sfp.*
            END IF
            
            LET l_o_prog = g_prog
            CASE l_sfp.sfp06
               WHEN "1" LET g_prog='asfi511'
               WHEN "2" LET g_prog='asfi512'
               WHEN "3" LET g_prog='asfi513'
               WHEN "4" LET g_prog='asfi514'
               WHEN "6" LET g_prog='asfi526'
               WHEN "7" LET g_prog='asfi527'
               WHEN "8" LET g_prog='asfi528'
               WHEN "9" LET g_prog='asfi529'
            END CASE
            
            IF g_success = "Y" THEN
               CALL i501sub_s('1',l_sfp.sfp01,TRUE,'N')
            END IF
            LET g_prog = l_o_prog
            
            IF g_success='Y' THEN
               COMMIT WORK
            ELSE
               ROLLBACK WORK
            END IF
         END IF
       END IF
   END FOR
END FUNCTION

# 一般委外工單
FUNCTION i500sub_process3()
   DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01
   DEFINE l_sfp   RECORD LIKE sfp_file.* 
   DEFINE l_o_prog STRING
   DEFINE l_sql    STRING
   DEFINE l_sfb08  LIKE sfb_file.sfb08
   DEFINE l_tmp    LIKE sfb_file.sfb08

   LET g_rec_b3 = 1
   LET l_ac3 = 1
   LET g_process[l_ac3].* = g_data[l_ac].*
   CALL i500sub_ecdicd01(g_process[l_ac3].sfbiicd09) RETURNING l_ecdicd01
   
   #重新計算生產參考數量sfbiicd06
   CASE WHEN l_ecdicd01 = '2'
             LET l_sql = "SELECT SUM(qty2) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                         " WHERE item1 = ",g_data[l_ac].rvv02,
                         "   AND sel2 = 'Y' "
             PREPARE r406_bin_temp14 FROM l_sql
             DECLARE bin_sum_cs14 CURSOR FOR r406_bin_temp14
             LET l_tmp = 0 
             OPEN bin_sum_cs14
             FETCH bin_sum_cs14 INTO l_tmp
             IF l_tmp > 0 THEN 
                LET g_process[l_ac3].sfbiicd06 = l_tmp
             END IF
        WHEN l_ecdicd01 = '3' OR l_ecdicd01 = '4'  #AS
             LET l_sql = "SELECT SUM(qty1) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                         " WHERE item1 = ",g_data[l_ac].rvv02,
                         "   AND sel2 = 'Y' "
             PREPARE r406_bin_temp15 FROM l_sql
             DECLARE bin_sum_cs15 CURSOR FOR r406_bin_temp15
             OPEN bin_sum_cs15
             FETCH bin_sum_cs15 INTO g_process[l_ac3].sfbiicd06
        OTHERWISE
   END CASE


   LET g_success = 'Y'
   BEGIN WORK
   CALL i500sub_ins_sfb()       # 1.產生委外工單單頭(sfb_file)
   IF g_success = 'N' THEN ROLLBACK WORK RETURN END IF
   CALL i500sub_ins_sfa()       # 2.產生委外工單單身(sfa_file)
   IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK RETURN END IF
   LET g_process_msg[l_ac].sfb01[l_ac3] = g_sfb.sfb01

   CALL i500sub_sfb_confirm()   # 3.處理委外工單確認(含產生委外採購單資料)
   CALL i500sub_sfp_gen()       # 4.產生發料單

   IF NOT cl_null(g_process_msg[l_ac].sfp01[l_ac3]) THEN #有發料單才往下執行
      SELECT * INTO g_sfp.*,g_sfq.*,g_sfs.* FROM sfp_file,sfq_file,sfs_file
       WHERE sfp01 = g_process_msg[l_ac].sfp01[l_ac3]
         AND sfp01 = sfq01 AND sfq01 = sfs01
      IF NOT cl_null(SQLCA.sqlcode) THEN
         LET g_success = 'Y'
         BEGIN WORK
         CALL i500sub_icaout('3')  # 5.處理icaout
         IF g_success = 'Y' THEN COMMIT WORK ELSE ROLLBACK WORK RETURN END IF

         #檢查有發料單存在否,若存在則自動過帳
         IF NOT cl_null(g_process_msg[l_ac].sfp01[l_ac3]) THEN
            BEGIN WORK
            CALL i501sub_y_chk(g_process_msg[l_ac].sfp01[l_ac3],NULL)
            IF g_success = "Y" THEN
               CALL i501sub_y_upd(g_process_msg[l_ac].sfp01[l_ac3],NULL,TRUE)
                 RETURNING l_sfp.*
            END IF
            
            LET l_o_prog = g_prog
            CASE l_sfp.sfp06
               WHEN "1" LET g_prog='asfi511'
               WHEN "2" LET g_prog='asfi512'
               WHEN "3" LET g_prog='asfi513'
               WHEN "4" LET g_prog='asfi514'
               WHEN "6" LET g_prog='asfi526'
               WHEN "7" LET g_prog='asfi527'
               WHEN "8" LET g_prog='asfi528'
               WHEN "9" LET g_prog='asfi529'
            END CASE
            
            IF g_success = "Y" THEN
               CALL i501sub_s('1',l_sfp.sfp01,TRUE,'N')
            END IF
            LET g_prog = l_o_prog
            
            IF g_success='Y' THEN
               LET g_process_msg[l_ac].success = 'Y'
               COMMIT WORK
            ELSE
               ROLLBACK WORK
            END IF
         END IF   
      END IF
   END IF
END FUNCTION

FUNCTION  i500sub_chk_idc(p_ac)
   DEFINE p_ac   LIKE type_file.num5
   DEFINE l_flag LIKE type_file.num5
   DEFINE l_ecdicd01 LIKE ecd_file.ecdicd01
   DEFINE l_qty       LIKE idc_file.idc08
   DEFINE l_imaicd08 LIKE imaicd_file.imaicd08
   DEFINE l_sql      STRING   

   LET l_flag = 1

   CALL i500sub_ecdicd01(g_data[p_ac].sfbiicd09) RETURNING l_ecdicd01

   SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
    WHERE imaicd00 = g_data[p_ac].rvv31

   #入庫料號狀態為[0-2],且須做刻號管理才要維護BIN刻號資料
   IF cl_null(g_data[p_ac].imaicd04) OR
      g_data[p_ac].imaicd04 NOT MATCHES '[01234]' OR   #入庫料號狀態不為[0-2]
      cl_null(l_imaicd08) OR l_imaicd08 <> 'Y' THEN  #不須做刻號管理
      CALL i500sub_del_data(l_table,p_ac)       
      RETURN l_flag
   END IF

   #bin_temp有勾選的數量加總要等於生產應發數量
   CASE WHEN l_ecdicd01 MATCHES '[346]'
             LET l_sql = "SELECT SUM(qty2) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                         " WHERE item1 = ",p_ac,
                         "   AND sel2 = 'Y' "
             PREPARE r406_bin_temp17 FROM l_sql
             DECLARE bin_sum_cs17 CURSOR FOR r406_bin_temp17
             OPEN bin_sum_cs17
             FETCH bin_sum_cs17 INTO l_qty
        OTHERWISE
             LET l_sql = "SELECT SUM(qty1) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                         " WHERE item1 = ",p_ac,
                         "   AND sel2 = 'Y' "
             PREPARE r406_bin_temp18 FROM l_sql
             DECLARE bin_sum_cs18 CURSOR FOR r406_bin_temp18
             OPEN bin_sum_cs18
             FETCH bin_sum_cs18 INTO l_qty
   END CASE
   IF cl_null(l_qty) THEN LET l_qty = 0 END IF

   #刻號數量與生產發料數量不同
   IF l_qty <> g_data[p_ac].sfb08 AND l_qty <> g_data[p_ac].sfbiicd06 THEN
      CALL cl_getmsg('aic-142',g_lang) RETURNING g_process_msg[p_ac].rvv_msg
      LET g_process_msg[p_ac].success = 'N'  
      LET l_flag = 0 RETURN l_flag
   END IF

   #若料件狀態為2 且資料有任一筆為DG但未維護料號
   IF g_data[p_ac].imaicd04 = '2' THEN
      LET g_cnt = 0
      LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                  " WHERE item1 = ",p_ac,
                  "   AND sel2 = 'Y'",
                  "   AND icf05 = '1' ",
                  "   AND (ima01 IS NULL OR ima01 = ' ')"
   PREPARE r406_bin_temp19 FROM l_sql
   DECLARE bin_count_cs19 CURSOR FOR r406_bin_temp19
   OPEN bin_count_cs19
   FETCH bin_count_cs19 INTO g_cnt
      IF g_cnt > 0 THEN
         CALL cl_getmsg('aic-138',g_lang) RETURNING g_process_msg[p_ac].rvv_msg
         LET g_process_msg[p_ac].success = 'N'  
         LET l_flag = 0 RETURN l_flag
      END IF

      IF l_ecdicd01 MATCHES '[456]' THEN
         LET g_cnt = 0
         LET l_sql = "SELECT COUNT(*) FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     " WHERE item1 = ",p_ac,
                     "   AND sel2 = 'Y'",
                     "   AND icf05 = '1' ",
                     "   AND (sfbiicd08_b IS NULL OR sfbiicd08_b = ' ')"
         PREPARE r406_bin_temp20 FROM l_sql
         DECLARE bin_count_cs20 CURSOR FOR r406_bin_temp20
         OPEN bin_count_cs20
         FETCH bin_count_cs20 INTO g_cnt
         IF g_cnt > 0 THEN
            #尚有資料為Down grade,須維護產品型號但尚未維護!
            CALL cl_getmsg('aic-138',g_lang)
            RETURNING g_process_msg[p_ac].rvv_msg
            LET g_process_msg[p_ac].success = 'N' 
            LET l_flag = 0 RETURN l_flag
         END IF
       END IF
   END IF

   RETURN l_flag
END FUNCTION


#multi特別處理
FUNCTION i500sub_icout_temp_gen()
    DEFINE l_cnt LIKE type_file.num5
    DEFINE l_qty           LIKE sfa_file.sfa05,
           l_qty1          LIKE sfa_file.sfa05,
           l_qty2          LIKE sfa_file.sfa05,
           l_bin_temp_qty1 LIKE sfa_file.sfa05,
           l_bin_temp_qty2 LIKE sfa_file.sfa05
    DEFINE l_sql           STRING    

    LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
               " WHERE item1 = ",g_data[l_ac].rvv02,
               "   AND sel2 = 'Y' ",
               "   AND qty1 >0 AND qty2 > 0 ",
               " ORDER BY item2 "
   PREPARE r406_bin_temp16 FROM l_sql
   DECLARE icout_temp_cs CURSOR FOR r406_bin_temp16

    CALL g_idc.clear()
    LET l_cnt = 1
    LET g_rec_b2 = 0
    FOREACH icout_temp_cs INTO l_ac,g_idc[l_cnt].*
      LET l_cnt = l_cnt + 1
    END FOREACH
    CALL g_idc.deleteElement(l_cnt)
    LET g_rec_b2 = l_cnt - 1
    IF g_rec_b2 = 0 THEN LET g_success = 'N' RETURN END IF

    LET l_qty1 = 0  LET l_qty2 = 0

    LET l_qty = g_process[l_ac3].sfb08
    FOR l_ac2 = 1 TO g_rec_b2
        #multi特別處理
        IF l_qty <= 0 THEN EXIT FOR END IF
        IF g_idc[l_ac2].qty2 = 0 THEN CONTINUE FOR END IF

        IF g_idc[l_ac2].qty2 <= l_qty THEN
           LET l_bin_temp_qty1 = g_idc[l_ac2].qty1
           LET l_bin_temp_qty2 = g_idc[l_ac2].qty2

           LET l_qty  = l_qty - l_bin_temp_qty2
           LET l_qty1 = l_qty1 + l_bin_temp_qty1        #PCS
           LET l_qty2 = l_qty2 + l_bin_temp_qty2        #die
        ELSE
           LET l_bin_temp_qty2 = l_qty
           LET l_bin_temp_qty1 = (l_bin_temp_qty2 * g_idc[l_ac2].qty1)/
                                  g_idc[l_ac2].qty2
           LET l_qty = 0
           LET l_qty1 = l_qty1 + l_bin_temp_qty1        #PCS
           LET l_qty2 = l_qty2 + l_bin_temp_qty2        #die
        END IF

        LET l_sql = "UPDATE ",g_cr_db_str CLIPPED,l_table CLIPPED,
                     "   SET qty1 = qty1- ",l_bin_temp_qty1,",",
                     "       qty2 = qty2 - ",l_bin_temp_qty2, 
                     " WHERE item1 = ",l_ac,
                     "   AND item2 = '",g_idc[l_ac2].item,"' "
         PREPARE p406_upd_3 FROM l_sql
         EXECUTE p406_upd_3

        IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
           LET g_success = 'N' RETURN
        END IF

        INSERT INTO icout_temp                                                                                                      
             VALUES(l_ac3,g_idc[l_ac2].idc05,g_idc[l_ac2].idc06,                                                                    
                    '','',l_bin_temp_qty1,l_bin_temp_qty2)                                                                          
        IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF
    END FOR
     SELECT SUM(qty1) INTO g_process[l_ac3].sfbiicd06 FROM icout_temp
      WHERE item1 = l_ac3
END FUNCTION

#處理icaout
FUNCTION i500sub_icaout(p_type)
    DEFINE p_type      LIKE type_file.chr1      #1.multi die    2.down grade   3.一般
    DEFINE l_sql       STRING
    DEFINE l_cnt       LIKE type_file.num10
    DEFINE l_imaicd08 LIKE imaicd_file.imaicd08,
           l_ima906    LIKE ima_file.ima906
    DEFINE l_idc    RECORD LIKE idc_file.*
    DEFINE l_idb  RECORD LIKE idb_file.*
    DEFINE l_qty           LIKE sfa_file.sfa05,
           l_qty1          LIKE sfa_file.sfa05,
           l_qty2          LIKE sfa_file.sfa05,
           l_bin_temp_qty1 LIKE sfa_file.sfa05,
           l_bin_temp_qty2 LIKE sfa_file.sfa05
    DEFINE l_ac_1          LIKE type_file.num5

    SELECT imaicd08 INTO l_imaicd08 FROM imaicd_file
     WHERE imaicd00 = g_data[l_ac].rvv31

    #入庫料號狀態為[0-2],且須做刻號管理才要維護BIN刻號資料
    IF cl_null(g_data[l_ac].imaicd04) OR
       g_process[l_ac3].imaicd04 NOT MATCHES '[01234]' OR  #入庫料號狀態不為[0-2]
       cl_null(l_imaicd08) OR l_imaicd08 <> 'Y' THEN    #不須做刻號管理
       RETURN
    END IF

    CASE WHEN p_type = '1'  #1.multi die
              LET l_sql = "SELECT ",l_ac,",'Y',item1,idc05,idc06, ",
                          "       icf03,icf05,qty1,qty2,'','' ",
                          "  FROM icout_temp ",  
                          " WHERE item1 = ",l_ac3
         WHEN p_type = '2'  #2.down grade
              IF g_process[l_ac3].sfb05 = g_data[l_ac].sfb05 THEN
                 LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED,
                             " WHERE item1 = ",l_ac,
                             "   AND icf05 <> '1' AND ima01 IS NULL",
                             "   AND sel2 = 'Y' AND qty1 > 0 AND qty2 > 0 "
              ELSE
                 LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED, 
                             " WHERE item1 = ",l_ac,
                             "   AND icf05 = '1' ",
                             "   AND ima01 ='",g_process[l_ac3].sfb05,"'",
                             "   AND sel2 = 'Y' AND qty1 > 0 AND qty2 > 0 "
              END IF
         WHEN p_type = '3'  #3.一般
              LET l_sql = "SELECT * FROM ",g_cr_db_str CLIPPED,l_table CLIPPED, 
                          " WHERE item1 = ",g_data[l_ac].rvv02,
                          "   AND sel2 = 'Y' AND (qty1 > 0 OR qty2 > 0) "
    END CASE
    DECLARE bin_temp_cs2 CURSOR FROM l_sql
    CALL g_idc.clear()
    LET l_cnt = 1
    LET g_rec_b2 = 0
    FOREACH bin_temp_cs2 INTO l_ac_1,g_idc[l_cnt].*
      LET l_cnt = l_cnt + 1
    END FOREACH
    CALL g_idc.deleteElement(l_cnt)
    LET g_rec_b2 = l_cnt - 1
    IF g_rec_b2 = 0 THEN LET g_success = 'N' RETURN END IF

    SELECT ima906 INTO l_ima906 FROM ima_file WHERE ima01 = g_sfs.sfs04
    LET l_qty1 = 0  LET l_qty2 = 0

    IF p_type = '1' THEN
       LET l_qty = g_sfb.sfb08
       FOR l_ac2 = 1 TO g_rec_b2
           #multi特別處理
            LET l_bin_temp_qty1 = g_idc[l_ac2].qty1
            LET l_bin_temp_qty2 = g_idc[l_ac2].qty2

            LET l_qty1 = l_qty1 + g_idc[l_ac2].qty1   #PCS
            LET l_qty2 = l_qty2 + g_idc[l_ac2].qty2   #die

           #1.產生idb
            SELECT * INTO l_idc.* FROM idc_file
             WHERE idc01 = g_sfs.sfs04 AND idc02 = g_sfs.sfs07
               AND idc03 = g_sfs.sfs08 AND idc04 = g_sfs.sfs09
               AND idc05 = g_idc[l_ac2].idc05
               AND idc06 = g_idc[l_ac2].idc06
            IF SQLCA.sqlcode = 100 THEN LET g_success = 'N' RETURN END IF

            LET l_idb.idb01 = g_sfs.sfs04          #料件編號
            LET l_idb.idb02 = g_sfs.sfs07          #倉庫
            LET l_idb.idb03 = g_sfs.sfs08          #儲位
            LET l_idb.idb04 = g_sfs.sfs09          #批號
            LET l_idb.idb05 = l_idc.idc05          #刻號
            LET l_idb.idb06 = l_idc.idc06          #BIN
            LET l_idb.idb07 = g_sfp.sfp01          #單據編號
            LET l_idb.idb08 = g_sfs.sfs02          #單據項次
            LET l_idb.idb09 = g_sfp.sfp03          #異動日期
            LET l_idb.idb10 = l_idc.idc08          #庫存數量
            LET l_idb.idb11 = l_bin_temp_qty1      #出貨數量
            LET l_idb.idb12 = l_idc.idc07          #單位
            LET l_idb.idb13 = l_idc.idc09          #母體料號
            LET l_idb.idb14 = l_idc.idc10          #母批
            LET l_idb.idb15 = l_idc.idc11          #DATECODE
            LET l_idb.idb16 = l_bin_temp_qty2      #出貨die數
            LET l_idb.idb17 = l_idc.idc13          #YIELD
            LET l_idb.idb18 = l_idc.idc14          #TEST #
            LET l_idb.idb19 = l_idc.idc15          #DEDUCT
            LET l_idb.idb20 = l_idc.idc16          #PASSBIN
            LET l_idb.idb21 = l_idc.idc19          #接單料號
            LET l_idb.idb25 = l_idc.idc20          #備註
            LET l_idb.idbplant = g_sfp.sfpplant    
            LET l_idb.idblegal = g_sfp.sfplegal    
            INSERT INTO idb_file VALUES(l_idb.*)
            IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF
           #2.押備置idc_file
            UPDATE idc_file SET idc21 = idc21 + l_bin_temp_qty1
             WHERE idc01 = g_sfs.sfs04 AND idc02 = g_sfs.sfs07
               AND idc03 = g_sfs.sfs08 AND idc04 = g_sfs.sfs09
               AND idc05 = g_idc[l_ac2].idc05
               AND idc06 = g_idc[l_ac2].idc06
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N' RETURN
            END IF
       END FOR

       #3.回寫參考單位sfs_file
       IF l_ima906 MATCHES '[13]' THEN
          #料號為wafer,imaicd04=0-1,用dice數量加總給原將單據的第二單位數量。
          #料號為wafer,imaicd04=2,同上,但用pass bin
          IF g_process[l_ac3].imaicd04 MATCHES '[0124]' THEN
             IF g_process[l_ac3].imaicd04 = '2' THEN
                LET g_sfs.sfs35 = l_qty1
             ELSE
                LET g_sfs.sfs35 = l_qty2
             END IF  
             LET g_sfs.sfs34 = g_sfs.sfs32/g_sfs.sfs35
          END IF
          UPDATE sfs_file SET sfs34 = g_sfs.sfs34,
                              sfs35 = g_sfs.sfs35
           WHERE sfs01 = g_sfs.sfs01
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <> 1 THEN
             LET g_success = 'N' RETURN
          END IF
       END IF
    ELSE
       FOR l_ac2 = 1 TO g_rec_b2
           #發料參考數量
            LET l_qty1 = l_qty1 + g_idc[l_ac2].qty1   #PCS
            LET l_qty2 = l_qty2 + g_idc[l_ac2].qty2   #die

           #1.產生idb
            SELECT * INTO l_idc.* FROM idc_file
             WHERE idc01 = g_sfs.sfs04 AND idc02 = g_sfs.sfs07
               AND idc03 = g_sfs.sfs08 AND idc04 = g_sfs.sfs09
               AND idc05 = g_idc[l_ac2].idc05
               AND idc06 = g_idc[l_ac2].idc06
            IF SQLCA.sqlcode = 100 THEN LET g_success = 'N' RETURN END IF

            LET l_idb.idb01 = g_sfs.sfs04          #料件編號
            LET l_idb.idb02 = g_sfs.sfs07          #倉庫
            LET l_idb.idb03 = g_sfs.sfs08          #儲位
            LET l_idb.idb04 = g_sfs.sfs09          #批號
            LET l_idb.idb05 = l_idc.idc05          #刻號
            LET l_idb.idb06 = l_idc.idc06          #BIN
            LET l_idb.idb07 = g_sfp.sfp01          #單據編號
            LET l_idb.idb08 = g_sfs.sfs02          #單據項次
            LET l_idb.idb09 = g_sfp.sfp03          #異動日期
            LET l_idb.idb10 = l_idc.idc08          #庫存數量
            LET l_idb.idb11 = g_idc[l_ac2].qty1    #出貨數量
            LET l_idb.idb12 = l_idc.idc07          #單位
            LET l_idb.idb13 = l_idc.idc09          #母體料號
            LET l_idb.idb14 = l_idc.idc10          #母批
            LET l_idb.idb15 = l_idc.idc11          #DATECODE
            LET l_idb.idb16 = g_idc[l_ac2].qty2    #出貨die數
            LET l_idb.idb17 = l_idc.idc13          #YIELD
            LET l_idb.idb18 = l_idc.idc14          #TEST #
            LET l_idb.idb19 = l_idc.idc15          #DEDUCT
            LET l_idb.idb20 = l_idc.idc16          #PASSBIN
            LET l_idb.idb21 = l_idc.idc19          #接單料號
            LET l_idb.idb25 = l_idc.idc20          #備註
            LET l_idb.idbplant = g_sfp.sfpplant    
            LET l_idb.idblegal = g_sfp.sfplegal    
            INSERT INTO idb_file VALUES(l_idb.*)
            IF SQLCA.sqlcode THEN LET g_success = 'N' RETURN END IF
           #2.押備置idc_file
            UPDATE idc_file SET idc21 = idc21+g_idc[l_ac2].qty1
             WHERE idc01 = g_sfs.sfs04 AND idc02 = g_sfs.sfs07
               AND idc03 = g_sfs.sfs08 AND idc04 = g_sfs.sfs09
               AND idc05 = g_idc[l_ac2].idc05
               AND idc06 = g_idc[l_ac2].idc06
            IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
               LET g_success = 'N' RETURN
            END IF
       END FOR

       #3.回寫參考單位sfs_file
       IF l_ima906 MATCHES '[13]' THEN
          #料號為wafer,imaicd04=0-1,用dice數量加總給原將單據的第二單位數量。
          #料號為wafer,imaicd04=2,同上,但用pass bin
          IF g_process[l_ac3].imaicd04 MATCHES '[0124]' THEN
             IF g_process[l_ac3].imaicd04 = '2' THEN
                LET g_sfs.sfs35 = l_qty2
             ELSE 
                LET g_sfs.sfs35 = l_qty2
             END IF
             LET g_sfs.sfs34 = g_sfs.sfs32/g_sfs.sfs35
          END IF
          UPDATE sfs_file SET sfs34 = g_sfs.sfs34,
                              sfs35 = g_sfs.sfs35
           WHERE sfs01 = g_sfs.sfs01
          IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] <> 1 THEN
             LET g_success = 'N' RETURN
          END IF
       END IF
    END IF

END FUNCTION

FUNCTION i500sub_ins_sfb()
    DEFINE li_result   LIKE type_file.num5,
           l_ecdicd01 LIKE ecd_file.ecdicd01
    DEFINE l_imaicd04 LIKE imaicd_file.imaicd04 

    CALL i500sub_ecdicd01(g_process[l_ac3].sfbiicd09) RETURNING l_ecdicd01

    INITIALIZE g_sfb.* TO NULL
    LET g_sfb.sfb01 = g_idu.idu18
    LET g_sfb.sfb02 = '7'
    LET g_sfb.sfb04  ='4'
    LET g_sfb.sfb05  =g_process[l_ac3].sfb05
    LET g_sfb.sfb06  =g_process[l_ac3].sfb06
    LET g_sfb.sfb071 =g_idu.idu19
    LET g_sfb.sfb081 =0
    LET g_sfb.sfb09  =0
    LET g_sfb.sfb10  =0
    LET g_sfb.sfb11  =0
    LET g_sfb.sfb111 =0
    LET g_sfb.sfb12  =0
    LET g_sfb.sfb121 =0
    LET g_sfb.sfb13  =g_idu.idu19
    LET g_sfb.sfb15  =g_idu.idu19
    LET g_sfb.sfb23  ='Y'
    LET g_sfb.sfb24  ='N'
    LET g_sfb.sfb28  ='1'
    LET g_sfb.sfb29  ='Y'
    LET g_sfb.sfb39  ='1'
    LET g_sfb.sfb41  ='N'
    LET g_sfb.sfb81  =g_idu.idu19
    LET g_sfb.sfb82  =g_idu.idu11
    LET g_sfb.sfb87  ='N' 
    LET g_sfb.sfb91  =g_idu.idu01 
    LET g_sfb.sfb92  =g_process[l_ac3].rvv02
    LET g_sfb.sfb98  =' '
    LET g_sfb.sfb99  ='N'
    LET g_sfb.sfb100 ='1'
    LET g_sfb.sfbacti='Y'
    LET g_sfb.sfbuser=g_user
    LET g_sfb.sfbgrup=g_grup
    LET g_sfb.sfbdate=g_idu.idu19
    LET g_sfb.sfb27  =g_process[l_ac3].sfb27
    LET g_sfb.sfb271 =g_process[l_ac3].sfb271
    LET g_sfb.sfb44 = g_user
    LET g_sfb.sfbplant = g_plant
    LET g_sfb.sfblegal = g_legal
    LET g_sfb.sfboriu  = g_user
    LET g_sfb.sfborig  = g_grup
    LET g_sfb.sfb104 = 'N'

    SELECT ima910 INTO g_sfb.sfb95 FROM ima_file
     WHERE ima01 = g_process[l_ac3].sfb05
    IF cl_null(g_sfb.sfb95) THEN LET g_sfb.sfb95 = ' ' END IF

    CALL s_auto_assign_no("asf",g_sfb.sfb01,g_sfb.sfb81,"1","sfb_file",
                          "sfb01","","","")
         RETURNING li_result,g_sfb.sfb01
    IF (NOT li_result) THEN #產生工單號失敗
        CALL cl_getmsg('asf-377',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
        LET g_process_msg[l_ac].success = 'N'  
        LET g_success = 'N' RETURN
    END IF
    SELECT SUBSTR(smy57,1,1),SUBSTR(smy57,2,2),SUBSTR(smy57,6,6)
      INTO g_sfb.sfb93, g_sfb.sfb94, g_sfb.sfb100
      FROM smy_file WHERE smyslip = g_idu.idu18
    LET g_sfb.sfb93  ='N'--->確定不走製
    #------------------------------------------------------------以下為客製
    LET g_sfb.sfb82 = g_process[l_ac3].sfb82           #部門廠商

    SELECT pmn01,pmn02,pmniicd01,pmniicd02
      INTO g_sfb.sfb86,g_sfbi.sfbiicd15,                #母工單號/項次
           g_sfb.sfb22,g_sfb.sfb221                    #訂單單號/項次
      FROM pmn_file,pmni_file                           
     WHERE (pmn01 || pmn02) IN
           (SELECT rvv36 || rvv37 FROM rvv_file
             WHERE rvv01 = g_process[l_ac3].rvv01
               AND rvv02 = g_process[l_ac3].rvv02)
               AND pmni01 = pmn01 AND pmni02 = pmn02    

    LET g_sfbi.sfbiicd01 = g_process[l_ac3].sfbiicd01   #下階廠商
    LET g_sfbi.sfbiicd02 = g_process[l_ac3].sfbiicd02   #wafer廠商
    LET g_sfbi.sfbiicd03 = g_process[l_ac3].sfbiicd03   #wafer site
    LET g_sfbi.sfbiicd04 = 0                            #預計生產數量
    LET g_sfbi.sfbiicd05 = 0                            #預計生產參考數量
    SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file WHERE imaicd00=g_sfb.sfb05
    LET g_sfb.sfb08 = g_process[l_ac3].sfb08           #生產數量
    LET g_sfbi.sfbiicd06 = g_process[l_ac3].sfbiicd06   #生產參考數量
    LET g_sfbi.sfbiicd08 = g_process[l_ac3].sfb05       #產品型號
    LET g_sfbi.sfbiicd09 = g_process[l_ac3].sfbiicd09   #作業編號
    LET g_sfbi.sfbiicd10 = g_process[l_ac3].sfbiicd10   #multi die

    IF l_ecdicd01 MATCHES '[46]' THEN
       SELECT icj06,icj04
         INTO g_sfbi.sfbiicd11,                         #打線圖
              g_sfbi.sfbiicd12                          #PKG
         FROM icj_file
        WHERE icj01 = g_process[l_ac3].sfbiicd14
          AND icj02 = g_process[l_ac3].sfbiicd08
          AND icj03 = g_process[l_ac3].sfb82
    END IF
    LET g_sfbi.sfbiicd13 = g_process[l_ac3].sfbiicd13   #回貨批號  
    LET g_sfbi.sfbiicd14 = g_process[l_ac3].sfbiicd14   #母體料號
    LET g_sfbi.sfbiicd16 = g_process[l_ac3].rvv01       #入庫單號
    LET g_sfbi.sfbiicd17 = g_process[l_ac3].rvv02       #入庫項次
       #批次工單時若為FT則帶ASS回貨時datecode到工單單頭
    IF l_ecdicd01 = 5 THEN
       SELECT rvviicd02 INTO g_sfbi.sfbiicd07
         FROM rvvi_file
        WHERE rvvi01 = g_sfbi.sfbiicd16
          AND rvvi02 = g_sfbi.sfbiicd17
    ELSE
       LET g_sfbi.sfbiicd07 = NULL                         #Date Code
    END IF
    IF l_ecdicd01 MATCHES '[46]' THEN
      SELECT icj05 INTO g_sfbi.sfbiicd18 FROM icj_file
       WHERE icj01 = g_sfbi.sfbiicd14
         AND icj02 = g_sfbi.sfbiicd08
         AND icj03 = g_sfb.sfb82
   END IF
    
    INSERT INTO sfb_file VALUES(g_sfb.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_getmsg(SQLCA.sqlcode,g_lang) RETURNING g_msg
       LET g_process_msg[l_ac].rvv_msg = 'ins sfb_file err:',g_msg
       LET g_process_msg[l_ac].success = 'N'  
       LET g_success = 'N'
       RETURN
    END IF
    
    LET g_sfbi.sfbi01=g_sfb.sfb01
    LET g_sfbi.sfbiplant = g_plant
    LET g_sfbi.sfbilegal = g_legal
    INSERT INTO sfbi_file VALUES(g_sfbi.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_getmsg(SQLCA.sqlcode,g_lang) RETURNING g_msg
       LET g_process_msg[l_ac].rvv_msg = 'ins sfbi_file err:',g_msg
       LET g_process_msg[l_ac].success = 'N'  
       LET g_success = 'N'
       RETURN
    END IF

    #若為6.TKY且有押上製程編號,則產生製程追蹤檔
    IF l_ecdicd01 = '6' AND NOT cl_null(g_sfb.sfb06) THEN
       CALL i500sub_ins_ecm()
    END IF
END FUNCTION

#產生製程追蹤檔
FUNCTION i500sub_ins_ecm()
  DEFINE l_ima55  LIKE ima_file.ima55,
         l_ima571 LIKE ima_file.ima571,
         l_ecu01  LIKE ecu_file.ecu01,
         l_ecb    RECORD LIKE ecb_file.*, #routing detail file
         l_ecm    RECORD LIKE ecm_file.*, #routing detail file
         l_sgc    RECORD LIKE sgc_file.*, #routing detail file
         l_sgd    RECORD LIKE sgd_file.*, #routing detail file
         l_woq    LIKE   sfb_file.sfb08   #工單未生產數量
  DEFINE l_bdate,l_day LIKE type_file.dat,
         l_flag        LIKE type_file.chr1

  #決定製程料號
  SELECT ima571 INTO l_ima571 FROM ima_file WHERE ima01=g_sfb.sfb05

  SELECT ecu01 FROM ecu_file WHERE ecu01=l_ima571 AND ecu02=g_sfb.sfb06
     AND ecuacti = 'Y'  #CHI-C90006
  IF SQLCA.sqlcode THEN
     SELECT ecu01 FROM ecu_file WHERE ecu01=g_sfb.sfb05 AND ecu02=g_sfb.sfb06
        AND ecuacti = 'Y'  #CHI-C90006
     IF SQLCA.sqlcode = 100 THEN
        CALL cl_getmsg('aec-014',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
        LET g_process_msg[l_ac].success = 'N' 
        LET g_success = 'N' RETURN
     ELSE
        LET l_ecu01=g_sfb.sfb05
     END IF
  ELSE
     LET l_ecu01=l_ima571
  END IF

  #取製程資料
  DECLARE c_put CURSOR FOR
   SELECT * FROM ecb_file
    WHERE ecb01=l_ecu01
      AND ecb02=g_sfb.sfb06
      AND ecbacti='Y'
    ORDER BY ecb03 #製程序號

  FOREACH c_put INTO l_ecb.*
    IF SQLCA.sqlcode THEN EXIT FOREACH END IF
    INITIALIZE l_ecm.* TO NULL
    LET l_ecm.ecm01      =  g_sfb.sfb01
    LET l_ecm.ecm02      =  g_sfb.sfb02
    LET l_ecm.ecm03_par  =  g_sfb.sfb05
    LET l_ecm.ecm03      =  l_ecb.ecb03
    LET l_ecm.ecm04      =  l_ecb.ecb06
    LET l_ecm.ecm05      =  l_ecb.ecb07
    LET l_ecm.ecm06      =  l_ecb.ecb08
    LET l_ecm.ecm07      =  0
    LET l_ecm.ecm08      =  0
    LET l_ecm.ecm09      =  0
    LET l_ecm.ecm10      =  0
    LET l_ecm.ecm11      =  l_ecb.ecb02          #製程編號
    LET l_ecm.ecm13      =  l_ecb.ecb18          #固定工時(秒)
    LET l_ecm.ecm14      =  l_ecb.ecb19*l_woq    #標準工時(秒)
    LET l_ecm.ecm15      =  l_ecb.ecb20          #固定機時(秒)
    LET l_ecm.ecm16      =  l_ecb.ecb21*l_woq    #標準機時(秒)
    LET l_ecm.ecm49      =  l_ecb.ecb38*l_woq    #製程人力
    LET l_ecm.ecm45      =  l_ecb.ecb17          #作業名稱
    LET l_ecm.ecm52      =  l_ecb.ecb39          #SUB 否
    LET l_ecm.ecm53      =  l_ecb.ecb40          #PQC 否
    LET l_ecm.ecm54      =  l_ecb.ecb41          #Check in 否
    LET l_ecm.ecm55      =  l_ecb.ecb42          #Check in Hold 否
    LET l_ecm.ecm56      =  l_ecb.ecb43          #Check Out Hold 否
    #------>
    LET l_ecm.ecm291     =  0
    LET l_ecm.ecm292     =  0
    LET l_ecm.ecm301     =  0
    LET l_ecm.ecm302     =  0
    LET l_ecm.ecm303     =  0
    LET l_ecm.ecm311     =  0
    LET l_ecm.ecm312     =  0
    LET l_ecm.ecm313     =  0
    LET l_ecm.ecm314     =  0
    LET l_ecm.ecm315     =  0           #bonus
    LET l_ecm.ecm316     =  0           #bonus
    LET l_ecm.ecm321     =  0
    LET l_ecm.ecm322     =  0
    #------>
    LET l_ecm.ecm57      = l_ecb.ecb44
    LET l_ecm.ecm58      = l_ecb.ecb45
    LET l_ecm.ecm59      = l_ecb.ecb46
    LET l_ecm.ecmacti    =  'Y'
    LET l_ecm.ecmuser    =  g_user
    LET l_ecm.ecmgrup    =  g_grup
    LET l_ecm.ecmmodu    =  ''
    LET l_ecm.ecmdate    =  g_idu.idu19
   #-------------------------------------
    LET l_ecm.ecm51 = g_sfb.sfb15
    LET l_day = ((l_ecm.ecm14 + l_ecm.ecm13) / 86400 +0.99 ) * -1
    CALL s_wknxt(l_ecm.ecm51,l_day) RETURNING l_flag,l_bdate
    CALL s_wknxt(l_bdate,1) RETURNING l_flag,l_ecm.ecm50
   #-------------------------------------
    LET l_ecm.ecmplant = g_sfb.sfbplant
    LET l_ecm.ecmlegal = g_sfb.sfblegal
    LET l_ecm.ecm012 = ' '
    LET l_ecm.ecm66  = ' '
    INSERT INTO ecm_file VALUES(l_ecm.*)
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_getmsg(SQLCA.sqlcode,g_lang) RETURNING g_msg
       LET g_process_msg[l_ac].rvv_msg = 'ins ecm_file err:',g_msg
       LET g_process_msg[l_ac].success = 'N'  
       LET g_success = 'N' RETURN
    END IF
  END FOREACH
  LET g_cnt = 0
  SELECT COUNT(*) INTO g_cnt FROM ecm_file WHERE ecm01 = g_sfb.sfb01
  IF g_cnt = 0 THEN
     CALL cl_err('','asf-386',1)
     CALL cl_getmsg('asf-386',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
     LET g_process_msg[l_ac].success = 'N'  
     LET g_success = 'N' RETURN
  END IF
END FUNCTION

# 產生委外工單單身(sfa_file)
FUNCTION i500sub_ins_sfa()
    DEFINE l_minopseq  LIKE type_file.num5,
           l_ecdicd01 LIKE ecd_file.ecdicd01,
           l_imaicd04 LIKE imaicd_file.imaicd04
    DEFINE l_sfa      RECORD LIKE sfa_file.*
    DEFINE l_sfai     RECORD LIKE sfai_file.*

    CALL s_minopseq(g_sfb.sfb05,g_sfb.sfb06,g_sfb.sfb071) RETURNING l_minopseq

    CALL s_cralc(g_sfb.sfb01,g_sfb.sfb02,g_sfb.sfb05,g_sma.sma29,
                 g_sfb.sfb08,g_sfb.sfb071,'Y',g_sma.sma71,l_minopseq,'',
                 g_sfb.sfb95)
         RETURNING g_cnt
   
    #產生出來的備料只能有一筆
    IF g_cnt <> 1 THEN
       CALL cl_getmsg('aic-136',g_lang) RETURNING g_process_msg[l_ac].rvv_msg
       LET g_process_msg[l_ac].success = 'N'  
       LET g_success = 'N' RETURN
    END IF

    #產生出來的備料要等於入庫料號
    UPDATE sfa_file SET sfa03=g_process[l_ac3].rvv31,sfa27=g_process[l_ac3].rvv31
         WHERE sfa01=g_sfb.sfb01

    UPDATE sfai_file SET sfai03=g_process[l_ac3].rvv31,sfai27=g_process[l_ac3].rvv31
         WHERE sfai01=g_sfb.sfb01

    CALL i500sub_ecdicd01(g_sfbi.sfbiicd09) RETURNING l_ecdicd01

    #---------------------------更新ICD欄位------------------------------#
    SELECT sfb_file.*,sfbi_file.*,sfa_file.*,sfai_file.*  
      INTO g_sfb.*,g_sfbi.*,g_sfa.*,g_sfai.* 
      FROM sfb_file,sfbi_file,sfa_file,sfai_file  
     WHERE sfa01 = g_sfb.sfb01 AND sfa01 = sfb01
       AND sfai01=sfa01 AND sfbi01=sfb01  
       AND sfai03=sfa03 AND sfai08=sfa08 AND sfa12 =sfai12 AND sfai27 = sfa27 
    SELECT ima25,ima907 INTO g_sfa.sfa12,g_sfai.sfaiicd02 FROM ima_file WHERE ima01 = g_sfa.sfa03
    LET g_sfai.sfai12 = g_sfa.sfa12 
  
    IF cl_null(g_sfai.sfaiicd02) THEN
       SELECT imaicd04 INTO l_imaicd04 FROM imaicd_file WHERE imaicd00=g_sfa.sfa03
       IF l_imaicd04 = '0' OR l_imaicd04='1' THEN
          LET g_sfai.sfaiicd02 = 'EA'
       END IF
    END IF
    LET g_sfa.sfa30      = g_data[l_ac].rvv32
    LET g_sfa.sfa31      = g_data[l_ac].rvv33
    LET g_sfai.sfaiicd03 = g_data[l_ac].rvv34
    LET g_sfai.sfaiicd04 = 0
    LET g_sfai.sfaiicd05 = 0
    CALL i500sub_set_sfa_qty(l_ecdicd01) #更新應發數量/應發參考數量

    UPDATE sfa_file SET * = g_sfa.* WHERE sfa01 = g_sfa.sfa01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_getmsg(SQLCA.sqlcode,g_lang) RETURNING g_msg
       LET g_process_msg[l_ac].rvv_msg = 'upd sfa_file err:',g_msg
       LET g_process_msg[l_ac].success = 'N'  
       LET g_success = 'N' RETURN
    END IF
    IF l_ecdicd01 MATCHES '[34]' THEN
       LET g_sfbi.sfbiicd05 = g_sfa.sfa05
       UPDATE sfbi_file SET * = g_sfbi.* WHERE sfbi01 = g_sfb.sfb01
       IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
          CALL cl_getmsg(SQLCA.sqlcode,g_lang) RETURNING g_msg
          LET g_process_msg[l_ac].rvv_msg = 'upd sfbi_file err:',g_msg  
          LET g_process_msg[l_ac].success = 'N'  
          LET g_success = 'N' RETURN
       END IF
    END IF
    UPDATE sfai_file SET * = g_sfai.* WHERE sfai01 = g_sfb.sfb01
    IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
       CALL cl_getmsg(SQLCA.sqlcode,g_lang) RETURNING g_msg
       LET g_process_msg[l_ac].rvv_msg = 'upd sfai_file err:',g_msg  
       LET g_process_msg[l_ac].success = 'N'  
       LET g_success = 'N' RETURN
    END IF
END FUNCTION

#更新應發數量/應發參考數量
FUNCTION i500sub_set_sfa_qty(p_ecdicd01)
    DEFINE p_ecdicd01  LIKE ecd_file.ecdicd01,
           l_cnt       LIKE type_file.num5
    DEFINE l_sfb08     LIKE sfb_file.sfb08
    DEFINE l_ima25     LIKE ima_file.ima25
    DEFINE t_ima25     LIKE ima_file.ima25

    SELECT ima25 INTO l_ima25 FROM ima_file WHERE ima01=g_sfa.sfa03
    SELECT ima25 INTO t_ima25 FROM ima_file WHERE ima01=g_sfb.sfb05

    LET g_sfai.sfaiicd01 = g_process[l_ac3].rvv85
    LET g_sfa.sfa05 = g_process[l_ac3].rvv17    

END FUNCTION

#產生發料單
FUNCTION i500sub_sfp_gen()
    DEFINE l_sfp01 LIKE sfp_file.sfp01

    SELECT sfb_file.*,sfa_file.* INTO g_sfb.*,g_sfa.* FROM sfb_file,sfa_file
     WHERE sfb01 = sfa01 AND sfb01 = g_process_msg[l_ac].sfb01[l_ac3]

    IF g_sfb.sfb01 IS NULL THEN CALL cl_err('',-400,0) RETURN END IF
   #先做基本檢查
    IF g_sfb.sfb87 = 'N' THEN RETURN END IF #不可未確認
    IF g_sfb.sfb04 = '1' THEN RETURN END IF #不可未發放

    CALL i301sub_ind_icd_material_collect(g_sfb.sfb01,g_idu.idu22,g_sfp03,'')
         RETURNING l_sfp01
    IF NOT cl_null(l_sfp01) THEN
       LET g_cnt = 0
       SELECT COUNT(*) INTO g_cnt FROM sfp_file WHERE sfp01 = l_sfp01
       IF g_cnt > 0 THEN
          LET g_process_msg[l_ac].sfp01[l_ac3] = l_sfp01
       END IF
    END IF
END FUNCTION

#工單確認(含產生委外採購單)
FUNCTION i500sub_sfb_confirm()
    DEFINE l_flag LIKE type_file.chr1 
    DEFINE l_cnt       LIKE type_file.num5
    DEFINE l_pmm40     LIKE pmm_file.pmm40               
    DEFINE l_pmm40t    LIKE pmm_file.pmm40t           


    SELECT sfb_file.*,sfa_file.* INTO g_sfb.*,g_sfa.* FROM sfb_file,sfa_file
     WHERE sfb01 = sfa01 AND sfb01 = g_process_msg[l_ac].sfb01[l_ac3]

    #CALL i301sub_ind_icd_set_pmm(g_ta_pmm22,g_ta_pmm42,g_pmm22,g_pmm42)
    
    CALL i301sub_firm1_chk(g_sfb.sfb01,0)    #CALL原確認的check段 
    IF g_success = 'Y' THEN
       CALL i301sub_firm1_upd(g_sfb.sfb01,"",0)  #CALL原確認的update段
    END IF
    LET g_cnt = 0
    #重取工單資料
    SELECT sfb_file.*,sfa_file.* INTO g_sfb.*,g_sfa.* FROM sfb_file,sfa_file
     WHERE sfb01 = g_sfb.sfb01 AND sfb01 = sfa01

    #若工單確認失敗->作廢工單,刪除委外採購單
    IF g_sfb.sfb87 <> 'Y' THEN
       DELETE FROM pmm_file WHERE pmm01 = g_sfb.sfb01
       DELETE FROM pmn_file WHERE pmn01 = g_sfb.sfb01
       IF NOT s_industry('std') THEN
          LET l_flag = s_del_pmni(g_sfb.sfb01,'','')
       END IF
       UPDATE sfb_file SET sfb87 = 'X',
                           sfbmodu = g_user,
                           sfbdate = g_idu.idu19
        WHERE sfb01 = g_sfb.sfb01
    ELSE
       LET g_process_msg[l_ac].pmm01[l_ac3] = g_sfb.sfb91
       SELECT COUNT(*) INTO l_cnt FROM pmm_file
           WHERE pmm01 = g_sfb.sfb91
       IF l_cnt = 0 THEN
          UPDATE pmm_file SET pmm01=g_sfb.sfb91,pmm25='2' WHERE pmm01 = g_sfb.sfb01
          UPDATE pmn_file SET pmn01=g_sfb.sfb91,pmn02=g_sfb.sfb92,pmn16='2' WHERE pmn01 = g_sfb.sfb01
          UPDATE pmni_file SET pmni01=g_sfb.sfb91,pmni02=g_sfb.sfb92 WHERE pmni01 = g_sfb.sfb01
       ELSE
          DELETE FROM pmm_file WHERE pmm01 = g_sfb.sfb01
          UPDATE pmn_file SET pmn01=g_sfb.sfb91,pmn02=g_sfb.sfb92,pmn16='2' WHERE pmn01 = g_sfb.sfb01
         #因單號已變更，需重新計算未稅、含稅金額
          SELECT SUM(ta_pmn88),SUM(ta_pmn88t)
            INTO l_pmm40,l_pmm40t
            FROM pmn_file
           WHERE pmn01 = g_sfb.sfb91
          UPDATE pmm_file SET pmm40 = l_pmm40,pmm40t = l_pmm40t WHERE pmm01 = g_sfb.sfb91
        
          UPDATE pmni_file SET pmni01=g_sfb.sfb91,pmni02=g_sfb.sfb92 WHERE pmni01 = g_sfb.sfb01
       END IF  
    END IF
END FUNCTION

FUNCTION i500sub_create_icout_temp()         
   DROP TABLE icout_temp                                  
   CREATE TEMP TABLE icout_temp (                                                    
     item1          LIKE type_file.num5,                                                                                             
     idc05          LIKE idc_file.idc05,                                                                                             
     idc06          LIKE idc_file.idc06,                                                                                             
     icf03          LIKE icf_file.icf03,                                                                                             
     icf05          LIKE icf_file.icf05,                                                            
     qty1           LIKE idc_file.idc08,          
     qty2           LIKE idc_file.idc08);                                                        
   IF SQLCA.SQLCODE THEN                                                                                                            
     CALL cl_err('cretmp',SQLCA.SQLCODE,1)   
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      
     EXIT PROGRAM                                                           
   END IF                              
END FUNCTION

FUNCTION i500sub_del_data(p_table,p_ac)
DEFINE p_table     STRING
DEFINE p_ac        LIKE type_file.num5
DEFINE l_sql       STRING
     LET l_sql = "DELETE FROM ",g_cr_db_str CLIPPED,p_table CLIPPED," WHERE item1 = ",p_ac
     PREPARE deldata_prep FROM l_sql
     EXECUTE deldata_prep
END FUNCTION

#庫存數量
FUNCTION i500sub_qty(p_sfbiicd09,p_imaicd04,p_rvv31,p_rvv32,p_rvv33,p_rvv34,p_sfbiicd10,p_sfbiicd14)
   DEFINE p_ac        LIKE type_file.num5
   DEFINE l_sql       STRING
   DEFINE l_pcs       LIKE idc_file.idc08 #庫存數量(pcs)
   DEFINE l_dies      LIKE idc_file.idc08 #庫存數量(dies)
   DEFINE l_icf01     LIKE icf_file.icf01 #bin item
   DEFINE l_ecdicd01  LIKE ecd_file.ecdicd01    #作業群組
   DEFINE p_sfbiicd09 LIKE sfbi_file.sfbiicd09
   DEFINE p_imaicd04  LIKE imaicd_file.imaicd04
   DEFINE p_rvv31     LIKE rvv_file.rvv31
   DEFINE p_rvv32     LIKE rvv_file.rvv32
   DEFINE p_rvv33     LIKE rvv_file.rvv33
   DEFINE p_rvv34     LIKE rvv_file.rvv34
   DEFINE p_sfbiicd10 LIKE sfbi_file.sfbiicd10
   DEFINE p_sfbiicd14 LIKE sfbi_file.sfbiicd14

   CALL i500sub_ecdicd01(p_sfbiicd09) RETURNING l_ecdicd01

   #取得庫存數量
   IF p_imaicd04 = '2' THEN
      CALL i500sub_icf01(p_rvv31,p_rvv32,p_rvv33,p_rvv34,p_sfbiicd14) RETURNING l_icf01 #--決定串icf_file的料號
      IF cl_null(l_icf01) THEN
        CALL cl_err('','aic-132',1)
        RETURN 0
      END IF
      LET l_sql =
          "SELECT SUM(idc08-idc21), ",
          "       SUM(idc12 *((idc08-idc21)/idc08)) ",
          "  FROM idc_file,icf_file ",
          " WHERE idc01 = '",p_rvv31,"'",
          "   AND idc02 = '",p_rvv32,"'",
          "   AND idc03 = '",p_rvv33,"'",
          "   AND idc04 = '",p_rvv34,"'",
          "   AND (idc08 - idc21) > 0 ",
          "   AND idc16 IN ('Y','N') ",
          "   AND idc17 = 'N'",
          "   AND icf01 = '",l_icf01,"'",
          "   AND icf02 = idc06 "

      IF l_ecdicd01 MATCHES '[34]' AND p_sfbiicd10 = 'Y' THEN
         LET l_sql = l_sql CLIPPED, " AND icf05 <> '1' "
      END IF
   ELSE
      LET l_sql =
       "SELECT SUM(idc08-idc21), ",
          "    SUM(idc12 *((idc08-idc21)/idc08)) ",
          "  FROM idc_file ",
          " WHERE idc01 = '",p_rvv31,"'",
          "   AND idc02 = '",p_rvv32,"'",
          "   AND idc03 = '",p_rvv33,"'",
          "   AND idc04 = '",p_rvv34,"'",
          "   AND idc17 = 'N'",
          "   AND (idc08 - idc21) > 0 "
   END IF
   DECLARE qty_cs CURSOR FROM l_sql
   OPEN qty_cs
   FETCH qty_cs INTO l_pcs,l_dies

   IF l_ecdicd01 = '2' THEN
      RETURN l_pcs         #--回傳片數
   ELSE
      RETURN l_dies        #--回die數
   END IF
END FUNCTION

FUNCTION i500sub_icf01(p_rvv31,p_rvv32,p_rvv33,p_rvv34,p_sfbiicd14)
  DEFINE p_ac        LIKE type_file.num5
  DEFINE l_imaicd01  LIKE imaicd_file.imaicd01
  DEFINE l_cnt       LIKE type_file.num5
  DEFINE p_rvv31     LIKE rvv_file.rvv31
  DEFINE p_rvv32     LIKE rvv_file.rvv32
  DEFINE p_rvv33     LIKE rvv_file.rvv33
  DEFINE p_rvv34     LIKE rvv_file.rvv34
  DEFINE p_sfbiicd14 LIKE sfbi_file.sfbiicd14

  #1. 用入庫料號+idc06串bin檔
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM idc_file,icf_file
   WHERE idc01 = p_rvv31
     AND idc02 = p_rvv32
     AND idc03 = p_rvv33
     AND idc04 = p_rvv34
     AND (idc08 - idc21) > 0
     AND idc16 IN ('Y','N')
     AND icf01 = p_rvv31
     AND icf02 = idc06
  IF l_cnt > 0 THEN       #串的到回傳
     RETURN p_rvv31
  END IF                  #串不到

  #2. 串不到改用wafer料號+idc06串bin檔
  #取得wafer料號(imaicd01)
  SELECT imaicd01 INTO l_imaicd01 FROM imaicd_file
   WHERE imaicd00 = p_rvv31
  IF NOT cl_null(l_imaicd01) THEN
     #用wafer料號串
     LET l_cnt = 0
     SELECT COUNT(*) INTO l_cnt FROM idc_file,icf_file
      WHERE idc01 = p_rvv31
        AND idc02 = p_rvv32
        AND idc03 = p_rvv33
        AND idc04 = p_rvv34
        AND (idc08 - idc21) > 0
        AND idc16 IN ('Y','N')
        AND icf01 = l_imaicd01
        AND icf02 = idc06
     IF l_cnt > 0 THEN       #串的到回傳
        RETURN l_imaicd01
     END IF                  #串不到
  END IF

  #3. 再串不到改用母體料號+idc06串bin檔
  LET l_cnt = 0
  SELECT COUNT(*) INTO l_cnt FROM idc_file,icf_file
   WHERE idc01 = p_rvv31
     AND idc02 = p_rvv32
     AND idc03 = p_rvv33
     AND idc04 = p_rvv34
     AND (idc08 - idc21) > 0
     AND idc16 IN ('Y','N')
     AND icf01 = p_sfbiicd14
     AND icf02 = idc06
  IF l_cnt > 0 THEN
     RETURN p_sfbiicd14
  ELSE
     RETURN NULL
  END IF
END FUNCTION

FUNCTION i500sub_def_idc(p_sel2,p_imaicd04,p_icf05,p_ima01,p_rvv31,
                         p_sfb05,p_sfbiicd08_b,p_sfbiicd14,p_sfbiicd08)
   DEFINE p_ac,p_ac2     LIKE type_file.num5
   DEFINE p_sel2         LIKE type_file.chr1
   DEFINE p_imaicd04     LIKE imaicd_file.imaicd04
   DEFINE p_icf05        LIKE icf_file.icf05
   DEFINE p_ima01        LIKE ima_file.ima01
   DEFINE p_rvv31        LIKE rvv_file.rvv31
   DEFINE p_sfb05        LIKE sfb_file.sfb05
   DEFINE p_sfbiicd08_b  LIKE sfbi_file.sfbiicd08
   DEFINE p_sfbiicd14    LIKE sfbi_file.sfbiicd14
   DEFINE p_sfbiicd08    LIKE sfbi_file.sfbiicd08

   #在勾選單身二後,並且符合料件狀態為2且為刻號性質為D/G時,
   #抓取符合條件(與主生產料號/產品型號不同)的第一筆資料
   #當生產料號與產品型號的預設值
   #(生產料號/產品型號為空白時,才需做此預設動作)
   IF p_sel2 = 'Y' AND (p_imaicd04 = '2' OR p_imaicd04='4') AND  p_icf05 = '1' THEN
      IF cl_null(p_ima01) THEN
         #預設down grade工單之生產料號
         DECLARE sel_icm02 CURSOR FOR
            SELECT icm02
              FROM icm_file,ima_file
             WHERE ima01 = icm01
               AND icm01 = p_rvv31  #入庫料號
               AND icm02 <> p_sfb05 #下階料
               AND icmacti = 'Y'
         FOREACH sel_icm02 INTO p_ima01
            EXIT FOREACH
         END FOREACH
      END IF
      IF cl_null(p_sfbiicd08_b) THEN
         #預設down grade工單之產品型號
         DECLARE sel_ick02 CURSOR FOR
            SELECT ick02
              FROM ick_file,ima_file
             WHERE ima01 = ick02
               AND ick01 = p_sfbiicd14     #母體料號
               AND ick02 <> p_sfbiicd08    #產品型號
               AND ickacti = 'Y'
         FOREACH sel_ick02 INTO p_sfbiicd08_b
            EXIT FOREACH
         END FOREACH
      END IF
   END IF
   RETURN p_ima01,p_sfbiicd08_b
END FUNCTION

FUNCTION i500sub_ecdicd01(p_ecd01)
    DEFINE p_ecd01     LIKE ecd_file.ecd01
    DEFINE l_ecdicd01 LIKE ecd_file.ecd01
    SELECT ecdicd01 INTO l_ecdicd01 FROM ecd_file WHERE ecd01 = p_ecd01
    RETURN l_ecdicd01
END FUNCTION

#-----------------------------------------------------------------------------#
#--------------------------------列印執行後結果-------------------------------#
#-----------------------------------------------------------------------------#
FUNCTION i500sub_out()
DEFINE
    l_i        LIKE type_file.num5,
    sr         RECORD
                rvv01    LIKE rvv_file.rvv01,           #入庫單號
                rvv02    LIKE rvv_file.rvv02,           #入庫項次
                rvv_msg  LIKE occ_file.occ1012,         #入庫資訊

                sfb01    LIKE sfb_file.sfb01,           #工單單號
                sfb04    LIKE sfb_file.sfb04,           #工單狀態
                sfb87    LIKE sfb_file.sfb87,           #工單確認否

                pmm01    LIKE sfb_file.sfb01,           #採購單號
                pmm18    LIKE pmm_file.pmm18,           #採購資訊

                sfp01    LIKE sfs_file.sfs01,           #發料單號
                sfp04    LIKE sfp_file.sfp04            #扣帳否
               END RECORD,
    l_name     LIKE type_file.chr20,
    l_za05     LIKE za_file.za05

    IF g_prog = 'aici500' OR (g_prog='aicp047' AND g_bgjob='N') THEN
       CALL cl_outnam(g_prog) RETURNING l_name
       SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang

       START REPORT i500_rep TO l_name
    END IF

    FOR l_ac = 1 to g_process_msg.getLength()
       INITIALIZE sr.* TO NULL
       IF g_data[l_ac].sel = 'N' THEN CONTINUE FOR END IF
       LET sr.rvv01   = g_process_msg[l_ac].rvv01
       LET sr.rvv02   = g_process_msg[l_ac].rvv02
       LET sr.rvv_msg = g_process_msg[l_ac].rvv_msg
       FOR l_ac3 = 1 TO g_process_msg[l_ac].sfb01.getLength()
           LET sr.sfb01   = g_process_msg[l_ac].sfb01[l_ac3]
           IF NOT cl_null(sr.sfb01) THEN
              SELECT sfb04,sfb87 INTO sr.sfb04,sr.sfb87 FROM sfb_file
               WHERE sfb01 = sr.sfb01
           END IF

           LET sr.pmm01   = g_process_msg[l_ac].pmm01[l_ac3]
           IF NOT cl_null(sr.pmm01) THEN
              SELECT pmm18 INTO sr.pmm18 FROM pmm_file
               WHERE pmm01 = sr.pmm01
           END IF

           LET sr.sfp01   = g_process_msg[l_ac].sfp01[l_ac3]
           IF NOT cl_null(sr.sfp01) THEN
              SELECT sfp04 INTO sr.sfp04 FROM sfp_file
               WHERE sfp01 = sr.sfp01
           END IF
           IF g_bgjob = 'Y' AND g_prog = 'aicp047' THEN
              CALL i500sub_ins_err(sr.rvv01,sr.rvv02,sr.rvv_msg,sr.sfb01,sr.pmm01,sr.sfp01,g_process_msg[l_ac].success)
           ELSE
              SELECT sfb91,sfb92 INTO sr.rvv01,sr.rvv02 FROM sfb_file WHERE sfb01=sr.sfb01
              OUTPUT TO REPORT i500_rep(sr.*)
           END IF
       END FOR
       IF g_prog = 'aici500' OR (g_prog='aicp047' AND g_bgjob='N') THEN
          IF g_process_msg[l_ac].sfb01.getLength() = 0 THEN
             OUTPUT TO REPORT i500_rep(sr.*)
          END IF
        END IF
    END FOR

    IF g_prog = 'aici500' OR (g_prog='aicp047' AND g_bgjob='N') THEN

       FINISH REPORT i500_rep

       ERROR ""
       CALL cl_prt(l_name,' ','1',g_len)
    END IF
END FUNCTION

REPORT i500_rep(sr)
DEFINE
    sr         RECORD
                rvv01    LIKE rvv_file.rvv01,           #入庫單號
                rvv02    LIKE rvv_file.rvv02,           #入庫項次
                rvv_msg  LIKE occ_file.occ1012,         #入庫資訊

                sfb01    LIKE sfb_file.sfb01,           #工單單號
                sfb04    LIKE sfb_file.sfb04,           #工單狀態
                sfb87    LIKE sfb_file.sfb87,           #工單確認否

                pmm01    LIKE sfb_file.sfb01,           #採購單號
                pmm18    LIKE pmm_file.pmm18,           #採購單確認否

                sfp01    LIKE sfs_file.sfs01,           #發料單號
                sfp04    LIKE sfp_file.sfp04            #扣帳否
               END RECORD,
    l_trailer_sw    LIKE type_file.chr1,
    l_i             LIKE type_file.num5

   OUTPUT
       TOP MARGIN 0
       LEFT MARGIN 0
       BOTTOM MARGIN 6
       PAGE LENGTH g_page_line

    ORDER BY sr.rvv01,sr.rvv02,sr.sfb01
    FORMAT
    PAGE HEADER
       PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 ,
                    g_company CLIPPED
       PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]

       LET g_pageno = g_pageno + 1
       LET pageno_total = PAGENO USING '<<<',"/pageno"
       PRINT g_head CLIPPED,pageno_total
       PRINT g_dash[1,g_len]
       LET l_trailer_sw = 'y'
       PRINT g_x[31],g_x[32],g_x[33],g_x[34],g_x[35],
             g_x[36],g_x[37],g_x[38],g_x[39],g_x[40]
       PRINT g_dash1
    ON EVERY ROW
       PRINT COLUMN g_c[31],sr.rvv01 CLIPPED,
             COLUMN g_c[32],cl_numfor(sr.rvv02 CLIPPED,4,0),  

             COLUMN g_c[33],sr.sfb01 CLIPPED,
             COLUMN g_c[34],sr.sfb04 CLIPPED,
             COLUMN g_c[35],sr.sfb87 CLIPPED,

             COLUMN g_c[36],sr.pmm01 CLIPPED,
             COLUMN g_c[37],sr.pmm18 CLIPPED,

             COLUMN g_c[38],sr.sfp01 CLIPPED,
             COLUMN g_c[39],sr.sfp04 CLIPPED,

             COLUMN g_c[40],sr.rvv_msg CLIPPED

    ON LAST ROW
       PRINT g_dash[1,g_len]
       LET l_trailer_sw = 'n'
       PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED

    PAGE TRAILER
        IF l_trailer_sw = 'y' THEN
            PRINT g_dash[1,g_len]
            PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
        ELSE
            SKIP 2 LINE
        END IF
END REPORT

FUNCTION i500sub_ins_err(p_rvv01,p_rvv02,p_rvv_msg,p_sfb01,p_pmm01,p_sfp01,p_flag)                                                                                                             
DEFINE l_idp      RECORD 
                  idp01   LIKE idp_file.idp01,
                  idp02   LIKE idp_file.idp02,
                  idp03   LIKE idp_file.idp03,
                  idp04   DATETIME YEAR TO MINUTE,
                  idp05   LIKE idp_file.idp05,
                  idp06   LIKE idp_file.idp06,
                  idp07   LIKE idp_file.idp07,
                  idp08   LIKE idp_file.idp08,
                  idp09   LIKE idp_file.idp09,
                  idp10   LIKE idp_file.idp10,
                  idp11   LIKE idp_file.idp11,
                  idp12   LIKE idp_file.idp12
                  END RECORD
DEFINE p_rvv01    LIKE rvv_file.rvv01
DEFINE p_rvv02    LIKE rvv_file.rvv02
DEFINE p_rvv_msg  LIKE idp_file.idp12
DEFINE p_sfb01    LIKE sfb_file.sfb01
DEFINE p_pmm01    LIKE pmm_file.pmm01
DEFINE p_sfp01    LIKE sfp_file.sfp01
DEFINE p_flag     LIKE type_file.chr1
                                                                                                                                    
  INITIALIZE l_idp.* TO NULL                                                                                                        
  SELECT MAX(idp03)+1 INTO l_idp.idp03                                                                                              
         FROM idp_file                                                                                                              
        WHERE idp01 = p_rvv01                                                                                            
          AND idp02 = p_rvv02                                                                                            
  IF cl_null(l_idp.idp03) THEN LET l_idp.idp03 = 1 END IF                                                                           
  LET l_idp.idp01 = p_rvv01                                                                                              
  LET l_idp.idp02 = p_rvv02                                                                                              
  LET l_idp.idp04 = CURRENT YEAR TO MINUTE
  LET l_idp.idp05 = p_flag                                                                                                          
  LET l_idp.idp06 = p_sfb01
  LET l_idp.idp07 = p_pmm01
  LET l_idp.idp09 = p_sfp01
  LET l_idp.idp11 = p_rvv_msg
  INSERT INTO idp_file VALUES (l_idp.*)                                                                                             
  IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN       #置入資料庫不成功                                                             
      RETURN                                                                                                                        
  END IF                                                                                                                            
END FUNCTION

FUNCTION i500sub_create_bin_temp()
DEFINE l_table   STRING
DEFINE l_sql     STRING
   LET l_sql = " item1.type_file.num5, ",
               " sel2.type_file.chr1, ",
               " item2.type_file.num10, ",
               " idc05.idc_file.idc05, ",
               " idc06.idc_file.idc06, ",
               " icf03.icf_file.icf03, ",
               " icf05.icf_file.icf05, ",
               " qty1.idc_file.idc08, ",
               " qty2.idc_file.idc08, ",
               " ima01.ima_file.ima01, ",
               " ima02.ima_file.ima02, ",
               " sfbiicd08_b.sfbi_file.sfbiicd08 "
              ,",chk.type_file.chr1  "        
    LET l_table = cl_prt_temptable('aici500',l_sql) CLIPPED
    IF l_table = -1 THEN 
       CALL cl_used(g_prog,g_time,2) RETURNING g_time 
       EXIT PROGRAM 
    END IF
    RETURN l_table
END FUNCTION
#FUN-CA0022
#FUN-CC0077
