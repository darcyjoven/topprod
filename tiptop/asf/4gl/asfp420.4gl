# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: asfp420.4gl
# Descriptions...: 委外採購單結案作業
# Date & Author..: 93/06/10 By Keith
# Modify.........: 92/04/03 NO:6961..p420_update中的
# ...............: update sfb_file,sfa_file部份拿掉不影響委外工單
# Modify.........: No:8936,8937 03/01/02 By Ching add 輸入日期 check 不可小於 sma53
# Modify.........: No.MOD-530850 05/03/31 By Will 增加料件的開窗
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.MOD-660148 06/06/30 By Claire 重工委外工單可納入結案 sfb02='8'
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-660047 06/10/20 By Sarah 選擇方式改用勾選輸入較方便
# Modify.........: No.FUN-6A0090 06/11/07 By douzh l_time轉g_time
# Modify.........: No.FUN-710026 07/01/15 By hongmei 錯誤訊息匯總顯示修改
# Modify.........: No.FUN-910053 09/02/12 By jan sma74-->ima153
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A40023 10/04/12 By vealxu ima26x調整
# Modify.........: No:CHI-A70049 10/08/27 By Pengu  將多餘的DISPLAY程式mark
# Modify.........: No.FUN-AA0059 10/10/26 By chenying 料號開窗控管
# Modify.........: No:FUN-B30211 11/03/31 By lixiang  加cl_used(g_prog,g_time,2) 
# Modify.........: No.MOD-BC0030 11/12/05 By destiny 结案时应该只结掉选中的采购单
# Modify.........: No.TQC-BC0213 11/12/31 By zhangll 單身全部結案，自動更新單頭結案碼
# Modify.........: No.TQC-D70004 13/07/01 By yangtt 1.單身"廠商編號"欄位建議增加開窗
#                                                   2."工單號碼"開窗有料號，建議把料件名稱和規格都顯示出來
#                                                   3."採購單號"開窗建議把供應廠商名稱，採購員名稱和部門名稱欄位都顯示出來

DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE
    g_sfb         DYNAMIC ARRAY OF RECORD
         sure     LIKE type_file.chr1,     #No.FUN-680121 VARCHAR(1)# 選擇
         sfb01    LIKE sfb_file.sfb01,     # 工單編號
         pmn01    LIKE pmn_file.pmn01,     # 採購單號
         pmn02    LIKE pmn_file.pmn02,     # 項次
         sfb05    LIKE sfb_file.sfb05,     # 料件編號
         sfb15    LIKE sfb_file.sfb15,     # 完工日期
         pmm09    LIKE pmm_file.pmm09,     # 廠商編號
         sfb08    LIKE sfb_file.sfb08,     # 訂購(生產)量
         sfb09    LIKE sfb_file.sfb09,     # 完工數量
        #qty      LIKE ima_file.ima26      #No.FUN-680121 DECIMAL(11,3) # 差異數量  #FUN-A40023
         qty      LIKE type_file.num15_3   #FUN-A40023
             END RECORD,
    g_unalc       LIKE type_file.num5,     #No.FUN-680121 SMALLINT
    g_pmm22       LIKE pmm_file.pmm22,     # Curr
    g_pmm42       LIKE pmm_file.pmm42,     # Ex.Rate
    g_ima53       LIKE ima_file.ima53,
    g_ima531      LIKE ima_file.ima531,
    g_wc          STRING,  #No.FUN-580092 HCN
    g_sql         STRING,  #No.FUN-580092 HCN
    g_cmd         LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(60)
    l_sql         LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(500)
    l_exit_sw     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_exit        LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    l_sw          LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
    g_rec_b       LIKE type_file.num5,          #No.FUN-680121 SMALLINT
    l_ac,l_sl     LIKE type_file.num5           #No.FUN-680121 SMALLINT
DEFINE g_arrno    LIKE type_file.num5           #No.FUN-680121 SMALLINT#科目條件之ARRAY個數
DEFINE g_cnt      LIKE type_file.num10          #No.FUN-680121 INTEGER
DEFINE g_msg      LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(72)
 
