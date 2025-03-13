# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimp611.4gl
# Descriptions...: 料件(ima26*)及明細庫存量(img10)檢查作業
# Modify.........: No.MOD-480395 04/08/19 By Nicola 報表標題標準化
# Modify.........: No.MOD-4A0048 04/10/06 By Mandy 列印出報表,不對齊
# Modify.........: No.MOD-530179 05/03/22 By Mandy 將DEFINE 用DEC(),DECIMAL()方式的改成用LIKE方式
# Modify.........: No.FUN-540025 05/04/12 By Carrier 雙單位內容修改
# Modify.........: NO.FUN-5C0001 06/01/03 BY yiting 加上是否顯示執行過程選項及cl_progress_bar()
# Modify.........: No.FUN-570122 06/02/24 By yiting 背景執行
# Modify.........: No.MOD-640236 06/04/10 By kim 執行完後,出現執行成功,是否繼續作業,之後又出現執行失敗,是否繼續作業,
# Modify.........: No.MOD-640505 06/04/18 By Claire 加入 database ds
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義 
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.FUN-710025 07/01/17 By bnlent  錯誤訊息匯整
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.MOD-740016 07/04/09 By pengu line 660 IF sr.imk09 != l_img10 THEN
#                                                  應調整為IF sr.imk09 != l_img10 or sr.imk09<0 THEN
# Modify.........: No.MOD-740015 07/04/09 By pengu 修改計算MPS/MRP可用庫存數量的SQL限制條件
# Modify.........: No.FUN-8A0086 08/10/21 By zhaijie添加LET g_success = 'N'
# Modify.........: No.FUN-920028 09/02/04 By jan aimp611料件及明細庫存檢查時, 應一并檢查負庫存
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/23 By vealxu ima26x 調整
# Modify.........: No:FUN-A70120 10/08/03 BY alex 調整rowid為type_file.row_id
 
DATABASE ds   
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql	     string,  #No.FUN-580092 HCN
       g_yy,g_mm,b_yy,b_mm   LIKE type_file.num5,    #No.FUN-690026 SMALLINT
#      bal26,bal261,bal262   LIKE ima_file.ima26,    #MOD-530179    #FUN-A20044
       bal26,bal261,bal262   LIKE type_file.num15_3,                #FUN-A20044
       g_stime,g_etime       LIKE type_file.chr8,    #No.FUN-690026 VARCHAR(8)
       g_item_t              LIKE img_file.img01,
       g_bdate1,g_edate1     LIKE type_file.dat,     #No.FUN-690026 DATE
       g_bdate2,g_edate2     LIKE type_file.dat,     #No.FUN-690026 DATE
       g_code                LIKE type_file.num5,    #No.FUN-690026 SMALLINT
       chkimk                LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
       show                  LIKE type_file.chr1,    #NO.FUN-5C0001 #No.FUN-690026 VARCHAR(1)
       g_program             LIKE zz_file.zz01       #No.FUN-690026 VARCHAR(10)
 
DEFINE p_row,p_col     LIKE type_file.num5    #No.FUN-690026 SMALLINT
DEFINE g_i             LIKE type_file.num5    #count/index for any purpose  #No.FUN-690026 SMALLINT
DEFINE g_chr           LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
DEFINE g_change_lang   LIKE type_file.chr1    #是否有做語言切換 No.FUN-570122  #No.FUN-690026 VARCHAR(1)
 
MAIN
DEFINE l_flag LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
 
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   LET g_program= ARG_VAL(1)    	# Get arguments from command line
   LET g_code   = ARG_VAL(2)       	# Get arguments from command line
   LET g_pdate  = ARG_VAL(3)       	# Get arguments from command line
   LET g_towhom = ARG_VAL(4)
   LET g_rlang  = ARG_VAL(5)
   LET g_bgjob  = ARG_VAL(6)
   LET g_prtway = ARG_VAL(7)
   LET g_copies = ARG_VAL(8)
   LET g_wc     = ARG_VAL(9)
   LET g_yy     = ARG_VAL(10)
   LET g_mm     = ARG_VAL(11)
   LET chkimk   = ARG_VAL(12)
   #No.FUN-570122 ----Start----
   INITIALIZE g_bgjob_msgfile TO NULL
   LET b_yy     = ARG_VAL(13)
   LET b_mm     = ARG_VAL(14)
   LET g_bgjob  = ARG_VAL(15)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob= 'N'
   END IF
   #No.FUN-570122 ----End----
 
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
#NO.FUN-570122  MARK---
#   OPEN WINDOW aimp611_w AT p_row,p_col
#     WITH FORM "aim/42f/aimp611"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#    
#   CALL cl_ui_init()
#
#   CALL cl_opmsg('p')
 
#   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  
#      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01=g_sma.sma53
#      LET chkimk='N' 
 
#      WHILE TRUE
#         CONSTRUCT BY NAME g_wc ON img01,img02,img03,img04,ima23,ima08 
         
#         #No.FUN-580031 --start--
#         BEFORE CONSTRUCT
#             CALL cl_qbe_init()
#         #No.FUN-580031 ---end---
#
#            ON IDLE g_idle_seconds
#               CALL cl_on_idle()
#               CONTINUE CONSTRUCT
#
#             ON ACTION about         #MOD-4C0121
#                CALL cl_about()      #MOD-4C0121
 
#             ON ACTION help          #MOD-4C0121
#                CALL cl_show_help()  #MOD-4C0121
 
#             ON ACTION controlg      #MOD-4C0121
#                CALL cl_cmdask()     #MOD-4C0121
      
