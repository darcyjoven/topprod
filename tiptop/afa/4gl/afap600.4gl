# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: afap600.4gl
# Descriptions...: 盤點資料產生作業                                   
# Date & Author..: 96/05/06 By Sophia
# Modify.........: No.MOD-470041 04/07/19 By Nicola 修改INSERT INTO 語法
# Modify.........: No.FUN-570144 06/03/07 By yiting 批次背景執行
# Modify.........: No.FUN-660136 06/06/20 By Ice cl_err --> cl_err3
# Modify.........: No.FUN-680070 06/08/30 By johnray 欄位型態定義,改為LIKE形式
# Modify.........: No.FUN-6A0069 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.TQC-6C0009 06/12/05 By Rayven 語言按鈕有問題，單擊后彈出對話框‘是否運行’選擇‘是’，程序報錯‘資料重復’
# Modify.........: No.FUN-710028 07/01/22 By hellen 錯誤訊息匯總顯示修改
# Modify.........: No.MOD-840622 08/04/24 By lilingyu 盤點編號欄位長度超過16碼則報錯
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.FUN-8A0086 08/10/22 By chenmoyan 完善FUN-710050的錯誤匯總的修改
# Modify.........: No.MOD-8C0276 08/12/29 By clover BEGIN WORK重複 ,將其MARK;查詢無資料SHOW 訊息
# Modify.........: No.FUN-980003 09/08/13 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0036 10/08/09 By vealxu 增加拋轉fca21
# Modify.........: No.FUN-B30211 11/03/31 By yangtingting   未加離開前得cl_used(2)
# Modify.........: No.MOD-C10129 12/01/16 By Polly fca20值改抓g_zero
# Modify.........: No.TQC-C20138 12/02/13 By wujie prompt的语言种类不对
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
    DEFINE tm  RECORD			    	# Print condition RECORD
              lot      LIKE type_file.chr20,                  #stock tag (Y/N)       #No.FUN-680070 VARCHAR(10)
              qty      LIKE type_file.chr1,                          #No.FUN-680070 VARCHAR(01)
              order    LIKE type_file.chr20                    #No.FUN-680070 VARCHAR(10)
              END RECORD,
          g_faj     RECORD 
                    faj01  LIKE faj_file.faj01,    #序號    
                    faj02  LIKE faj_file.faj02,    #財產編號
                    faj022 LIKE faj_file.faj022,   #附號   
                    faj04  LIKE faj_file.faj04,    #資產類別  
                    faj09  LIKE faj_file.faj09,    #資產性質    
                    faj17  LIKE faj_file.faj17,    #數量         
                    faj18  LIKE faj_file.faj18,    #計量單位
                    faj19  LIKE faj_file.faj19,    #保管人       
                    faj20  LIKE faj_file.faj20,    #保管部門      
                    faj21  LIKE faj_file.faj21,    #存放位置      
                    faj58  LIKE faj_file.faj58,    #銷帳數量      
                    faj93  LIKE faj_file.faj93     #FUN-9A0036 族群  
                    END RECORD,
       g_afacnt   LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       g_date     LIKE type_file.dat,          #No.FUN-680070 DATE
       g_zero     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
       g_program  LIKE type_file.chr20,        #No.FUN-680070 VARCHAR(10)
       g_cmd      LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(1000)
       g_wc       string,  #No.FUN-580092 HCN
       l_sw       LIKE type_file.chr1         #No.FUN-680070 VARCHAR(01)
