# Prog. Version..: '5.30.06-13.03.12(00004)'     #
#
# Pattern name...: asfp321.4gl
# Descriptions...: 工單下階工單刪除產生作業
# Date & Author..: 92/11/19 Lee
# Modify.........: No.MOD-4A0252 04/10/26 By Smapmin 工單編號開窗
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.MOD-7C0070 07/12/11 By Pengu 1.mark AFTER FIELD x的程式段
#                                                  2.按放棄，應出現執行失敗不應再 show 執行成功訊息
# Modify.........: No.FUN-7B0018 08/02/25 By hellen 行業比拆分表以后，增加INS/DEL行業別TABLE
# Modify.........: No.TQC-840066 08/04/28 By Mandy AXD系統欲刪,原使用 AXD 模組相關欄位的程式進行調整
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:TQC-A80039 10/08/10 By lilingyu 單據簽核狀況為"S:送簽中"的工單也不可刪除
# Modify.........: No.FUN-A90035 10/09/20 By vealxu 如果sfd的確認碼='Y',則工單不可刪除
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:TQC-D70068 13/07/22 By 1.幫助按鈕灰色，無法打開help
#                                            2.錄入母工單號，確定後，彈出asfp3211畫面。此時點擊“退出”按鈕，會提示：“運行成功，是否要繼續作業”，提示信息不准確
#                                            3.母工單A。子工單B為已審核狀態。通過asfp321錄入母工單A，會運行出B工單，確定執行刪除，顯示運行成功，
#                                              但是實際上查看工單B，並沒有刪除成功。已審核的工單應該進行控管
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
	tm RECORD
		chPWono LIKE sfb_file.sfb01,	#工單編號
		chCWono LIKE sfb_file.sfb01,	#工單編號
		cfConfirm LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1) #是否逐一確認
	END RECORD,
	m_part LIKE sfb_file.sfb05,             #料件編號
	m_wostatus LIKE sfb_file.sfb04,	        #工單狀態
        g_cmd        LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(60)
        g_rec_b      LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        s_t          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
        l_exit_sw    LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
        l_ac,l_sl    LIKE type_file.num5           #No.FUN-680121 SMALLINT
#TQC-D70068--add--str--
DEFINE g_show_msg    DYNAMIC ARRAY OF RECORD
       fld01         LIKE  type_file.chr100, #工單編號
       fld02         LIKE  type_file.chr100  #異動狀況
                     END RECORD
DEFINE g_fld01       LIKE  gaq_file.gaq03
DEFINE g_fld02       LIKE  gaq_file.gaq03
DEFINE g_msg         LIKE  ze_file.ze03
DEFINE g_msg2        LIKE  ze_file.ze03
DEFINE g_err_cnt     LIKE  type_file.num5
#TQC-D70068--add--end--
MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT				# Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 
   CALL p321_cmd(0,0)          #condition input
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211

END MAIN
 
FUNCTION p321_cmd(p_row,p_col)
DEFINE p_row,p_col	LIKE type_file.num5          #No.FUN-680121 SMALLINT
DEFINE l_flag   LIKE type_file.chr1          #No.FUN-680121 VARCHAR(1)
 
    IF p_row = 0 THEN LET p_row = 5 LET p_col = 10 END IF
    LET p_row = 5 LET p_col = 20
    OPEN WINDOW p321_w AT p_row,p_col
 	WITH FORM "asf/42f/asfp321" 
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
 
	CALL cl_opmsg('z')
	WHILE TRUE
           IF s_shut(0) THEN RETURN END IF
           CALL p321_i()
           IF cl_sure(0,0) THEN
              IF tm.chPWono IS NOT NULL THEN
                 CALL p321_p()
              ELSE
                 CALL p321_del(tm.chCWono)
              END IF
              #TQC-D70068--add--str--
              CALL s_showmsg()
              CALL cl_get_feldname('sfb01',g_lang) RETURNING g_fld01
              CALL cl_get_feldname('rxg04',g_lang) RETURNING g_fld02
              LET g_msg2 = g_fld01 CLIPPED,'|',g_fld02 CLIPPED
              CALL cl_show_array(base.TypeInfo.create(g_show_msg),g_msg,g_msg2)
              #TQC-D70068--add--end--
          #-------------No.MOD-7C0070 add
              IF g_success = 'Y' THEN   #TQC-D70068 add
                 CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束
              #TQC-D70068--add--str--
              ELSE
                 CALL cl_end2(2) RETURNING l_flag
              END IF
              #TQC-D70068--add--end--
           ELSE
              CALL cl_end2(2) RETURNING l_flag        #批次作業正確結束
          #-------------No.MOD-7C0070 end
           END IF
          #CALL cl_end2(1) RETURNING l_flag        #批次作業正確結束  #No.MOD-7C0070 mark
 
           IF l_flag THEN
              CONTINUE WHILE
           ELSE
              EXIT WHILE
           END IF
	END WHILE
	CLOSE WINDOW p321_w