#         #No.FUN-580031 --start--
#         ON ACTION qbe_select
#            CALL cl_qbe_select()
#         #No.FUN-580031 ---end---
#
#         END CONSTRUCT
#         IF INT_FLAG THEN
#            LET INT_FLAG = 0 CLOSE WINDOW aimp611_w EXIT PROGRAM
#         END IF
#         LET show = 'Y'  #NO.FUN-5C0001
#         #INPUT BY NAME g_yy,g_mm,chkimk,b_yy,b_mm WITHOUT DEFAULTS
#         INPUT BY NAME g_yy,g_mm,show,chkimk,b_yy,b_mm
#             WITHOUT DEFAULTS  #NO.FUN-5C0001
 
#            AFTER FIELD g_yy
#               IF g_yy IS NULL THEN NEXT FIELD g_yy END IF
#            AFTER FIELD g_mm
#               IF g_mm IS NULL OR (g_mm=0 OR g_mm>12) THEN NEXT FIELD g_mm END IF
#            AFTER FIELD chkimk
#               IF cl_null(chkimk) OR chkimk NOT MATCHES '[YN]' THEN 
#                  NEXT FIELD chkimk
#               END IF
#               IF chkimk='N' THEN 
#                  LET b_yy=0
#                  LET b_mm=0
#                  DISPLAY BY NAME b_mm,b_yy    
#                  EXIT INPUT 
#               END IF
#            AFTER FIELD b_yy
#               IF b_yy IS NULL THEN NEXT FIELD b_yy END IF
#               IF b_yy < g_yy THEN 
#                  CALL cl_err('','aim-403',0)
#                  NEXT FIELD b_yy
#               END IF  
#            AFTER FIELD b_mm
#               IF b_mm IS NULL OR ( b_mm=0 OR b_mm>12 )THEN NEXT FIELD b_mm END IF
#               IF b_yy=g_yy AND b_mm < g_mm THEN  
#                  CALL cl_err('','aim-403',0)
#                  NEXT FIELD b_mm
#               END IF  
#
#            ON ACTION CONTROLR
#               CALL cl_show_req_fields()
#               
#            ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
#            
#            ON IDLE g_idle_seconds
#               CALL cl_on_idle()
#               CONTINUE INPUT
# 
#             ON ACTION about         #MOD-4C0121
#                CALL cl_about()      #MOD-4C0121
# 
#             ON ACTION help          #MOD-4C0121
#                CALL cl_show_help()  #MOD-4C0121
# 
#            ON ACTION locale
#               LET g_action_choice = "locale"
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#               EXIT INPUT
#      
#         #No.FUN-580031 --start--
#         ON ACTION qbe_save
#            CALL cl_qbe_save()
#         #No.FUN-580031 ---end---
#
#         END INPUT
#      
#         IF g_action_choice = "locale" THEN
#            LET g_action_choice = ""
#            CALL cl_dynamic_locale()
#            CONTINUE WHILE
#         END IF
#      
#         IF INT_FLAG THEN
#            LET INT_FLAG = 0 CLOSE WINDOW aimp611_w EXIT PROGRAM
#         END IF
#NO.FUN-570122 MARK--
#NO.FUN-570122 START---
   WHILE TRUE
      LET g_success = 'Y'
      IF g_bgjob = 'N' THEN
         CALL p611_i()
   #FUN-570122  ----End----
         IF cl_sure(0,0) THEN
            CALL s_azm(g_yy,g_mm) RETURNING g_chr,g_bdate1,g_edate1
            CALL cl_wait()
               BEGIN WORK     #No.FUN-710025
            CALL aimp611()
            CALL s_showmsg()  #No.FUN-710025
            IF g_success='Y' THEN
               COMMIT WORK
               CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
            ELSE
               ROLLBACK WORK
               CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
            END IF
            IF l_flag THEN
               CONTINUE WHILE
            ELSE
               CLOSE WINDOW aimp611_w
               EXIT WHILE
            END IF
         ELSE
            CONTINUE WHILE
         END IF
         ERROR ""
      ELSE
         CALL s_azm(g_yy,g_mm) RETURNING g_chr,g_bdate1,g_edate1
         CALL s_azm(b_yy,b_mm) RETURNING g_chr,g_bdate2,g_edate2
         CALL aimp611()
      #FUN-570122  ---Start---
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
      END IF
      EXIT WHILE
      #FUN-570122  ---End---
   END WHILE
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
  
#FUN-570122  ---Start---
FUNCTION p611_i()
   DEFINE lc_cmd  LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(500)
 
   OPEN WINDOW aimp611_w AT p_row,p_col
     WITH FORM "aim/42f/aimp611"  ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL cl_opmsg('p')
 
 
   IF cl_null(g_bgjob) OR g_bgjob = 'N' THEN  
      SELECT azn02,azn04 INTO g_yy,g_mm FROM azn_file WHERE azn01=g_sma.sma53
      LET chkimk='N' 
   END IF
 
      WHILE TRUE
         CONSTRUCT BY NAME g_wc ON img01,img02,img03,img04,ima23,ima08 
        
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
             ON ACTION about         #MOD-4C0121
                CALL cl_about()      #MOD-4C0121
 
             ON ACTION help          #MOD-4C0121
                CALL cl_show_help()  #MOD-4C0121
 
             ON ACTION controlg      #MOD-4C0121
                CALL cl_cmdask()     #MOD-4C0121
     
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         END CONSTRUCT
         LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
         IF INT_FLAG THEN
            LET INT_FLAG = 0 CLOSE WINDOW aimp611_w 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
            EXIT PROGRAM
               
         END IF
         LET show = 'Y'  #NO.FUN-5C0001
         #INPUT BY NAME g_yy,g_mm,chkimk,b_yy,b_mm WITHOUT DEFAULTS
         INPUT BY NAME g_yy,g_mm,show,chkimk,b_yy,b_mm
             WITHOUT DEFAULTS  #NO.FUN-5C0001
 
            AFTER FIELD g_yy
               IF g_yy IS NULL THEN NEXT FIELD g_yy END IF
            AFTER FIELD g_mm
