# Prog. Version..: '5.30.06-13.03.12(00000)'     #
#
# Pattern name...: saglp003.4gl
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
# Modify.........: No.FUN-780068 07/08/31 By Sarah INPUT條件增加輸入axz01,axz05,axz06,axn_file SCHEMA改變,修改結轉下期方法
# Modify.........: No.FUN-980003 09/08/11 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-B60144 11/07/01 By lixiang copy from aglp003,移除axz01,axz06
# Modify.........: NO.FUN-BB0065 12/03/06 BY yiting axn->ayd, axo->aye,結轉時要加入key:族群及上層公司為key,並將aglp003獨立程式
# Modify.........: NO.FUN-C10054 12/03/06 By belle  畫面上的「期別」直接default'0',並且不可輸入
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE tm      RECORD
                aaa04  LIKE aaa_file.aaa04,
                aaa05  LIKE aaa_file.aaa05,
              # axz01  LIKE axz_file.axz01,   #公司編號   #FUN-780068 add   #No.FUN-B60144
                axz05  LIKE axz_file.axz05    #帳別       #FUN-780068 add  
              # axz06  LIKE axz_file.axz06    #幣別       #FUN-780068 add   #No.FUN-B60144
               END RECORD,
       close_y,close_m LIKE type_file.num5,   #closing year & month  #No.FUN-680098   SMALLINT   
       l_yy,l_mm       LIKE type_file.num5,   #No.FUN-680098  SMALLINT  
       b_date          LIKE type_file.dat,    #期間起始日期   #No.FUN-680098 DATE
       e_date          LIKE type_file.dat,    #期間起始日期   #No.FUN-680098 DATE
       g_bookno        LIKE aea_file.aea00,   #帳別
       bno             LIKE type_file.chr6,   #起始傳票編號   #No.FUN-680098 VARCHAR(6)    
       eno             LIKE type_file.chr6    #截止傳票編號   #No.FUN-680098 VARCHAR(6)    
DEFINE ls_date         STRING,                #No.FUN-570145
       l_flag          LIKE type_file.chr1,   #No.FUN-680098  VARCHAR(1)
       g_change_lang   LIKE type_file.chr1    #No.FUN-680098  VARCHAR(1) 
DEFINE g_argv1         LIKE type_file.chr1    #No.FUN-B60144
 
#MAIN           #No.FUN-B60144
#     DEFINE    l_time LIKE type_file.chr8              #No.FUN-6A0073
FUNCTION aglp003(p_argv1)                            #No.FUN-B60144
   DEFINE p_argv1     LIKE type_file.chr1            #No.FUN-B60144
 
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT
#No.FUN-B60144--add 
   LET g_argv1=p_argv1
   IF g_argv1 = '1' THEN
      LET g_prog= 'aglp003'
   ELSE
      LET g_prog= 'aglp0031'
   END IF
#No.FUN-B60144--end

   LET g_bookno = ARG_VAL(1)
  #-->No.FUN-570145 --start
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.aaa04    = ARG_VAL(2)                   #結轉年度
   LET tm.aaa05    = ARG_VAL(3)                   #結轉期別
  #LET tm.axz01    = ARG_VAL(3)                   #公司編號   #FUN-780068 add   #No.FUN-B60144
   LET tm.axz05    = ARG_VAL(4)                   #帳別       #FUN-780068 add
  #LET tm.axz06    = ARG_VAL(5)                   #幣別       #FUN-780068 add   #No.FUN-B60144
   LET g_bgjob     = ARG_VAL(6)
   IF cl_null(g_bgjob) THEN LET g_bgjob = 'N' END IF
  #--- No.FUN-570145 --end---

#No.FUN-B60144--mark 
#  IF (NOT cl_user()) THEN
#     EXIT PROGRAM
#  END IF
#No.FUN-B60144--mark
  
   WHENEVER ERROR CALL cl_err_msg_log