DEFINE g_i             LIKE type_file.num5     #count/index for any purpose       #No.FUN-680070 SMALLINT
DEFINE g_flag          LIKE type_file.chr1,                  #No.FUN-570144       #No.FUN-680070 VARCHAR(1)
       g_change_lang   LIKE type_file.chr1                 #是否有做語言切換 No.FUN-570144       #No.FUN-680070 VARCHAR(01)
 
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			             # Supress DEL key function
 
   INITIALIZE g_bgjob_msgfile TO NULL
   LET g_wc     = ARG_VAL(1)
   LET tm.qty  = ARG_VAL(2)
   LET tm.order  = ARG_VAL(3)
   LET g_bgjob = ARG_VAL(4)    #背景作業
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = "N"
   END IF
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AFA")) THEN
      EXIT PROGRAM
   END IF
 
   IF s_shut(0) THEN EXIT PROGRAM END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time 

   LET g_date  = g_today
   LET g_program = 'afap600'
   LET g_success = 'Y'
    WHILE TRUE
    IF g_bgjob = "N" THEN
      CALL p600_tm()
      IF cl_sure(18,20) THEN
         LET g_success = 'Y'
         BEGIN WORK
         CALL p600_cur()
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
           CLOSE WINDOW p600_w
           EXIT WHILE
        END IF
    ELSE
        CONTINUE WHILE
    END IF
  ELSE
    BEGIN WORK
    LET g_success = 'Y'
    CALL p600_cur()
    CALL s_showmsg()   #No.FUN-710028
    IF g_success = "Y" THEN
       COMMIT WORK
    ELSE
       ROLLBACK WORK
    END IF
    CALL cl_batch_bg_javamail(g_success)
    EXIT WHILE
   END IF
 END WHILE

  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-6A0069
END MAIN
 
FUNCTION p600_tm()
   DEFINE   l_faj01   LIKE faj_file.faj01,
            l_faj02   LIKE faj_file.faj02,
            l_flag    LIKE type_file.chr1,            #No.FUN-680070 VARCHAR(01)
            l_cnt     LIKE type_file.num5,         #No.FUN-680070 SMALLINT
            l_chr     LIKE type_file.chr1,         #No.FUN-680070 VARCHAR(1)
            l_cmd     LIKE type_file.chr1000        #No.FUN-680070 VARCHAR(1000)
   DEFINE   lc_cmd        LIKE type_file.chr1000           #No.FUN-570144       #No.FUN-680070 VARCHAR(500)
 
  OPEN WINDOW p600_w WITH FORM "afa/42f/afap600"
    ATTRIBUTE (STYLE = g_win_style CLIPPED)
 
  CALL cl_ui_init()
  CALL cl_opmsg('z')
 
   #執行前檢查
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.qty = 'Y'
   LET tm.order = '24'
   LET tm2.s1 = '2'
   LET tm2.s2 = '4'
      
   WHILE TRUE
      CONSTRUCT BY NAME g_wc ON faj09,faj04,faj01,faj02,faj021,faj19,faj20,faj21,faj26 
## No:2376 modify 1998/07/17 ----------
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
             CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
       ON ACTION locale
             CALL cl_dynamic_locale()         #No.TQC-6C0009 取消mark
           CALL cl_show_fld_cont()                   #No.FUN-550037 hmf #No.TQC-6C0009 取消mark
#             LET g_action_choice = "locale"
#           LET g_change_lang = TRUE        #->No.FUN-570144  #No.TQC-6C0009 mark
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
 
      
       ON ACTION exit                            #加離開功能
          LET INT_FLAG = 1
          EXIT CONSTRUCT
 
       #No.FUN-580031 --start--
       ON ACTION qbe_select
          CALL cl_qbe_select()
       #No.FUN-580031 ---end---
 
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('fajuser', 'fajgrup') #FUN-980030
### ----------------------------------
 
#NO.FUN-570144 START---
#      IF g_action_choice = "locale" THEN
#         LET g_action_choice = ""
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   #FUN-550037(smin)
         EXIT WHILE
#         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
          LET INT_FLAG = 0 
          CLOSE WINDOW p600_w  #NO.FUN-570144 
          CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
          EXIT PROGRAM         #NO.FUN-570144 
