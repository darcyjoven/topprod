# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: anmp650.4gl
# Descriptions...: 投資資料統計資料更新作業
# Date & Author..: 02/01/07/ by faith
# Modify.........: No.MOD-510178 05/02/02 By Kitty 加上投資單號開窗
# Modify.........: No.FUN-590111 05/10/03 By Nicola 計算欄位修正
# Modify.........: No.FUN-570127 06/03/08 By yiting 批次背景執行
# Modify.........: No.FUN-660148 06/06/21 By Hellen cl_err --> cl_err3
# Modify.........: No.FUN-680088 06/08/29 By Ray    多帳套處理
# Modify.........: No.FUN-680107 06/09/06 By Hellen 欄位類型修改
# Modify.........: No.FUN-690117 06/10/16 By cheunl cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0082 06/11/06 By dxfwo l_time轉g_time
# Modify.........: No.MOD-710065 07/01/10 By Smapmin 修改年月Default值
# Modify.........: No.FUN-710024 07/01/17 By Jackho 增加批處理錯誤統整功能
# Modify.........: No.FUN-980005 09/08/12 By TSD.Martin GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A30012 10/03/04 By Carrier 1.单据未审核则不计算 2.计算数量修正
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_gsk               RECORD LIKE gsk_file.*
DEFINE tm_wc,l_sql         LIKE type_file.chr1000  #No.FUN-680107 VARCHAR(100)
DEFINE g_flag              LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE g_last_yy,g_last_mm LIKE type_file.num5     #NO.FUN-680107 SMALLINT
DEFINE g_this_yy,g_this_mm LIKE type_file.num5     #NO.FUN-680107 SMALLINT
DEFINE g_next_yy,g_next_mm LIKE type_file.num5     #NO.FUN-680107 SMALLINT
DEFINE g_bdate,g_edate     LIKE type_file.dat      #NO.FUN-680107 DATE
DEFINE open_flag           LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE g_flag1             LIKE type_file.chr1     #No.FUN-680107 VARCHAR(1)
DEFINE g_vender            LIKE gsb_file.gsb01
DEFINE g_cnt               LIKE type_file.num5     #NO.FUN-680107 SMALLINT
DEFINE g_change_lang       LIKE type_file.num5     # Prog. Version..: '5.30.06-13.03.12(01) #是否有做語言切換 No.FUN-570127
DEFINE p_row,p_col         LIKE type_file.num5     #No.FUN-680107 SMALLINT
 
MAIN
#     DEFINE    l_time LIKE type_file.chr8           #No.FUN-6A0082
    DEFINE l_flag       LIKE type_file.chr1        #No.FUN-570127 #No.FUN-680107 VARCHAR(1)
    OPTIONS
        INPUT NO WRAP
    DEFER INTERRUPT
 
   #->No.FUN-570127 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm_wc             = ARG_VAL(1)
   LET g_this_yy = ARG_VAL(2)    #背景作業
   LET g_this_mm = ARG_VAL(3)    #背景作業
   LET g_bgjob = ARG_VAL(4)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #->No.FUN-570127 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ANM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690117
 
#NO.FUN-570127 mark--
#   OPEN WINDOW p650 AT p_row,p_col WITH FORM "anm/42f/anmp650"
#         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
#   CALL cl_ui_init()
 
#   CALL cl_opmsg('z')
 
#   CALL p650_ask()
#   CLOSE WINDOW p650
#NO.FUN-570127 mark--
 
#NO.FUN-570127 start--
   WHILE TRUE
    IF g_bgjob = "N" THEN
       CALL p650_ask()
       IF cl_sure(18,20) THEN
          LET g_success = 'Y'
          BEGIN WORK
          CALL p650()
          CALL s_showmsg()          #No.FUN-710024
          IF g_success = 'Y' THEN
             COMMIT WORK
             CALL cl_end2(1) RETURNING l_flag
          ELSE
             ROLLBACK WORK
             CALL cl_end2(2) RETURNING l_flag
          END IF
          IF l_flag THEN
               CONTINUE WHILE
          ELSE CLOSE WINDOW p650
               EXIT WHILE
          END IF
       ELSE
          CONTINUE WHILE
       END IF
    ELSE
       LET g_success = 'Y'
       BEGIN WORK
       CALL p650()
       CALL s_showmsg()          #No.FUN-710024
       IF g_success = "Y" THEN
            COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
    END IF
 END WHILE