#No.FUN-B60144--mark  
#  IF (NOT cl_setup("AGL")) THEN
#     EXIT PROGRAM
#  END IF
#  CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
#No.FUN-B60144
 
   IF g_bookno IS NULL OR g_bookno = ' ' THEN
      SELECT aaz64 INTO g_bookno FROM aaz_file
   END IF
#NO.FUN-570145 START
    #CALL aglp003_tm(0,0)
   WHILE TRUE
      LET g_change_lang = FALSE
      IF g_bgjob = 'N' THEN
         CALL aglp003_tm(0,0)
         IF cl_sure(21,21) THEN
            CALL cl_wait()
            LET g_success = 'Y'
            BEGIN WORK
            CALL p003()
            CALL s_showmsg()                          #NO.FUN-710023     
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
               CLOSE WINDOW aglp003_w
               EXIT WHILE
            END IF
         END IF
      ELSE
        #FUN-C10054--mark--
        #IF tm.aaa05=0 THEN      #FUN-BB0065
        ##IF tm.aaa05=1 THEN   
        #   LET l_yy = tm.aaa04-1 LET l_mm = 12
        #ELSE
        #   LET l_yy = tm.aaa04   LET l_mm = tm.aaa05-1
        #END IF
        #FUN-C10054--mark--
         LET l_mm = 0            #FUN-C10054 add
 
         LET g_success = 'Y'
         BEGIN WORK
         CALL p003()
         CALL s_showmsg()                             #NO.FUN-710023    
         IF g_success = 'Y' THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
      END  IF
   END WHILE
#->No.FUN-570145 ---end---
 
#  CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114    #No.FUN-B60144
#END MAIN                                                            #No.FUN-B60144
END FUNCTION    #No.FUN-B60144 
 
FUNCTION aglp003_tm(p_row,p_col)
   DEFINE  p_row,p_col     LIKE type_file.num5       #No.FUN-680098 SMALLINT
           #l_flag         LIKE type_file.chr1       #FUN-570145        #No.FUN-680098   VARCHAR(1) 
   DEFINE  lc_cmd          LIKE type_file.chr1000    #FUN-570145        #No.FUN-680098   VARCHAR(500)  
   DEFINE  l_cnt           LIKE type_file.num5                   #No.FUN-B60144 
   CALL s_dsmark(g_bookno)
 
   LET p_row = 4 LET p_col = 26
 
   OPEN WINDOW aglp003_w AT p_row,p_col WITH FORM "agl/42f/aglp0031" 
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
   CALL cl_ui_init()
 
   CALL s_shwact(0,0,g_bookno)
   CALL cl_opmsg('q')
   WHILE TRUE 
      IF s_shut(0) THEN RETURN END IF
      CLEAR FORM 
      INITIALIZE tm.* TO NULL			# Defaealt condition
 
     #FUN-C10054--Mark-- 
     #SELECT aaa04,aaa05,YEAR(aaa07),MONTH(aaa07) 
     #  INTO tm.aaa04,tm.aaa05,close_y,close_m FROM aaa_file
     #FUN-C10054--Mark-- 
      SELECT aaa04,YEAR(aaa07),MONTH(aaa07)            #FUN-C10054
        INTO tm.aaa04,close_y,close_m FROM aaa_file    #FUN-C10054
       WHERE aaa01 = g_bookno
      LET tm.aaa05 = 0
      DISPLAY BY NAME tm.aaa04,tm.aaa05
 
      LET g_bgjob = 'N'                              #FUN-570145
      #INPUT tm.aaa04,tm.aaa05 WITHOUT DEFAULTS FROM aaa04,aaa05
      #INPUT tm.aaa04,tm.aaa05,tm.axz01,tm.axz05,tm.axz06,g_bgjob WITHOUT DEFAULTS    #FUN-780068 add tm.axz01,tm.axz05,tm.axz06
      # FROM aaa04,aaa05,axz01,axz05,axz06,g_bgjob                                    #FUN-780068 add axz01,axz05,axz06
         #NO.FUN-570145 MARK--
         #ON ACTION locale
         #     CALL cl_dynamic_locale()
         #    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         #NO.FUN-570145 END
 	   LET tm.axz05 = g_bookno   #FUN-BB0065
       INPUT tm.aaa04,tm.aaa05,tm.axz05,g_bgjob WITHOUT DEFAULTS    #No.FUN-B60144
          FROM aaa04,aaa05,axz05,g_bgjob                            #No.FUN-B60144

         AFTER FIELD aaa04
            IF cl_null(tm.aaa04) THEN
               NEXT FIELD tm.aaa04
            END IF
            IF tm.aaa04<close_y THEN 
               CALL cl_err('','agl-085',0) 
               NEXT FIELD aaa04
            END IF
 
         AFTER FIELD aaa05 