MAIN
   OPTIONS
      INPUT NO WRAP
   DEFER INTERRUPT                        # Supress DEL key function
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-B30211 
   CALL p420_tm(0,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
END MAIN
 
FUNCTION p420_tm(p_row,p_col)
   DEFINE   p_row,p_col     LIKE type_file.num5,      #No.FUN-680121 SMALLINT
#       l_time            LIKE type_file.chr8              #No.FUN-6A0090
            l_flag          LIKE type_file.chr1,      #No.FUN-680121 VARCHAR(1)  # Used time for running the job
            l_cnt           LIKE type_file.num5,      #No.FUN-680121 SMALLINT
            l_cnt2          LIKE type_file.num5,      #No.FUN-680121 SMALLINT
            g_sta           LIKE type_file.chr1,      #No.FUN-680121 VARCHAR(1)
            g_i             LIKE type_file.num5,      #No.FUN-680136 SMALLINT   #FUN-660047 add
            l_allow_insert  LIKE type_file.num5,      #No.FUN-680136 SMALLINT   #FUN-660047 add
            l_allow_delete  LIKE type_file.num5       #No.FUN-680136 SMALLINT   #FUN-660047 add
 
   IF s_shut(0) THEN RETURN END IF
   LET p_row = 4   LET p_col = 2
 
   OPEN WINDOW p4201_w AT p_row,p_col WITH FORM "asf/42f/asfp420"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
 
   LET p_row = 10  LET p_col = 35
 
   OPEN WINDOW p420_w AT p_row,p_col WITH FORM "asf/42f/asfp420a"
        ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_locale("asfp420a")
 
   WHILE TRUE
      CLEAR FORM
      CALL g_sfb.clear()
 
      INPUT BY NAME g_today WITHOUT DEFAULTS
 
         AFTER FIELD g_today
            IF NOT cl_null(g_today) THEN
               #No.8936,8937 Add
               IF g_today <= g_sma.sma53 THEN
                  CALL cl_err(g_today,'axm-164',1)
                  NEXT FIELD g_today
               END IF
               ##
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT INPUT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_save
            CALL cl_qbe_save()
         #No.FUN-580031 ---end---
 
      END INPUT
      IF INT_FLAG THEN
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      CLOSE WINDOW p420_w
 
      CALL cl_getmsg('mfg5050',g_lang)
      RETURNING g_msg
      MESSAGE g_msg
      CALL ui.Interface.refresh()
      CALL cl_getmsg('mfg5051',g_lang) RETURNING g_msg
      MESSAGE g_msg
      CALL ui.Interface.refresh()
      CLEAR FORM
      CALL g_sfb.clear()
 
      CONSTRUCT g_wc ON sfb01,pmn01,pmn02,sfb05,sfb15,pmm09
           FROM s_sfb[1].sfb01,s_sfb[1].pmn01,s_sfb[1].pmn02,
                s_sfb[1].sfb05,s_sfb[1].sfb15,s_sfb[1].pmm09
         #No.FUN-580031 --start--
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #No.FUN-580031 ---end---
 
         ON ACTION locale
            CALL cl_dynamic_locale()
            CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
        #MOD-530850
         ON ACTION CONTROLP
            CASE
              #carrier 20130614  --Begin
              WHEN INFIELD(sfb01)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_sfb420"     #TQC-D70004
                 LET g_qryparam.form = "q_sfb420_1"   #TQC-D70004
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_sfb[1].sfb01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO sfb01
                 NEXT FIELD sfb01
              WHEN INFIELD(pmn01)
                 CALL cl_init_qry_var()
                #LET g_qryparam.form = "q_pmn420"     #TQC-D70004
                 LET g_qryparam.form = "q_pmn420_1"   #TQC-D70004
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_sfb[1].pmn01
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmn01
                 NEXT FIELD pmn01
              #carrier 20130614  --End  
              WHEN INFIELD(sfb05)
#FUN-AA0059---------mod------------str-----------------                            
#                CALL cl_init_qry_var()
#                LET g_qryparam.form = "q_ima"
#                LET g_qryparam.state = "c"
#                LET g_qryparam.default1 = g_sfb[1].sfb05
#                CALL cl_create_qry() RETURNING g_qryparam.multiret
               CALL q_sel_ima(TRUE, "q_ima","",g_sfb[1].sfb05,"","","","","",'')  RETURNING  g_qryparam.multiret
#FUN-AA0059---------mod------------end-----------------
                DISPLAY g_qryparam.multiret TO sfb05
                NEXT FIELD sfb05
             #TQC-D70004----add---str---
              WHEN INFIELD(pmm09)
                 CALL cl_init_qry_var()
                 LET g_qryparam.form = "q_pmm091" 
                 LET g_qryparam.state = "c"
                 LET g_qryparam.default1 = g_sfb[1].pmm09
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO pmm09
                 NEXT FIELD pmm09
             #TQC-D70004----add---end---
             OTHERWISE
                EXIT CASE
           END CASE
        #--
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
         ON ACTION exit                            #加離開功能
            LET INT_FLAG = 1
            EXIT CONSTRUCT
 
         #No.FUN-580031 --start--
         ON ACTION qbe_select
            CALL cl_qbe_select()
         #No.FUN-580031 ---end---
 
      END CONSTRUCT
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         EXIT WHILE
      END IF
 
      #資料權限的檢查
      #Begin:FUN-980030
      #      IF g_priv2='4' THEN                           #只能使用自己的資料
      #         LET g_wc = g_wc CLIPPED," AND pmmuser = '",g_user,"'"
      #      END IF
      #      IF g_priv3='4' THEN                           #只能使用相同群的資料
      #         LET g_wc = g_wc CLIPPED," AND pmmgrup MATCHES '",g_grup CLIPPED,"*'"
      #      END IF
 
      #      IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
      #         LET g_wc = g_wc CLIPPED," AND pmmgrup IN ",cl_chk_tgrup_list()
      #      END IF
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond('pmmuser', 'pmmgrup')
      #End:FUN-980030
 
      LET g_sql="SELECT COUNT(*) FROM pmn_file,sfb_file,pmm_file ",
                " WHERE pmn01 = pmm01 AND pmn41 = sfb01 ",
                " AND (sfb02 ='7' OR sfb02='8') ",       #MOD-660148
                " AND pmn011 = 'SUB' AND pmn16 = '2' ",  #MOD-660148
                " AND sfb04  IN ('2','3','4','5','6','7') AND sfb10 = 0 AND sfb11 = 0 ",
                " AND ",g_wc
      PREPARE p420_p FROM g_sql
      DECLARE p420_css  CURSOR FOR p420_p
      OPEN p420_css
      FETCH p420_css INTO l_cnt
      IF l_cnt = 0 THEN
         CALL cl_err('','mfg3382',1)
         CONTINUE WHILE
      END IF
      LET g_sql="SELECT 'Y',sfb01,pmn01,pmn02,pmn04,sfb15,pmm09,sfb08,sfb09,sfb08-sfb09",
                " FROM pmn_file,pmm_file,sfb_file ",
                " WHERE pmn011 = 'SUB' AND pmn16 = '2' AND ",g_wc CLIPPED,
                " AND pmn01 = pmm01 ",
                " AND pmn41 = sfb01 ",
                " AND (sfb02 = '7' OR sfb02= '8') ", #MOD-660148
                " AND sfb04  IN ('2','3','4','5','6','7') AND sfb10 = 0 AND sfb11 = 0 ",
                " ORDER BY sfb01,pmn01,pmn02 "
      PREPARE p420_prepare FROM g_sql           # RUNTIME 編譯
      IF SQLCA.sqlcode THEN
         CALL cl_err('prepare:',SQLCA.sqlcode,1) 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211
         EXIT PROGRAM
      END IF
      DECLARE p420_cs CURSOR FOR p420_prepare
      CALL cl_opmsg('z')
      LET l_ac = 1
      LET l_cnt = 0
      LET g_cnt = 0
      LET g_arrno = 420
  #   LET l_exit_sw = 'y'
      LET l_exit = 'Y'     #bugno:6738 add
      LET l_sw = 'y'
      FOREACH p420_cs INTO g_sfb[l_ac].*
         IF SQLCA.sqlcode THEN
            CALL cl_err('Cannot Foreach: ',SQLCA.sqlcode,1)
            EXIT FOREACH
         END IF
         IF g_sma.sma73 = 'Y' THEN
            CALL p420_check(g_sfb[l_ac].sfb01) RETURNING l_cnt2
            IF l_cnt2 = 1 THEN
               LET g_sfb[l_ac].sure = 'Y'
               LET l_cnt = l_cnt + 1
            ELSE
              #LET g_sfb[l_ac].sure = ' '   #FUN-660047 mark
               LET g_sfb[l_ac].sure = 'N'   #FUN-660047
            END IF
         ELSE
            LET g_sfb[l_ac].sure = 'Y'
            LET l_cnt = l_cnt + 1
         END IF
         LET l_ac = l_ac + 1                           #累加筆數
         IF l_ac > g_arrno THEN                        #超過肚量了
            CALL cl_err('','9035',0)
            EXIT FOREACH
         END IF
      END FOREACH
      CALL g_sfb.deleteElement(l_ac)        #FUN-660047 add
      IF l_ac=1 THEN                                   #沒有抓到
         CALL cl_err('','mfg5052',0)                   #顯示錯誤, 並回去
         CONTINUE WHILE
      END IF
      LET g_cnt = l_ac -1
      CALL SET_COUNT(l_ac - 1)
      IF g_gui_type MATCHES "[13]" AND fgl_getenv('GUI_VER') = '6' THEN
         CALL cl_getmsg('mfg5056',g_lang)
         RETURNING g_msg
         MESSAGE g_msg
         CALL ui.Interface.refresh()
      ELSE
         CALL cl_getmsg('mfg5056',g_lang)
         RETURNING g_msg
        #DISPLAY g_msg AT 2,1     #CHI-A70049 mark          #顯示操作指引
      END IF
      DISPLAY g_cnt TO FORMONLY.cn3  #顯示總筆數
      DISPLAY l_cnt TO FORMONLY.cn2
 
     #start FUN-660047 mark
     #CALL cl_set_act_visible("accept,cancel", TRUE)
     #DISPLAY ARRAY g_sfb TO s_sfb.*  #顯示並進行選擇
     #   ON ACTION CONTROLR
     #      CALL cl_show_req_fields()
     #   ON ACTION CONTROLG
     #      CALL cl_cmdask()
     #   ON ACTION CONTROLN  #重查
     #      LET l_exit='N'
     #      EXIT DISPLAY
     #   ON ACTION select_cancel  #選擇或取消
     #      LET l_ac = ARR_CURR()
     #      LET l_sl = SCR_LINE()
     #      IF g_sfb[l_ac].sure IS NULL OR g_sfb[l_ac].sure=' ' THEN
     #         IF p420_check(g_sfb[l_ac].sfb01) THEN
     #            LET g_sfb[l_ac].sure='Y'            #設定為選擇
     #            LET l_cnt=l_cnt+1                   #累加已選筆數
     #         ELSE
     #            CALL cl_getmsg('mfg5048',g_lang) RETURNING g_msg
     #            IF cl_prompt(0,0,g_msg) THEN
     #               LET g_sfb[l_ac].sure='Y'          #設定為選擇
     #               LET l_cnt=l_cnt+1                 #累加已選筆數
     #            END IF
     #         END IF
     #      ELSE
     #         LET g_sfb[l_ac].sure=''           #設定為不選擇
     #         LET l_cnt=l_cnt-1                   #減少已選筆數
     #      END IF
     #      DISPLAY g_sfb[l_ac].sure TO s_sfb[l_sl].sure
     #      DISPLAY l_cnt TO FORMONLY.cn2
     #   ON IDLE g_idle_seconds
     #      CALL cl_on_idle()
     #      CONTINUE DISPLAY
     #END DISPLAY
     #CALL cl_set_act_visible("accept,cancel", TRUE)
     #IF INT_FLAG THEN
     #   LET INT_FLAG = 0
     #   EXIT WHILE
     #END IF #使用者中斷
     #IF l_exit='N' THEN
     #   CONTINUE WHILE
     #END IF
     #IF l_cnt < 1 THEN                               #已選筆數超過 0筆
     #   EXIT WHILE
     #END IF
     #end FUN-660047 mark
 
     #start FUN-660047 add
      LET g_rec_b = g_cnt
      LET l_ac = 0
      LET l_allow_insert = FALSE
      LET l_allow_delete = FALSE
 
      INPUT ARRAY g_sfb WITHOUT DEFAULTS FROM s_sfb.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,APPEND ROW=l_allow_insert)
         BEFORE INPUT
            IF g_rec_b != 0 THEN
               CALL fgl_set_arr_curr(l_ac)
            END IF
 
         BEFORE ROW
            LET l_ac = ARR_CURR()
 
         AFTER FIELD sure
            IF NOT cl_null(g_sfb[l_ac].sure) THEN
               IF g_sfb[l_ac].sure NOT MATCHES "[YN]" THEN
                  NEXT FIELD sure
               END IF
            END IF
 
         AFTER INPUT
            LET l_cnt  = 0
            FOR g_i =1 TO g_rec_b
               IF g_sfb[g_i].sure = 'Y' AND
                  NOT cl_null(g_sfb[g_i].sfb01)  THEN
                  LET l_cnt = l_cnt + 1
               END IF
            END FOR
            DISPLAY l_cnt TO FORMONLY.cn2
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()
 
         ON ACTION CONTROLG
            CALL cl_cmdask()
 
         ON ACTION CONTROLN  #重查
            LET l_exit='N'
            EXIT INPUT
 
         ON ACTION select_all
            FOR g_i = 1 TO g_rec_b
                LET g_sfb[g_i].sure="Y"
            END FOR
            LET l_cnt = g_rec_b
            DISPLAY g_rec_b TO FORMONLY.cn2
 
         ON ACTION cancel_all
            FOR g_i = 1 TO g_rec_b
                LET g_sfb[g_i].sure="N"
            END FOR
            LET l_cnt = 0
            DISPLAY 0 TO FORMONLY.cn2
 
         AFTER ROW
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
 
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
 
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121
 
      END INPUT
      IF l_exit='N' THEN
         CONTINUE WHILE
      END IF
     #end FUN-660047 add
 
      IF NOT cl_sure(0,0) THEN
         EXIT WHILE
      END IF
      CALL cl_wait()
 
      BEGIN WORK
         LET l_sl=0
         LET g_success = 'Y'
         FOR l_ac=1 TO g_cnt
            IF g_sfb[l_ac].sure='Y' THEN          #該單據要結案
               CALL p420_update(g_sfb[l_ac].sfb01,
                                g_sfb[l_ac].pmn01,
                                g_sfb[l_ac].pmn02,
                                g_sfb[l_ac].sfb05)
            END IF
         END FOR
         CALL s_showmsg()                           #NO.FUN-710026
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
         ERROR""
         EXIT WHILE
   END WHILE
   ERROR ""
   CLOSE WINDOW p4201_w