#         EXIT WHILE
      END IF
      DISPLAY BY NAME tm.qty,tm.order
      LET g_bgjob = 'N' #NO.FUN-570144 
      INPUT BY NAME
         tm.lot,tm.qty,tm2.s1,tm2.s2,tm2.s3,
         #tm2.s4,tm2.s5,tm2.s6,tm2.s7
         tm2.s4,tm2.s5,tm2.s6,tm2.s7,g_bgjob  #NO.FUN-570144 
         WITHOUT DEFAULTS 
  
         AFTER FIELD lot   
            IF cl_null(tm.lot) THEN 
               NEXT FIELD lot
            END IF
         #NO.MOD-840622   --Begin--                                                                                                  
            IF LENGTH(tm.lot) > 16 THEN                                                                                             
               CALL cl_err(tm.lot,'afa-933',1)                                                                                      
               LET tm.lot = NULL                                                                                                    
               NEXT FIELD lot                                                                                                       
            END IF                                                                                                                  
 
            SELECT COUNT(*) INTO g_afacnt FROM fca_file
             WHERE fca01 = tm.lot
            IF g_afacnt > 0 THEN 
 
               OPEN WINDOW p600_pro_w WITH 6 ROWS,40 COLUMNS
                       
               WHILE l_chr IS NULL OR l_chr NOT MATCHES'[123]'
                  CASE
                     WHEN g_lang = '0' 
                        DISPLAY"(1).重 新 產 生" AT 2,3
                        DISPLAY"(2).覆 蓋\ 原 資 料" AT 3,3
                        DISPLAY"(3).放 棄 處 理        " AT 4,3
                        LET INT_FLAG = 0  ######add for prompt bug
                        PROMPT "     請選擇 : " FOR CHAR l_chr 
                           ON IDLE g_idle_seconds
                              CALL cl_on_idle()
                           
                           ON ACTION about         
                              CALL cl_about()      
                           
                           ON ACTION help          
                              CALL cl_show_help()  
                           
                           ON ACTION controlg      
                              CALL cl_cmdask()     
                        END PROMPT
 
                     WHEN g_lang = '2' 
#No.TQC-C20138 --begin
#                        DISPLAY"(1).重 新 產 生" AT 2,3
#                        DISPLAY"(2).覆 蓋\ 原 資 料" AT 3,3
#                        DISPLAY"(3).放 棄 處 理        " AT 4,3 
#                        LET INT_FLAG = 0  ######add for prompt bug
#                        PROMPT "     請選擇 : " FOR CHAR l_chr 
                        DISPLAY"(1).重 新 产 生" AT 2,3
                        DISPLAY"(2).覆 盖 原 资 料" AT 3,3
                        DISPLAY"(3).放 弃 处 理        " AT 4,3 
                        LET INT_FLAG = 0  ######add for prompt bug
                        PROMPT "     请选择 : " FOR CHAR l_chr
#No.TQC-C20138 --end
                        #-----TQC-860018---------
                           ON IDLE g_idle_seconds
                              CALL cl_on_idle()
                           
                           ON ACTION about         
                              CALL cl_about()      
                           
                           ON ACTION help          
                              CALL cl_show_help()  
                           
                           ON ACTION controlg      
                              CALL cl_cmdask()     
                        END PROMPT
 
                     OTHERWISE
                        DISPLAY"(1).Regenerate" AT 2,2
                        DISPLAY"(2).Cover orient data" AT 3,2
                        DISPLAY"(3).Quit Process    " AT 4,2
                        LET INT_FLAG = 0  ######add for prompt bug
                        PROMPT "     Option : " FOR CHAR l_chr 
                           ON IDLE g_idle_seconds
                              CALL cl_on_idle()
                           
                           ON ACTION about         #MOD-4C0121
                              CALL cl_about()      #MOD-4C0121
                           
                           ON ACTION help          #MOD-4C0121
                              CALL cl_show_help()  #MOD-4C0121
                           
                           ON ACTION controlg      #MOD-4C0121
                              CALL cl_cmdask()     #MOD-4C0121
                        END PROMPT
                  END CASE
                  IF l_chr NOT MATCHES'[123]' THEN
                     CONTINUE WHILE
                  END IF
                  IF INT_FLAG THEN 
                     LET INT_FLAG = 0 LET l_chr = "3" 
                  END IF
               END WHILE
 
               IF l_chr matches'[3]' THEN
                  EXIT WHILE
               END IF
               IF l_chr matches'[1]' THEN 
                  SELECT COUNT(*) INTO l_cnt FROM fca_file 
                   WHERE fca01 = tm.lot                  
                  IF l_cnt > 0 THEN 
                     DELETE FROM fca_file WHERE fca01 = tm.lot
                     IF SQLCA.sqlcode or SQLCA.sqlerrd[3]=0 THEN 
                        CALL cl_err3("del","fca_file",tm.lot,"",SQLCA.sqlcode,"","Ins:",1)   #No.FUN-660136
                     END IF
                  END IF
               END IF
               CLOSE WINDOW p600_pro_w 
            END IF
         
         AFTER FIELD qty 
            IF cl_null(tm.qty) OR tm.qty NOT MATCHES '[YN]' THEN
               NEXT FIELD qty
            END IF
 
         AFTER INPUT
            LET tm.order = tm2.s1[1,1],tm2.s2[1,1],tm2.s3[1,1],
                           tm2.s4[1,1],tm2.s5[1,1],tm2.s6[1,1],
                           tm2.s7[1,1]
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()	# Command execution
 
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
      #->No.FUN-570144 ---end---
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
  
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
 