#No.TQC-720032 -- begin --
            IF NOT cl_null(g_mm) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                  WHERE azm01 = g_yy
               IF g_azm.azm02 = 1 THEN
                  IF g_mm > 12 OR g_mm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD g_mm
                  END IF
               ELSE
                  IF g_mm > 13 OR g_mm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD g_mm
                  END IF
               END IF
            END IF
#               IF g_mm IS NULL OR (g_mm=0 OR g_mm>12) THEN NEXT FIELD g_mm END IF
#No.TQC-720032 -- end --
 
            AFTER FIELD chkimk
               IF cl_null(chkimk) OR chkimk NOT MATCHES '[YN]' THEN 
                  NEXT FIELD chkimk
               END IF
               IF chkimk='N' THEN 
                  LET b_yy=0
                  LET b_mm=0
                  DISPLAY BY NAME b_mm,b_yy    
                  EXIT INPUT 
               END IF
            AFTER FIELD b_yy
               IF b_yy IS NULL THEN NEXT FIELD b_yy END IF
               IF b_yy < g_yy THEN 
                  CALL cl_err('','aim-403',0)
                  NEXT FIELD b_yy
               END IF  
            AFTER FIELD b_mm
#No.TQC-720032 -- begin --
            IF NOT cl_null(b_mm) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                  WHERE azm01 = b_yy
               IF g_azm.azm02 = 1 THEN
                  IF b_mm > 12 OR b_mm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD b_mm
                  END IF
               ELSE
                  IF b_mm > 13 OR b_mm < 1 THEN
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD b_mm
                  END IF
               END IF
            END IF
#               IF b_mm IS NULL OR ( b_mm=0 OR b_mm>12 )THEN NEXT FIELD b_mm END IF
#No.TQC-720032 -- end --
               IF b_yy=g_yy AND b_mm < g_mm THEN  
                  CALL cl_err('','aim-403',0)
                  NEXT FIELD b_mm
               END IF  
 
            ON ACTION CONTROLR
               CALL cl_show_req_fields()
               
            ON ACTION CONTROLG CALL cl_cmdask()    # Command execution
            
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE INPUT
 
             ON ACTION about         #MOD-4C0121
                CALL cl_about()      #MOD-4C0121
 
             ON ACTION help          #MOD-4C0121
                CALL cl_show_help()  #MOD-4C0121
 
            ON ACTION locale
           #->No.FUN-570155--end---
        #  LET g_action_choice='locale'
        #  CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_change_lang = TRUE
           #->No.FUN-570155--end---
               EXIT INPUT
      
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
         END INPUT
      
         IF g_action_choice = "locale" THEN
            LET g_action_choice = ""
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()   #FUN-550037(smin)
            CONTINUE WHILE
         END IF
      
         IF INT_FLAG THEN
            LET INT_FLAG = 0 CLOSE WINDOW aimp611_w 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
            EXIT PROGRAM
               
         END IF
 
        CALL p611_i1()
        IF g_bgjob = "Y" THEN
           SELECT zz08 INTO lc_cmd FROM zz_file
            WHERE zz01 = "aimp611"
           IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
              CALL cl_err('aimp611','9031',1)
           ELSE
              LET g_wc=cl_replace_str(g_wc, "'", "\"")
              LET lc_cmd = lc_cmd CLIPPED,
                          " '",g_program CLIPPED,"'",
                          " '",g_code CLIPPED,"'",
                          " '",g_pdate CLIPPED,"'",
                          " '",g_towhom CLIPPED,"'",
                          " '",g_rlang CLIPPED,"'",
                          " '",g_bgjob CLIPPED,"'",
                          " '",g_prtway CLIPPED ,"'",
                          " '",g_copies CLIPPED,"'", 
                          " '",g_wc CLIPPED,"'",
                          " '",g_yy CLIPPED,"'", 
                          " '",g_mm CLIPPED,"'", 
                          " '",chkimk CLIPPED,"'",
                          " '",b_yy CLIPPED,"'",
                          " '",b_mm CLIPPED,"'", 
                          " '",g_bgjob CLIPPED,"'"
              CALL cl_cmdat('aimp611',g_time,lc_cmd CLIPPED)
           END IF
           CLOSE WINDOW p611_w
           CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
           EXIT PROGRAM
        END IF
        EXIT WHILE
      END WHILE
END FUNCTION
 
FUNCTION p611_i1()
 
   LET g_bgjob = 'N'
 
   INPUT BY NAME g_bgjob WITHOUT DEFAULTS
 
        #No.FUN-570122 --start--
         ON CHANGE g_bgjob
            IF g_bgjob = "Y" THEN
               LET show = "N"
               DISPLAY BY NAME show
               CALL cl_set_comp_entry("show",FALSE)
            ELSE
               CALL cl_set_comp_entry("show",TRUE)
            END IF
         #No.FUN-570122 ---end---
 
      AFTER FIELD g_bgjob
         IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
            NEXT FIELD g_bgjob
         END IF
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      AFTER INPUT
       IF INT_FLAG THEN EXIT INPUT END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
    ON ACTION about         #BUG-4C0121
       CALL cl_about()      #BUG-4C0121
 
    ON ACTION help          #BUG-4C0121
       CALL cl_show_help()  #BUG-4C0121
 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
 
   END INPUT
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW aimp611_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
 
END FUNCTION
 