#No.TQC-720032 -- begin --
            IF NOT cl_null(tm.aaa05) THEN
               SELECT azm02 INTO g_azm.azm02 FROM azm_file
                 WHERE azm01 = tm.aaa04
               IF g_azm.azm02 = 1 THEN
                  #IF tm.aaa05 > 12 OR tm.aaa05 < 1 THEN
                  IF tm.aaa05 > 12 OR tm.aaa05 < 0  THEN   #FUN-BB0065
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD aaa05
                  END IF
               ELSE
                  #IF tm.aaa05 > 13 OR tm.aaa05 < 1 THEN
                  IF tm.aaa05 > 13 OR tm.aaa05 < 0 THEN   #FUN-BB0065
                     CALL cl_err('','agl-020',0)
                     NEXT FIELD aaa05
                  END IF
               END IF
            END IF
#No.TQC-720032 -- end --
            IF cl_null(tm.aaa05) THEN
                NEXT FIELD aaa05
            END IF
            IF tm.aaa04*100+tm.aaa05 < close_y*100+close_m THEN
               CALL cl_err('','agl-085',0) 
                NEXT FIELD aaa05
            END IF
            #上一期年(l_yy)/月(l_mm)
            IF tm.aaa05=1 THEN 
               LET l_yy=tm.aaa04-1 LET l_mm=12
            ELSE
               LET l_yy=tm.aaa04 LET l_mm=tm.aaa05-1
            END IF

      #No.FUN-B60144--add--
         AFTER FIELD axz05
            IF NOT cl_null(tm.axz05) THEN
               SELECT COUNT(*) INTO l_cnt FROM aaa_file WHERE aaa01=tm.axz05
               IF l_cnt=0 THEN
                  CALL cl_err('',100,0)
                  LET tm.axz05=NULL      
                  NEXT FIELD axz05
               END IF
            ELSE
               CALL cl_err('',-1124,0)
               NEXT FIELD axz05
            END IF
     #No.FUN-B60144--end--   

     #No.FUN-B60144--mark                
     #  #str FUN-780068 add
     #   AFTER FIELD axz01    #公司編號
     #      IF cl_null(tm.axz01) THEN NEXT FIELD axz01 END IF
     #      SELECT axz05,axz06 INTO tm.axz05,tm.axz06 FROM axz_file
     #       WHERE axz01 = tm.axz01
     #      IF STATUS THEN
     #         CALL cl_err(tm.axz01,'aco-025',0) NEXT FIELD axz01
     #      ELSE
     #         DISPLAY BY NAME tm.axz05,tm.axz06
     #      END IF
     #No.FUN-B60144--mark
 
         ON ACTION CONTROLP
            CASE
            #No.FUN-B60144--mark
            #  WHEN INFIELD(axz01)   #公司編號
            #      CALL cl_init_qry_var()
            #      LET g_qryparam.form = 'q_axz'
            #      LET g_qryparam.default1 = tm.axz01
            #      CALL cl_create_qry() RETURNING tm.axz01
            #      DISPLAY BY NAME tm.axz01
            #      NEXT FIELD axz01
            #No.FUN-B60144--mark 
               WHEN INFIELD(axz05)   #帳別
                   CALL cl_init_qry_var()
                   LET g_qryparam.form = 'q_aaa'
                   LET g_qryparam.default1 = tm.axz05
                   CALL cl_create_qry() RETURNING tm.axz05
                   DISPLAY BY NAME tm.axz05
                   NEXT FIELD axz05
            #No.FUN-B60144--mark
            #  WHEN INFIELD(axz06)   #幣別
            #      CALL cl_init_qry_var()
            #      LET g_qryparam.form = 'q_azi'
            #      LET g_qryparam.default1 = tm.axz06
            #      CALL cl_create_qry() RETURNING tm.axz06
            #      DISPLAY BY NAME tm.axz06
            #      NEXT FIELD axz06
            #No.FUN-B60144--mark
               OTHERWISE EXIT CASE
            END CASE
        #end FUN-780068 add
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
   
         #No.FUN-580031 --start--
         BEFORE INPUT
            CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
         #->FUN-570145-start----------
         ON ACTION locale
            #CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()               #No.FUN-550037 hmf
            LET g_change_lang = TRUE
            EXIT INPUT
         #->FUN-570145-end------------
 
      END INPUT
     #FUN-570145 --start--
      #IF INT_FLAG THEN LET INT_FLAG = 0 EXIT PROGRAM  END IF
      IF g_change_lang THEN
         LET g_change_lang = FALSE
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()               #No.FUN-550037 hmf
         CONTINUE WHILE
      END IF
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         CLOSE WINDOW aglp003_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
 
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
#  CLOSE WINDOW aglp003_w
      IF g_bgjob = 'Y' THEN
         SELECT zz08 INTO lc_cmd FROM zz_file WHERE zz01= 'aglp0031'
         IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
            CALL cl_err('aglp0031','9031',1)   
         ELSE
            LET lc_cmd = lc_cmd CLIPPED,
                         " ''",
                         " '",tm.aaa04 CLIPPED,"'",
                         " '",tm.aaa05 CLIPPED,"'",
                     #   " '",tm.axz01 CLIPPED,"'",   #FUN-780068 add            #No.FUN-B60144--mark
                         " '",tm.axz05 CLIPPED,"'",   #FUN-780068 add
                     #   " '",tm.axz06 CLIPPED,"'",   #FUN-780068 add            #No.FUN-B60144--mark
                         " '",g_bgjob CLIPPED,"'"
            CALL cl_cmdat('aglp0031',g_time,lc_cmd CLIPPED)
         END IF
         CLOSE WINDOW aglp003_w
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
         EXIT PROGRAM
      END IF
      EXIT WHILE