#->No.FUN-570127 ---end---
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
END MAIN
 
FUNCTION p650_ask()
   DEFINE   l_bdate   LIKE type_file.chr8    #NO.FUN-680107 VARCHAR(08)
   DEFINE   l_year    LIKE gsk_file.gsk02
   DEFINE   lc_cmd    LIKE type_file.chr1000 #No.FUN-570127 #NO.FUN-680107 VARCHAR(500)
 
#NO.FUN-570127 start--
   OPEN WINDOW p650 AT p_row,p_col WITH FORM "anm/42f/anmp650"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   CALL cl_opmsg('z')
#NO.FUN-570127 end---
 
    WHILE TRUE
       CLEAR FORM  #add by faith 020122
       #-----MOD-710065---------
       #LET g_this_yy = g_nmz.nmz41
       #LET g_this_mm = g_nmz.nmz42
       #DISPLAY g_nmz.nmz41, g_nmz.nmz42 TO y1,m1 
       LET g_this_yy = YEAR(g_today)
       LET g_this_mm = MONTH(g_today)
       DISPLAY g_this_yy,g_this_mm TO y1,m1 
       #-----END MOD-710065-----
       LET g_bgjob = 'N'                         #NO.FUN-570127 
##     No: 2400 modify 1998/08/18 ---------
 
       #INPUT BY NAME g_this_yy, g_this_mm WITHOUT DEFAULTS
       INPUT BY NAME g_this_yy, g_this_mm,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570127
 
          AFTER FIELD g_this_mm    # 月份
             IF NOT  cl_null(g_this_mm) THEN
                IF (g_this_mm >13) OR (g_this_mm <=0) THEN
                   CALL cl_err(g_this_mm,'anm-088',0)
                   #LET g_this_mm = g_nmz.nmz42   #MOD-710065
                   LET g_this_mm = MONTH(g_today)   #MOD-710065
                   NEXT FIELD g_this_mm
                END IF
             END IF
 
          ON ACTION CONTROLR
             CALL cl_show_req_fields()
 
          ON ACTION CONTROLG
             CALL cl_cmdask()
 
          ON ACTION locale                    #genero
#             LET g_action_choice = "locale"
#             CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
              LET g_change_lang = TRUE                  #no.FUN-570127
              EXIT INPUT
 
          ON IDLE g_idle_seconds
             CALL cl_on_idle()
             CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
 
          ON ACTION exit  #加離開功能genero
             LET INT_FLAG = 1
             EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
       END INPUT
 
#NO.FUN-570127 start---
#       IF g_action_choice = "locale" THEN  #genero
#          LET g_action_choice = ""
#          CALL cl_dynamic_locale()
#          CONTINUE WHILE
#       END IF
 
       IF g_change_lang THEN
          LET g_change_lang = FALSE
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
          CONTINUE WHILE
       END IF
 
       IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p650
          CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
          EXIT PROGRAM
#          EXIT WHILE
       END IF
#NO.FUN-570127 end-----
 
       CONSTRUCT BY NAME tm_wc ON gsb01
 
        #No.MOD-510178 add
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
        ON ACTION CONTROLP
            CASE
                WHEN INFIELD(gsb01)
                     CALL cl_init_qry_var()
                     LET g_qryparam.form = "q_gsb"
                     LET g_qryparam.state= "c"
                     #LET g_qryparam.default1 = gsb01
                     CALL cl_create_qry() RETURNING g_qryparam.multiret
                     DISPLAY g_qryparam.multiret TO gsb01
                OTHERWISE EXIT CASE
            END CASE
       #add end
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
         ON ACTION exit              #加離開功能genero
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      ON ACTION locale
        #->No.FUN-570127 --start--
           LET g_change_lang = TRUE
           EXIT CONSTRUCT
        #->No.FUN-570127 ---end---
 
       END CONSTRUCT
 
#NO.FUN-570127 start--
#       IF INT_FLAG THEN
#          LET INT_FLAG = 0
#          EXIT WHILE
#      END IF
 