#NO.FUN-570144 MARK--------------
#      #------- 按 DEL 鍵結束 -----------
#      IF INT_FLAG THEN
#         LET INT_FLAG = 0
#         CLOSE WINDOW p600_w
#         EXIT PROGRAM
#      END IF
#      IF cl_sure(15,17) THEN
#         CALL p600_cur()
#      END IF
#      ERROR ""
#      IF g_success = 'Y' THEN
#         COMMIT WORK
#         CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#      ELSE 
#         ROLLBACK WORK
#         CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#      END IF
#       IF l_flag THEN CONTINUE WHILE ELSE EXIT WHILE END IF #No.MOD-470567
#      CLOSE WINDOW p600_w
#      EXIT WHILE 
#NO.FUN-570144 MARK--------
 
#NO.FUN-570144 start-------
  IF INT_FLAG THEN
     LET INT_FLAG = 0
     CLOSE WINDOW p600_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
 
  IF g_change_lang THEN
     LET g_change_lang = FALSE
     CALL cl_dynamic_locale()
     CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
     CONTINUE WHILE
  END IF
 
  IF g_bgjob = 'Y' THEN
     SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01 = 'afap600'
     IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
        CALL cl_err('afap600','9031',1)   
     ELSE
        LET g_wc = cl_replace_str(g_wc,"'","\"")
        LET lc_cmd = lc_cmd CLIPPED,
                     " '",g_wc CLIPPED,"'",
                     " '",tm.qty CLIPPED,"'",
                     " '",tm.order CLIPPED,"'",
                     " '",g_bgjob CLIPPED,"'"
        CALL cl_cmdat('afap600',g_time,lc_cmd CLIPPED)
     END IF
     CLOSE WINDOW p600_w
     CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
     EXIT PROGRAM
  END IF
  EXIT WHILE
END WHILE
#NO.FUN-570144 END----------------
END FUNCTION
 
#---->資料處理
FUNCTION p600_cur()
   DEFINE l_name	LIKE type_file.chr20, 		# External(Disk) file name       #No.FUN-680070 VARCHAR(20)