#No.FUN-570145 ---end---
   END WHILE
END FUNCTION
 
FUNCTION p003()
DEFINE l_axn_o RECORD LIKE axn_file.*
DEFINE l_axn_n RECORD LIKE axn_file.*
DEFINE l_aya01 LIKE aya_file.aya01,   #分類代碼   #FUN-780068 add
      #l_axo04 LIKE axo_file.axo04,     #FUN-C10054 mark
       l_axo16 LIKE axo_file.axo16,   #合併否    #No.FUN-B60144
       l_axl01 LIKE axl_file.axl01,              #No.FUN-B60144
       l_axl02 LIKE axl_file.axl02
      ,l_aah04 LIKE aah_file.aah04      #FUN-C10054
      ,l_aai02 LIKE aai_file.aai02      #FUN-C10054
      ,l_aai03 LIKE aai_file.aai03      #FUN-C10054
      ,l_aag01 LIKE aag_file.aag01      #FUN-C10054
      ,l_aag06 LIKE aag_file.aag06      #FUN-C10054

#No.FUN-B60144--add--
   IF g_argv1='1' THEN
      LET l_axo16='Y'
   ELSE
      LET l_axo16='N'
   END IF
#No.FUN-B60144--end--
   
   ### -->1.結轉前先刪除舊資料
   DELETE FROM axn_file
    WHERE axn01 = tm.aaa04   #年度 
      AND axn02 = tm.aaa05   #月份
   #  AND axn14 = tm.axz01   #公司編號                 #No.FUN-B60144--mark
      AND axn15 = tm.axz05   #帳別 
   #  AND axn16 = tm.axz06   #幣別                 #No.FUN-B60144--mark
      AND axn20 = l_axo16    #FUN-BC0065
   IF SQLCA.sqlcode THEN
      CALL cl_err3("del","axn_file",tm.aaa04,tm.aaa05,SQLCA.sqlcode,"","del axn_file",1)
      LET g_success = 'N'
      RETURN
   END IF
 
   INITIALIZE l_axn_o.* TO NULL
 
  #FUN-C10054--Begin Mark--
  #DECLARE axn_cs1 CURSOR FOR
  #   SELECT * FROM axn_file
  #    WHERE axn01 = l_yy  
  #      AND axn02 = l_mm 
  #      AND axn15 = tm.axz05  
  #      AND axn20 = l_axo16
  #    ORDER BY axn17      
  #FUN-C10054---End Mark---
  #FUN-C10054--Begin--
   DECLARE aai_cs1 CURSOR FOR
      SELECT UNIQUE aai02,aai03 FROM aai_file
       WHERE aai00 = tm.axz05  
  #FUN-C10054---End---
 
   CALL s_showmsg_init()            
  #FOREACH axn_cs1 INTO l_axn_o.*            #FUN-C10054 mark
   FOREACH aai_cs1 INTO l_aai02,l_aai03      #FUN-C10054
      IF g_success='N' THEN                                                    
         LET g_totsuccess='N'                                                   
         LET g_success='Y' 
      END IF                                                     
      #NO.FUN-710023--END
 
      IF SQLCA.sqlcode THEN
       # LET g_showmsg=l_yy,"/",l_mm,"/",tm.axz01,"/",tm.axz05,"/",tm.axz06    #No.FUN-B60144
         LET g_showmsg=l_yy,"/",l_mm,"/",tm.axz05 
       # CALL s_errmsg('axn01,axn02,axn14,axn15,axn16',g_showmsg,'(axn_cs1#1:foreach)',SQLCA.sqlcode,1) #No.FUN-B60144
         CALL s_errmsg('axn01,axn02,axn15',g_showmsg,'(axn_cs1#1:foreach)',SQLCA.sqlcode,1) #No.FUN-B60144 
         LET g_success='N' RETURN                             
      END IF
 
      INITIALIZE l_axn_n.* TO NULL
 
      LET l_axn_n.axn01 = tm.aaa04       #年度
      LET l_axn_n.axn02 = tm.aaa05       #月份
     #LET l_axn_n.axn14 = tm.axz01       #公司編號    #FUN-780068 add  #No.FUN-B60144
      LET l_axn_n.axn15 = tm.axz05       #帳別        #FUN-780068 add
     #LET l_axn_n.axn16 = tm.axz06       #幣別        #FUN-780068 add  #No.FUN-B60144
     #LET l_axn_n.axn17 = l_axn_o.axn17  #分類代碼    #FUN-BB0065 #FUN-780068 add
      LET l_axn_n.axn18 = l_axn_o.axn18  #餘額        #FUN-780068 add
     #LET l_axn_n.axn19 = l_axn_o.axn19               #FUN-BB0065 #No.FUN-B60144
      LET l_axn_n.axn17 = l_aai02   				  #FUN-BB0065 
      LET l_axn_n.axn19 = l_aai03					  #FUN-BB0065 
      LET l_axn_n.axnuser = g_user
      LET l_axn_n.axngrup = g_grup
      LET l_axn_n.axndate = g_today
      LET l_axn_n.axnlegal = g_legal    
      LET l_axn_n.axnoriu = g_user     
      LET l_axn_n.axnorig = g_grup    

     #FUN-C10054--Begin--
      DECLARE aai_cs2 CURSOR FOR
         SELECT UNIQUE aag01,aag06 FROM aai_file,aag_file
          WHERE aag01 = aai01 AND aai02 = l_aai02
            AND aai03 = l_aai03
      LET l_axn_n.axn18 = 0
      FOREACH aai_cs2 INTO l_aag01,l_aag06 
         LET l_aah04 = 0
         SELECT SUM(aah04-aah05) INTO l_aah04
           FROM aah_file,aai_file
          WHERE aah01 = aai01
            AND aah01 = l_aag01
            AND aai00 = tm.axz05
            AND aai02 = l_aai02
            AND aai03 = l_aai03
            AND aah02 = tm.aaa04
            AND aah03 = l_mm
         IF cl_null(l_aah04) THEN LET l_aah04 = 0 END IF
         IF l_aag06 = '2' THEN
            LET l_aah04= l_aah04 * (-1)
         END IF
         LET l_axn_n.axn18 = l_axn_n.axn18+l_aah04
      END FOREACH

      IF cl_null(l_axn_n.axn14) THEN
         LET l_axn_n.axn14 = ' '
      END IF
      IF cl_null(l_axn_n.axn16) THEN
         LET l_axn_n.axn16 = ' '
      END IF
     #FUN-C10054---End---
 
   #FUN-C10054--Begin Mark--
   #  SELECT SUM(axo04) INTO l_axo04 
   #    FROM axo_file,aya_file
   #   WHERE aya01 = axo14
   #     AND axo01 = tm.aaa04       #年度
   #     AND axo02 = tm.aaa05       #月份
   #   # AND axo11 = tm.axz01       #公司編號    #No.FUN-B60144
   #     AND axo12 = tm.axz05       #帳別
   #   # AND axo13 = tm.axz06       #幣別        #No.FUN-B60144
   #     AND axo14 = l_axn_n.axn17  #分類代碼
   #     AND axo16 = l_axo16                     #No.FUN-B60144
   #   GROUP BY aya01
   #  IF cl_null(l_axo04) THEN LET l_axo04 = 0 END IF
 
   #  #本期餘額 = 上期餘額 + 本期異動金額
   #  LET l_axn_n.axn18 = l_axn_n.axn18 + l_axo04
   #No.FUN-B60144--end--

   #No.FUN-B60144--add
     #SELECT SUM(axo04) INTO l_axo04 
     #  FROM axo_file,aya_file
     # WHERE aya01 = axo14
     #   AND axo01 = l_yy      
     #   AND axo02 = l_mm     
     #   AND axo12 = tm.axz05       
     #   AND axo14 = l_axn_n.axn17
     #   AND axo15 = l_axn_n.axn19
     #   AND axo16 = l_axo16                 
     # GROUP BY aya01
     #IF cl_null(l_axo04) THEN LET l_axo04 = 0 END IF

     #LET l_axn_n.axn18 = l_axn_n.axn18 + l_axo04
     #IF cl_null(l_axn_n.axn14) THEN
     #   LET l_axn_n.axn14 = ' '
     #END IF
     #IF cl_null(l_axn_n.axn16) THEN
     #   LET l_axn_n.axn16 = ' '
     #END IF
     #IF cl_null(l_axn_n.axn19) THEN
     #   LET l_axn_n.axn19 = ' '
     #END IF
     #FUN-C10054--End Mark--

      LET l_axn_n.axn20 = l_axo16
    #No.FUN-B60144--end 
      LET l_axn_n.axnoriu = g_user      #No.FUN-980030 10/01/04
      LET l_axn_n.axnorig = g_grup      #No.FUN-980030 10/01/04
      INSERT INTO axn_file VALUES (l_axn_n.*)
      IF STATUS THEN
         UPDATE axn_file SET axn18 = l_axn_n.axn18,
                             axnmodu = g_user,
                             axndate = g_today
                       WHERE axn01 = l_axn_n.axn01   #年度 
                         AND axn02 = l_axn_n.axn02   #月份
                      #  AND axn14 = l_axn_n.axn14   #公司編號    #No.FUN-B60144
                         AND axn15 = l_axn_n.axn15   #帳別  
                      #  AND axn16 = l_axn_n.axn16   #幣別        #No.FUN-B60144
                         AND axn17 = l_axn_n.axn17   #分類代碼
                         AND axn20 = l_axo16                      #No.FUN-B60144 
         IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#           CALL cl_err('upd_axn)',SQLCA.sqlcode,1)   #No.FUN-660123