END FUNCTION
 
FUNCTION p321_i()
   DEFINE   l_sfRequired    LIKE type_file.num5,          #No.FUN-680121 SMALLINT
            l_cfDirection   LIKE type_file.chr1           #No.FUN-680121 VARCHAR(1) #TQC-840066
 
   ERROR ''
   CLEAR FORM 
   INITIALIZE tm.* TO NULL
   LET tm.cfConfirm='Y'
   INPUT BY NAME tm.* WITHOUT DEFAULTS 
      ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
     AFTER FIELD chPWono	#工單編號
         IF tm.chPWono='   -      ' THEN
            LET tm.chPWono=''
         END IF
         IF tm.chPWono IS NOT NULL THEN
            LET tm.chCWono=''
            DISPLAY BY NAME tm.chCWono
            CALL p321_chPWono()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.chPWono,g_errno,0)
               NEXT FIELD chPWono
            END IF
         END IF
         LET l_cfDirection='D'
      BEFORE FIELD chCWono
         IF tm.chPWono IS NOT NULL THEN
            IF l_cfDirection='D' THEN
               NEXT FIELD cfConfirm
            ELSE
               NEXT FIELD chPWono
            END IF
         END IF
 
      AFTER FIELD chCWono
         IF tm.chCWono='   -      ' THEN
            LET tm.chCWono='' 
         END IF
         IF tm.chCWono IS NOT NULL THEN
            CALL p321_chCWono()
            IF NOT cl_null(g_errno) THEN
               CALL cl_err(tm.chCWono,g_errno,0)
               NEXT FIELD chCWono
            END IF
         END IF
 
      BEFORE FIELD cfConfirm
         IF tm.chPWono IS NULL AND tm.chCWono IS NULL THEN
            CALL cl_err('','mfg5084',0)
            NEXT FIELD chCWono
         END IF
         IF tm.chCWono IS NOT NULL THEN
            EXIT INPUT
         END IF
 
      AFTER FIELD cfConfirm
         LET l_cfDirection='D'
         IF tm.cfConfirm IS NULL OR tm.cfConfirm NOT MATCHES '[YN]' THEN
            NEXT FIELD cfConfirm
         END IF
 
      AFTER INPUT	#檢查必要欄位是否輸入
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
         LET l_sfRequired=TRUE
         IF (tm.chPWono IS NULL OR tm.chPWono=' ')
            AND (tm.chCWono IS NULL OR tm.chCWono=' ')
         THEN
            DISPLAY BY NAME tm.chPWono 
            LET l_sfRequired=FALSE
         END IF
         IF NOT l_sfRequired THEN
            CALL cl_err('','9033',0)
            IF tm.chPWono IS NULL OR tm.chPWono=' ' THEN
               NEXT FIELD chPWono
            END IF
         END IF
 
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(chPWono)       #工單編號
      #        CALL q_sfb(10,3,tm.chPWono,'') RETURNING tm.chPWono
      #        CALL FGL_DIALOG_SETBUFFER( tm.chPWono )
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb903"   #MOD-4A0252
               LET g_qryparam.default1 = tm.chPWono
               CALL cl_create_qry() RETURNING tm.chPWono
#               CALL FGL_DIALOG_SETBUFFER( tm.chPWono )
               DISPLAY BY NAME tm.chPWono
               NEXT FIELD chPWono
            WHEN INFIELD(chCWono)       #工單編號
#              CALL q_sfb(10,3,tm.chCWono,'') RETURNING tm.chCWono
#              CALL FGL_DIALOG_SETBUFFER( tm.chCWono )
               CALL cl_init_qry_var()
                LET g_qryparam.form = "q_sfb904"    #MOD-4A0252
               LET g_qryparam.default1 = tm.chCWono
               CALL cl_create_qry() RETURNING tm.chCWono