FUNCTION aimp611()
   DEFINE l_rowid           LIKE type_file.row_id   #chr18  FUN-A70120
   DEFINE l_name            LIKE type_file.chr20,   #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
          l_sql             LIKE type_file.chr1000, #No.FUN-690026 VARCHAR(611)
          l_msg             LIKE type_file.chr1000, #MOD-4A0048    #No.FUN-690026 VARCHAR(500),
          t_msg             LIKE type_file.chr1000, #No.FUN-540025 #No.FUN-690026 VARCHAR(500),
          l_bal,l_pia30     LIKE pia_file.pia30,
          l_pia50           LIKE pia_file.pia50,
          l_bdate,l_edate   LIKE type_file.dat,     #No.FUN-690026 DATE
          g_count           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          w_tlf026          LIKE tlf_file.tlf026,
          l_img10           LIKE img_file.img10,
#         l_ima26           LIKE ima_file.ima26,    #No.FUN-A20044
#         l_ima261          LIKE ima_file.ima261,   #No.FUN-A20044
#         l_ima262          LIKE ima_file.ima262,   #No.FUN-A20044
          l_avl_stk_mpsmrp  LIKE type_file.num15_3, #No.FUN-A20044
          l_unavl_stk       LIKE type_file.num15_3, #No.FUN-A20044
          l_avl_stk         LIKE type_file.num15_3, #No.FUN-A20044 
          l_imk05           LIKE imk_file.imk05,
          l_imk06           LIKE imk_file.imk06,
          l_count           LIKE type_file.num10,   #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
          l_sw              LIKE type_file.num10,   #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
          l_cnt1            LIKE type_file.num10,   #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
          l_sw_tot          LIKE type_file.num10,   #NO.FUN-5C0001 ADD  #No.FUN-690026 INTEGER
          xx                RECORD LIKE tlf_file.*,
          sr                RECORD        
                            img01     LIKE img_file.img01,
                            img02     LIKE img_file.img02,
                            img03     LIKE img_file.img03,
                            img04     LIKE img_file.img04,
                            imk09     LIKE imk_file.imk09,
                            imk05     LIKE imk_file.imk05,
                            imk06     LIKE imk_file.imk06
                            END RECORD
     LET g_stime=TIME
     LET g_item_t=' '
     LET g_count=0
 
     SELECT zo02 INTO g_company FROM zo_file WHERE zo01 = g_lang
     CALL cl_outnam('aimp611') RETURNING l_name
     START REPORT aimp611_rep TO l_name 
     LET l_sql="SELECT img01,img02,img03,img04,imk09,imk05,imk06",
               "  FROM img_file,ima_file, OUTER imk_file ",
               " WHERE ",g_wc CLIPPED," AND img01=ima01",
               "   AND img_file.img01=imk_file.imk01 AND img_file.img02=imk_file.imk02",
               "   AND img_file.img03=imk_file.imk03 AND img_file.img04=imk_file.imk04" CLIPPED

     IF chkimk='N' THEN
        LET l_sql = l_sql CLIPPED," AND imk_file.imk05=",g_yy," AND imk_file.imk06=",g_mm,
                    " ORDER BY img01,img02,img03,img04"
     ELSE 
        LET l_sql = l_sql CLIPPED," AND imk_file.imk05 BETWEEN ",g_yy," AND ",b_yy,
                    " ORDER BY img01,img02,img03,img04"
     END IF 
 
     IF show = 'N' THEN
         IF chkimk='N' THEN
             LET g_sql ="SELECT COUNT(*) ",
                        "   FROM img_file,ima_file, OUTER imk_file ",
                        "  WHERE ",g_wc CLIPPED,
                        "    AND img01=ima01 ",
                        "    AND img_file.img01=imk_file.imk01 AND img_file.img02=imk_file.imk02 ",
                        "    AND img_file.img03=imk_file.imk03 AND img_file.img04=imk_file.imk04 ",
                        "    AND imk_file.imk05='",g_yy,"' AND imk_file.imk06= '",g_mm,"'"
         ELSE
             LET g_sql ="SELECT COUNT(*) ",
                        "   FROM img_file,ima_file, OUTER imk_file ",
                        "  WHERE ",g_wc CLIPPED,
                        "    AND img01=ima01 ",
                        "    AND img_file.img01=imk_file.imk01 AND img_file.img02=imk_file.imk02 ",
                        "    AND img_file.img03=imk_file.imk03 AND img_file.img04=imk_file.imk04 ",
                        "    AND imk_file.imk05 BETWEEN '",g_yy,"' AND '",b_yy,"'"
         END IF
         PREPARE aimp611_show_p FROM g_sql
         IF STATUS  THEN CALL cl_err('prep:',STATUS,1) 
            CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
            EXIT PROGRAM 
         END IF
         DECLARE aimp611_show_c CURSOR FOR aimp611_show_p
         OPEN aimp611_show_c
         FETCH aimp611_show_c INTO l_sw_tot
         LET l_count = 1
         IF l_sw_tot>0 THEN
             IF l_sw_tot > 10 THEN
                 LET l_sw = l_sw_tot /10
                 CALL cl_progress_bar(10)
              ELSE
                 CALL cl_progress_bar(l_sw_tot)
              END IF
         END IF
     END IF
 
     PREPARE aimp611_prepare1 FROM l_sql
     IF STATUS  THEN CALL cl_err('prep:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF

     DECLARE aimp611_curs1 CURSOR FOR aimp611_prepare1
     CALL s_showmsg_init()  
     FOREACH aimp611_curs1 INTO sr.*
       IF STATUS THEN CALL s_errmsg('','','foreach:',STATUS,0) 
            IF show = 'N' THEN
               CALL cl_close_progress_bar()
            END IF
            LET g_success ='N'    #FUN-8A0086
            EXIT FOREACH 
       END IF

       IF g_success='N' THEN                                                                                                        
          LET g_totsuccess='N'                                                                                                      
          LET g_success="Y"                                                                                                         
       END IF                 
       #No.FUN-710025--End--
       LET l_cnt1 = l_cnt1 + 1 #NO.FUN-5C0001  ADD

       #庫存年月>檢查統計檔截止年度期別-1 則不再查詢
       IF chkimk='Y' AND
         (( sr.imk05=g_yy AND sr.imk06 < g_mm ) OR    
         ( sr.imk05=b_yy AND sr.imk06 > b_mm-1 )) THEN 
           IF show = 'N' THEN
              IF l_sw_tot > 10 THEN  #筆數合計
                  IF l_count = 10 AND l_cnt1 = l_sw_tot THEN
                     CALL cl_progressing(" ")
                  END IF
                  IF (l_cnt1 mod l_sw) = 0 AND l_count < 10 THEN  #分割完的倍數>
                     CALL cl_progressing(" ")
                     LET l_count = l_count + 1
                  END IF
              ELSE
                  CALL cl_progressing(" ")
              END IF
          END IF
          CONTINUE FOREACH 
       END IF 

       IF sr.img01 != g_item_t THEN
          SELECT SUM(img10*img21) INTO bal26 FROM img_file
              WHERE img01 = g_item_t AND img24 = 'Y'
          SELECT SUM(img10*img21) INTO bal261 FROM img_file
              WHERE img01 = g_item_t AND img23 = 'N'
          SELECT SUM(img10*img21) INTO bal262 FROM img_file
              WHERE img01 = g_item_t AND img23 = 'Y'
          IF bal26  IS NULL THEN LET bal26  = 0 END IF
          IF bal261 IS NULL THEN LET bal261 = 0 END IF
          IF bal262 IS NULL THEN LET bal262 = 0 END IF
          #-->取ima_file 比較
#           SELECT ima26,ima261,ima262 INTO l_ima26,l_ima261,l_ima262   #FUN-A20044
#             FROM ima_file WHERE ima01 = g_item_t                      #FUN-A20044
           CALL s_getstock(g_item_t,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk   #FUN-A20044
#          IF l_ima26 != bal26 THEN                                     #FUN-A20044
           IF l_avl_stk_mpsmrp != bal26 THEN                            #FUN-A20044     
              CALL cl_getmsg('aim-420',g_lang) RETURNING l_msg
              LET l_msg=l_msg CLIPPED,
              #LET l_msg = 'MRP 可用量不正確(ima26)',
#                 l_ima26 using'----------','-',bal26 using '##########'           #FUN-A20044
                  l_avl_stk_mpsmrp using'----------','-',bal26 using '##########'  #FUN-A20044
              OUTPUT TO REPORT aimp611_rep(g_item_t,l_msg)
           END IF
#          IF l_ima261 != bal261 THEN                                              #FUN-A20044
           IF l_unavl_stk != bal261 THEN                                           #FUN-A20044
              CALL cl_getmsg('aim-421',g_lang) RETURNING l_msg
              LET l_msg=l_msg CLIPPED,
#                 l_ima261 using'----------','-',bal261 using '##########'         #FUN-A20044
                  l_unavl_stk using'----------','-',bal261 using '##########'      #FUN-A20044
              OUTPUT TO REPORT aimp611_rep(g_item_t,l_msg)
           END IF
#          IF l_ima262 != bal262 THEN                                              #FUN-A20044
           IF l_avl_stk != bal262 THEN                                             #FUN-A20044   
              #No.FUN-540025  --begin
              CALL cl_getmsg('aim-422',g_lang) RETURNING l_msg
              LET l_msg=l_msg CLIPPED,
#                 l_ima262 using'----------','-',bal262 using '##########'         #FUN-A20044
                  l_avl_stk using'----------','-',bal262 using '##########'        #FUN-A20044 
              OUTPUT TO REPORT aimp611_rep(g_item_t,l_msg)
           END IF
       END IF
 
       LET g_item_t=sr.img01   
       LET g_count=g_count+1
       IF show = 'Y' OR g_bgjob = 'N' THEN
           MESSAGE sr.img01,sr.img04,g_count
           CALL ui.Interface.refresh()
       END IF
       IF cl_null(sr.imk09) THEN LET sr.imk09=0 END IF

       ####---庫存異動     
       CALL s_azm(sr.imk05,sr.imk06) RETURNING g_chr,g_bdate2,g_edate2
       #讀取庫存異動明細資料
       DECLARE p611_c2 CURSOR FOR
         SELECT rowid,tlf_file.* FROM tlf_file
          WHERE tlf01 = sr.img01
            AND tlf06 > g_edate2
            AND ( tlf907 <> 0 ) AND tlf902 = sr.img02 
            AND tlf903 = sr.img03 AND tlf904 = sr.img04
          ORDER BY tlf06,tlf08
    #  LET l_bal = sr.imk09  #本期期初量=上期期末庫存量
       LET l_bal=0
       FOREACH p611_c2 INTO l_rowid,xx.*
         IF STATUS THEN CALL s_errmsg('','','foreach2:',STATUS,1) EXIT FOREACH END IF
         IF xx.tlf10 IS NULL THEN LET xx.tlf10=0 END IF
         IF xx.tlf12 IS NULL OR xx.tlf12=0 THEN LET xx.tlf12=1 END IF
         IF xx.tlf031=sr.img02 AND xx.tlf032=sr.img03 AND xx.tlf033=sr.img04
            AND xx.tlf13 != 'apmt1071'
            THEN LET xx.tlf10  = xx.tlf10 *  1
            ELSE LET xx.tlf10  = xx.tlf10 * -1
         END IF
         LET l_bal = l_bal + xx.tlf10*xx.tlf12
       END FOREACH

       SELECT img10 INTO l_img10 FROM img_file       #庫存總數量
             WHERE img01=sr.img01 AND img02=sr.img02
               AND img03=sr.img03 AND img04=sr.img04
       IF SQLCA.sqlcode THEN LET l_img10 = 0 END IF
       LET l_img10=l_img10 - l_bal 
      #------------No.MOD-740016 modify
      #IF sr.imk09 != l_img10 THEN           
       IF sr.imk09 != l_img10 OR sr.imk09 < 0 OR l_img10 < 0  THEN    #FUN-920028       
      #------------No.MOD-740016 end
         #MOD-4A0048
        # LET l_msg=sr.imk05 USING '####','/',
        #           sr.imk06 USING '&&' CLIPPED,
        #           '不正確倉儲資料',sr.img02 CLIPPED,
        #           sr.img03 CLIPPED,sr.img04 CLIPPED,' ',
        #           l_img10 USING '----------','-',
        #           sr.imk09 USING '----------'
          #No.FUN-540025  --begin
          CALL cl_getmsg('aim-420',g_lang) RETURNING t_msg
          LET l_msg=sr.imk05 USING '####','/'
          LET l_msg=l_msg CLIPPED,sr.imk06 USING '&&' 
          LET l_msg=l_msg CLIPPED,' ',t_msg
          LET l_msg=l_msg CLIPPED,' ',sr.img02
          LET l_msg=l_msg CLIPPED,' ',sr.img03
          LET l_msg=l_msg CLIPPED,' ',sr.img04
          LET l_msg=l_msg CLIPPED,' ',l_img10  USING '----------','-'
          LET l_msg=l_msg CLIPPED,' ',sr.imk09 USING '----------'
          #MOD-4A0048(end)
              OUTPUT TO REPORT aimp611_rep(sr.img01,l_msg)
       END IF
       #NO.FUN-5C0001 START---
       IF show = 'N' THEN
          IF l_sw_tot > 10 THEN  #筆數合計
             IF l_count = 10 AND l_cnt1 = l_sw_tot THEN
                 CALL cl_progressing(" ")
             END IF
             IF (l_cnt1 mod l_sw) = 0 AND l_count < 10 THEN  #分割完的倍數時才呼
                  CALL cl_progressing(" ")
                  LET l_count = l_count + 1
             END IF
          ELSE
              CALL cl_progressing(" ")
          END IF
       END IF
       #NO.FUN-5C0001 END-----
 
     END FOREACH
     #No.FUN-710025--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
     #No.FUN-710025--End--
 
#....................................................................
     #check最後一筆img_file
          SELECT SUM(img10*img21) INTO bal26 FROM img_file
             #----------------No.MOD-740015 modify
             #WHERE img01 = g_item_t AND img23 = 'Y' AND img24 = 'Y'
              WHERE img01 = g_item_t AND img24 = 'Y'
             #----------------No.MOD-740015 end
          SELECT SUM(img10*img21) INTO bal261 FROM img_file
              WHERE img01 = g_item_t AND img23 = 'N'
          SELECT SUM(img10*img21) INTO bal262 FROM img_file
              WHERE img01 = g_item_t AND img23 = 'Y'
          IF bal26  IS NULL THEN LET bal26  = 0 END IF
          IF bal261 IS NULL THEN LET bal261 = 0 END IF
          IF bal262 IS NULL THEN LET bal262 = 0 END IF
 
          #-->取ima_file 比較
          #No.FUN-540025  --begin
#          SELECT ima26,ima261,ima262 INTO l_ima26,l_ima261,l_ima262                   #FUN-A20044
#            FROM ima_file WHERE ima01 = g_item_t                                      #FUN-A20044
           CALL s_getstock(g_item_t,g_plant) RETURNING l_avl_stk_mpsmrp,l_unavl_stk,l_avl_stk  #FUN-A20044
#           IF l_ima26 != bal26 THEN                                                   #FUN-A20044
            IF l_avl_stk_mpsmrp != bal26 THEN                                          #FUN-A20044    
              CALL cl_getmsg('aim-420',g_lang) RETURNING t_msg
              LET l_msg =sr.imk05 USING '####','/',sr.imk06 USING '&&',
              #           ' MRP 可用量不正確(ima26)',
                         t_msg CLIPPED,
#                  l_ima26 using'----------','-',bal26 using '----------'              #FUN-A20044
                   l_avl_stk_mpsmrp using'----------','-',bal26 using '----------'     #FUN-A20044
              OUTPUT TO REPORT aimp611_rep(g_item_t,l_msg)
           END IF
#           IF l_ima261 != bal261 THEN                                                 #FUN-A20044
            IF l_unavl_stk != bal261 THEN                                              #FUN-A20044      
              CALL cl_getmsg('aim-421',g_lang) RETURNING t_msg
              LET l_msg =sr.imk05 USING '####','/',sr.imk06 USING '&&',
              #           ' 不可用量不正確(ima261)',
                         t_msg CLIPPED,
#                  l_ima261 using'----------','-',bal261 using '----------'            #FUN-A20044
                   l_unavl_stk using'----------','-',bal261 using '----------'         #FUN-A20044
              OUTPUT TO REPORT aimp611_rep(g_item_t,l_msg)
           END IF
#           IF l_ima262 != bal262 THEN                                                 #FUN-A20044
           IF l_avl_stk != bal262 THEN                                                 #FUN-A20044
              CALL cl_getmsg('aim-422',g_lang) RETURNING t_msg
              LET l_msg =sr.imk05 USING '####','/',sr.imk06 USING '&&',
              #           ' 庫存可用量不正確(ima262)',
                         t_msg CLIPPED,
#                  l_ima262 using'----------','-',bal262 using '----------'            #FUN-A20044
                   l_avl_stk using'----------','-',bal262 using '----------'           #FUN-A20044
              OUTPUT TO REPORT aimp611_rep(g_item_t,l_msg)
           END IF
 
    #No.FUN-540025  --begin
    IF g_sma.sma115 = 'Y' THEN
       CALL aimp611_imgg()
    END IF
    #No.FUN-540025  --end
           
     FINISH REPORT aimp611_rep
     CALL cl_prt(l_name,g_prtway,g_copies,g_len)
END FUNCTION
 
REPORT aimp611_rep(p_ima01,p_msg)
   DEFINE p_ima01    LIKE ima_file.ima01,
          p_msg      LIKE type_file.chr1000,#MOD-4A0048  #No.FUN-690026 VARCHAR(500)
          l_last_sw  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)
          
  OUTPUT TOP MARGIN g_top_margin LEFT MARGIN g_left_margin BOTTOM MARGIN g_bottom_margin PAGE LENGTH g_page_line
   ORDER BY p_ima01 
    
  FORMAT                                          
   PAGE HEADER
      PRINT COLUMN ((g_len-FGL_WIDTH(g_company CLIPPED))/2)+1 , g_company CLIPPED
      PRINT COLUMN ((g_len-FGL_WIDTH(g_x[1]))/2)+1 ,g_x[1]
      LET g_pageno = g_pageno + 1
      LET pageno_total = PAGENO USING '<<<',"/pageno" 
      PRINT g_head CLIPPED,pageno_total     
      PRINT 
      PRINT g_dash
      PRINT g_x[31],g_x[32]
      PRINT g_dash1 
      LET l_last_sw = 'n'
 
   ON EVERY ROW
      PRINT COLUMN g_c[31],p_ima01,
            COLUMN g_c[32],p_msg 
   ON LAST ROW
      LET l_last_sw = 'y'
 
   PAGE TRAILER
      PRINT g_dash
      IF l_last_sw = 'n'
         THEN PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[6] CLIPPED
         ELSE PRINT g_x[4],g_x[5] CLIPPED, COLUMN (g_len-9), g_x[7] CLIPPED
      END IF
 
END REPORT
 
FUNCTION aimp611_imgg()
   DEFINE l_rowid           LIKE type_file.row_id   #chr18  FUN-A70120
   DEFINE l_sql             LIKE type_file.chr1000, 
          l_msg             LIKE type_file.chr1000, #MOD-4A0048    #No.FUN-690026 VARCHAR(100) 
          t_msg             LIKE type_file.chr1000, #No.FUN-540025 #No.FUN-690026 VARCHAR(100) 
          l_bal             LIKE pia_file.pia30,
          g_count           LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_imgg10          LIKE imgg_file.imgg10,  #No.FUN-540025
          t_img10           LIKE imgg_file.imgg10,  #No.FUN-540025
          l_imkk05          LIKE imkk_file.imkk05,
          l_imkk06          LIKE imkk_file.imkk06,
          l_img01           LIKE img_file.img01,
          l_img02           LIKE img_file.img02,
          l_img03           LIKE img_file.img03,
          l_img04           LIKE img_file.img04,
          xx                RECORD LIKE tlff_file.*,
          sr2               RECORD        
                            imgg01 LIKE imgg_file.imgg01,
                            imgg02 LIKE imgg_file.imgg02,
                            imgg03 LIKE imgg_file.imgg03,
                            imgg04 LIKE imgg_file.imgg04,
                            imgg09 LIKE imgg_file.imgg09,
                            imkk09 LIKE imkk_file.imkk09,
                            imkk05 LIKE imkk_file.imkk05,
                            imkk06 LIKE imkk_file.imkk06
                            END RECORD
   DEFINE lsb_wc   base.StringBuffer
   DEFINE ls_wc    STRING
 
     LET g_count=0
     LET ls_wc=g_wc CLIPPED
     LET lsb_wc=base.StringBuffer.create()
     CALL lsb_wc.append(ls_wc.trim())
     CALL lsb_wc.replace("img","imgg",0)
     LET ls_wc=lsb_wc.toString()
 
     LET l_img01=' '
     LET l_img02=' '
     LET l_img03=' '
     LET l_img04=' '
     LET l_sql="SELECT imgg01,imgg02,imgg03,imgg04,imgg09,imkk09,imkk05,imkk06",
               "  FROM imgg_file,ima_file, OUTER imkk_file ",
               " WHERE ",ls_wc CLIPPED," AND imgg01=ima01",
               "   AND imgg_file.imgg01=imkk_file.imkk01 AND imgg_file.imgg02=imkk_file.imkk02",
               "   AND imgg_file.imgg03=imkk_file.imkk03 AND imgg_file.imgg04=imkk_file.imkk04",
               "   AND imgg_file.imgg09=imkk_file.imkk10"
     IF chkimk='N' THEN
        LET l_sql = l_sql CLIPPED," AND imkk_file.imkk05=",g_yy," AND imkk_file.imkk06=",g_mm,
                    " ORDER BY imgg01,imgg02,imgg03,imgg04,imgg09"
     ELSE 
        LET l_sql = l_sql CLIPPED," AND imkk_file.imkk05 BETWEEN ",g_yy," AND ",b_yy,
                    " ORDER BY imgg01,imgg02,imgg03,imgg04,imgg09"
     END IF 
     PREPARE aimp611_prepare2 FROM l_sql
     IF STATUS  THEN CALL cl_err('prep:',STATUS,1) 
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM 
     END IF

     DECLARE aimp611_curs2 CURSOR FOR aimp611_prepare2

     FOREACH aimp611_curs2 INTO sr2.*
       IF STATUS THEN CALL s_errmsg('','','foreach:',STATUS,1) EXIT FOREACH END IF
       #庫存年月>檢查統計檔截止年度期別-1 則不再查詢
       IF chkimk='Y' AND
         (( sr2.imkk05=g_yy AND sr2.imkk06 < g_mm ) OR    
         ( sr2.imkk05=b_yy AND sr2.imkk06 > b_mm-1 )) THEN 
          CONTINUE FOREACH 
       END IF 
       IF sr2.imgg01 <> l_img01 OR sr2.imgg02 <> l_img02 OR
          sr2.imgg03 <> l_img03 OR sr2.imgg04 <> l_img04 THEN
          LET l_imgg10=0
          SELECT SUM(imgg10*imgg211) INTO l_imgg10 FROM imgg_file 
           WHERE imgg01=l_img01  AND imgg02=l_img02 
             AND imgg03=l_img03  AND imgg04=l_img04
          IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF   
          LET t_img10=0
          SELECT img10 INTO t_img10 FROM img_file
           WHERE img01=l_img01  AND img02=l_img02
             AND img03=l_img03  AND img04=l_img04
          IF cl_null(t_img10) THEN LET t_img10=0 END IF
          IF t_img10 <> l_imgg10 THEN 
             CALL cl_getmsg('aim-424',g_lang) RETURNING l_msg
             LET l_msg = l_msg CLIPPED,t_img10 USING '----------','-',
                                      l_imgg10 USING '##########'
             OUTPUT TO REPORT aimp611_rep(sr2.imgg01,l_msg)
          END IF
       END IF
       LET l_img01=sr2.imgg01
       LET l_img02=sr2.imgg02
       LET l_img03=sr2.imgg03
       LET l_img04=sr2.imgg04
       
       LET g_count=g_count+1

       IF g_bgjob = 'N' THEN
           MESSAGE sr2.imgg01 CLIPPED,' ',sr2.imgg02 CLIPPED,' ',
                   sr2.imgg03 CLIPPED,' ',sr2.imgg04 CLIPPED,' ',
                   sr2.imgg09 CLIPPED,' ',g_count
           CALL ui.Interface.refresh()
       END IF
 
       IF cl_null(sr2.imkk09) THEN LET sr2.imkk09=0 END IF

       ####---庫存異動     
       CALL s_azm(sr2.imkk05,sr2.imkk06) RETURNING g_chr,g_bdate2,g_edate2

       #讀取庫存異動明細資料
       DECLARE p611_c3 CURSOR FOR
         SELECT rowid,tlff_file.* FROM tlff_file
          WHERE tlff01 = sr2.imgg01
            AND tlff06 > g_edate2
            AND ( tlff907 <> 0 ) AND tlff902 = sr2.imgg02 
            AND tlff903 = sr2.imgg03 AND tlff904 = sr2.imgg04
            AND tlff220 = sr2.imgg09
          ORDER BY tlff06,tlff08
    #  LET l_bal = sr2.imkk09  #本期期初量=上期期末庫存量
       LET l_bal=0

       FOREACH p611_c3 INTO l_rowid,xx.*
         IF STATUS THEN CALL s_errmsg('','','foreach2:',STATUS,1) EXIT FOREACH END IF
         IF xx.tlff10 IS NULL THEN LET xx.tlff10=0 END IF
         IF xx.tlff12 IS NULL OR xx.tlff12=0 THEN LET xx.tlff12=1 END IF
         IF xx.tlff031=sr2.imgg02 AND xx.tlff032=sr2.imgg03 AND xx.tlff033=sr2.imgg04
            AND xx.tlff13 != 'apmt1071'
            THEN LET xx.tlff10  = xx.tlff10 *  1
            ELSE LET xx.tlff10  = xx.tlff10 * -1
         END IF
         LET l_bal = l_bal + xx.tlff10 #*xx.tlff12 都是庫存單位,不用轉換率
       END FOREACH

       SELECT imgg10 INTO l_imgg10 FROM imgg_file       #庫存總數量
             WHERE imgg01=sr2.imgg01 AND imgg02=sr2.imgg02
               AND imgg03=sr2.imgg03 AND imgg04=sr2.imgg04
               AND imgg09=sr2.imgg09
       IF SQLCA.sqlcode THEN LET l_imgg10 = 0 END IF
       LET l_imgg10=l_imgg10 - l_bal 
       IF sr2.imkk09 != l_imgg10 THEN
          CALL cl_getmsg('aim-423',g_lang) RETURNING l_msg     
          LET l_msg=sr2.imkk05 USING '####','/'
          LET l_msg=l_msg CLIPPED,sr2.imkk06 USING '&&' 
          LET l_msg=l_msg CLIPPED,' ',t_msg CLIPPED
          LET l_msg=l_msg CLIPPED,' ',sr2.imgg02
          LET l_msg=l_msg CLIPPED,' ',sr2.imgg03
          LET l_msg=l_msg CLIPPED,' ',sr2.imgg04
          LET l_msg=l_msg CLIPPED,' ',sr2.imgg04
          LET l_msg=l_msg CLIPPED,' ',l_imgg10  USING '----------','-'
          LET l_msg=l_msg CLIPPED,' ',sr2.imkk09 USING '----------'
          #MOD-4A0048(end)
          OUTPUT TO REPORT aimp611_rep(sr2.imgg01,l_msg)
       END IF
     END FOREACH
     LET l_imgg10=0
     SELECT SUM(imgg10*imgg211) INTO l_imgg10 FROM imgg_file 
      WHERE imgg01=l_img01  AND imgg02=l_img02 
        AND imgg03=l_img03  AND imgg04=l_img04
     IF cl_null(l_imgg10) THEN LET l_imgg10 = 0 END IF   
     LET t_img10=0
     SELECT img10 INTO t_img10 FROM img_file
      WHERE img01=l_img01  AND img02=l_img02
        AND img03=l_img03  AND img04=l_img04
     IF cl_null(t_img10) THEN LET t_img10=0 END IF
     IF t_img10 <> l_imgg10 THEN 
        CALL cl_getmsg('aim-424',g_lang) RETURNING l_msg
        LET l_msg = l_msg CLIPPED,t_img10 USING '----------','-',
                                 l_imgg10 USING '##########'
        OUTPUT TO REPORT aimp611_rep(sr2.imgg01,l_msg)
     END IF
 
END FUNCTION
#No.FUN-540025  --end