#           CALL cl_err3("upd","axn_file",tm.aaa04,tm.aaa05,SQLCA.sqlcode,"","upd_axn",1)   #No.FUN-660123 #NO.FUN-710023
            LET g_showmsg=tm.aaa04,"/",tm.aaa05 
            CALL s_errmsg('axn01,axn02',g_showmsg,'upd_axn)',SQLCA.sqlcode,1) #NO.FUN-710023 
            LET g_success='N' RETURN 
         END IF
      END IF
   END FOREACH
#FUN-C10054--Begin Mark-- 
##找看看有沒有上期沒有，本期卻增加的分類代碼
##No.FUN-B60144
## DECLARE axo_cs1 CURSOR FOR
##    SELECT aya01,SUM(axo04)
##      FROM axo_file,aya_file
##     WHERE aya01 = axo14
##       AND axo01 = tm.aaa04       #年度
##       AND axo02 = tm.aaa05       #月份
##     # AND axo11 = tm.axz01       #公司編號     #No.FUN-B60144
##       AND axo12 = tm.axz05       #帳別
##     # AND axo13 = tm.axz06       #幣別         #No.FUN-B60144
##       AND axo16 = l_axo16                      #No.FUN-B60144
##       AND axo14 NOT IN (SELECT axo14 FROM axo_file
##                          WHERE axo01 = l_yy           #年度
##                            AND axo02 = l_mm           #月份
##                         #  AND axo11 = tm.axz01       #公司編號     #No.FUN-B60144
##                            AND axo12 = tm.axz05)      #帳別
##                         #  AND axo13 = tm.axz06)      #幣別         #No.FUN-B60144 
##       AND axo14 NOT IN (SELECT axn17 FROM axn_file
##                          WHERE axn01 = l_yy           #年度 
##                            AND axn02 = l_mm           #月份
##                        #   AND axn14 = tm.axz01       #公司編號     #No.FUN-B60144
##                            AND axn15 = tm.axz05)      #帳別
##                        #   AND axn16 = tm.axz06)      #幣別         #No.FUN-B60144
##     GROUP BY aya01
#
## FOREACH axo_cs1 INTO l_aya01,l_axo04
##No.FUN-B60144--end