END FUNCTION
 
FUNCTION p420_check(l_sfb01)              #CLOSE
	DEFINE l_qty,l_qty_h,l_qty_l	LIKE sfb_file.sfb09,
		   l_sfb01	LIKE sfb_file.sfb01,
		   l_sfb08	LIKE sfb_file.sfb08,
		   l_sfb09	LIKE sfb_file.sfb09,
		   l_sfb10	LIKE sfb_file.sfb10,
		   l_sfb11	LIKE sfb_file.sfb11,
		   l_sfb12	LIKE sfb_file.sfb12,
                   l_sfb05      LIKE sfb_file.sfb05    #FUN-910053
        DEFINE  l_ima153     LIKE ima_file.ima153   #FUN-910053 
	SELECT sfb08,sfb09,sfb10,sfb11,sfb12,sfb05     #FUN-910053 add sfb05
		INTO l_sfb08,l_sfb09,l_sfb10,l_sfb11,l_sfb12,l_sfb05
		FROM sfb_file WHERE sfb01 = l_sfb01
	IF STATUS AND STATUS != 100 THEN
	#	CALL cl_err('',STATUS,0)   #No.FUN-660128
		CALL cl_err3("sel","sfb_file",l_sfb01,"",STATUS,"","",0)    #No.FUN-660128
		RETURN
	END IF
        CALL s_get_ima153(l_sfb05) RETURNING l_ima153  #FUN-910053  
	IF g_sma.sma73 = 'Y' THEN			#工單數量是否作勾稽
       #IF g_sma.sma74 IS NULL THEN LET g_sma.sma74 = 0 END IF  #FUN-910053
		LET l_qty = l_sfb09+l_sfb10+l_sfb11+l_sfb12
        	#LET l_qty_l = l_sfb08 * (100-g_sma.sma74)/100
		#LET l_qty_h = l_sfb08 * (100+g_sma.sma74)/100
		LET l_qty_l = l_sfb08 * (100-l_ima153)/100
		LET l_qty_h = l_sfb08 * (100+l_ima153)/100
		IF l_qty > l_qty_h OR l_qty < l_qty_l THEN
			RETURN 0
		END IF
	END IF
	RETURN 1
