# Prog. Version..: '5.30.06-13.03.12(00010)'        #
#
# Pattern name...: afap304.4gl
# Descriptions...: 固定資產月底結轉作業                    
# Date & Author..: 96/07/03 By Sophia
# Modify.........: No.FUN-4C0008 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-570144 06/03/03 By yiting 批次作業背景執行功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-660216 06/07/10 By Rainy CALL cl_cmdrun()中的程式如果是"p"或"t"，則改成CALL cl_cmdrun_wait()
# Modify.........: No.FUN-680028 06/08/23 By day 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.MOD-6C0185 06/12/29 By Smapmin 不做年結也要COMMIT WORK
# Modify.........: No.FUN-710028 07/01/19 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-780096 07/08/31 By rainy  primary key 複合key 處理 
# Modify.........: NO.TQC-790093 07/09/20 BY yiting Primary Key的-268訊息 程式修改
# Modify.........: No.TQC-780083 07/09/21 By Smapmin 秀出下期年度/期別
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.MOD-970030 09/07/06 By mike CURSOR p304_cs的SQL加上AND npptype=npqtype條件
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-970059 09/09/02 By sabrina 在呼叫afap305之前要先做commit work/rollback work，否則餘額會少算12月
# Modify.........: No.MOD-970193 09/07/21 By Sarah 修正MOD-970059,背景執行段也應修改
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/06 By lixiang 固定资料財簽二功能
# Modify.........: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善"追單
# Modify.........: No:FUN-BB0114 11/11/22 By minpp 處理財簽二重測BUG 
# Modify.........: No:FUN-D40121 13/05/31 By lujh 若參數有值，则年度期別使用參數的值
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_wc,g_sql       string,  #No.FUN-580092 HCN
        g_yy,g_mm        LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       b_date,e_date    LIKE type_file.dat,          #No.FUN-680070 DATE
       g_dc             LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       g_amt1,g_amt2    LIKE type_file.num20_6,  #FUN-4C0008       #No.FUN-680070 DECIMAL(20,6)
       g_foo            RECORD LIKE foo_file.*
DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_chr           LIKE type_file.chr1         #No.FUN-680070 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10           #No.FUN-680070 INTEGER
DEFINE l_flag           LIKE type_file.chr1,                 #No.FUN-570144       #No.FUN-680070 VARCHAR(1)
       g_change_lang    LIKE type_file.chr1                 #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)
DEFINE l_cmd            LIKE type_file.chr1000             #FUN-570144 BY 050919       #No.FUN-680070 VARCHAR(100)
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8            #No.FUN-6A0069
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #->No.FUN-570144 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy    = ARG_VAL(1)
   LET g_mm    = ARG_VAL(2)
   LET g_bgjob = ARG_VAL(3)                    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
   #->NO.FUN-570144 --end---
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
#NO.FUN-570144 MARK--
#   OPEN WINDOW p304_w AT p_row,p_col WITH FORM "afa/42f/afap304"
################################################################################
# START genero shell script ADD
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
#NO.FUN-570144 MARK--
 
   CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
  #->No.FUN-570144 --start--
WHILE TRUE
 
    IF g_bgjob = "N" THEN
       CALL p304()
       IF cl_sure(18,20) THEN
          LET g_success = 'Y'
          BEGIN WORK
          #No.FUN-680028--begin
