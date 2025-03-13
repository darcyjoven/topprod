# Prog. Version..: '5.30.06-13.03.12(00001)'     #
#
# Pattern name...: gglp601.4gl
# Descriptions...: 期末結轉作業 (整批資料處理作業)
# Input parameter: 
# Return code....: 
# Modify ........: No.FUN-570145 06/02/28 By yiting 批次背景執行
# Modify.........: No.FUN-660123 06/06/19 By Jackho cl_err --> cl_err3
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-710023 07/01/16 By yjkhero 錯誤訊息匯整
# Modify.........: No.TQC-720032 07/03/01 By johnray 修正期別檢核方式
# Modify.........: No.FUN-780068 07/08/31 By Sarah INPUT條件增加輸入asg01,asg05,asg06,atq_file SCHEMA改變,修改結轉下期方法
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B60144 11/07/01 By lixiang  呼叫sgglp601.4gl
# Modify.........: NO.FUN-BB0037 11/11/22 By lilingyu 合併報表移植

DATABASE ds
 
GLOBALS "../../config/top.global"    #FUN-BB0037

#No.FUN-B60144--mark-- 
#DEFINE tm      RECORD
#               aaa04  LIKE aaa_file.aaa04,
#               aaa05  LIKE aaa_file.aaa05,
#               asg01  LIKE asg_file.asg01,   #公司編號   #FUN-780068 add
#               asg05  LIKE asg_file.asg05,   #帳別       #FUN-780068 add
#               asg06  LIKE asg_file.asg06    #幣別       #FUN-780068 add
#              END RECORD,
#      close_y,close_m LIKE type_file.num5,   #closing year & month  #No.FUN-680098   SMALLINT   
#      l_yy,l_mm       LIKE type_file.num5,   #No.FUN-680098  SMALLINT  
#      b_date          LIKE type_file.dat,    #期間起始日期   #No.FUN-680098 DATE
#      e_date          LIKE type_file.dat,    #期間起始日期   #No.FUN-680098 DATE
#      g_bookno        LIKE aea_file.aea00,   #帳別
#      bno             LIKE type_file.chr6,   #起始傳票編號   #No.FUN-680098 VARCHAR(6)    
#      eno             LIKE type_file.chr6    #截止傳票編號   #No.FUN-680098 VARCHAR(6)    
#DEFINE ls_date         STRING,                #No.FUN-570145
#      l_flag          LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)
#      g_change_lang   LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1) 
#
#No.FUN-B60144--mark--

MAIN
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0073
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT

#No.FUN-B60144--mark-- 
#  LET g_bookno = ARG_VAL(1)
# #-->No.FUN-570145 --start
#  INITIALIZE g_bgjob_msgfile TO NULL
#  LET tm.aaa04    = ARG_VAL(2)                   #結轉年度
#  LET tm.aaa05    = ARG_VAL(3)                   #結轉期別
#  LET tm.asg01    = ARG_VAL(3)                   #公司編號   #FUN-780068 add
#  LET tm.asg05    = ARG_VAL(4)                   #帳別       #FUN-780068 add
#  LET tm.asg06    = ARG_VAL(5)                   #幣別       #FUN-780068 add
#  LET g_bgjob     = ARG_VAL(6)
#  IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
# #--- No.FUN-570145 --end---
#
#No.FUN-B60144--mark--

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114

