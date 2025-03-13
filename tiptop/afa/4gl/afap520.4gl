# Prog. Version..: '5.30.07-13.05.31(00010)'     #
#
# Pattern name...: afap520.4gl
# Descriptions...: 保費分錄底稿產生作業
# Date & Author..: 97/08/26 By Sophia
# Modify.........: No.MOD-490176 93/09/22 By Yuna 
#                    1.若單據編號空白應該不可過,且應該要先default
#                    2.單據編號若重複,應加入訊息警告是否重新產生
#                    3.判斷若傳票編號(fdd06)不為空白,則表示已拋轉過不可再拋轉     
# Modify.........: No.FUN-550034 05/05/16 By jackie 單據編號加大 
# Modify.........: No.FUN-570144 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-710028 07/02/03 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0005 09/10/07 By Smapmin 異動碼預設為NULL而非一個空白
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2) 
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
# Modify.........: No:FUN-B40056 11/05/11 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料 
# Modify.........: No:MOD-B80280 11/08/24 By Sarah 異動日npp02要改為該期的最後一天
# Modify.........: No:MOD-B80302 11/08/30 By Dido 單別會與10類衝突,因此單別前增加12區隔
# Modify.........: No.FUN-D10065 13/01/17 By lujh 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No.FUN-D40118 13/05/20 By zhangweib 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_wc,g_sql     STRING  #No.FUN-580092 HCN
DEFINE tm RECORD
             fdd03    LIKE fdd_file.fdd03,
             fdd033   LIKE fdd_file.fdd033,
             v_no     LIKE npp_file.npp01
       END RECORD
DEFINE g_fdd   RECORD LIKE fdd_file.*
DEFINE g_bookno       LIKE aag_file.aag00      #FUN-D10065 add
DEFINE g_npp   RECORD LIKE npp_file.*
DEFINE g_npq   RECORD LIKE npq_file.*
DEFINE g_t1           LIKE type_file.chr5      #No.FUN-550034          #No.FUN-680070 VARCHAR(5)
DEFINE l_flag         LIKE type_file.chr1      #No.FUN-680070 VARCHAR(1)
DEFINE t_date         LIKE type_file.dat       #No.FUN-680070 DATE
DEFINE p_row,p_col    LIKE type_file.num5      #No.FUN-680070 SMALLINT
DEFINE g_flag         LIKE type_file.chr1,     #No.FUN-570144          #No.FUN-680070 VARCHAR(1)
       g_change_lang  LIKE type_file.chr1      #是否有做語言切換       #No.FUN-570144       #No.FUN-680070 VARCHAR(01)
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8          #No.FUN-6A0069
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #->No.FUN-570144 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc       = ARG_VAL(1)
   LET tm.fdd03   = ARG_VAL(2)
   LET tm.fdd033  = ARG_VAL(3)
   LET tm.v_no    = ARG_VAL(4)
   LET g_bgjob    = ARG_VAL(5)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #->No.FUN-570144 ---end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570144 MARK---
#   OPEN WINDOW p520_w AT p_row,p_col WITH FORM "afa/42f/afap520"
################################################################################
# START genero shell script ADD
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
#NO.FUN-570144 MARK---                              
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
 WHILE TRUE 
#NO.FUN-570144 START---
#   BEGIN WORK 
   LET g_success='Y'
   IF g_bgjob = "N" THEN
   CALL p520()
   IF cl_sure(18,20) THEN
         LET g_success = 'Y'
         BEGIN WORK
         #No.FUN-680028 --begin
         CALL p520_go('0')
 #       IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN  
         IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #NO.FUN-AB0088 
            CALL p520_go('1')
         END IF  
         CALL s_showmsg()   #No.FUN-710028
         IF g_success = 'Y' THEN
            COMMIT WORK
            CALL cl_end2(1) RETURNING g_flag
         ELSE
            ROLLBACK WORK
            CALL cl_end2(2) RETURNING g_flag
         END IF
        IF g_flag THEN
           CONTINUE WHILE
        ELSE
           CLOSE WINDOW p520_w
           EXIT WHILE
        END IF
    ELSE
        CONTINUE WHILE
    END IF
  ELSE
    BEGIN WORK
    LET g_success = 'Y'
    #No.FUN-680028 --begin
    CALL p520_go('0')
