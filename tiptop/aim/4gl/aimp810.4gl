# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aimp810.4gl
# Descriptions...: 空白盤點標籤產生作業
# Date & Author..: 93/05/17 By Apple
# Modify.........: No.FUN-5A0199 06/01/05 By Sarah 標籤別放大至5碼,單號放大至10碼
# Modify.........: NO.FUN-570122 06/02/16 BY yiting 背景執行
# Modify.........: No.FUN-660078 06/06/13 By rainy aim系統中，用char定義的變數，改為用LIK
# Modify.........: NO.FUN-660156 06/06/22 By Tracy cl_err -> cl_err3 
# Modify.........: No.FUN-680006 06/08/04 By kim GP3.5 利潤中心
# Modify.........: No.FUN-690026 06/09/07 By Carrier 欄位型態用LIKE定義
# Modify.........: No.FUN-690115 06/10/13 By dxfwo cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0074 06/10/26 By johnray l_time轉g_time
# Modify.........: No.TQC-6B0057 06/11/14 By Ray 修正語言別切換無效
# Modify.........: No.FUN-710025 07/01/19 By bnlent  錯誤訊息匯整
# Modify.........: No.TQC-6B0110 07/03/05 By pengu 3X版以後標籤編號已經放大為10碼，但程式段還是用USING &&&&&&
# Modify.........: No.MOD-6B0108 07/03/05 By pengu 1.只勾選產生"現有庫存盤點資料"直接按"確認"，無法執行回到標籤欄位待輸入
#                                                  2.只勾選執行[產生在製工單盤點資料]，其他資料皆未keyin時直拉按[確認]
#                                                    游標會回到未勾選[產生現有庫存盤點資料]的標籤待輸入,且無法離開
#                                                  3.勾選執行[產生在製工單盤點資料]-->輸入標籤別後-->不會自動帶出起始流水號
# Modify.........: No.MOD-7C0181 07/12/25 By Pengu 調整stkno與wipno的資料型態
# Modify.........: No.MOD-840697 08/07/13 By Pengu 未產生多單位的空白標籤
# Modify.........: No.FUN-8A0035 08/10/28 By jan 流水號依參數aza42編碼 
# Modify.........: No.FUN-980004 09/08/26 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.CHI-960065 09/11/09 By jan 盤點資料生成時編碼方式采用自動編碼
# Modify.........: No.FUN-A60095 10/07/19 By kim GP5.25 平行工藝
# Modify.........: No:TQC-AC0391 10/12/29 By zhangll aimi800->asmi300
# Modify.........: No:MOD-B60006 11/06/01 By Vampire tm.stk 和 tm.wip 抓取前五碼 
# Modify.........: No:TQC-C30348 12/04/01 By SunLM 修正錯誤提示

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#start FUN-5A0199
DEFINE tm  RECORD                            # Print condition RECORD
            a        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            stk      LIKE pia_file.pia01,    #FUN-660078  #CHI-960065
           #-------------No.MOD-7C0181 modify
           #stkno    LIKE pic_file.pic16,    #FUN-660078
           #stkno    LIKE pib_file.pib03,    #FUN-660078 #CHI-960065
           #-------------No.MOD-7C0181 end
            paper1   LIKE type_file.num10,   #No.FUN-690026 INTEGER
            e        LIKE type_file.chr1,    #No.FUN-690026 VARCHAR(1)
            wip      LIKE pid_file.pid01,    #FUN-660078 #CHI-960065
           #-------------No.MOD-7C0181 modify
           #wipno    LIKE pic_file.pic36,    #FUN-660078
           #wipno    LIKE pib_file.pib03,    #FUN-660078  #CHI-960065
           #-------------No.MOD-7C0181 end
            paper2   LIKE type_file.num10    #No.FUN-690026 INTEGER
           END RECORD,
#end FUN-5A0199
       tm_stk_o           LIKE pia_file.pia01,   #CHI-960065
       tm_wip_o           LIKE pid_file.pid01,   #CHI-960065
       g_pic18            LIKE pia_file.pia01,   #CHI-960065  
       g_pic19            LIKE pia_file.pia01,   #CHI-960065
       g_pic38            LIKE pid_file.pid01,   #CHI-960065 
       g_pic39            LIKE pid_file.pid01,   #CHI-960065
       l_time             LIKE type_file.chr8,
       g_stkcnt,g_wipcnt  LIKE type_file.num10    #No.FUN-690026 INTEGER
DEFINE g_change_lang      LIKE type_file.chr1     #是否有做語言切換 No.FUN-570122  #No.FUN-690026 VARCHAR(1)
DEFINE g_t1               LIKE oay_file.oayslip   #CHI-960065
DEFINE g_stk   LIKE pia_file.pia01    #MOD-B60006 add
DEFINE g_wip   LIKE pid_file.pid01    #MOD-B60006 add

