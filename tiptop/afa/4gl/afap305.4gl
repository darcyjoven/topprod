# Prog. Version..: '5.30.06-13.03.19(00010)'     #
#
# Pattern name...: afap305.4gl
# Descriptions...: 固定資產年底結轉作業                    
# Date & Author..: 96/07/03 By Sophia
# Modify.........: No.FUN-4C0008 04/12/03 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-570144 06/03/06 By yiting 批次作業背景執行功能
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680028 06/08/23 By Ray 多帳套修改
# Modify.........: No.FUN-680070 06/09/07 By johnray 欄位形態定義改為LIKE形式,并入FUN-680028過單
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........; No.MOD-6C0185 06/12/29 By Smapmin 背景執行時,g_success要給值
# Modify.........: No.FUN-710028 07/01/19 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.TQC-780096 07/08/31 By rainy  primary key 複合key 處理 
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.FUN-AB0088 11/04/07 By lixiang 固定资料財簽二功能
# Modify.........: No:FUN-B60140 11/09/06 By minpp "財簽二二次改善"追單
# Modify.........: No:FUN-C50121 12/05/29 By minpp  若折舊日期大於當前折舊年月就報錯并返回
# Modify.........: No:MOD-CA0123 12/11/07 By Elise 程式碼與註記間無空格導致維護Action資料錯誤
# Modify.........: No:MOD-CC0282 12/01/02 By Polly 調整抓取年月份時間順序；afa-131控卡調整
  
DATABASE ds
 
GLOBALS "../../config/top.global"
 
 DEFINE g_wc,g_sql	string,  #No.FUN-580092 HCN
        g_yy,g_mm	LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       b_date,e_date	LIKE type_file.dat,          #No.FUN-680070 DATE
       g_dc		LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
       g_amt1,g_amt2	LIKE type_file.num20_6,  #No.FUN-4C0008       #No.FUN-680070 DECIMAL(20,6)
       g_foo		RECORD LIKE foo_file.*
DEFINE p_row,p_col      LIKE type_file.num5         #No.FUN-680070 SMALLINT
DEFINE   g_cnt           LIKE type_file.num10           #No.FUN-680070 INTEGER
DEFINE l_flag          LIKE type_file.chr1,                 #No.FUN-570144       #No.FUN-680070 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1                 #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8  	    #No.FUN-6A0069
   DEFINE   l_fan03       LIKE fan_file.fan03              #FUN-C50121
   DEFINE   l_fan04       LIKE fan_file.fan04              #FUN-C50121
   OPTIONS
        INPUT NO WRAP
   DEFER INTERRUPT
 
   #->No.FUN-570144 --start--
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_yy    = ARG_VAL(1)
   LET g_bgjob = ARG_VAL(2)    #背景作業
   LET g_success = ARG_VAL(3)   #MOD-6C0185
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
 
#NO.FUN-570144 MARK--
#   OPEN WINDOW p305_w AT p_row,p_col WITH FORM "afa/42f/afap305"
################################################################################
# START genero shell script ADD
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
#    CALL cl_ui_init()
 
# END genero shell script ADD
################################################################################
#NO.FUN-570144 MARK--                              
 
 
     CALL  cl_used(g_prog,g_time,1) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
    #->No.FUN-570144 --start--
   #FUN-C50121--add-s-tr
    SELECT MAX(fan03) INTO l_fan03 FROM fan_file
    SELECT MAX(fan04) INTO l_fan04 FROM fan_file  WHERE fan03=l_fan03
   #FUN-C50121--add--end
    WHILE TRUE
    SELECT faa07,faa08 INTO g_yy,g_mm FROM faa_file     #MOD-CC0282 add
    IF g_bgjob = "N" THEN
       CALL p305()
       #FUN-C50121--add--str
       IF (l_fan03 > g_yy) or (l_fan03=g_yy and l_fan04>g_mm) THEN
          CALL cl_err('','afa-889',1)
          LET g_success = 'N'
       END IF
       #FUN-C50121---ADD--END
       IF g_success = 'N' THEN EXIT WHILE END IF #FUN-C50121 add
       #IF cl_sure(18,20) THEN   #MOD-6C0185
       #----------------------MOD-CC0282---------------------mark
       #IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
       #   (g_aza.aza02 = '2' AND g_mm = 13)) THEN
       #   #IF NOT cl_sure(0,0) THEN RETURN END IF   #MOD-6C0185
       #   IF NOT cl_sure(0,0) THEN EXIT WHILE END IF   #MOD-6C0185
       #ELSE
       #   CALL cl_err(' ','afa-131',1)
       #   #RETURN   #MOD-6C0185
       #   EXIT WHILE   #MOD-6C0185
       #END IF
       #----------------------MOD-CC0282---------------------mark
        LET g_success = 'Y'
        BEGIN WORK
        CALL p305_1()
        CALL s_showmsg()         #No.FUN-710028
        IF g_success = 'Y' THEN
           COMMIT WORK
           CALL cl_end2(1) RETURNING l_flag
        ELSE
           ROLLBACK WORK
           CALL cl_end2(2) RETURNING l_flag
        END IF
        IF l_flag THEN
           CONTINUE WHILE
        ELSE
           CLOSE WINDOW p305_w
           EXIT WHILE
        END IF
       #ELSE   #MOD-6C0185
       #   CONTINUE WHILE   #MOD-6C0185
       #END IF   #MOD-6C0185
   ELSE
      #FUN-C50121--add--str
       IF (l_fan03 > g_yy) or (l_fan03=g_yy and l_fan04>g_mm) THEN
          CALL cl_err('','afa-889',1)
          LET g_success = 'N'
       END IF
       #FUN-C50121---ADD--END
       IF g_success = 'N' THEN EXIT WHILE END IF #FUN-C50121 add
       BEGIN WORK
       LET g_success = 'Y'         #No.FUN-8A0086
       CALL p305_1()
       CALL s_showmsg()         #No.FUN-710028
       IF g_success = "Y" THEN
          COMMIT WORK
       ELSE
          ROLLBACK WORK
       END IF
       CALL cl_batch_bg_javamail(g_success)
       EXIT WHILE
   END IF