##No.FUN-B60144--add   
#  DECLARE axo_cs1 CURSOR FOR
#     SELECT aya01,axo15,SUM(axo04)
#       FROM axo_file,aya_file
#      WHERE aya01 = axo14
#        AND axo01 = l_yy
#        AND axo02 = l_mm
#        AND axo12 = tm.axz05
#        AND axo16 = l_axo16
#        AND (axo14 NOT IN (SELECT axn17 FROM axn_file
#                           WHERE axn01 = l_yy
#                             AND axn02 = l_mm
#                             AND axn15 = tm.axz05
#                             AND axn20 = l_axo16)
#          OR axo15 NOT IN (SELECT axn19 FROM axn_file
#                           WHERE axn01 = l_yy
#                             AND axn02 = l_mm
#                             AND axn15 = tm.axz05
#                             AND axn20 = l_axo16))
#      GROUP BY aya01,axo15

#  FOREACH axo_cs1 INTO l_aya01,l_axl01,l_axo04
##No.FUN-B60144--end
#     #NO.FUN-710023--BEGIN                                                           
#     IF g_success='N' THEN                                                    
#        LET g_totsuccess='N'                                                   
#        LET g_success='Y' 
#     END IF                                                     
#     #NO.FUN-710023--END
#
#     IF SQLCA.sqlcode THEN
#      # LET g_showmsg=tm.aaa04,"/",tm.aaa05,"/",tm.axz01,"/",tm.axz05,"/",tm.axz06      #No.FUN-B60144
#      # CALL s_errmsg('axo01,axo02,axo11,axo12,axo13',g_showmsg,'(axo_cs1#1:foreach)',SQLCA.sqlcode,1)   #No.FUN-B60144
#        LET g_showmsg=tm.aaa04,"/",tm.aaa05,"/",tm.axz05    #No.FUN-B60144
#        CALL s_errmsg('axo01,axo02,axo12',g_showmsg,'(axo_cs1#1:foreach)',SQLCA.sqlcode,1)   #No.FUN-B60144 
#        LET g_success='N' RETURN                             
#     END IF
#
#     INITIALIZE l_axn_n.* TO NULL
#
#     LET l_axn_n.axn01 = tm.aaa04       #年度
#     LET l_axn_n.axn02 = tm.aaa05       #月份
#   # LET l_axn_n.axn14 = tm.axz01       #公司編號    #FUN-780068 add   #No.FUN-B60144
#     LET l_axn_n.axn15 = tm.axz05       #帳別        #FUN-780068 add
#   # LET l_axn_n.axn16 = tm.axz06       #幣別        #FUN-780068 add   #No.FUN-B60144
#     LET l_axn_n.axn17 = l_aya01        #分類代碼    #FUN-780068 add
#     LET l_axn_n.axn18 = l_axo04        #餘額        #FUN-780068 add
#     LET l_axn_n.axn19 = l_axl01                     #No.FUN-B60144 
#     LET l_axn_n.axnuser = g_user
#     LET l_axn_n.axngrup = g_grup
#     LET l_axn_n.axndate = g_today
#     LET l_axn_n.axnlegal = g_legal     #FUN-980003 add
#  
#  #No.FUN-B60144--add
#     IF cl_null(l_axn_n.axn14) THEN
#        LET l_axn_n.axn14 = ' '
#     END IF
#     IF cl_null(l_axn_n.axn16) THEN
#        LET l_axn_n.axn16 = ' '
#     END IF
#     IF cl_null(l_axn_n.axn19) THEN
#        LET l_axn_n.axn19 = ' '
#     END IF