#   IF g_aza.aza63 = 'Y' AND g_success = 'Y' THEN   
    IF g_faa.faa31 = 'Y' AND g_success = 'Y' THEN   #NO.FUN-AB0088 
       CALL p520_go('1')
    END IF  
    #No.FUN-680028 --end
     IF g_success = "Y" THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    CALL cl_batch_bg_javamail(g_success)
    EXIT WHILE
   END IF
 END WHILE
#->No.FUN-570144 ---end---
 
#NO.FUN-570144 MARK----
#   CALL p520()
#   IF g_success = 'Y' THEN 
#     COMMIT WORK 
#     # CALL cl_cmmsg(1)
#      CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#   ELSE 
#      ROLLBACK WORK 
#     # CALL cl_rbmsg(1)
#      CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#   END IF
#   IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF
# END WHILE
# CALL cl_end(0,0)
# CLOSE WINDOW p520_w
#NO.FUN-570144 MARK----
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
END MAIN
 
FUNCTION p520()
   DEFINE   l_name   LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
   DEFINE   l_n      LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE   l_str    LIKE type_file.chr20        #No.FUN-680070 VARCHAR(20)
   DEFINE   l_cmd    LIKE type_file.chr1000      #No.FUN-680070 VARCHAR(30)
   DEFINE   l_cnt    LIKE type_file.num5         #No.FUN-680070 SMALLINT
   DEFINE   l_yy     LIKE type_file.chr4         #No.FUN-680070 VARCHAR(04)
   DEFINE   l_mm     LIKE type_file.chr3         #No.FUN-680070 VARCHAR(02)
   DEFINE   lc_cmd   LIKE type_file.chr1000      #No.FUN-570144 #No.FUN-680070 VARCHAR(500)
 
  #->No.FUN-570144 --start--
  LET p_row = 5 LET p_col = 28
 
  OPEN WINDOW p520_w AT p_row,p_col WITH FORM "afa/42f/afap520"
    ATTRIBUTE (STYLE = g_win_style)
 
  CALL cl_ui_init()
  CALL cl_opmsg('z')
 
  #->No.FUN-570144 ---end---
 
  #LET tm.v_no   = 'WBB'
   CLEAR FORM
   CALL cl_opmsg('p')
 
   WHILE TRUE
      CONSTRUCT BY NAME g_wc ON fdd02,fdd022,fdd01 
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
#           CALL cl_dynamic_locale()
#          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
            LET g_change_lang = TRUE                 #->No.FUN-570144
            EXIT CONSTRUCT
 
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
  LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fdduser', 'fddgrup') #FUN-980030
 
#NO.FUN-570144 START---
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         EXIT WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW p110_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
      END IF
 