MAIN
DEFINE l_flag  LIKE type_file.chr1    #No.FUN-690026 VARCHAR(1)

   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT			     # Supress DEL key function
 
   #No.FUN-570122 ----start----
   INITIALIZE g_bgjob_msgfile TO NULL
   LET tm.a = ARG_VAL(1)
   LET tm.stk = ARG_VAL(2)
  #LET tm.stkno = ARG_VAL(3)  #CHI-960065
   LET tm.paper1 = ARG_VAL(3)
   LET tm.e = ARG_VAL(4)
   LET tm.wip = ARG_VAL(5)
  #LET tm.wipno = ARG_VAL(7)  #CHI-960065
   LET tm.paper2 = ARG_VAL(6)
   LET g_bgjob = ARG_VAL(7)
   IF cl_null(g_bgjob) THEN
      LET g_bgjob = 'N'
   END IF
   #No.FUN-570122 ----end----

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AIM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690115 BY dxfwo 
 
 
   IF s_shut(0) THEN 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM  
   END IF
   WHILE TRUE
#--NO.FUN-570122 START---
      LET g_success = 'Y' 
      IF g_bgjob = 'N' THEN
#--NO.FUN-571022 END---
          BEGIN WORK
          CALL p810_tm(0,0)		        # Input print condition
          IF cl_sure(0,0) THEN 
             CALL cl_wait()
             CALL p810()
             LET l_time = TIME 
             LET g_stk=tm.stk[1,5]    #MOD-B60006 add
             LET g_wip=tm.wip[1,5]    #MOD-B60006 add 
             INSERT INTO pic_file(pic01,pic02,pic03,pic04,
                                  pic14,pic15,pic16,pic17,
                                  pic18,pic19,pic20,
                                  pic34,pic35,pic36,pic37,
                                  pic38,pic39,pic40)
                           VALUES (g_today,l_time,'aimp810',g_user,
                           #       'Y', tm.stk,'',tm.paper1,  #CHI-960065 tm.stkno-->''   #MOD-B60006 mark
                                   'Y', g_stk,'',tm.paper1,   #MOD-B60006 add
                                   g_pic18,g_pic19,g_stkcnt,
                           #       'Y', tm.wip,'',tm.paper2,  #CHI-960065 tm.wipno-->''   #MOD-B60006 mark
                                   'Y', g_wip,'',tm.paper2,  #MOD-B60006 add
                                   g_pic38,g_pic39,g_wipcnt)
             IF SQLCA.sqlcode THEN 
#               CALL cl_err(' ',SQLCA.sqlcode,1) #No.FUN-660156
             #No.FUN-710025--Begin--
             #  CALL cl_err3("ins","pic_file",g_today,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
                CALL s_errmsg('','','',SQLCA.sqlcode,1)
             #No.FUN-710025--End--
                LET g_success = 'N'
            END IF
            MESSAGE ' '        #TQC-C30348 add
            CALL s_showmsg()   #No.FUN-710025
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
               EXIT WHILE
            END IF
     #          IF g_success = 'Y'
 #              THEN CALL cl_cmmsg(1) COMMIT WORK
 #                   CALL cl_end(19,20)
 #              ELSE CALL cl_rbmsg(1) ROLLBACK WORK
 #          END IF
            ERROR ""
#----NO.FUN-570122 START-------------
         ELSE
            CONTINUE WHILE
         END IF
      ELSE
         BEGIN WORK
         CALL p810()
         LET l_time = TIME
         LET g_stk=tm.stk[1,5]    #MOD-B60006 add
         LET g_wip=tm.wip[1,5]    #MOD-B60006 add 
         INSERT INTO pic_file(pic01,pic02,pic03,pic04,
                              pic14,pic15,pic16,pic17,
                              pic18,pic19,pic20,
                              pic34,pic35,pic36,pic37,
                              pic38,pic39,pic40)
                       VALUES (g_today,l_time,'aimp810',g_user,
                       #       'Y', tm.stk,'',tm.paper1,   #CHI-960065   #MOD-B60006 mark
                               'Y', g_stk,'',tm.paper1,    #MOD-B60006 add 
                               g_pic18,g_pic19,g_stkcnt,
                       #       'Y', tm.wip,'',tm.paper2,   #CHI-960065   #MOD-B60006 mark 
                               'Y', g_wip,'',tm.paper2,    #MOD-B60006 add 
                               g_pic38,g_pic39,g_wipcnt)
         IF SQLCA.sqlcode THEN