#     LET l_axn_n.axn20 = l_axo16
#  #No.FUN-B60144--end
#     INSERT INTO axn_file VALUES (l_axn_n.*)
#     IF STATUS THEN
#        UPDATE axn_file SET axn18 = axn18+l_axo04,
#                            axnmodu = g_user,
#                            axndate = g_today
#                      WHERE axn01 = l_axn_n.axn01   #年度 
#                        AND axn02 = l_axn_n.axn02   #月份
#                      # AND axn14 = l_axn_n.axn14   #公司編號    #No.FUN-B60144
#                        AND axn15 = l_axn_n.axn15   #帳別
#                      # AND axn16 = l_axn_n.axn16   #幣別        #No.FUN-B60144
#                        AND axn17 = l_aya01         #分類代碼
#                        AND axn20 = l_axo16
#        IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN 
#           CALL cl_err('upd_axn)',SQLCA.sqlcode,1)   #No.FUN-660123
#           CALL cl_err3("upd","axn_file",tm.aaa04,tm.aaa05,SQLCA.sqlcode,"","upd_axn",1)   #No.FUN-660123 #NO.FUN-710023
#           LET g_showmsg=tm.aaa04,"/",tm.aaa05 
#           CALL s_errmsg('axn01,axn02',g_showmsg,'upd_axn)',SQLCA.sqlcode,1) #NO.FUN-710023 
#           LET g_success='N' RETURN 
#        END IF
#     END IF
#  END FOREACH
# #end FUN-780068 mod
#FUN-C10054---End Mark---
 
   #NO.FUN-710023--BEGIN                                                           
   IF g_totsuccess="N" THEN                                                        
      LET g_success="N"                                                           
   END IF                                                                          
   #NO.FUN-710023--END
 
END FUNCTION