#      IF INT_FLAG THEN
#          LET g_success='N'   #No.MOD-490176
#        RETURN 
#      END IF
#NO.FUN-570144 END-----
 
      IF g_wc = ' 1=1' THEN
         CALL cl_err('','9046',0)
         CONTINUE WHILE
      ELSE
         EXIT WHILE
      END IF
   END WHILE
   
   CALL cl_opmsg('p')
 
   SELECT faa07,faa08 INTO tm.fdd03,tm.fdd033 FROM faa_file WHERE faa00='0'
    #--No.MOD-490176
   LET l_yy = tm.fdd03
   LET l_mm = tm.fdd033 using '&&'
  #LET l_str= l_yy,l_mm,'0001'        #MOD-B80302 mark
   LET l_str= '12',l_yy,l_mm,'0001'   #MOD-B80302
   LET tm.v_no=l_str
   DISPLAY BY NAME tm.v_no
   #--END
   LET g_bgjob = 'N'  #NO.FUN-570144
 
   WHILE TRUE   #NO.FUN-570144 
   #INPUT BY NAME tm.fdd03,tm.fdd033,tm.v_no WITHOUT DEFAULTS 
   INPUT BY NAME tm.fdd03,tm.fdd033,tm.v_no,g_bgjob WITHOUT DEFAULTS   #NO.FUN-570144
 
      AFTER FIELD fdd03
         IF cl_null(tm.fdd03) THEN
            NEXT FIELD fdd03 
         END IF
 
      AFTER FIELD fdd033
         IF cl_null(tm.fdd033) THEN
            NEXT FIELD fdd033
         END IF
         IF tm.fdd033 > 12 OR tm.fdd033 < 1 THEN
            NEXT FIELD fdd03
         END IF
   
      BEFORE FIELD v_no   # default value for v_no by 12-yyyymmxxxx
      #   IF cl_null(tm.v_no) THEN 
            LET l_yy = tm.fdd03
            LET l_mm = tm.fdd033 using '&&'
           #LET l_str= l_yy,l_mm,'0001'        #MOD-B80302 mark
            LET l_str= '12',l_yy,l_mm,'0001'   #MOD-B80302
            LET tm.v_no=l_str 
            DISPLAY BY NAME tm.v_no 
      #   END IF
      AFTER FIELD v_no   # default value for v_no by 12-yyyymmxxxx
         IF cl_null(tm.v_no) THEN
            NEXT FIELD FORMONLY.v_no
         END IF
         #-->check 是否存在
         SELECT count(*) INTO l_cnt FROM npp_file
          WHERE npp01 = tm.v_no AND nppsys = 'FA' and npp00 = 12
            AND npp011 = 1
            AND npptype = '0'     #No.FUN-680028
         IF cl_null(l_cnt) THEN
            LET l_cnt = 0
         END IF
         IF l_cnt > 0 THEN 
            CALL cl_err(tm.v_no,'afa-368',0)
         END IF 
{
      AFTER FIELD v_no  
         IF cl_null(tm.v_no) THEN
            NEXT FIELD v_no 
         END IF
#         LET g_t1=tm.v_no[1,3]
         CALL cl_set_docno_format("g_t1")   #No.FUN-550034
   #     CALL s_mfgslip(g_t1,'asf','3')
   #     IF NOT cl_null(g_errno) THEN                        #抱歉, 有問題
   #        CALL cl_err(g_t1,g_errno,0) NEXT FIELD iss_no
   #     END IF
         SELECT COUNT(*) INTO l_n FROM fah_file WHERE fahslip=tm.v_no
         IF l_n = 0 THEN
            CALL cl_err(tm.v_no,'afa-095',0) NEXT FIELD v_no
         END IF
         LET t_date   = MDY(l_mm,1,l_yy)
         CALL s_afaauno(tm.v_no,t_date) RETURNING g_i,tm.v_no
         IF g_i THEN
            NEXT FIELD v_no
         END IF
         DISPLAY BY NAME tm.v_no
}
   #  ON ACTION CONTROLP
   #     CASE WHEN INFIELD(v_no)
   #        CALL q_fah(FALSE,FALSE,tm.v_no,'') RETURNING tm.v_no 
   #        CALL FGL_DIALOG_SETBUFFER( tm.v_no )
   #        DISPLAY BY NAME tm.v_no
   #     END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         call cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      #->No.FUN-570144 --start--
      ON ACTION locale
         LET g_change_lang = TRUE
         EXIT INPUT
      #->No.FUN-570144 --end--
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
   END INPUT
 
#NO.FUN-570144 start---
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin) #NO.FUN-570112 MARK
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
          LET INT_FLAG = 0
          CLOSE WINDOW p110_w
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM
      END IF
 