#       CALL p650()
#       IF g_success = 'Y' THEN
#          COMMIT WORK
#          CALL cl_end2(1) RETURNING g_flag        #批次作業正確結束
#       ELSE
#          ROLLBACK WORK
#          CALL cl_end2(2) RETURNING g_flag        #批次作業失敗
#       END IF
#       IF g_flag THEN
#          CONTINUE WHILE
#       ELSE
#         EXIT WHILE
#       END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p650
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
         EXIT PROGRAM
      END IF
 
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
 
    IF g_bgjob = "Y" THEN
       SELECT zz08 INTO lc_cmd FROM zz_file
        WHERE zz01 = "anmp650"
       IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('anmp650','9031',1)   
       ELSE
          LET tm_wc=cl_replace_str(tm_wc, "'", "\"")
          LET lc_cmd = lc_cmd CLIPPED,
                       " '",tm_wc CLIPPED ,"'",
                       " '",g_this_yy CLIPPED,"'",
                       " '",g_this_mm CLIPPED,"'",
                       " '",g_bgjob CLIPPED,"'"
          CALL cl_cmdat('anmp650',g_time,lc_cmd CLIPPED)
       END IF
       CLOSE WINDOW p650
       CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690117
       EXIT PROGRAM
    END IF
    EXIT WHILE
#->No.FUN-570127 ---end---
  END WHILE
 
END FUNCTION
 
FUNCTION p650()
 