END FUNCTION
 
FUNCTION p420_update(p_sfb01,p_pmn01,p_pmn02,p_sfb05)
   DEFINE
      p_sfb01   LIKE sfb_file.sfb01,    #工單單號
      p_pmn01   LIKE pmn_file.pmn01,    #採購單號
      p_pmn02   LIKE pmn_file.pmn02,    #採購項次
      p_sfb05   LIKE sfb_file.sfb05,    #生產料件
      l_sfb05   LIKE sfb_file.sfb05,    #生產主料件
      l_sfb08   LIKE sfb_file.sfb08,
      l_sfb09   LIKE sfb_file.sfb09,
      l_sfb12   LIKE sfb_file.sfb12,
      l_pmn20   LIKE pmn_file.pmn20,
      l_pmn04   LIKE pmn_file.pmn04,
      l_pmn13   LIKE pmn_file.pmn13,
      l_pmn09   LIKE pmn_file.pmn09,
      l_pmn51   LIKE pmn_file.pmn51,
      l_pmn16   LIKE pmn_file.pmn16,
      l_sfa03   LIKE sfa_file.sfa03,
      l_sfa13   LIKE sfa_file.sfa13,
      l_sfa05   LIKE sfa_file.sfa05,
      l_sfa06   LIKE sfa_file.sfa06,
      l_sfa25   LIKE sfa_file.sfa25,
      l_bb      LIKE pmn_file.pmn16,
      l_diff    LIKE pmn_file.pmn13,          #No.FUN-680121 DECIMAL(7,3)
      l_pur     LIKE oea_file.oea01,          #No.FUN-680121 VARCHAR(13)
      l_item    LIKE aba_file.aba18,          #No.FUN-680121 VARCHAR(02)
      l_sta     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
     #l_qty1    LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(13,3)  #FUN-A40023
      l_qty1    LIKE type_file.num15_3,       #FUN-A40023  
      l_qty,l_qty_h,l_qty_l,l_qty_t,l_qty_d    LIKE sfb_file.sfb09,
      l_cnt     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
      l_pmm     LIKE type_file.num5,          #No.FUN-680121 SMALLINT
      l_pt      LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
      l_sql     LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(300)