#               CALL FGL_DIALOG_SETBUFFER( tm.chCWono )
               DISPLAY BY NAME tm.chCWono
               NEXT FIELD chCWono
            OTHERWISE EXIT CASE
         END CASE
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION exit                            #加離開功能
         LET INT_FLAG = 1
         EXIT INPUT
   
      #TQC-D70068--add--str--
      ON ACTION help
         CALL cl_show_help()
      #TQC-D70068--add--end--
   END INPUT
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
      EXIT PROGRAM  
   END IF
END FUNCTION
 
FUNCTION p321_chPWono()
DEFINE
	l_sfb02 LIKE sfb_file.sfb02,		#工單型態
	l_sfb04 LIKE sfb_file.sfb04,		#工單狀態
	l_sfb071 LIKE sfb_file.sfb071,		#有效日期
	l_sfbacti LIKE sfb_file.sfbacti,	#有效碼
	l_scCnt   LIKE type_file.num5           #No.FUN-680121 SMALLINT
DEFINE  l_sfdconf  LIKE sfd_file.sfdconf        #FUN-A90035 add
 
	LET g_errno=' '
	SELECT sfb02,sfb04,sfb05,sfb071,sfbacti    
		INTO l_sfb02,m_wostatus,m_part,l_sfb071,l_sfbacti  
		FROM sfb_file                                        
		WHERE sfb01=tm.chPWono AND sfb87!='X' 
	CASE
		WHEN SQLCA.SQLCODE=NOTFOUND LET g_errno='mfg5000'
		WHEN l_sfbacti='N' LET g_errno='9028'
		OTHERWISE LET g_errno=SQLCA.SQLCODE USING '----------'
	END CASE
	LET l_scCnt=0
	IF cl_null(g_errno)THEN	#沒有錯誤, 但要判斷是否有產生過
		SELECT COUNT(*)
			INTO l_scCnt
			FROM sfb_file
			WHERE sfb86=tm.chPWono AND sfb87!='X'
		IF l_scCnt<1 THEN LET g_errno='mfg5082' END IF
	END IF
#FUN-A90035 ------------------add start---------------------------------------
        IF cl_null(g_errno) THEN          # 沒有錯誤,但要判斷如果存在sfd以確認的資料，則出現錯誤訊息並控卡不可刪除
           DECLARE p321_curs CURSOR FOR SELECT sfdconf FROM sfd_file WHERE sfd03 = tm.chPWono 
           FOREACH p321_curs INTO l_sfdconf 
              IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
              IF l_sfdconf = 'Y' THEN
                 LET g_errno = 'asf-773'
                 EXIT FOREACH
              END IF
          END FOREACH                 
       END IF   
#FUN-A90035 ---------------add end--------------------------------------------  
END FUNCTION
 
FUNCTION p321_chCWono()
DEFINE
	l_sfb02 LIKE sfb_file.sfb02,		#工單型態
	l_sfb04 LIKE sfb_file.sfb04,		#工單狀態
	l_sfb071 LIKE sfb_file.sfb071,		#有效日期
	l_sfb86 LIKE sfb_file.sfb86,		#父階工單
	l_sfbacti LIKE sfb_file.sfbacti,	#有效碼
	l_scCnt LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
	LET g_errno=' '
	SELECT sfb86,sfbacti
		INTO l_sfb86,l_sfbacti
		FROM sfb_file
		WHERE sfb01=tm.chCWono AND sfb87!='X'
	CASE
		WHEN SQLCA.SQLCODE=NOTFOUND LET g_errno='mfg5000'
		WHEN l_sfbacti='N' LET g_errno='9028'
		WHEN l_sfb86 IS NULL OR l_sfb86=' ' LET g_errno='mfg5083'
		OTHERWISE LET g_errno=SQLCA.SQLCODE USING '----------'
	END CASE
END FUNCTION
 