#       l_time          LIKE type_file.chr8	    #No.FUN-6A0069
          l_cnt         LIKE type_file.num5,         #No.FUN-680070 SMALLINT
          l_sql 	LIKE type_file.chr1000,		# RDSQL STATEMENT       #No.FUN-680070 VARCHAR(1000)
          l_za05	LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(40)
	  l_wc          LIKE type_file.chr1000,      #No.FUN-680070 VARCHAR(100)
          l_fca01   LIKE fca_file.fca01,
          l_fca02   LIKE fca_file.fca02,
          l_fca09   LIKE fca_file.fca09,
          l_faj01   LIKE faj_file.faj01,
          l_item    LIKE type_file.num5,         #No.FUN-680070 SMALLINT
	  l_sw      LIKE type_file.chr1,          #No.FUN-680070 VARCHAR(1)
          l_n           LIKE type_file.num5,                #MOD-8C0276
          l_sql2        LIKE type_file.chr1000               #MOD-8C0276
 
 
   LET l_sql = " SELECT faj01,faj02,faj022,faj04,faj09,faj17,faj18,",
               "faj19,faj20,faj21,faj58,faj93",              #FUN-9A0036 add faj93       
               "   FROM faj_file",
               "  WHERE ",g_wc CLIPPED,
               "    AND faj43 not IN ('0','5','6','X')",
               "    AND (faj17 - faj58) > 0 "
 
   #MOD-8C0276--add start
   LET l_sql2 = " SELECT count(*) ",
               "   FROM faj_file",
               "  WHERE ",g_wc CLIPPED,
               "    AND faj43 not IN ('0','5','6','X')",
               "    AND (faj17 - faj58) > 0 "
   PREPARE p600_pr2 FROM l_sql2
   DECLARE p600_cs2 CURSOR FOR p600_pr2
   
   FOREACH p600_cs2 INTO l_n
      IF l_n = 0 THEN
         LET  g_success = 'N'
      END IF
   END FOREACH
   #MOD-8C0276 --add --end
 
 
     LET l_sw='N'         
     FOR g_i = 1 TO 8       #資料產生順序
        CASE tm.order[g_i,g_i] 
 	   WHEN '1' IF l_sw='N' THEN 
                       LET l_wc=' ORDER BY faj09' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,faj09' 
                    END IF
           WHEN '2' IF l_sw='N' THEN
                       LET l_wc=' ORDER BY faj04' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,faj04'
                    END IF
           WHEN '3' IF l_sw ='N' THEN
                       LET l_wc= 'ORDER BY faj01' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,faj01'
                    END IF
           WHEN '4' IF l_sw='N' THEN
                       LET l_wc=' ORDER BY faj02' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,faj02'
                    END IF
           WHEN '5' IF l_sw='N' THEN
                       LET l_wc=' ORDER BY faj021' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,faj021'
                    END IF
           WHEN '6' IF l_sw='N' THEN 
	 	       LET l_wc=' ORDER BY faj19' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,faj19'
                    END IF
           WHEN '7' 
                    IF l_sw='N' THEN 
                       LET l_wc='ORDER BY faj20'  LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,faj20'
                    END IF 
           WHEN '8' IF l_sw='N' THEN
                       LET l_wc='ORDER BY faj21' LET l_sw='Y'
                    ELSE LET l_wc=l_wc CLIPPED,' ,faj21'
                    END IF     
           OTHERWISE LET l_wc = l_wc  CLIPPED
                     EXIT FOR 
        END CASE
        
     END FOR
     LET l_sql = l_sql CLIPPED,l_wc CLIPPED
 
     PREPARE p600_prepare1 FROM l_sql
     IF SQLCA.sqlcode != 0 THEN 
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time      #FUN-B30211
         EXIT PROGRAM
     END IF
     DECLARE p600_cs1 CURSOR WITH HOLD FOR p600_prepare1
 
     #BEGIN WORK    #MOD-8C0276
 
     CALL s_showmsg_init()    #No.FUN-710028
     FOREACH p600_cs1 INTO g_faj.*
       IF SQLCA.sqlcode != 0 THEN