#         CALL p304_1()
          CALL p304_1('0')
  #       IF g_aza.aza63 = 'Y' THEN  
         ##-----No:FUN-B60140 Mark-----
         #IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088 
         #   CALL p304_1('1')
         #END IF
         ##-----No:FUN-B60140 Mark END-----
          #No.FUN-680028--end  
       #MOD-970059---add---start---
          CALL s_showmsg()
          IF g_success = 'Y' THEN
             COMMIT WORK
          ELSE
             ROLLBACK WORK
          END IF
       #MOD-970059---add---end
          IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
             (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
             LET l_cmd = ''
             IF cl_confirm('axr-240') THEN
                #LET l_cmd = " afap305 '",g_yy,"' 'Y' "   #MOD-6C0185
                LET l_cmd = " afap305 '",g_yy,"' 'Y' '",g_success,"' "   #MOD-6C0185
                #CALL cl_cmdrun(l_cmd)  #FUN-570144 BY 050919  #FUN-660216 remark
                CALL cl_cmdrun_wait(l_cmd)                     #FUN-660216 add
             END IF
          END IF
         #CALL s_showmsg()         #No.FUN-710028    #MOD-970059 mark
          IF g_success = 'Y' THEN
            #COMMIT WORK                             #MOD-970059 mark
             CALL cl_end2(1) RETURNING l_flag
          ELSE
            #ROLLBACK WORK                           #MOD-970059 mark
             CALL cl_end2(2) RETURNING l_flag
          END IF
          IF l_flag THEN
             CONTINUE WHILE
          ELSE
             CLOSE WINDOW p304_w
             EXIT WHILE
          END IF
      ELSE
       CONTINUE WHILE
      END IF
   ELSE
     BEGIN WORK
     #No.FUN-680028--begin
#    CALL p304_1()
     CALL p304_1('0')
#    IF g_aza.aza63 = 'Y' THEN   
    ##-----No:FUN-B60140 Mark-----
    #IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
    #   CALL p304_1('1')
    #END IF
    ##-----No:FUN-B60140 Mark-----
     #No.FUN-680028--end  
   #str MOD-970193 add
     CALL s_showmsg()         
     IF g_success = "Y" THEN
        COMMIT WORK
     ELSE
        ROLLBACK WORK
     END IF
   #end MOD-970193 add
     LET l_cmd=''
     IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
         (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
         #CALL cl_cmdrun("afap305 'Y'")
         #LET l_cmd = " afap305 '",g_yy,"' 'Y' "   #MOD-6C0185
         LET l_cmd = " afap305 '",g_yy,"' 'Y' '",g_success,"' "   #MOD-6C0185
         #CALL cl_cmdrun(l_cmd)  #FUN-570144 BY 050919   #FUN-660216 remark
         CALL cl_cmdrun_wait(l_cmd)                      #FUN-660216 add
     END IF
    #str MOD-970193 mark
    #CALL s_showmsg()         #No.FUN-710028
    #IF g_success = "Y" THEN
    #   COMMIT WORK
    #ELSE
    #   ROLLBACK WORK
    #END IF
    #end MOD-970193 mark
     CALL cl_batch_bg_javamail(g_success)
     EXIT WHILE
  END IF
END WHILE
  # CALL p304()
  # CLOSE WINDOW p304_w
  #->No.FUN-570144 --end--
     CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
END MAIN
 
FUNCTION p304()
  DEFINE   lc_cmd        LIKE type_file.chr1000           #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
 
  #->No.FUN-570144 --start--
  LET p_row = 5 LET p_col = 28
 
  OPEN WINDOW p304_w AT p_row,p_col WITH FORM "afa/42f/afap304"
   ATTRIBUTE (STYLE = g_win_style)
 
  CALL cl_ui_init()
  CALL cl_opmsg('z')
 
  #->No.FUN-570144 ---end---
 
  CLEAR FORM
  IF cl_null(g_yy) AND cl_null(g_mm) THEN    #FUN-D40121 add
     SELECT faa07,faa08 INTO g_yy,g_mm FROM faa_file
  END IF                                     #FUN-D40121 add
  DISPLAY g_yy TO FORMONLY.g_yy 
  DISPLAY g_mm TO FORMONLY.g_mm 
  #-----TQC-780083--------
  IF g_mm+1 >12 THEN
     DISPLAY g_yy+1 TO FORMONLY.g_yy2
     DISPLAY 1 TO FORMONLY.g_mm2
  ELSE
     DISPLAY g_yy TO FORMONLY.g_yy2
     DISPLAY g_mm+1 TO FORMONLY.g_mm2
  END IF
  #-----END TQC-780083----
 
 
  #->No.FUN-570144 --start--
  LET g_bgjob = "N"
WHILE TRUE
  INPUT BY NAME g_bgjob WITHOUT DEFAULTS
    ON ACTION CONTROLG
       CALL cl_cmdask()
    ON IDLE g_idle_seconds
       CALL cl_on_idle()
       CONTINUE INPUT
 
    ON ACTION about         #BUG-4C0121
       CALL cl_about()      #BUG-4C0121
 
    ON ACTION help          #BUG-4C0121
       CALL cl_show_help()  #BUG-4C0121
 
    ON ACTION locale           #genero
     #->No.FUN-570144 --start--
       LET g_change_lang = TRUE
       EXIT INPUT
     #->No.FUN-570144 ---end---
 
   END INPUT
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      CONTINUE WHILE
   END IF
 
   IF INT_FLAG THEN
      LET INT_FLAG=0
      CLOSE WINDOW p304_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
      RETURN
   END IF
 
   IF g_bgjob = "Y" THEN
    SELECT zz08 INTO lc_cmd FROM zz_file
     WHERE zz01 = "afap304"
    IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
       CALL cl_err('afap304','9031',1)   
    ELSE
       LET lc_cmd = lc_cmd CLIPPED,
                    " '",g_yy CLIPPED,"'",
                    " '",g_mm CLIPPED,"'",
                    " '",g_bgjob CLIPPED,"'"
       CALL cl_cmdat('afap304',g_time,lc_cmd CLIPPED)
    END IF
    CLOSE WINDOW p304_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
    EXIT PROGRAM
   END IF
 EXIT WHILE
END WHILE
#->No.FUN-570144 ---end---
 
#NO.FUN-570144 MARK--
#    CALL cl_opmsg('z')
 
#    IF NOT cl_sure(0,0) THEN RETURN END IF
#    CALL cl_wait()
#    CALL p304_1()
#    ERROR ''
#    IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
#        (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
#       IF cl_confirm('axr-240') THEN CALL cl_cmdrun('afap305') END IF
#    END IF
#NO.FUN-570144 MARK---
END FUNCTION
 
#FUNCTION p304_1()  #No.FUN-680028
FUNCTION p304_1(l_npptype)           #No.FUN-680028
DEFINE l_npptype LIKE npp_file.npptype  #No.FUN-680028
 
   #No.FUN-680028--begin
#  CALL s_azm(g_yy,g_mm) RETURNING g_chr,b_date,e_date
#  IF g_aza.aza63 = 'Y' THEN  
   IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
      IF l_npptype = '0' THEN
         CALL s_azmm(g_yy,g_mm,g_faa.faa02p,g_faa.faa02b) RETURNING g_chr,b_date,e_date
      ELSE
         CALL s_azmm(g_yy,g_mm,g_faa.faa02p,g_faa.faa02c) RETURNING g_chr,b_date,e_date
      END IF
   ELSE
     CALL s_azm(g_yy,g_mm) RETURNING g_chr,b_date,e_date
   END IF
   #No.FUN-680028--end  
 
   #No.+045 010403 by plum
   #IF g_chr='1' THEN CALL cl_err('s_azm:error','',1) RETURN END IF
    IF g_chr='1' THEN 
       CALL cl_err('s_azm:error','agl-101',1) 
       LET g_success='N' #FUN-BB0114 ADD
       RETURN 
    END IF
   #No.+045..end
 
    IF g_bgjob= 'N' THEN        #FUN-570144
        MESSAGE "del foo!"
        CALL ui.Interface.refresh()
    END IF
    #No.FUN-680028--begin
#   DELETE FROM foo_file WHERE foo03=g_yy AND foo04=g_mm
#   IF g_aza.aza63 = 'Y' THEN   
   ##-----No:FUN-B60140-----
   #IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088
   #   IF l_npptype = '0' THEN
   #      DELETE FROM foo_file WHERE foo03=g_yy AND foo04=g_mm
   #                             AND foo08=g_faa.faa02b
   #   ELSE
   #      DELETE FROM foo_file WHERE foo03=g_yy AND foo04=g_mm
   #                             AND foo08=g_faa.faa02c
   #   END IF
   #ELSE
   #   DELETE FROM foo_file WHERE foo03=g_yy AND foo04=g_mm
   #END IF
    DELETE FROM foo_file WHERE foo03=g_yy AND foo04=g_mm
                           AND foo08=g_faa.faa02b
    ##-----No:FUN-B60140 End-----
    #No.FUN-680028--end  
    IF STATUS THEN 
#       CALL cl_err('del foo:',STATUS,1)    #No.FUN-660136
        CALL cl_err3("del","foo_file",g_yy,g_mm,STATUS,"","del foo:",1)   #No.FUN-660136
        LET g_success = 'N'                   #FUN-570144
        RETURN 
    END IF
    IF g_bgjob= 'N' THEN        #FUN-570144
        MESSAGE SQLCA.SQLERRD[3],' Rows deleted!'
        CALL ui.Interface.refresh()
    END IF
    DECLARE p304_cs CURSOR WITH HOLD FOR
#           SELECT npq03,npq05,npq06,SUM(npq07)             #No.FUN-680028
            SELECT npq03,npq05,npq06,SUM(npq07),npp06,npp07 #No.FUN-680028
                    FROM npp_file,npq_file
                   WHERE nppsys= npqsys
                     AND npptype=l_npptype  #No.FUN-680028
                     AND npqsys= 'FA'
                     AND npp00 = npq00 
                     AND npp01 = npq01
                     AND npp011= npq011
                     AND npp02 BETWEEN b_date AND e_date
                     AND npptype = npqtype #MOD-970030      
#                   GROUP BY npq03,npq05,npq06                           #No.FUN-680028
                   GROUP BY npq03,npq05,npq06,npp06,npp07   #No.FUN-680028
    LET g_foo.foo03=g_yy
    LET g_foo.foo04=g_mm
 
    LET g_foo.foolegal=g_legal #FUN-980003 add
 
    LET g_cnt=0
#   FOREACH p304_cs INTO g_foo.foo01,g_foo.foo02,g_dc,g_amt1                                #No.FUN-680028
    CALL s_showmsg_init()    #No.FUN-710028
#   FOREACH p304_cs INTO g_foo.foo01,g_foo.foo02,g_dc,g_amt1,g_foo.foo07,g_foo.foo08        #No.FUN-680028
    FOREACH p304_cs INTO g_foo.foo01,g_foo.foo02,g_dc,g_amt1,g_foo.foo07,g_foo.foo08        #No.FUN-680028
#      IF STATUS THEN CALL cl_err('foreach:',STATUS,1) RETURN END IF                        #No.FUN-710028
#      IF STATUS THEN CALL s_errmsg('','','foreach:',STATUS,0) RETURN END IF                #No.FUN-710028 #No.FUN-8A0086
#No.FUN-8A0086 --Begin
       IF STATUS THEN CALL s_errmsg('','','foreach:',STATUS,0)
          LET g_success = 'N'
          RETURN 
       END IF
#No.FUN-8A0086 --End
#No.FUN-710028 --begin                                                                                                              
       IF g_success='N' THEN                                                                                                         
          LET g_totsuccess='N'                                                                                                       
          LET g_success="Y"                                                                                                          
       END IF                                                                                                                        
#No.FUN-710028 -end
 
       LET g_cnt=g_cnt+1
       IF g_bgjob = 'N' THEN       #FUN-570144
           MESSAGE "(",g_cnt USING '<<<<<',") fetch npq:",g_foo.foo01
           CALL ui.Interface.refresh()
       END IF
       IF g_dc = '1' THEN
          LET g_foo.foo05d=g_amt1 LET g_foo.foo06c=0
       ELSE
          LET g_foo.foo05d=0      LET g_foo.foo06c=g_amt1
       END IF
       #No.FUN-680028--begin
  #    IF g_aza.aza63 = 'Y' THEN 
      ##-----No:FUN-B60140-----
      #IF g_faa.faa31 = 'Y' THEN   #NO.FUN-AB0088 
      #   IF l_npptype = '0' THEN
      #      LET g_foo.foo08 = g_faa.faa02b
      #      IF cl_null(g_foo.foo08) THEN
      #         LET g_foo.foo08 = g_faa.faa02b
      #      END IF
      #   ELSE
      #      LET g_foo.foo08 = g_faa.faa02c
      #      IF cl_null(g_foo.foo08) THEN
      #         LET g_foo.foo08 = g_faa.faa02c
      #      END IF
      #   END IF
      #ELSE
      #   IF cl_null(g_foo.foo08) THEN
      #      LET g_foo.foo08 = g_faa.faa02b
      #   END IF
      #END IF
       LET g_foo.foo08 = g_faa.faa02b
       IF cl_null(g_foo.foo08) THEN
          LET g_foo.foo08 = g_faa.faa02b
       END IF
      ##-----No:FUN-B60140 END-----
       IF cl_null(g_foo.foo07) THEN
          LET g_foo.foo07 = g_faa.faa02p
       END IF
       #No.FUN-680028--end  
 
     #TQC-780096 begin
       IF cl_null(g_foo.foo01) THEN LET g_foo.foo01 = ' ' END IF
       IF cl_null(g_foo.foo02) THEN LET g_foo.foo02 = ' ' END IF
       IF cl_null(g_foo.foo03) THEN LET g_foo.foo03 = 0 END IF
       IF cl_null(g_foo.foo04) THEN LET g_foo.foo04 = 0 END IF
       IF cl_null(g_foo.foo07) THEN LET g_foo.foo07 = ' ' END IF
       IF cl_null(g_foo.foo08) THEN LET g_foo.foo08 = ' ' END IF
     #TQC-780096 end    
       INSERT INTO foo_file VALUES(g_foo.*)
#       IF STATUS AND STATUS!=-239 AND STATUS!=-268 THEN 
        #IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #NO.TQC-790093   #TQC-780083
        IF STATUS AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN   #NO.TQC-790093   #TQC-780083
#          CALL cl_err('ins foo:',STATUS,1)   #No.FUN-660136
#          CALL cl_err3("ins","foo_file",g_foo.foo01,g_foo.foo02,STATUS,"","ins foo:",1)   #No.FUN-660136 #No.FUN-710028
           LET g_showmsg = g_foo.foo01,"/",g_foo.foo02,"/",g_foo.foo03,"/",g_foo.foo04     #No.FUN-710028
           CALL s_errmsg('foo01,foo02,foo03,foo04',g_showmsg,'ins foo:',STATUS,1)          #No.FUN-710028
           LET g_success = 'N'                   #FUN-570144
#          RETURN            #No.FUN-710028
           CONTINUE FOREACH  #No.FUN-710028
       END IF
#       IF STATUS = -239 OR STATUS =-268 THEN
        IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #NO.TQC-790093
          UPDATE foo_file SET foo05d=foo05d+g_foo.foo05d,
                              foo06c=foo06c+g_foo.foo06c
                 WHERE foo01=g_foo.foo01
                   AND foo02=g_foo.foo02
                   AND foo03=g_foo.foo03
                   AND foo04=g_foo.foo04
                   AND foo08=g_foo.foo08  #No:FUN-B60140
#          IF STATUS AND STATUS!=-239 AND STATUS!=-268 THEN
           #IF cl_sql_dup_value(SQLCA.SQLCODE) THEN   #NO.TQC-790093   #TQC-780083
           IF STATUS AND NOT cl_sql_dup_value(SQLCA.SQLCODE) THEN   #NO.TQC-790093   #TQC-780083
#            CALL cl_err('upd foo:',STATUS,1)    #No.FUN-660136
#            CALL cl_err3("upd","foo_file",g_foo.foo01,g_foo.foo02,STATUS,"","upd foo:",1)   #No.FUN-660136 #No.FUN-710028
             LET g_showmsg = g_foo.foo01,"/",g_foo.foo02,"/",g_foo.foo03,"/",g_foo.foo04     #No.FUN-710028
             CALL s_errmsg('foo01,foo02,foo03,foo04',g_showmsg,'upd foo:',STATUS,1)          #No.FUN-710028
             LET g_success = 'N'                   #FUN-570144
#            RETURN            #No.FUN-710028
             CONTINUE FOREACH  #No.FUN-710028
          END IF
       END IF
    END FOREACH
#No.FUN-710028 --begin                                                                                                              
    IF g_totsuccess="N" THEN                                                                                                        
       LET g_success="N"                                                                                                            
    END IF                                                                                                                          
#No.FUN-710028 --end
 
    #-----更新系統參數檔----------
    IF NOT ((g_aza.aza02 = '1' AND g_mm = 12) OR
        (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
       IF l_npptype = '0' THEN     #No.FUN-680028
          UPDATE faa_file SET faa08 = faa08 + 1  #將現行期別加1
       END IF   #No.FUN-680028
    #END IF   #MOD-6C0185
       IF l_npptype = '0' AND (SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0) THEN  #No.FUN-680028
#         CALL cl_err('upd faa',SQLCA.SQLCODE,0)   #No.FUN-660136
          CALL cl_err3("upd","faa_file","","",SQLCA.SQLCODE,"","upd faa",0) #No.FUN-660136 #No.FUN-710028
          CALL s_errmsg('faa08','','upd faa:',SQLCA.SQLCODE,1)              #No.FUN-710028
          LET g_success = 'N'                   #FUN-570144
          RETURN        
       END IF
    END IF   #MOD-6C0185
    ERROR ''
    # Prog. Version..: '5.30.06-13.03.12(0,0)  #FUN-570144
END FUNCTION