#   IF INT_FLAG THEN
#      RETURN
#   END IF
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'afap520'
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('afap520','9031',1)   
     ELSE
        LET g_wc = cl_replace_str(g_wc,"'","\"")
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",g_wc CLIPPED,"'",
                     " '",tm.fdd03 CLIPPED,"'",
                     " '",tm.fdd033 CLIPPED,"'",
                     " '",tm.v_no CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('afap520',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p520_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
  EXIT WHILE
END WHILE
END FUNCTION
#NO.FUN-570144 end-----------
 
FUNCTION p520_go(p_npptype)
   DEFINE p_npptype   LIKE npp_file.npptype     #No.FUN-680028
   DEFINE l_name      LIKE type_file.chr20      #No.FUN-680070 VARCHAR(20)
   DEFINE l_n         LIKE type_file.num5       #No.FUN-680070 SMALLINT
   DEFINE l_str       LIKE type_file.chr20      #No.FUN-680070 VARCHAR(20)
   DEFINE l_cnt       LIKE type_file.num5       #No.FUN-680070 SMALLINT
   DEFINE l_cmd       LIKE type_file.chr1000    #No.FUN-680070 VARCHAR(30)
   DEFINE l_bdate     LIKE type_file.dat        #MOD-B80280 add
   DEFINE l_edate     LIKE type_file.dat        #MOD-B80280 add
 
    #--No.MOD-490176 
   SELECT count(*) INTO l_cnt FROM npp_file
      WHERE npp01 = tm.v_no AND nppsys = 'FA' and npp00 = 12
      AND npp011 = 1
      AND npptype = p_npptype     #No.FUN-680028
   IF cl_null(l_cnt) THEN
      LET l_cnt = 0
   END IF
   IF l_cnt > 0 THEN
      CALL cl_err(tm.v_no,'afa-368',0)
      IF p_npptype = '0' THEN   #No.FUN-680028
         IF NOT cl_confirm('afa-367') THEN
            LET g_success='N'
            RETURN
         END IF
      END IF   #No.FUN-680028
   END IF
   #--END
 
   #IF NOT cl_sure(0,0) THEN  #NO.FUN-570144 MARK
   #   RETURN
   #END IF
   #---->(1-1)insert 單頭
   LET g_npp.nppsys ='FA'
   LET g_npp.npp00  = 12  
   LET g_npp.npp01  =tm.v_no
   LET g_npp.npp011 = 1
  #LET g_npp.npp02  = g_today                                  #MOD-B80280 mark
   CALL s_azn01(tm.fdd03,tm.fdd033) RETURNING l_bdate,l_edate  #MOD-B80280 add
   LET g_npp.npp02  = l_edate                                  #MOD-B80280 add 
   LET g_npp.npp03  = NULL
   LET g_npp.nppglno= NULL
   LET g_npp.npptype = p_npptype     #No.FUN-680028
   LET g_npp.npplegal= g_legal       #FUN-980003 add
   DELETE FROM npp_file WHERE nppsys = 'FA' and npp00 = 12
                          and npp01= tm.v_no and npp011 = 1
                          AND npptype = p_npptype     #No.FUN-680028
   INSERT INTO npp_file VALUES(g_npp.*)
   IF SQLCA.SQLERRD[3]=0 OR STATUS THEN 
      LET g_success = 'N' 
#     CALL cl_err('ins npp:',STATUS,0)    #No.FUN-660136
      CALL cl_err3("ins","npp_file",g_npp.npp01,g_npp.nppsys,STATUS,"","ins npp:",0)   #No.FUN-660136
      RETURN
   END IF
   IF g_bgjob = 'N' THEN  #NO.FUN-570144 
       message  g_npp.npp01
       CALL ui.Interface.refresh()
   END IF
   #---->(1-1)insert 單身
   DELETE FROM npq_file WHERE npqsys = 'FA' and npq00 = 12
                          and npq01= tm.v_no and npq011 = 1
                          AND npqtype = p_npptype     #No.FUN-680028
                                              
   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = tm.v_no
   #FUN-B40056--add--end--  

   LET g_npq.npqsys ='FA'
   LET g_npq.npq00  = 12
   LET g_npq.npq01  =tm.v_no
   LET g_npq.npq011 = 1
   LET g_npq.npq02  = 0 #No.FUN-680028  
   LET g_npq.npqtype = p_npptype     #No.FUN-680028
   LET g_npq.npqlegal= g_legal       #FUN-980003 add
 
   LET g_sql="SELECT * FROM fdd_file",
            " WHERE ",g_wc CLIPPED,
            "  AND fdd03 = '",tm.fdd03,"'",
            "  AND fdd033= '",tm.fdd033,"'",
             "  AND (fdd06 IS NULL OR fdd06 = '')",   #No.MOD-490176
            "  ORDER BY fdd08,fdd04 "
   LET l_n = 0
   PREPARE p520_prepare FROM g_sql
   DECLARE p520_cs CURSOR WITH HOLD FOR p520_prepare
      CALL cl_outnam('afap520') RETURNING l_name
   START REPORT afap520_rep TO l_name
      FOREACH p520_cs INTO g_fdd.*
         IF STATUS THEN 
            CALL cl_err('p520(foreach):',STATUS,1) EXIT FOREACH      
         END IF
         IF g_fdd.fdd05 = 0 THEN
            CONTINUE FOREACH
         END IF
         LET l_n = l_n + 1
         OUTPUT TO REPORT afap520_rep(g_fdd.*,p_npptype)     #No.FUN-680028
      END FOREACH
 
      IF l_n = 0 THEN
         LET g_success='N' 
      END IF
   FINISH REPORT afap520_rep
  #No.+366 010705 plum
  #No.+366..end
 
END FUNCTION
   
REPORT afap520_rep(l_fdd,p_npptype)          #No.FUN-680028
   DEFINE l_last_sw LIKE type_file.chr1,     #No.FUN-680070 VARCHAR(1)
          l_fdd     RECORD LIKE fdd_file.*,
          p_npptype LIKE npp_file.npptype,   #No.FUN-680028
          l_fbz14   LIKE fbz_file.fbz14,
          l_faj54   LIKE faj_file.faj54
   DEFINE l_aag44       LIKE aag_file.aag44    #No.FUN-D40118   Add
   DEFINE l_flag        LIKE type_file.chr1    #No.FUN-D40118   Add
 
  OUTPUT TOP MARGIN g_top_margin
         LEFT MARGIN g_left_margin
         BOTTOM MARGIN g_bottom_margin
         PAGE LENGTH g_page_line
  ORDER  EXTERNAL BY l_fdd.fdd08,l_fdd.fdd04
  FORMAT
 
   AFTER GROUP OF l_fdd.fdd08  #保險費用科目
      LET g_npq.npq02=g_npq.npq02+1
      #No.FUN-680028 --begin
      IF p_npptype = '0' THEN
         SELECT fbz14 INTO l_fbz14 FROM fbz_file WHERE fbz00='0'
      ELSE
         SELECT fbz141 INTO l_fbz14 FROM fbz_file WHERE fbz00='0'
      END IF
      #No.FUN-680028 --end
      IF cl_null(l_fbz14) THEN LET l_fbz14 = ' ' END IF
      LET g_npq.npq03=l_fbz14   #科目(預付保險費用)
      LET g_npq.npq04=NULL
    # SELECT aag02 INTO g_npq.npq04 FROM aag_file WHERE aag01=l_fbz14
    # IF SQLCA.sqlcode THEN LET g_npq.npq04 = ' ' END IF
      LET g_npq.npq05  = "   "  #部門
      LET g_npq.npq06  = '2' 
      LET g_npq.npq07f = GROUP SUM(l_fdd.fdd05)
      LET g_npq.npq07  = g_npq.npq07f 
      LET g_npq.npq08  = ' '  LET g_npq.npq11  =''   #MOD-9A0005
      LET g_npq.npq12  =''    LET g_npq.npq13  =''   #MOD-9A0005
      LET g_npq.npq14  =''    LET g_npq.npq15  =' '  #MOD-9A0005
      LET g_npq.npq21  =' '    LET g_npq.npq22  =' ' 
      LET g_npq.npq23  = l_fdd.fdd01
      LET g_npq.npq24  =g_aza.aza17 
      LET g_npq.npq25  = 1 
      #FUN-D10065--mark--str--
      CALL s_def_npq3(g_bookno,g_npq.npq03,g_prog,g_npq.npq01,'','')
      RETURNING g_npq.npq04
      #FUN-D10065--mark--end--
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES(g_npq.*)
      IF g_bgjob = 'N' THEN  #NO.FUN-570144
          message  g_npq.npq01,' ',g_npq.npq03,' ',g_npq.npq07
          CALL ui.Interface.refresh()
      END IF  
      IF SQLCA.SQLERRD[3]=0 OR STATUS THEN 
         CALL cl_err('ins npq:',STATUS,0)
         LET g_success='N' 
      END IF
      CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  
 
   AFTER GROUP OF l_fdd.fdd04  #折舊部門
      LET g_npq.npq02=g_npq.npq02+1
      #No.FUN-680028 --begin
      IF p_npptype = '0' THEN
         LET g_npq.npq03=l_fdd.fdd08  #折舊科目 
      ELSE
         LET g_npq.npq03=l_fdd.fdd081
      END IF
      #No.FUN-680028 --end
      LET g_npq.npq04=NULL
    # SELECT aag02 INTO g_npq.npq04 FROM aag_file WHERE aag01=l_fdd.fdd08
    # IF SQLCA.sqlcode THEN LET g_npq.npq04 = ' ' END IF
      LET g_npq.npq05=l_fdd.fdd04  #部門
      LET g_npq.npq06='1'         
      LET g_npq.npq07f = GROUP SUM(l_fdd.fdd05)
      LET g_npq.npq07  = g_npq.npq07f 
      LET g_npq.npq08  = ' '  LET g_npq.npq11  =''   #MOD-9A0005
      LET g_npq.npq12  =''    LET g_npq.npq13  =''   #MOD-9A0005
      LET g_npq.npq14  =''    LET g_npq.npq15  =' '  #MOD-9A0005
      LET g_npq.npq21  =' '    LET g_npq.npq22  =' ' 
      LET g_npq.npq23  = l_fdd.fdd01
      LET g_npq.npq24  =g_aza.aza17 
      LET g_npq.npq25  = 1 
      IF g_bgjob = 'N' THEN  #NO.FUN-570144 
          message  g_npq.npq01,' ',g_npq.npq03,' ',g_npq.npq07
          CALL ui.Interface.refresh()
      END IF 
      #FUN-D10065--mark--str--
      CALL s_def_npq3(g_bookno,g_npq.npq03,g_prog,g_npq.npq01,'','')
      RETURNING g_npq.npq04
      #FUN-D10065--mark--end--
     #FUN-D40118 ---Add--- Start
      SELECT aag44 INTO l_aag44 FROM aag_file
       WHERE aag00 = g_bookno
         AND aag01 = g_npq.npq03
      IF g_aza.aza26 = '2' AND l_aag44 = 'Y' THEN
         CALL s_chk_ahk(g_npq.npq03,g_bookno) RETURNING l_flag
         IF l_flag = 'N'   THEN
            LET g_npq.npq03 = ''
         END IF
      END IF
     #FUN-D40118 ---Add--- End
      INSERT INTO npq_file VALUES(g_npq.*)
      IF SQLCA.SQLERRD[3]=0 OR STATUS THEN 
#        CALL cl_err('ins npq:',STATUS,0)   #No.FUN-660136
         CALL cl_err3("ins","npq_file",g_npq.npq01,g_npq.npqsys,STATUS,"","ins npq:",0)   #No.FUN-660136
         LET g_success='N' 
      END IF
      CALL s_flows('3','',g_npq.npq01,g_npp.npp02,'N',g_npq.npqtype,TRUE)   #No.TQC-B70021  
END REPORT