#         CALL cl_err('foreach:',SQLCA.sqlcode,1)         #No.FUN-710028
          CALL s_errmsg('','','foreach:',SQLCA.sqlcode,1) #No.FUN-710028
          LET g_success = 'N'                             #No.FUN-8A0086
          EXIT FOREACH 
       END IF
  
       LET g_success = 'Y'
       SELECT fca02 INTO l_fca02 FROM fca_file
        WHERE fca01  = tm.lot
          AND fca03  = g_faj.faj02
          AND fca031 = g_faj.faj022
       IF STATUS <> 100 THEN
        { SELECT max(fca02)+1 INTO l_fca02
            FROM fca_file
           WHERE fca01  = tm.lot
             AND fca03  = g_faj.faj02
             AND fca031 = g_faj.faj022}
          IF tm.qty = 'Y' THEN
             LET l_fca09 = g_faj.faj17 - g_faj.faj58
          ELSE
             LET l_fca09 = 0 
          END IF
          IF cl_null(l_fca02) THEN
             LET l_fca02 = 1
          END IF
     UPDATE fca_file SET 
            fca01=tm.lot       ,fca02=l_fca02,
            fca03=g_faj.faj02  ,fca031=g_faj.faj022,
            fca04=g_faj.faj01  ,fca05=g_faj.faj20,
            fca06=g_faj.faj19  ,fca07=g_faj.faj21,
            fca08=g_faj.faj18  ,fca09=l_fca09,
            fca10=g_faj.faj20  ,fca11=g_faj.faj19,
            fca12=g_faj.faj21  ,fca13='',
            fca14=''           ,fca15='N',
            fca16=g_user       ,fca17=g_today,
            fca18=''           ,fca19='',
           #fca20=g_zeroi      ,fca21=g_faj.faj93            #FUN-9A0036 add fca21 #MOD-C10129 mark
            fca20=g_zero       ,fca21=g_faj.faj93            #MOD-C10129 add
 
           WHERE fca01 = tm.lot
             AND fca03 = g_faj.faj02
             AND fca031 = g_faj.faj022
          IF SQLCA.sqlcode or SQLCA.sqlerrd[3]=0 THEN 
#            CALL cl_err('Update:',SQLCA.sqlcode,1)   #No.FUN-660136
#            CALL cl_err3("upd","fca_file",tm.lot,g_faj.faj02,SQLCA.sqlcode,"","Update:",1)  #No.FUN-660136 #No.FUN-710028
             LET g_showmsg = tm.lot,"/",g_faj.faj02,"/",g_faj.faj022                         #No.FUN-710028
             CALL s_errmsg('fca01,fca03,fca031',g_showmsg,'Update:',SQLCA.sqlcode,1)         #No.FUN-710028
             LET g_success = 'N'
#            RETURN            #No.FUN-710028
             CONTINUE FOREACH  #No.FUN-710028
          END IF
     ELSE
          SELECT max(fca02)+1 INTO l_fca02
            FROM fca_file
           WHERE fca01  = tm.lot
          IF tm.qty = 'Y' THEN
             LET l_fca09 = g_faj.faj17 - g_faj.faj58
          ELSE
             LET l_fca09 = 0 
          END IF
          IF cl_null(l_fca02) THEN
             LET l_fca02 = 1
          END IF
           INSERT INTO fca_file(fca01,fca02,fca03,fca031,fca04,fca05,fca06, #No.MOD-470041
                               fca07,fca08,fca09,fca10,fca11,fca12,fca13,
                               fca14,fca15,fca16,fca17,fca18,fca19,fca20,fca21,              #FUN-9A0036 add fca21
                               fcalegal) #FUN-980003 add
               VALUES (tm.lot,l_fca02,g_faj.faj02,g_faj.faj022,g_faj.faj01,
                       g_faj.faj20,g_faj.faj19,g_faj.faj21,g_faj.faj18,
                       l_fca09,g_faj.faj20,g_faj.faj19,g_faj.faj21,'','',
                       'N',g_user,g_today,'','',g_zero,g_faj.faj93,                          #FUN-9A0036 add g_faj.faj93   
                       g_legal)          #FUN-980003 add
          IF SQLCA.sqlcode or SQLCA.sqlerrd[3]=0 THEN 
#            CALL cl_err('Ins:',SQLCA.sqlcode,1)   #No.FUN-660136
#            CALL cl_err3("ins","fca_file",tm.lot,l_fca02,SQLCA.sqlcode,"","Ins:",1)   #No.FUN-660136 #No.FUN-710028
             LET g_showmsg = tm.lot,"/",l_fca02    #No.FUN-710028
             CALL s_errmsg('fca01,fca02',g_showmsg,'Ins:',SQLCA.sqlcode,1)  #No.FUN-710028
             LET g_success = 'N'
#            RETURN           #No.FUN-710028
             CONTINUE FOREACH #No.FUN-710028
          END IF
       END IF
       END FOREACH
#No.FUN-710028 --begin                                                                                                              
       IF g_totsuccess="N" THEN                                                                                                        
          LET g_success="N"                                                                                                            
       END IF                                                                                                                          
#No.FUN-710028 --end
 
END FUNCTION