#    BEGIN WORK        #No.FUN-710024 mark
 
    #求出上期年月資料
    IF g_this_mm > 1 THEN
       LET g_last_yy = g_this_yy
       LET g_last_mm = g_this_mm - 1
    ELSE
       LET g_last_yy = g_this_yy - 1
       IF g_aza.aza02 = '1' THEN
          LET g_last_mm = 12
       ELSE
          LET g_last_mm = 13
       END IF
    END IF
    #No.FUN-680088 --begin
    IF g_aza.aza63 = 'Y' THEN
       CALL s_azmm(g_this_yy,g_this_mm,g_nmz.nmz02p,g_nmz.nmz02b) RETURNING g_flag1,g_bdate,g_edate
    ELSE
       CALL s_azm(g_this_yy,g_this_mm) RETURNING g_flag1,g_bdate,g_edate
    END IF
    #No.FUN-680088 --end
  # SELECT MIN(azn01),MAX(azn01) INTO g_bdate,g_edate FROM azn_file
  #        WHERE azn02 = g_this_yy AND azn04 = g_this_mm
 
     #Begin:FUN-980030
     #     IF g_priv2='4' THEN                           #只能使用自己的資料
     #         LET tm_wc = tm_wc clipped," AND gsbuser = '",g_user,"'"
     #     END IF
     #     IF g_priv3='4' THEN                           #只能使用相同群的資料
     #         LET tm_wc = tm_wc clipped," AND gsbgrup MATCHES '",g_grup CLIPPED,"*'"
     #     END IF
 
     #     IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
     #         LET tm_wc = tm_wc clipped," AND gsbgrup IN ",cl_chk_tgrup_list()
     #     END IF
     LET tm_wc = tm_wc CLIPPED,cl_get_extra_cond('gsbuser', 'gsbgrup')
     #End:FUN-980030
 
 
     LET g_success = 'Y'
 
     LET l_sql = "SELECT gsb01 FROM gsb_file ",
                 " WHERE ",tm_wc CLIPPED,
                 "   AND gsbconf = 'Y'"        #No.TQC-A30012
     PREPARE p650_p1 FROM l_sql
     IF SQLCA.sqlcode THEN
        CALL cl_err('prepare:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
 
     DECLARE p650_c1 CURSOR FOR p650_p1
     IF SQLCA.sqlcode THEN
        CALL cl_err('decalre p650_cl:',SQLCA.sqlcode,1)
        LET g_success = 'N'
        RETURN
     END IF
 
 
     LET g_vender =' '   #add by faith 020122
     LET g_cnt = 0
     CALL s_showmsg_init()   #No.FUN-710024
     FOREACH p650_c1 INTO g_vender    #投資單號
       IF SQLCA.sqlcode THEN
#No.FUN-710024--begin
#          CALL cl_err('p650_c1',SQLCA.sqlcode,1)
          CALL s_errmsg('','','p650_c1',SQLCA.sqlcode,1) 
#No.FUN-710024--end
          LET g_success = 'N'
          RETURN
       END IF
 
       #先將投資資料統計檔gsk_file中年度[gsk02]及月份[gsk03]
       #等於月結年度的資料刪除
 
       DELETE FROM gsk_file
        WHERE gsk01 = g_vender
          AND gsk02 = g_this_yy
          AND gsk03 = g_this_mm
 
       INITIALIZE g_gsk.* TO NULL
       MESSAGE 'fetch vender:',g_vender
       CALL ui.Interface.refresh()
 
       CALL p650_last_saving()   #上期統計資料
       CALL p650_this_dc_tot()   #本期異動資料
 
       LET g_gsk.gsk01 = g_vender
       LET g_gsk.gsk02 = g_this_yy
       LET g_gsk.gsk03 = g_this_mm
       #FUN-980005  add legal 
       LET g_gsk.gsklegal = g_legal 
       #FUN-980005  end legal 
       INSERT INTO gsk_file VALUES (g_gsk.*)
       IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#         CALL cl_err('ins gsk',STATUS,1)   #No.FUN-660148
#No.FUN-710024--begin
#          CALL cl_err3("ins","gsk_file",g_gsk.gsk01,g_gsk.gsk02,STATUS,"","ins gsk",1) #No.FUN-660148
          LET g_showmsg=g_gsk.gsk01,"/",g_gsk.gsk02,"/",g_gsk.gsk03
          CALL s_errmsg('gsk01,gsk02,gsk03',g_showmsg,'ins gsk',STATUS,1)
          LET g_success = 'N'
#          EXIT FOREACH
          CONTINUE FOREACH
#No.FUN-710024--end
       END IF
       LET g_cnt = g_cnt + 1
    END FOREACH
 
    IF g_cnt = 0 THEN
#No.FUN-710024--begin
#       CALL cl_err('','aap-129',1)
       CALL s_errmsg('','','','aap-129',1)
#No.FUN-710024--end
       LET g_success = 'N'
    END IF
 
END FUNCTION
 
#上期統計資料
FUNCTION p650_last_saving()
       SELECT * INTO g_gsk.* FROM gsk_file
             WHERE gsk01 = g_vender
               AND gsk02 = g_last_yy
               AND gsk03 = g_last_mm
       IF STATUS THEN
          LET g_gsk.gsk04 = 0    #留倉數量
          LET g_gsk.gsk05 = 0    #留倉金額
       END IF
END FUNCTION
 
#本期異動
FUNCTION p650_this_dc_tot()
    DEFINE l_gsh05,l_gse05 LIKE gsh_file.gsh05,   #No.TQC-A30012
           l_gsh06,l_gse06 LIKE gse_file.gse06    #No:FUN-590111
 
       #投資購買異動數量,金額
       SELECT SUM(gsh05),SUM(gsh06) INTO l_gsh05,l_gsh06   #No:FUN-590111  #No.TQC-A30012
         FROM gsh_file
        WHERE gsh03 = g_vender
          AND gsh02 BETWEEN g_bdate AND g_edate
          AND gshconf = 'Y'         #No.TQC-A30012

       #投資出售異動數量,金額
       SELECT SUM(gse05),SUM(gse06) INTO l_gse05,l_gse06   #No:FUN-590111  #No.TQC-A30012
         FROM gse_file
        WHERE gse03 = g_vender
          AND gse02 BETWEEN g_bdate AND g_edate
          AND gseconf = 'Y'         #No.TQC-A30012

       #-----No:FUN-590111-----
       IF cl_null(l_gsh05) THEN LET l_gsh05 = 0 END IF  #No.TQC-A30012
       IF cl_null(l_gsh06) THEN LET l_gsh06 = 0 END IF
       IF cl_null(l_gse05) THEN LET l_gse05 = 0 END IF  #No.TQC-A30012
       IF cl_null(l_gse06) THEN LET l_gse06 = 0 END IF

       LET g_gsk.gsk04=g_gsk.gsk04+l_gsh05-l_gse05      #No.TQC-A30012
       LET g_gsk.gsk05=g_gsk.gsk05+l_gsh06-l_gse06
       #-----No:FUN-590111 END-----

END FUNCTION