#No.FUN-B60144--mark-- 
#  IF g_bookno IS NULL OR g_bookno = ' ' THEN
#     SELECT aaz64 INTO g_bookno FROM aaz_file
#  END IF
##NO.FUN-570145 START
#   #CALL gglp601_tm(0,0)
#  WHILE TRUE
#     LET g_change_lang = FALSE
#     IF g_bgjob = 'N' THEN
#        CALL gglp601_tm(0,0)
#        IF cl_sure(21,21) THEN
#           CALL cl_wait()
#           LET g_success = 'Y'
#           BEGIN WORK
#           CALL p003()
#           CALL s_showmsg()                          #NO.FUN-710023     
#           IF g_success='Y' THEN
#              COMMIT WORK
#              CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#           ELSE
#              ROLLBACK WORK
#              CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#           END IF
#           IF l_flag THEN
#              CONTINUE WHILE
#           ELSE
#              CLOSE WINDOW gglp601_w
#              EXIT WHILE
#           END IF
#        END IF
#     ELSE
#        IF tm.aaa05=1 THEN   #結轉期別=1
#           LET l_yy = tm.aaa04-1 LET l_mm = 12
#        ELSE
#           LET l_yy = tm.aaa04   LET l_mm = tm.aaa05-1
#        END IF
#
#        LET g_success = 'Y'
#        BEGIN WORK
#        CALL p003()
#        CALL s_showmsg()                             #NO.FUN-710023    
#        IF g_success = 'Y' THEN
#           COMMIT WORK
#        ELSE
#           ROLLBACK WORK
#        END IF
#        CALL cl_batch_bg_javamail(g_success)
#        EXIT WHILE
#     END  IF
#  END WHILE
#->No.FUN-570145 ---end---
#No.FUN-B60144--mark--

   CALL gglp601('1')       #No.FUN-B60144  
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN

#No.FUN-B60144--mark-- 
#FUNCTION gglp601_tm(p_row,p_col)
#  DEFINE  p_row,p_col     LIKE type_file.num5       #No.FUN-680098 SMALLINT
#          #l_flag         LIKE type_file.chr1       #FUN-570145        #No.FUN-680098   VARCHAR(1) 
#  DEFINE  lc_cmd          LIKE type_file.chr1000    #FUN-570145        #No.FUN-680098   VARCHAR(500)  
#
#  CALL s_dsmark(g_bookno)
#
#  LET p_row = 4 LET p_col = 26
#
#  OPEN WINDOW gglp601_w AT p_row,p_col WITH FORM "agl/42f/gglp601" 
#       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
#   
#  CALL cl_ui_init()
#
#  CALL s_shwact(0,0,g_bookno)
#  CALL cl_opmsg('q')
#  WHILE TRUE 
#     IF s_shut(0) THEN RETURN END IF
#     CLEAR FORM 
#     INITIALIZE tm.* TO NULL			# Defaealt condition
#
#     #結轉年度,結轉期別,關帳年度,關帳期別
#     SELECT aaa04,aaa05,YEAR(aaa07),MONTH(aaa07) 
#       INTO tm.aaa04,tm.aaa05,close_y,close_m FROM aaa_file
#      WHERE aaa01 = g_bookno
#     DISPLAY BY NAME tm.aaa04,tm.aaa05
#
#     LET g_bgjob = 'N'                              #FUN-570145
#     #INPUT tm.aaa04,tm.aaa05 WITHOUT DEFAULTS FROM aaa04,aaa05
#     INPUT tm.aaa04,tm.aaa05,tm.asg01,tm.asg05,tm.asg06,g_bgjob WITHOUT DEFAULTS    #FUN-780068 add tm.asg01,tm.asg05,tm.asg06
#      FROM aaa04,aaa05,asg01,asg05,asg06,g_bgjob                                    #FUN-780068 add asg01,asg05,asg06
#        #NO.FUN-570145 MARK--
#        #ON ACTION locale
#        #     CALL cl_dynamic_locale()
#        #    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#        #NO.FUN-570145 END
#
#        AFTER FIELD aaa04
#           IF cl_null(tm.aaa04) THEN
#              NEXT FIELD tm.aaa04
#           END IF
#           IF tm.aaa04<close_y THEN 
#              CALL cl_err('','agl-085',0) 
#              NEXT FIELD aaa04
#           END IF
#
#        AFTER FIELD aaa05 
#No.TQC-720032 -- beatk --
#           IF NOT cl_null(tm.aaa05) THEN
#              SELECT azm02 INTO g_azm.azm02 FROM azm_file
#                WHERE azm01 = tm.aaa04
#              IF g_azm.azm02 = 1 THEN
#                 IF tm.aaa05 > 12 OR tm.aaa05 < 1 THEN
#                    CALL cl_err('','agl-020',0)
#                    NEXT FIELD aaa05
#                 END IF
#              ELSE
#                 IF tm.aaa05 > 13 OR tm.aaa05 < 1 THEN
#                    CALL cl_err('','agl-020',0)
#                    NEXT FIELD aaa05
#                 END IF
#              END IF
#           END IF
#No.TQC-720032 -- end --
#           IF cl_null(tm.aaa05) THEN
#               NEXT FIELD aaa05
#           END IF
#           IF tm.aaa04*100+tm.aaa05 < close_y*100+close_m THEN
#              CALL cl_err('','agl-085',0) 
#               NEXT FIELD aaa05
#           END IF
#           #上一期年(l_yy)/月(l_mm)
#           IF tm.aaa05=1 THEN 
#              LET l_yy=tm.aaa04-1 LET l_mm=12
#           ELSE
#              LET l_yy=tm.aaa04 LET l_mm=tm.aaa05-1
#           END IF
#
#       #str FUN-780068 add
#        AFTER FIELD asg01    #公司編號
#           IF cl_null(tm.asg01) THEN NEXT FIELD asg01 END IF
#           SELECT asg05,asg06 INTO tm.asg05,tm.asg06 FROM asg_file
#            WHERE asg01 = tm.asg01
#           IF STATUS THEN
#              CALL cl_err(tm.asg01,'aco-025',0) NEXT FIELD asg01
#           ELSE
#              DISPLAY BY NAME tm.asg05,tm.asg06
#           END IF
#
#        ON ACTION CONTROLP
#           CASE
#              WHEN INFIELD(asg01)   #公司編號
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = 'q_asg'
#                  LET g_qryparam.default1 = tm.asg01
#                  CALL cl_create_qry() RETURNING tm.asg01
#                  DISPLAY BY NAME tm.asg01
#                  NEXT FIELD asg01
#              WHEN INFIELD(asg05)   #帳別
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = 'q_aaa'
#                  LET g_qryparam.default1 = tm.asg05
#                  CALL cl_create_qry() RETURNING tm.asg05
#                  DISPLAY BY NAME tm.asg05
#                  NEXT FIELD asg05
#              WHEN INFIELD(asg06)   #幣別
#                  CALL cl_init_qry_var()
#                  LET g_qryparam.form = 'q_azi'
#                  LET g_qryparam.default1 = tm.asg06
#                  CALL cl_create_qry() RETURNING tm.asg06
#                  DISPLAY BY NAME tm.asg06
#                  NEXT FIELD asg06
#              OTHERWISE EXIT CASE
#           END CASE
#       #end FUN-780068 add
#
#        ON ACTION CONTROLZ
#           CALL cl_show_req_fields()
#
#        ON ACTION CONTROLG
#           CALL cl_cmdask()
#
#        ON IDLE g_idle_seconds
#           CALL cl_on_idle()
#           CONTINUE INPUT
#
#        ON ACTION about         #MOD-4C0121
#           CALL cl_about()      #MOD-4C0121
#
#        ON ACTION help          #MOD-4C0121
#           CALL cl_show_help()  #MOD-4C0121
#
#        ON ACTION exit                            #加離開功能
#           LET INT_FLAG = 1
#           EXIT INPUT
#  
#        #No.FUN-580031 --start--
#        BEFORE INPUT
#           CALL cl_qbe_init()
#        #No.FUN-580031 ---end---
#
#        #No.FUN-580031 --start--
#        ON ACTION qbe_select
#           CALL cl_qbe_select()
#        #No.FUN-580031 ---end---
#
#        #No.FUN-580031 --start--
#        ON ACTION qbe_save
#           CALL cl_qbe_save()
#        #No.FUN-580031 ---end---
#
#        #->FUN-570145-start----------
#        ON ACTION locale
#           #CALL cl_dynamic_locale()
#           CALL cl_show_fld_cont()               #No.FUN-550037 hmf
#           LET g_change_lang = TRUE
#           EXIT INPUT
#        #->FUN-570145-end------------
#
#     END INPUT
#    #FUN-570145 --start--
#     #IF INT_FLAG THEN LET INT_FLAG = 0 EXIT PROGRAM  END IF
#     IF g_change_lang THEN
#        LET g_change_lang = FALSE
#        CALL cl_dynamic_locale()
#        CALL cl_show_fld_cont()               #No.FUN-550037 hmf
#        CONTINUE WHILE
#     END IF
#     IF INT_FLAG THEN
#        LET INT_FLAG = 0
#        CLOSE WINDOW gglp601_w
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#        EXIT PROGRAM
#     END IF
#
#     IF cl_sure(21,21) THEN
#        CALL cl_wait()
#        #期末結轉(END OF MONTH)
#        LET g_success = 'Y'
#        BEGIN WORK
#-----------------------------月結
#        CALL p003()
#        IF g_success='Y' THEN
#           COMMIT WORK
#           CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
#        ELSE
#           ROLLBACK WORK
#           CALL cl_end2(2) RETURNING l_flag        #批次作業失敗
#        END IF
#        IF l_flag THEN
#           CONTINUE WHILE
#        ELSE
#           EXIT WHILE
#        END IF
#     END  IF
#     ERROR ""
#  END WHILE
#  CLOSE WINDOW gglp601_w
#     IF g_bgjob = 'Y' THEN
#        SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'gglp601'
#        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
#           CALL cl_err('gglp601','9031',1)   
#        ELSE
#           LET lc_cmd = lc_cmd CLIPPED,
#                        " ''",
#                        " '",tm.aaa04 CLIPPED,"'",
#                        " '",tm.aaa05 CLIPPED,"'",
#                        " '",tm.asg01 CLIPPED,"'",   #FUN-780068 add
#                        " '",tm.asg05 CLIPPED,"'",   #FUN-780068 add
#                        " '",tm.asg06 CLIPPED,"'",   #FUN-780068 add
#                        " '",g_bgjob CLIPPED,"'"
#           CALL cl_cmdat('gglp601',g_time,lc_cmd CLIPPED)
#        END IF
#        CLOSE WINDOW gglp601_w
#        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
#        EXIT PROGRAM
#     END IF
#     EXIT WHILE
#No.FUN-570145 ---end---
#  END WHILE
#END FUNCTION
#
#FUNCTION p003()
#DEFINE l_atq_o RECORD LIKE atq_file.*
#DEFINE l_atq_n RECORD LIKE atq_file.*
#DEFINE l_ats01 LIKE ats_file.ats01,   #分類代碼   #FUN-780068 add
#      l_atr04 LIKE atr_file.atr04    #異動金額
#
#
#  ### -->1.結轉前先刪除舊資料
#  DELETE FROM atq_file
#   WHERE atq01 = tm.aaa04   #年度 
#     AND atq02 = tm.aaa05   #月份
#     AND atq14 = tm.asg01   #公司編號
#     AND atq15 = tm.asg05   #帳別
#     AND atq16 = tm.asg06   #幣別
#  IF SQLCA.sqlcode THEN
#     CALL cl_err3("del","atq_file",tm.aaa04,tm.aaa05,SQLCA.sqlcode,"","del atq_file",1)
#     LET g_success = 'N'
#     RETURN
#  END IF
#
#  INITIALIZE l_atq_o.* TO NULL
#
# #str FUN-780068 mod
#  ### -->2.開始結轉資料
#  #找出上一期的atq
#  DECLARE atq_cs1 CURSOR FOR 
#     SELECT * FROM atq_file 
#      WHERE atq01 = l_yy       #上一期年度 
#        AND atq02 = l_mm       #上一期月份
#        AND atq14 = tm.asg01   #公司編號
#        AND atq15 = tm.asg05   #帳別
#        AND atq16 = tm.asg06   #幣別
#      ORDER BY atq17           #分類
#
#  CALL s_showmsg_init()                     #NO.FUN-710023 
#  FOREACH atq_cs1 INTO l_atq_o.*
#     #NO.FUN-710023--BEGIN                                                           
#     IF g_success='N' THEN                                                    
#        LET g_totsuccess='N'                                                   
#        LET g_success='Y' 
#     END IF                                                     
#     #NO.FUN-710023--END
#
#     IF SQLCA.sqlcode THEN
#        LET g_showmsg=l_yy,"/",l_mm,"/",tm.asg01,"/",tm.asg05,"/",tm.asg06
#        CALL s_errmsg('atq01,atq02,atq14,atq15,atq16',g_showmsg,'(atq_cs1#1:foreach)',SQLCA.sqlcode,1)
#        LET g_success='N' RETURN                             
#     END IF
#
#     INITIALIZE l_atq_n.* TO NULL
#
#     LET l_atq_n.atq01 = tm.aaa04       #年度
#     LET l_atq_n.atq02 = tm.aaa05       #月份
#     LET l_atq_n.atq14 = tm.asg01       #公司編號    #FUN-780068 add
#     LET l_atq_n.atq15 = tm.asg05       #帳別        #FUN-780068 add
#     LET l_atq_n.atq16 = tm.asg06       #幣別        #FUN-780068 add
#     LET l_atq_n.atq17 = l_atq_o.atq17  #分類代碼    #FUN-780068 add
#     LET l_atq_n.atq18 = l_atq_o.atq18  #餘額        #FUN-780068 add
#     LET l_atq_n.atquser = g_user
#     LET l_atq_n.atqgrup = g_grup
#     LET l_atq_n.atqdate = g_today
#     LET l_atq_n.atqlegal = g_legal     #FUN-980003 add
#
#     LET l_atr04 = 0
#     #本期異動金額
#     SELECT SUM(atr04) INTO l_atr04 
#       FROM atr_file,ats_file
#      WHERE ats01 = atr14
#        AND atr01 = tm.aaa04       #年度
#        AND atr02 = tm.aaa05       #月份
#        AND atr11 = tm.asg01       #公司編號
#        AND atr12 = tm.asg05       #帳別
#        AND atr13 = tm.asg06       #幣別
#        AND atr14 = l_atq_n.atq17  #分類代碼
#      GROUP BY ats01
#     IF cl_null(l_atr04) THEN LET l_atr04 = 0 END IF
#
#     #本期餘額 = 上期餘額 + 本期異動金額
#     LET l_atq_n.atq18 = l_atq_n.atq18 + l_atr04
#
#     LET l_atq_n.atqoriu = g_user      #No.FUN-980030 10/01/04
#     LET l_atq_n.atqorig = g_grup      #No.FUN-980030 10/01/04
#     INSERT INTO atq_file VALUES (l_atq_n.*)
#     IF STATUS THEN
#        UPDATE atq_file SET atq18 = l_atq_n.atq18,
#                            atqmodu = g_user,
#                            atqdate = g_today
#                      WHERE atq01 = l_atq_n.atq01   #年度 
#                        AND atq02 = l_atq_n.atq02   #月份
#                        AND atq14 = l_atq_n.atq14   #公司編號
#                        AND atq15 = l_atq_n.atq15   #帳別
#                        AND atq16 = l_atq_n.atq16   #幣別
#                        AND atq17 = l_atq_n.atq17   #分類代碼
#        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#           CALL cl_err('upd_atq)',SQLCA.sqlcode,1)   #No.FUN-660123
#           CALL cl_err3("upd","atq_file",tm.aaa04,tm.aaa05,SQLCA.sqlcode,"","upd_atq",1)   #No.FUN-660123 #NO.FUN-710023
#           LET g_showmsg=tm.aaa04,"/",tm.aaa05 
#           CALL s_errmsg('atq01,atq02',g_showmsg,'upd_atq)',SQLCA.sqlcode,1) #NO.FUN-710023 
#           LET g_success='N' RETURN 
#        END IF
#     END IF
#  END FOREACH
#
#  #找看看有沒有上期沒有，本期卻增加的分類代碼
#  DECLARE atr_cs1 CURSOR FOR
#     SELECT ats01,SUM(atr04)
#       FROM atr_file,ats_file
#      WHERE ats01 = atr14
#        AND atr01 = tm.aaa04       #年度
#        AND atr02 = tm.aaa05       #月份
#        AND atr11 = tm.asg01       #公司編號
#        AND atr12 = tm.asg05       #帳別
#        AND atr13 = tm.asg06       #幣別
#        AND atr14 NOT IN (SELECT atr14 FROM atr_file
#                           WHERE atr01 = l_yy           #年度
#                             AND atr02 = l_mm           #月份
#                             AND atr11 = tm.asg01       #公司編號
#                             AND atr12 = tm.asg05       #帳別
#                             AND atr13 = tm.asg06)      #幣別
#        AND atr14 NOT IN (SELECT atq17 FROM atq_file
#                           WHERE atq01 = l_yy           #年度 
#                             AND atq02 = l_mm           #月份
#                             AND atq14 = tm.asg01       #公司編號
#                             AND atq15 = tm.asg05       #帳別
#                             AND atq16 = tm.asg06)      #幣別
#      GROUP BY ats01
#
#  FOREACH atr_cs1 INTO l_ats01,l_atr04
#     #NO.FUN-710023--BEGIN                                                           
#     IF g_success='N' THEN                                                    
#        LET g_totsuccess='N'                                                   
#        LET g_success='Y' 
#     END IF                                                     
#     #NO.FUN-710023--END
#
#     IF SQLCA.sqlcode THEN
#        LET g_showmsg=tm.aaa04,"/",tm.aaa05,"/",tm.asg01,"/",tm.asg05,"/",tm.asg06
#        CALL s_errmsg('atr01,atr02,atr11,atr12,atr13',g_showmsg,'(atr_cs1#1:foreach)',SQLCA.sqlcode,1)
#        LET g_success='N' RETURN                             
#     END IF
#
#     INITIALIZE l_atq_n.* TO NULL
#
#     LET l_atq_n.atq01 = tm.aaa04       #年度
#     LET l_atq_n.atq02 = tm.aaa05       #月份
#     LET l_atq_n.atq14 = tm.asg01       #公司編號    #FUN-780068 add
#     LET l_atq_n.atq15 = tm.asg05       #帳別        #FUN-780068 add
#     LET l_atq_n.atq16 = tm.asg06       #幣別        #FUN-780068 add
#     LET l_atq_n.atq17 = l_ats01        #分類代碼    #FUN-780068 add
#     LET l_atq_n.atq18 = l_atr04        #餘額        #FUN-780068 add
#     LET l_atq_n.atquser = g_user
#     LET l_atq_n.atqgrup = g_grup
#     LET l_atq_n.atqdate = g_today
#     LET l_atq_n.atqlegal = g_legal     #FUN-980003 add
#
#     INSERT INTO atq_file VALUES (l_atq_n.*)
#     IF STATUS THEN
#        UPDATE atq_file SET atq18 = atq18+l_atr04,
#                            atqmodu = g_user,
#                            atqdate = g_today
#                      WHERE atq01 = l_atq_n.atq01   #年度 
#                        AND atq02 = l_atq_n.atq02   #月份
#                        AND atq14 = l_atq_n.atq14   #公司編號
#                        AND atq15 = l_atq_n.atq15   #帳別
#                        AND atq16 = l_atq_n.atq16   #幣別
#                        AND atq17 = l_ats01         #分類代碼
#        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#           CALL cl_err('upd_atq)',SQLCA.sqlcode,1)   #No.FUN-660123
#           CALL cl_err3("upd","atq_file",tm.aaa04,tm.aaa05,SQLCA.sqlcode,"","upd_atq",1)   #No.FUN-660123 #NO.FUN-710023
#           LET g_showmsg=tm.aaa04,"/",tm.aaa05 
#           CALL s_errmsg('atq01,atq02',g_showmsg,'upd_atq)',SQLCA.sqlcode,1) #NO.FUN-710023 
#           LET g_success='N' RETURN 
#        END IF
#     END IF
#  END FOREACH
# #end FUN-780068 mod
#
#  #NO.FUN-710023--BEGIN                                                           
#  IF g_totsuccess="N" THEN                                                        
#     LET g_success="N"                                                           
#  END IF                                                                          
#  #NO.FUN-710023--END
#
#END FUNCTION
#No.FUN-B60144--mark--