END WHILE
    #->No.FUN-570144 --end--
 
   #CALL p305()   #MOD-6C0185
   #CLOSE WINDOW p305_w   #MOD-6C0185
   CALL  cl_used(g_prog,g_time,2) RETURNING g_time #No.MOD-580088  HCN 20050818  #No.FUN-6A0069
END MAIN
 
FUNCTION p305()
  DEFINE   lc_cmd        LIKE type_file.chr1000           #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
  #->No.FUN-570144 --start--
  LET p_row = 5 LET p_col = 28
  OPEN WINDOW p305_w AT p_row,p_col WITH FORM "afa/42f/afap305"
  ATTRIBUTE (STYLE = g_win_style)
 
  CALL cl_ui_init()
  CALL cl_opmsg('z')
  #->No.FUN-570144 ---end---
 
  CLEAR FORM
 #SELECT faa07,faa08 INTO g_yy,g_mm FROM faa_file     #MOD-CC0282 mark
  DISPLAY g_yy TO FORMONLY.g_yy 

  #->No.FUN-570144 --start--
  LET g_bgjob = "N"
  WHILE TRUE
  INPUT BY NAME g_bgjob WITHOUT DEFAULTS
     ON ACTION CONTROLG
        CALL cl_cmdask()
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE INPUT
 
     ON ACTION about         #BUG-4C0121  #MOD-CA0123 move
        CALL cl_about()      #BUG-4C0121
 
     ON ACTION help          #BUG-4C0121  #MOD-CA0123 move
        CALL cl_show_help()  #BUG-4C0121
 
     ON ACTION locale
        LET g_change_lang = TRUE
        EXIT INPUT
  END INPUT
 
  IF g_change_lang THEN
     LET g_change_lang = FALSE
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     CONTINUE WHILE
  END IF
 
  IF INT_FLAG THEN
     LET INT_FLAG=0
     CLOSE WINDOW p305_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
     RETURN
  END IF
 
    IF g_bgjob = "Y" THEN
     SELECT zz08 INTO lc_cmd FROM zz_file
      WHERE zz01 = "afap305"
      IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
         CALL cl_err('afap305','9031',1)  
      ELSE
         LET lc_cmd = lc_cmd CLIPPED,
                    " '",g_yy    CLIPPED,"'",
                    " '",g_bgjob CLIPPED,"'"
         CALL cl_cmdat('afap305',g_time,lc_cmd CLIPPED)
      END IF
      CLOSE WINDOW p305_w
      CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
      EXIT PROGRAM
    END IF
    EXIT WHILE
  END WHILE
  #->No.FUN-570144 --end--
 
#NO.FUN-570144 MARK--
#  WHILE TRUE
#    CALL cl_opmsg('z')
#    IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
#        (g_aza.aza02 = '2' AND g_mm = 13)   ) THEN
#        IF NOT cl_sure(0,0) THEN RETURN END IF
#    ELSE
#        CALL cl_err(' ','afa-131',1)
#        RETURN
#    END IF
#    CALL cl_wait()
#    CALL p305_1()
#    ERROR ''
#    EXIT WHILE
#  END WHILE
#NO.FUN-570144 MARK---
END FUNCTION
 