#           CALL cl_err(' ',SQLCA.sqlcode,1) #No.FUN-660156
            CALL cl_err3("ins","pic_file",g_today,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
            LET g_success = 'N'
         END IF
         IF g_success = "Y" THEN
            COMMIT WORK
         ELSE
            ROLLBACK WORK
         END IF
         CALL cl_batch_bg_javamail(g_success)
         EXIT WHILE
     END IF  
#-----------NO.FUN-571022 end------------
   END WHILE
   CLOSE WINDOW p810_w
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
END MAIN
 
FUNCTION p810_tm(p_row,p_col)
   DEFINE p_row,p_col	LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_pib03       LIKE pib_file.pib03,
          l_cmd		LIKE type_file.chr1000  #No.FUN-690026 VARCHAR(400)
   DEFINE lc_cmd        LIKE type_file.chr1000  #No.FUN-570122 #No.FUN-690026 VARCHAR(500) 
   DEFINE l_t2         LIKE type_file.num5    #FUN-8A0035
   DEFINE l_t3         STRING                 #FUN-8A0035
   DEFINE li_result    LIKE type_file.num5    #CHI-960065
   DEFINE l_smydesc    LIKE smy_file.smydesc  #CHI-960065
 
   LET p_row = 4 LET p_col = 17
 
   OPEN WINDOW p810_w AT p_row,p_col WITH FORM "aim/42f/aimp810" 
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
 
 WHILE TRUE
   CALL cl_ui_init()
   SELECT aza42 INTO g_aza.aza42 FROM aza_file  #No.FUN-8A0035
   CALL cl_opmsg('p')
   LET tm_stk_o = tm.stk                        #CHI-960065 
   LET tm_wip_o = tm.wip                        #CHI-960065
   INITIALIZE tm.* TO NULL			# Default condition
   LET tm.a = 'N'
   LET tm.e = 'N'
  #INPUT BY NAME tm.a,tm.stk,tm.stkno,tm.paper1,                        #CHI-960065
  #              tm.e,tm.wip,tm.wipno,tm.paper2,g_bgjob  #NO.FUN-570122 #CHI-960065
   INPUT BY NAME tm.a,tm.stk,tm.paper1,                                 #CHI-960065
                 tm.e,tm.wip,tm.paper2,g_bgjob  #NO.FUN-570122          #CHI-960065
#                 tm.e,tm.wip,tm.wipno,tm.paper2
                 WITHOUT DEFAULTS 
 
      AFTER FIELD a 
        IF tm.a IS NULL OR tm.a not matches'[YyNn]'
        THEN NEXT FIELD a
        END IF
        IF tm.a matches'[Nn]' THEN 
              LET tm.stk    = ' '   #LET tm.stkno = ' '   #CHI-960065
              LET tm.paper1 = ' '  
              DISPLAY BY NAME tm.stk,tm.paper1            #CHI-960065 
              NEXT FIELD e   
        ELSE  IF cl_null(tm.paper1) THEN LET tm.paper1 = 0   END IF
              DISPLAY BY NAME tm.stk,tm.paper1            #CHI-960065
         END IF
 
      AFTER FIELD stk
         IF NOT cl_null(tm.stk) THEN
      #CHI-960065--begin--mod-------------------------------------
      #     LET l_cmd= "SELECT pib03 FROM pib_file  ", 
      #                " WHERE pib01 = '",tm.stk,"'",
      #                "   FOR UPDATE "	
      #     LET l_cmd=cl_forupd_sql(l_cmd)
      #     PREPARE p810_pib FROM l_cmd
      #     DECLARE p810_cpib CURSOR FOR p810_pib 

      #     OPEN  p810_cpib 
      #     FETCH p810_cpib INTO l_pib03
      #     IF SQLCA.sqlcode THEN
      #        CALL cl_err(tm.stk,'mfg0107',0)
      #        NEXT FIELD stk 
      #     END IF
      #     DISPLAY BY NAME tm.stk 
      #    #-----------No.TQC-6B0110 modify
      #    #LET tm.stkno = l_pib03 + 1  USING'&&&&&&'
#No.FU#-8A0035--BEGIN--
#     #     LET tm.stkno = l_pib03 + 1  USING'&&&&&&&&&&'
      #     CASE g_aza.aza42
      #     WHEN '1'
      #          LET tm.stkno = l_pib03 + 1  USING'&&&&&&&&'
      #     WHEN '2'
      #          LET tm.stkno = l_pib03 + 1  USING'&&&&&&&&&'
      #     WHEN '3'
#           LET tm.stkno = l_pib03 + 1  USING'&&&&&&&&&&'
      #     OTHERWISE
      #          LET tm.stkno = l_pib03 + 1  USING'&&&&&&&&'
      #     END CASE
#No.FU#-8A0035--END--
      #    #-----------No.TQC-6B0110 end
      #     DISPLAY BY NAME tm.stkno
            CALL s_check_no("aim",tm.stk,tm_stk_o,"5","pia_file","pia01","")
            RETURNING li_result,tm.stk
            DISPLAY BY NAME tm.stk
            IF (NOT li_result) THEN 
            NEXT FIELD stk 
         END IF
            LET l_smydesc = s_get_doc_no(tm.stk)
            SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip = l_smydesc
            DISPLAY l_smydesc TO smydesc1 LET l_smydesc = NULL
      #CHI-960065--end--mod--------------------------------------------------- 
            END IF

#CHI-960065--begin--mark------------------------------------------------------
#     BEFORE FIELD stkno 
#        IF tm.stk IS NULL OR tm.stk = ' ' THEN 
#           NEXT FIELD stk 
#        END IF

#     AFTER FIELD stkno 
#        #No.FUN-8A0035--BEGIN--
#        CASE g_aza.aza42
#           WHEN '1'
#                LET l_t2 = 8
#           WHEN '2'
#                LET l_t2 = 9
#           WHEN '3'
#                LET l_t2 = 10
#           OTHERWISE
#                LET l_t2 = 8
#        END CASE
#        IF NOT cl_null(tm.stkno) THEN
#           LET l_t3 = tm.stkno
#           IF l_t3.getlength()<>l_t2 THEN
#              CALL cl_err('','aim-015',1)
#              NEXT FIELd stkno
#           END IF
#         END IF
#         #No.FUN-8A0035--END--
#        IF tm.stkno < l_pib03  THEN  
#           CALL cl_err(tm.stkno,'mfg0108',0)
#           NEXT FIELD stkno
#        END IF
#CHI-960065--end--mark-----------------------------------------------------
 
      AFTER FIELD paper1
         IF tm.paper1 IS NULL OR tm.paper1 <=0 THEN 
            NEXT FIELD paper1
         END IF
 
      AFTER FIELD e 
        IF tm.e IS NULL OR tm.e not matches'[YyNn]'
        THEN NEXT FIELD e
        END IF
        #FUN-570122  
        IF tm.a matches'[Nn]' AND tm.e matches'[Nn]'
        THEN EXIT INPUT
        END IF
        #FUN-570122
        IF tm.e matches'[Nn]' THEN 
              LET tm.wip    = ' '   #LET tm.wipno = ' '  #CHI-960065
              LET tm.paper2 = ' '  
              DISPLAY BY NAME tm.wip,tm.paper2           #CHI-960065
             #FUN-570122   ---Start---
              NEXT FIELD g_bgjob
             #EXIT INPUT
             #FUN-570122   ---End---
        ELSE 
              IF cl_null(tm.paper2) THEN LET tm.paper2 = 1    END IF
              DISPLAY BY NAME tm.wip,tm.paper2           #CHI-960065
         END IF
        #FUN-570122   ---Start---
        #IF tm.a matches'[Nn]' AND tm.e matches'[Nn]'
        #THEN EXIT INPUT
        #END IF
        #FUN-570122   ---End---
 
      AFTER FIELD wip
      #CHI-960065--begin--mod--------------------------------------
      #  IF tm.wip is not null and tm.wip != ' ' 
      #  THEN LET l_cmd= " SELECT pib03 FROM pib_file  ", 
      #                   " WHERE pib01 = '",tm.wip,"'",
      #                   "   FOR UPDATE "
      #       LET l_cmd=cl_forupd_sql(l_cmd)
      #       PREPARE p810_pib2 FROM l_cmd
      #       DECLARE p810_cpib2 CURSOR FOR p810_pib2

      #       OPEN  p810_cpib2
      #       FETCH p810_cpib2 INTO l_pib03
      #        IF SQLCA.sqlcode THEN
      #           CALL cl_err(tm.stk,'mfg0107',0)
      #           NEXT FIELD wip 
      #        END IF
      #      #-----------No.TQC-6B0110 modify
      #      #LET tm.wipno = l_pib03 + 1  USING'&&&&&&'
#No.FU#-8A0035--BEGIN--                                                                                                             
      #      #LET tm.wipno = l_pib03 + 1  USING'&&&&&&&&&&'                                                                         
      #      #-----------No.TQC-6B0110 end                                                                                          
      #     CASE g_aza.aza42
      #     WHEN '1'
      #          LET tm.wipno = l_pib03 + 1  USING'&&&&&&&&'
      #     WHEN '2'
      #          LET tm.wipno = l_pib03 + 1  USING'&&&&&&&&&'
      #     WHEN '3'
             #LET tm.wipno = l_pib03 + 1  USING'&&&&&&&&&&'                                                                         
      #     OTHERWISE
      #          LET tm.wipno = l_pib03 + 1  USING'&&&&&&&&'
      #     END CASE
#No.FU#-8A0035--END-- 
      #       DISPLAY BY NAME tm.wipno
      #  END IF
         IF NOT cl_null(tm.wip) THEN
            CALL s_check_no("aim",tm.wip,tm_wip_o,"I","pid_file","pid01","")
            RETURNING li_result,tm.wip
            DISPLAY BY NAME tm.wip
            IF (NOT li_result) THEN
            NEXT FIELD wip 
         END IF
            LET l_smydesc = s_get_doc_no(tm.wip)
            SELECT smydesc INTO l_smydesc FROM smy_file WHERE smyslip = l_smydesc
            DISPLAY l_smydesc TO smydesc2 LET l_smydesc = NULL
            END IF
      #CHI-960065--end--mod-----------------------------------------

#CHI-960065--begin--mark-------------------------------------------
#     BEFORE FIELD wipno 
#        IF tm.wip IS NULL OR tm.wip = ' ' THEN 
#           NEXT FIELD wip 
#        END IF

#     AFTER FIELD wipno 
#        #No.FUN-8A0035--BEGIN--
#        LET l_t2 = NULL
#        LET l_t3 = NULL
#        CASE g_aza.aza42
#           WHEN '1'
#                LET l_t2 = 8
#           WHEN '2'
#                LET l_t2 = 9
#           WHEN '3'
#                LET l_t2 = 10
#           OTHERWISE
#                LET l_t2 = 8
#        END CASE
#        IF NOT cl_null(tm.wipno) THEN
#           LET l_t3 = tm.wipno
#           IF l_t3.getlength()<>l_t2 THEN
#              CALL cl_err('','aim-015',1)
#              NEXT FIELd wipno
#           END IF
#         END IF
#         #No.FUN-8A0035--END-- 
#        IF tm.wipno < l_pib03  THEN  
#           CALL cl_err(tm.wipno,'mfg0108',0)
#           NEXT FIELD wipno
#        END IF
#CHI-960065--end--mark-----------------------------------------
 
      AFTER FIELD paper2 
         IF tm.paper2 IS NULL OR tm.paper2 <=0
         THEN NEXT FIELD paper2
         END IF
 
      #No.FUN-570122 ----Start----
      AFTER FIELD g_bgjob
          IF g_bgjob NOT MATCHES "[YN]"  OR cl_null(g_bgjob) THEN
              NEXT FIELD g_bgjob
          END IF
      #No.FUN-570122 ----End----
 
      AFTER INPUT  
         IF INT_FLAG THEN EXIT INPUT END IF
        #---------No.MOD-6B0108 modify
        #IF tm.stkno IS NULL OR tm.wipno IS NULL THEN 
        #   NEXT FIELD stk 
        #END IF
         IF tm.a ='Y' AND tm.stk IS NULL THEN   #CHI-960065 tm.stkno-->tm.stk
            NEXT FIELD stk 
         END IF
         IF tm.e = 'Y' AND tm.wip IS NULL THEN  #CHI-960065 tm.wipno-->tm.wip
            NEXT FIELD  wip
         END IF
        #---------No.MOD-6B0108 end
 
      ON ACTION CONTROLP 
            CASE
               WHEN INFIELD(stk) 
                 #CHI-960065--begin--mod-------------------------------------
                 #CALL cl_init_qry_var()
                 #LET g_qryparam.form = 'q_pib'
                 #LET g_qryparam.default1 = tm.stk
                 #CALL cl_create_qry() RETURNING tm.stk
#                #CALL FGL_DIALOG_SETBUFFER( tm.stk )
                  LET g_t1 = s_get_doc_no(tm.stk)
                  CALL q_smy( FALSE,TRUE,g_t1,'AIM','5') RETURNING g_t1
                  LET tm.stk=g_t1
                 #CHI-960065--end--mod-----------------------------------------
                  DISPLAY BY NAME tm.stk 
                  NEXT FIELD stk  
               WHEN INFIELD(wip) 
                  CALL cl_init_qry_var()
                 #CHI-960065--begin--mod-- -------------------------------------
                 #LET g_qryparam.form = 'q_pib'
                 #LET g_qryparam.default1 = tm.wip
                 #CALL cl_create_qry() RETURNING tm.wip
#                # CALL FGL_DIALOG_SETBUFFER( tm.wip )
                  LET g_t1 = s_get_doc_no(tm.wip)
                  CALL q_smy( FALSE,TRUE,g_t1,'AIM','I') RETURNING g_t1
                  LET tm.wip=g_t1
                 #CHI-960065--end--mod------------------------------------------
                  DISPLAY BY NAME tm.wip 
                  NEXT FIELD wip  
               OTHERWISE EXIT CASE
            END CASE
 
       ON ACTION mntn_tag      #標籤資料
         #CALL cl_cmdrun('aimi800' )
          CALL cl_cmdrun('asmi300' )   #Mod No:TQC-AC0391
 
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG CALL cl_cmdask()	# Command execution
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
   
      ON ACTION locale
          #->No.FUN-570122--end---
        #  LET g_action_choice='locale'
        #  CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
           LET g_change_lang = TRUE
           #->No.FUN-570122--end---
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
 
   END INPUT
   
   #No.TQC-6B0057 --begin
#  IF g_action_choice = "locale" THEN
#     LET g_action_choice = ""
#     CALL cl_dynamic_locale()
#     CONTINUE WHILE
#  END IF
   IF g_change_lang THEN
      LET g_change_lang = FALSE
      CALL cl_dynamic_locale()
      CALL cl_show_fld_cont()
      CONTINUE WHILE
   END IF
   #No.TQC-6B0057 --end
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 CLOSE WINDOW p810_w 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
      EXIT PROGRAM
         
   END IF
     #No.FUN-570122 ----Start----
     IF g_bgjob = "Y" THEN
        SELECT zz08 INTO lc_cmd FROM zz_file
         WHERE zz01 = "aimp810"
        IF SQLCA.sqlcode OR lc_cmd IS NULL THEN
           CALL cl_err('aimp810','9031',1)
        ELSE
           LET lc_cmd = lc_cmd CLIPPED,
                        " '",tm.a CLIPPED,"'",
                        " '",tm.stk CLIPPED,"'",
                       #" '",tm.stkno CLIPPED,"'",   #CHI-960065
                        " '",tm.paper1 CLIPPED,"'",
                        " '",tm.e CLIPPED,"'",
                        " '",tm.wip CLIPPED,"'",
                       #" '",tm.wipno CLIPPED,"'",   #CHI-960065
                        " '",tm.paper2 CLIPPED,"'",
                        " '",g_bgjob CLIPPED,"'"
           CALL cl_cmdat('aimp810',g_time,lc_cmd CLIPPED)
        END IF
        CLOSE WINDOW p810_w
        CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690115 BY dxfwo 
        EXIT PROGRAM
     END IF
     EXIT WHILE
     #No.FUN-570122 ----End----
 END WHILE
END FUNCTION
   
FUNCTION p810()
   DEFINE l_name            LIKE type_file.chr20,   #External(Disk) file name  #No.FUN-690026 VARCHAR(20)
#       l_time          LIKE type_file.chr8                #No.FUN-6A0074
          l_cnt             LIKE type_file.num5,    #No.FUN-690026 SMALLINT
          l_estkno,l_ewipno LIKE pib_file.pib03,    #FUN-660078
          l_pia01           LIKE pia_file.pia01,
          l_pid01           LIKE pid_file.pid01
   DEFINE l_pia930          LIKE pia_file.pia930    #FUN-680006
   DEFINE li_result         LIKE type_file.num5     #CHI-960065
   DEFINE l_stk             STRING                  #CHI-960065
   DEFINE l_wip             STRING                  #CHI-960065
 
     LET g_success = 'Y'
     #產生[現有庫存]空白盤點標籤
	 IF tm.a matches'[Yy]' THEN 
#CHI-960065--begin--mark-------------------------------------------     
#       SELECT pib03 INTO l_estkno FROM pib_file WHERE pib01 =tm.stk
#       IF l_estkno IS NULL OR l_estkno =' ' THEN
#      #-------------No.TQC-6B0110 modify
#      #LET l_estkno = '000001'
#      #LET l_estkno = '0000000001'  #FUN-8A0035
##No.FUN-8A0035--BEGIN--                                                                                                             
#           CASE g_aza.aza42                                                                                                        
#           WHEN '1'                                                                                                                
#                LET l_estkno = '00000001'                                                                                          
#           WHEN '2'                                                                                                                
#                LET l_estkno = '000000001'                                                                                         
#           WHEN '3'                                                                                                                
#                LET l_estkno = '0000000001'                                                                                        
#           OTHERWISE                                                                                                               
#                LET l_estkno = '00000001'                                                                                          
#           END CASE                                                                                                                
##No.FUN-8A0035--END--
#      #-------------No.TQC-6B0110 end
#       END IF 
#       IF l_estkno < tm.stkno  THEN 
#          LET l_estkno = tm.stkno
#       END IF
#       LET g_pic18 = l_estkno 
#CHI-960065--end--mark--------------------------------------
        LET g_stkcnt = 0
        LET l_pia930=s_costcenter(g_grup) #FUN-680006
        CALL s_showmsg_init()   #No.FUN-710025
	FOR l_cnt=1 TO tm.paper1
           #No.FUN-710025--Begin--                                                                                                      
            IF g_success='N' THEN                                                                                                        
               LET g_totsuccess='N'                                                                                                      
               LET g_success="Y"                                                                                                         
            END IF                                                                                                                       
           #No.FUN-710025--End-
 
	   #LET l_pia01  = tm.stk,'-',l_estkno           #FUN-5A0199 mark
       #CHI-960065--begin--mod-------------------
	   #LET l_pia01  = tm.stk CLIPPED,'-',l_estkno   #FUN-5A0199 
            CALL s_auto_assign_no("aim",tm.stk,g_today,"5","pia_file","pia01","","","")
            RETURNING li_result,l_pia01
            IF (NOT li_result) THEN
                LET g_success = 'N'
                EXIT FOR 
            END IF
            IF g_stkcnt = 0 THEN
               LET g_pic18 = l_pia01
               LET l_stk = tm.stk
               IF l_stk.getlength() > 6 THEN
                  LET tm.stk = s_get_doc_no(tm.stk)
               END IF
            END IF
           #CHI-960065--end--mod------------------------------------
            INSERT INTO pia_file (pia01, pia11,pia12,pia15,pia16,pia19,pia930,piaplant,pialegal) #FUN-680006 #FUN-980004 add piaplant,pialegal
                           VALUES(l_pia01,g_user,g_today,0,'Y','N',l_pia930,g_plant,g_legal)   #FUN-680006 #FUN-980004 add g_plant,g_legal
             IF SQLCA.sqlcode THEN
#               CALL cl_err(l_pia01,SQLCA.sqlcode,0)  #No.FUN-660156
             #No.FUN-710025--Begin--
             #  CALL cl_err3("ins","pic_file",l_pia01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
                CALL s_errmsg('','',l_pia01,SQLCA.sqlcode,0)  
                LET g_success = 'N'
             #  RETURN 
             #  CONTINUE FOR
             #No.FUN-710025--End--
             END IF
            #-------------No.MOD-840697 add
             IF g_sma.sma115 = 'Y' THEN 
               
                INSERT INTO piaa_file (piaa01,piaa09,piaa11,piaa12,piaa15,piaa16,piaa19,piaa930,piaaplant,piaalegal)  #FUN-980004 add piaaplant,piaalegal
                               VALUES(l_pia01,' ',g_user,g_today,0,'Y','N',l_pia930,g_plant,g_legal)   #FUN-980004 add g_plant,g_legal 
                IF SQLCA.sqlcode THEN
                   CALL s_errmsg('','',l_pia01,SQLCA.sqlcode,0)  
                   LET g_success = 'N'
                END IF
             END IF
            #-------------No.MOD-840697 end
            #-------------No.TQC-6B0110 modify
            #LET l_estkno = l_estkno + 1 USING "&&&&&&"
            #LET l_estkno = l_estkno + 1 USING "&&&&&&&&&&"   #No.FUN-8A0035
#No.FUN-8A0035--BEGIN--
#CHI-960065--begin--mark-------------------------------------
#           CASE g_aza.aza42
#           WHEN '1'
#                LET l_estkno = l_estkno + 1 USING "&&&&&&&&"
#           WHEN '2'
#                LET l_estkno = l_estkno + 1 USING "&&&&&&&&&"
#           WHEN '3'
#                LET l_estkno = l_estkno + 1 USING "&&&&&&&&&&"
#           OTHERWISE
#                LET l_estkno = l_estkno + 1 USING "&&&&&&&&"
#           END CASE
#CHI-960065--end--mark-----------------------------------------
#No.FUN-8A0035--END-- 
            #-------------No.TQC-6B0110 end
             LET g_stkcnt = g_stkcnt + 1
        END FOR
        #No.FUN-710025--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
        #No.FUN-710025--End--
 
       #-----------No.TQC-6B0110 modify
       #LET g_pic19 = l_estkno -1 USING "&&&&&&"
       #LET g_pic19 = l_estkno -1 USING "&&&&&&&&&&"  #No.FUN-8A0035
        #No.FUN-8A0035--BEGIN--
#CHI-960065--begin--mark--------------------------------------
#           CASE g_aza.aza42
#           WHEN '1'
#             LET g_pic19 = l_estkno -1 USING "&&&&&&&&"
#           WHEN '2'
#             LET g_pic19 = l_estkno -1 USING "&&&&&&&&&"
#           WHEN '3'
#             LET g_pic19 = l_estkno -1 USING "&&&&&&&&&&"
#           OTHERWISE
#             LET g_pic19 = l_estkno -1 USING "&&&&&&&&"
#           END CASE
#       #No.FUN-8A0035--END-- 
#      #-----------No.TQC-6B0110 end
 
#       #更新標籤別目前使用最大單號
#       UPDATE pib_file      
#          SET pib03 = g_pic19 
#        WHERE pib01 = tm.stk 
#           IF SQLCA.sqlerrd[3]=0 THEN
#              CALL cl_err(l_pid01,SQLCA.sqlcode,1) #No.FUN-660156
#           #No.FUN-710025--Begin
#           #  CALL cl_err3("upd","pic_file",tm.stk,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
#              CALL s_errmsg('','','',SQLCA.sqlcode,1)
#           #No.FUN-710025--End
#              LET g_success = 'N'
#              RETURN 
#           END IF
#       CLOSE p810_cpib 
#CHI-960065--end--mark-----------------------------------------------
        LET g_pic19 = l_pia01   #CHI-960065 記錄截止單號
     END IF
 
     #產生[在製工單]空白盤點標籤
	 IF tm.e matches'[Yy]' THEN 
#CHI-960065--begin--mark---------------------------------------------
#       SELECT pib03 INTO l_ewipno FROM pib_file WHERE pib01 =tm.wip
#       IF l_ewipno is null or l_ewipno ='' THEN
#      #------------No.TQC-6B0110 modify
#      #LET l_ewipno = '000000'
#      #LET l_ewipno = '0000000000'  #FUN-8A0035
##No.FUN-8A0035--BEGIN--
#           CASE g_aza.aza42
#           WHEN '1'
#             LET l_ewipno = '00000000'
#           WHEN '2'
#             LET l_ewipno = '000000000'
#           WHEN '3'
#             LET l_ewipno = '0000000000'
#           OTHERWISE
#             LET l_ewipno = '00000000'
#           END CASE
##No.FUN-8A0035--END-- 
#      #------------No.TQC-6B0110 end
#       END IF 
#       IF l_ewipno < tm.wipno  THEN 
#          LET l_ewipno = tm.wipno
#       END IF
#       LET g_pic38 = l_ewipno 
#CHI-960065--end--mark--------------------------------------------

        LET g_wipcnt = 0
 
	FOR l_cnt=1 TO tm.paper2
           #No.FUN-710025--Begin--                                                                                                      
            IF g_success='N' THEN                                                                                                        
               LET g_totsuccess='N'                                                                                                      
               LET g_success="Y"                                                                                                         
            END IF                                                                                                                       
           #No.FUN-710025--End-
 
	   #LET l_pid01  = tm.wip,'-',l_ewipno           #FUN-5A0199 mark
	    #CHI-960065--begin--mod-----------------------------
	    #LET l_pid01  = tm.wip CLIPPED,'-',l_ewipno   #FUN-5A0199
            CALL s_auto_assign_no("aim",tm.wip,g_today,"I","pid_file","pid01","","","")
            RETURNING li_result,l_pid01
            IF (NOT li_result) THEN
               LET g_success = 'N'
               EXIT FOR
            END IF
            IF g_wipcnt = 0 THEN
               LET g_pic38 = l_pid01  #記錄在制工單的起始單號
               LET l_wip = tm.wip
               IF l_wip.getlength() > 6 THEN
                  LET tm.wip = s_get_doc_no(tm.wip)
               END IF
            END IF
           #CHI-960065--end--mod---------------------------------
            INSERT INTO pid_file (pid01,pid06,pid07,pid08,pid09,pid12,pidplant,pidlegal,pid012,pid021)  #FUN-980004 add pidplant,pidlegal #FUN-A60095
                           VALUES(l_pid01,'Y','N',g_user,g_today,0,g_plant,g_legal,' ',0) #FUN-980004 add g_plant,g_legal #FUN-A60095
             IF SQLCA.sqlcode THEN
#               CALL cl_err(l_pid01,SQLCA.sqlcode,0) #No.FUN-660156
             #No.FUN-710025--Begin--
             #  CALL cl_err3("ins","pic_file",l_pid01,"",SQLCA.sqlcode,"","",0)  #No.FUN-660156
                CALL s_errmsg('','',l_pid01,SQLCA.sqlcode,1)
                LET g_success = 'N'
             #  RETURN  
                CONTINUE FOR
             #No.FUN-710025--End--
             END IF
            #------------No.TQC-6B0110 modify
            #LET l_ewipno = l_ewipno + 1 USING "&&&&&&"
            #LET l_ewipno = l_ewipno + 1 USING "&&&&&&&&&&"   #FUN-8A0035
            #No.FUN-8A0035--BEGIN--
           #CHI-960065--begin--mark--------------------------------
           #CASE g_aza.aza42
           #WHEN '1'
           #   LET l_ewipno = l_ewipno + 1 USING "&&&&&&&&"
           #WHEN '2'
           #   LET l_ewipno = l_ewipno + 1 USING "&&&&&&&&&"
           #WHEN '3'
           #   LET l_ewipno = l_ewipno + 1 USING "&&&&&&&&&&"
           #OTHERWISE
           #   LET l_ewipno = l_ewipno + 1 USING "&&&&&&&&"
           #END CASE
           #CHI-960065--end--mark---------------------------------- 
            #No.FUN-8A0035--END--
            #------------No.TQC-6B0110 end
             LET g_wipcnt = g_wipcnt + 1
        END FOR
        #No.FUN-710025--Begin--                                                                                                             
          IF g_totsuccess="N" THEN                                                                                                         
              LET g_success="N"                                                                                                             
          END IF                                                                                                                           
        #No.FUN-710025--End--
 
       #---------No.TQC-6B0110 modify
       #LET g_pic39 = l_ewipno -1 USING "&&&&&&"
       #LET g_pic39 = l_ewipno -1 USING "&&&&&&&&&&"  #FUN-8A0035
       #No.FUN-8A0035--BEGIN--
#CHI-960065--begin--mark-------------------------------------  
#      CASE g_aza.aza42
#      WHEN '1'
#         LET g_pic39 = l_ewipno -1 USING "&&&&&&&&"
#      WHEN '2'
#         LET g_pic39 = l_ewipno -1 USING "&&&&&&&&&"
#      WHEN '3'
#         LET g_pic39 = l_ewipno -1 USING "&&&&&&&&&&"
#      OTHERWISE
#         LET g_pic39 = l_ewipno -1 USING "&&&&&&&&"
#      END CASE
#      #No.FUN-8A0035--END--
#      #---------No.TQC-6B0110 end
 
#       UPDATE pib_file
#      	   SET pib03 = g_pic39 
#  	     WHERE pib01 = tm.wip 
#            IF SQLCA.sqlerrd[3]=0 THEN
#               CALL cl_err(l_pid01,SQLCA.sqlcode,1) #No.FUN-660156
#            #No.FUN-710025--Begin--
#            #  CALL cl_err3("upd","pic_file",l_pid01,"",SQLCA.sqlcode,"","",1)  #No.FUN-660156
#               CALL s_errmsg('pib01',tm.wip,l_pid01,SQLCA.sqlcode,1)  
#            #No.FUN-710025--End--
#               LET g_success = 'N'
#               RETURN 
#            END IF
#      CLOSE p810_cpib2
#CHI-960065--end--mark--------------------------------
       LET g_pic39 = l_pid01   #CHI-960065 記錄在制工單的截止單號
 
     END IF
END FUNCTION