DEFINE  l_ima153     LIKE ima_file.ima153   #FUN-910053 
 
   {ckp#1}
   #==>更改 pmn_file
   SELECT pmn51 INTO l_pmn51 FROM pmn_file
    WHERE pmn01 = p_pmn01 AND pmn02 = p_pmn02
   IF l_pmn51 > 0 THEN   #尚有在驗量,不可結案
      LET l_item = p_pmn02
      LET l_pur = p_pmn01,'-',l_item
      CALL cl_err(l_pur,'mfg3418',1)
      LET g_success = 'N'
      RETURN
   END IF
 
   SELECT sfb08,sfb09,sfb12,sfb09+sfb10+sfb11+sfb12
     INTO l_sfb08,l_sfb09,l_sfb12,l_qty_t
    FROM sfb_file WHERE sfb01 = p_sfb01
   IF SQLCA.sqlcode THEN
#     CALL cl_err('Select sfb:',SQLCA.SQLCODE,1)   #No.FUN-660128
      CALL cl_err3("sel","sfb_file",p_sfb01,"",SQLCA.sqlcode,"","Select sfb:",1)    #No.FUN-660128
      LET g_success ='N'
      RETURN
   END IF
     IF cl_null(l_sfb08) THEN LET l_sfb08=0 END IF
     IF l_qty_t  < l_sfb08 THEN
          LET l_qty_d = l_sfb08 - l_qty_t
      ELSE
          LET l_qty_d = 0
     END IF
   IF g_sma.sma73 = 'Y' THEN
      SELECT pmn13 INTO l_pmn13 FROM pmn_file
       WHERE pmn01 = p_pmn01 AND pmn02 = p_pmn02
     #FUN-910053--BEGIN--
      CALL s_get_ima153(p_sfb05) RETURNING l_ima153  #FUN-910053  
     #IF g_sma.sma74 - l_pmn13 > 0 THEN
      IF l_ima153 - l_pmn13 > 0 THEN
         #LET l_diff = g_sma.sma74
         LET l_diff = l_ima153
      ELSE
         LET l_diff = l_pmn13
      END IF
      #IF g_sma.sma74 IS NULL THEN
      #   LET g_sma.sma74 = 0
      #END IF
      #FUN-910053--END--
      LET l_qty = l_sfb09+l_sfb12
      LET l_qty_l = l_sfb08 * (100-l_diff)/100
      LET l_qty_h = l_sfb08 * (100+l_diff)/100
      IF l_qty > l_qty_h OR l_qty < l_qty_l THEN
         CALL cl_err(p_pmn01,'mfg3423',1)
      END IF
   END IF
  #BugNo:4728
  #BugNo:6961
   SELECT sfb05 INTO l_sfb05 FROM sfb_file   #l_sfb05工單主料
    WHERE sfb01=p_sfb01                      #p_sfb05單身料號
   IF cl_null(l_sfb05) THEN LET l_sfb05=' ' END IF
   IF l_sfb05=p_sfb05 THEN    #主料結案,代採料也要結,若代採料有結,主料不見得要結除非有選
       DECLARE pmn_cur CURSOR FOR
          SELECT pmn01,pmn02,pmn50-pmn20-pmn55,pmn16 FROM pmn_file
           WHERE pmn41 = p_sfb01
             AND pmn01=p_pmn01 AND pmn02=p_pmn02  #MOD-BC0030
       CALL s_showmsg_init()             #NO.FUN-710026
       FOREACH pmn_cur INTO p_pmn01,p_pmn02,l_qty1,l_pmn16
#NO.FUN-710026-----begin add
         IF g_success='N' THEN                                                                                                          
            LET g_totsuccess='N'                                                                                                       
            LET g_success="Y"                                                                                                          
         END IF                    
#NO.FUN-710026-----end
 
          IF l_pmn16 MATCHES '[678]' THEN CONTINUE FOREACH END IF
          CASE
             WHEN l_qty1 = 0 LET  l_sta = '6'
             WHEN l_qty1 > 0 LET  l_sta = '7'
             WHEN l_qty1 < 0 LET  l_sta = '8'
             OTHERWISE EXIT CASE
          END CASE
          UPDATE pmn_file SET pmn16 = l_sta, pmn57=l_qty1
            WHERE pmn01 = p_pmn01 AND pmn02 = p_pmn02
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err('Update pmn16 fail:',SQLCA.sqlcode,1)   #No.FUN-660128
#            CALL cl_err3("upd","pmn_file",p_pmn01,p_pmn02,SQLCA.sqlcode,"","Update pmn16 fail:",1)    #No.FUN-660128 #NO.FUN-710026
             LET g_showmsg=p_pmn01,"/",p_pmn02                                                         #NO.FUN-710026 
             CALL s_errmsg('pmn01,pmn02',g_showmsg,'Update pmn16 fail:',SQLCA.sqlcode,1)               #NO.FUN-710026
             LET g_success = 'N' 
#            EXIT FOREACH                                                                              #NO.FUN-710026
             CONTINUE FOREACH                                                                          #NO.FUN-710026                           
          END IF
       END FOREACH
#NO.FUN-710026----begin 
       IF g_totsuccess="N" THEN                                                                                                         
          LET g_success="N"                                                                                                             
       END IF 
#NO.FUN-710026----end
 
      #TQC-BC0213 mark 移至下方 不考慮工單對應的單身全部結才自動更新單頭，只考慮當前這張採購單單身都結了，就結單頭狀態碼
      ##==>Update pmm_file
      #SELECT COUNT(*) INTO l_pmm FROM pmn_file
      # WHERE pmn41 = p_sfb01 AND pmn16 ='2'
      #IF l_pmm IS NULL THEN LET l_pmm = 0 END IF
      #IF l_pmm = 0  THEN
      #   UPDATE pmm_file SET pmm25 = '6'
      #    WHERE pmm01 = p_pmn01
      #   IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#     #      CALL cl_err('Update pmm25 fail:',SQLCA.sqlcode,1)   #No.FUN-660128
#     #      CALL cl_err3("upd","pmm_file",p_pmn01,"",SQLCA.sqlcode,"","Update pmm25 fail:",1)    #No.FUN-660128 #NO.FUN-710026
      #      CALL s_errmsg('pmm01',p_pmn01,'Update pmm25 fail:',SQLCA.sqlcode,1)                 #NO.FUN-710026
      #      LET g_success = 'N'
      #   END IF
      #END IF
      #TQC-BC0213 mark--end 移至下方
   ELSE
        SELECT pmn01,pmn02,pmn50-pmn20-pmn55 INTO p_pmn01,p_pmn02,l_qty1
          FROM pmn_file
         WHERE pmn01 = p_pmn01
           AND pmn02 = p_pmn02
          CASE
             WHEN l_qty1 = 0 LET  l_sta = '6'
             WHEN l_qty1 > 0 LET  l_sta = '7'
             WHEN l_qty1 < 0 LET  l_sta = '8'
             OTHERWISE EXIT CASE
          END CASE
          UPDATE pmn_file SET pmn16 = l_sta, pmn57=l_qty1
            WHERE pmn01 = p_pmn01 AND pmn02 = p_pmn02
          IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
#            CALL cl_err('Update pmn16 fail:',SQLCA.sqlcode,1)   #No.FUN-660128
#            CALL cl_err3("upd","pmn_file",p_pmn01,p_pmn02,SQLCA.sqlcode,"","Update pmn16 fail:",1)    #No.FUN-660128 #NO.FUN-710026
             LET g_showmsg=p_pmn01,"/",p_pmn02                                                         #NO.FUN-710026 
             CALL s_errmsg('pmn01,pmn02',g_showmsg,'Update pmn16 fail:',SQLCA.sqlcode,1)               #NO.FUN-710026    
             LET g_success = 'N'
          END IF
   END IF
   #BugNo:6961==
   #TQC-BC0213 add 功能從上方移過來,程序寫法需變更
   #==>Update pmm_file
   SELECT COUNT(*) INTO l_pmm FROM pmn_file
    WHERE pmn01 = p_pmn01
      AND pmn16 NOT IN ('6','7','8','9')
   IF l_pmm IS NULL THEN LET l_pmm = 0 END IF

   IF l_pmm = 0 THEN
      UPDATE pmm_file SET pmm25 = '6', pmm27 = g_today
       WHERE pmm01 = p_pmn01
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3] = 0 THEN
         CALL s_errmsg('pmm01',p_pmn01,'Update pmm25 fail:',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   #TQC-BC0213 add--end  從上方移過來
 
END FUNCTION