FUNCTION p305_1()
  DEFINE next_yy LIKE type_file.num5         #No.FUN-680070 SMALLINT
  DEFINE l_faj RECORD LIKE faj_file.*          #No.FUN-680070 INT # saki 20070821 faj01 chr18 -> num10 
 
 #----------------------MOD-CC0282---------------------(S)
  IF ((g_aza.aza02 = '1' AND g_mm = 12) OR
     (g_aza.aza02 = '2' AND g_mm = 13)) THEN
     IF NOT cl_sure(0,0) THEN
        LET g_success = 'N'
        RETURN
     END IF
  ELSE
     CALL s_errmsg('','','','afa-131',1)
     LET g_success = 'N'
     RETURN
  END IF
 #----------------------MOD-CC0282---------------------(E)
  LET next_yy = g_yy + 1
  IF g_bgjob = 'N' THEN    #FUN-570144
      MESSAGE "del next year's foo!"
      CALL ui.Interface.refresh()
  END IF
  DELETE FROM foo_file WHERE foo03 = next_yy AND foo04=0 AND foo08=g_faa.faa02b  #No:FUN-B60140
  DECLARE p305_eoy_c CURSOR FOR
     SELECT foo01,foo02,foo07,foo08,SUM(foo05d-foo06c)     #No.FUN-680028
       FROM foo_file
      WHERE foo03 = g_yy
        AND foo08 = g_faa.faa02b  #No:FUN-B60140
      GROUP BY foo07,foo08,foo01,foo02     #No.FUN-680028
  LET g_cnt=1
  LET g_foo.foo03=next_yy
  LET g_foo.foo04=0
  LET g_foo.foolegal=g_legal #FUN-980003 add
 
  FOREACH p305_eoy_c INTO g_foo.foo01,g_foo.foo02,g_foo.foo07,g_foo.foo08,     #No.FUN-680028
                          g_foo.foo05d
     IF STATUS THEN CALL cl_err('foreach:',STATUS,1) RETURN END IF   
 
     IF g_foo.foo05d < 0
        THEN LET g_foo.foo06c = -g_foo.foo05d LET g_foo.foo05d=0
        ELSE LET g_foo.foo06c = 0
     END IF
     LET g_cnt=g_cnt+1
     IF g_bgjob = 'N' THEN    #FUN-570144
         MESSAGE "(",g_cnt USING '<<<<<',") ins foo:",g_foo.foo01
         CALL ui.Interface.refresh()
     END IF
 
     #TQC-780096 begin
       IF cl_null(g_foo.foo01) THEN LET g_foo.foo01 = ' ' END IF
       IF cl_null(g_foo.foo02) THEN LET g_foo.foo02 = ' ' END IF
       IF cl_null(g_foo.foo03) THEN LET g_foo.foo03 = 0 END IF
       IF cl_null(g_foo.foo04) THEN LET g_foo.foo04 = 0 END IF
       IF cl_null(g_foo.foo07) THEN LET g_foo.foo07 = ' ' END IF
       IF cl_null(g_foo.foo08) THEN LET g_foo.foo08 = ' ' END IF
     #TQC-780096 end    
     INSERT INTO foo_file VALUES (g_foo.*)
  END FOREACH
  #-----更新系統參數檔(faa_file.faa07)
  UPDATE faa_file SET faa07 = faa07 + 1, faa08 = 1 
    IF SQLCA.SQLCODE OR SQLCA.SQLERRD[3] = 0 THEN
#     CALL cl_err('upd faa',SQLCA.SQLCODE,0)   #No.FUN-660136
      CALL cl_err3("upd","faa_file","","",SQLCA.sqlcode,"","upd faa",0)   #No.FUN-660136
         RETURN
    END IF
  #-----更新系固定資產(faj_file.faj203/faj204)
  DECLARE p305_faj_c CURSOR FOR SELECT faj01,faj02,faj022 FROM faj_file WHERE 1= 1 
  CALL s_showmsg_init()    #No.FUN-710028
  FOREACH p305_faj_c INTO l_faj.faj01, l_faj.faj02, l_faj.faj022 
     IF SQLCA.sqlcode THEN 
#       CALL cl_err('p305_faj_c',SQLCA.sqlcode,0)         #No.FUN-710028
        CALL s_errmsg('','','p305_faj_c',SQLCA.sqlcode,0) #No.FUN-710028
        LET g_success = 'N'                               #No.FUN-8A0086
        EXIT FOREACH 
     END IF
#No.FUN-710028 --begin                                                                                                              
     IF g_success='N' THEN                                                                                                         
        LET g_totsuccess='N'                                                                                                       
        LET g_success="Y"                                                                                                          
     END IF                                                                                                                        
#No.FUN-710028 -end
     UPDATE faj_file SET faj203 = 0,
                         faj204 = 0
                         #faj2032= 0,   #No:FUN-AB0088 #No:FUN-B60140 Mark
                         #faj2042= 0    #No:FUN-AB0088 #No:FUN-B60140 Mark
   WHERE faj01 = l_faj.faj01 AND faj02 = l_faj.faj02 AND faj022 = l_faj.faj022  
     IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN 
#       CALL cl_err('up faj_file ',SQLCA.sqlcode,0)     #No.FUN-660136
#       CALL cl_err3("upd","faj_file","","",SQLCA.sqlcode,"","up faj_file ",0)   #No.FUN-660136 #No.FUN-710028
        CALL s_errmsg('faj01',l_faj.faj01,'up faj_file ',SQLCA.sqlcode,1)            #No.FUN-710028
        LET g_success = 'N'
#       EXIT FOREACH       #No.FUN-710028
        CONTINUE FOREACH   #No.FUN-710028
     END IF
  END FOREACH  
#No.FUN-710028 --begin                                                                                                              
  IF g_totsuccess="N" THEN                                                                                                        
     LET g_success="N"                                                                                                            
  END IF                                                                                                                          
#No.FUN-710028 --end
 
  ERROR ''
  #CALL cl_end(0,0)  #NO.FUN-570144 MARK
END FUNCTION