FUNCTION p321_p()
DEFINE
	l_arWo DYNAMIC ARRAY OF RECORD
		x     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
		sfb01 LIKE sfb_file.sfb01,
		sfb05 LIKE sfb_file.sfb05,
		sfb08 LIKE sfb_file.sfb08,
		ima55 LIKE ima_file.ima55
		END RECORD,
	l_iIdx,l_iCnt,l_iScl LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
	#取得資料
	DECLARE p321_pc CURSOR FOR
		SELECT 'Y',sfb01,sfb05,sfb08,ima55
		FROM sfb_file,OUTER ima_file
		WHERE sfb86=tm.chPWono
			AND sfb02<2
			AND sfb04<8
			AND ima_file.ima01=sfb_file.sfb05 AND sfb87!='X'
	LET l_iIdx=1
	FOREACH p321_pc INTO l_arWo[l_iIdx].*
		IF SQLCA.SQLCODE THEN EXIT FOREACH END IF
		LET l_iIdx=l_iIdx+1
		IF l_iIdx>49 THEN EXIT FOREACH END IF
	END FOREACH
 
         CALL l_arWo.deleteElement(l_iIdx) #MOD-480126
 
	#查看是否有資料
	LET l_iCnt=l_iIdx-1
	IF l_iCnt=0 THEN
          #CALL cl_err('',NOTFOUND,0)
           CALL cl_err(NOTFOUND,'mfg3382',0)
           RETURN
	END IF
 
	CALL SET_COUNT(l_iCnt)
	#若要逐筆確認
	IF tm.cfConfirm='Y' THEN
           OPEN WINDOW p3211_w AT 9,5 WITH FORM "asf/42f/asfp3211" 
            ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
           CALL cl_ui_locale("asfp3211")
 
           DISPLAY ARRAY l_arWo TO   s_arWO.*
            ATTRIBUTE(COUNT=l_iCnt,UNBUFFERED)
              BEFORE ROW
                EXIT DISPLAY
         #MOD-860081------add-----str---
         ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE DISPLAY
         
         ON ACTION about         
            CALL cl_about()      
         
         ON ACTION controlg      
            CALL cl_cmdask()     
         
         ON ACTION help          
            CALL cl_show_help()  
         #MOD-860081------add-----end---
           END DISPLAY
 
           INPUT   ARRAY l_arWo WITHOUT DEFAULTS FROM s_arWO.*
            ATTRIBUTE(COUNT=l_iCnt,MAXCOUNT=g_max_rec,UNBUFFERED,
                      INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
              BEFORE ROW
                LET l_iIdx=ARR_CURR()
                LET l_iScl=SCR_LINE()
 
             #-------------No.MOD-7C0070 mark
             #AFTER FIELD  x
             #  IF l_arWo[l_iIdx].x='Y' THEN
     	     #    LET l_arWo[l_iIdx].x='N'
             #  ELSE
	     #    LET l_arWo[l_iIdx].x='Y'
             #  END IF
             #  DISPLAY l_arWo[l_iIdx].x TO s_arWo[l_iScl].x
             #-------------No.MOD-7C0070 end
 
              ON IDLE g_idle_seconds
                    CALL cl_on_idle()
                    CONTINUE INPUT   
           
           END INPUT      
           CALL cl_set_act_visible("accept,cancel", TRUE)
           CLOSE WINDOW p3211_w
           IF INT_FLAG THEN LET INT_FLAG=0 RETURN END IF
	END IF
 
        #TQC-D70068--add--str--
        LET g_success = 'Y'
        CALL g_show_msg.clear()
        CALL s_showmsg_init()     #初始值for totsuccess
        LET g_err_cnt = 0
        #TQC-D70068--add--end--

	#進行資料的刪除
	FOR l_iIdx=1 TO l_iCnt
		IF l_arWo[l_iIdx].x MATCHES '[Yy]'
		THEN
			CALL p321_del(l_arWo[l_iIdx].sfb01)
		END IF
	END FOR
END FUNCTION
 
FUNCTION p321_del(p_sfb01)
DEFINE
	p_sfb01     LIKE sfb_file.sfb01,
	l_ima55_fac LIKE ima_file.ima55_fac,
	l_sfb       RECORD LIKE sfb_file.*	#工單資料
DEFINE  l_flag      LIKE type_file.chr1         #No.FUN-7B0018
 
	MESSAGE 'DELETE ',p_sfb01 
        CALL ui.Interface.refresh()
	SELECT sfb_file.*,ima55_fac INTO l_sfb.*,l_ima55_fac
          FROM sfb_file , OUTER ima_file
         WHERE sfb01 = p_sfb01 AND ima_file.ima01=sfb_file.sfb05
           AND sfb87 <> 'Y'  AND sfb87!='X'            # NO:0489
           AND sfb43 != 'S'                            #TQC-A80039
	IF SQLCA.SQLCODE THEN 
           #TQC-D70068--add--str--
           LET g_err_cnt = g_err_cnt + 1
           LET g_show_msg[g_err_cnt].fld01 = p_sfb01
           CALL cl_getmsg('asf1150',g_lang) RETURNING g_show_msg[g_err_cnt].fld02
           #TQC-D70068--add--end--
           RETURN 
        END IF
 
	IF l_ima55_fac IS NULL OR l_ima55_fac=0 THEN
           LET l_ima55_fac=1.0
	END IF
 
	#檢查備料資料
	IF l_sfb.sfb23='Y' THEN
           CALL s_delsfa(l_sfb.sfb01)
	END IF
 
	#檢查追蹤資料
	IF l_sfb.sfb24='Y' THEN
           DELETE FROM ecm_file
            WHERE ecm01=p_sfb01
           #TQC-D70068--add--str--
           IF SQLCA.sqlcode THEN
              IF g_bgerr THEN
                  CALL s_errmsg('sfb01',p_sfb01,'DELETE ecm_file Error',SQLCA.sqlcode,1)
                  LET g_totsuccess = 'N'
                  LET g_success = 'Y'
              ELSE
                  CALL cl_err(p_sfb01,SQLCA.sqlcode,1)
              END IF
           END IF
           #TQC-D70068--add--end--
        END IF
 
	#還原確認生產量
	LET l_sfb.sfb08=l_sfb.sfb08*l_ima55_fac
#	IF l_sfb.sfb04 = '1' THEN
	#	UPDATE ima_file
	#		SET ima81=ima81-l_sfb.sfb08
	#		WHERE ima01=l_sfb.sfb05
       # #END IF
       # IF l_sfb.sfb04 = '2' THEN
#	  UPDATE ima_file
#	   	 SET ima75=ima75-l_sfb.sfb08
#	   WHERE ima01=l_sfb.sfb05
#	END IF
	#刪除工單
        DELETE FROM sfb_file WHERE sfb01=p_sfb01
        #TQC-D70068--add--str--
        IF SQLCA.sqlcode THEN
           IF g_bgerr THEN
              CALL s_errmsg('sfb01',p_sfb01,'DELETE sfb_file Error',SQLCA.sqlcode,1)
              LET g_totsuccess = 'N'
              LET g_success = 'Y'
           ELSE
               CALL cl_err(p_sfb01,SQLCA.sqlcode,1)
           END IF
        END IF
        #TQC-D70068--add--end--
        #NO.FUN-7B0018 08/02/25 add --begin
        IF NOT s_industry('std') THEN
           LET l_flag = s_del_sfbi(p_sfb01,'')
        END IF
        #NO.FUN-7B0018 08/02/25 add --end
        DELETE FROM sfd_file WHERE sfd01=l_sfb.sfb85 AND sfd03=l_sfb.sfb01
        #TQC-D70068--add--str--
        IF SQLCA.sqlcode THEN
           IF g_bgerr THEN
              CALL s_errmsg('sfb01',p_sfb01,'DELETE sfd_file Error',SQLCA.sqlcode,1)
              LET g_totsuccess = 'N'
              LET g_success = 'Y'
           ELSE
              CALL cl_err(p_sfb01,SQLCA.sqlcode,1)
           END IF
        END IF
        #TQC-D70068--add--end--
	MESSAGE 'DELETE OK'
        CALL ui.Interface.refresh()
        #TQC-D70068--add--str--
        IF g_totsuccess = 'Y' THEN
           LET g_err_cnt = g_err_cnt + 1
           LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
           CALL cl_getmsg('asf1151',g_lang) RETURNING g_show_msg[g_err_cnt].fld02
        ELSE
           LET g_err_cnt = g_err_cnt + 1
           LET g_show_msg[g_err_cnt].fld01 = l_sfb.sfb01
           CALL cl_getmsg('asf1152',g_lang) RETURNING g_show_msg[g_err_cnt].fld02
        END IF
        #TQC-D70068--add--end--
END FUNCTION
