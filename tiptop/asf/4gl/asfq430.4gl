# Prog. Version..: '5.30.06-13.03.12(00009)'     #
#
# Pattern name...: asfq430.4gl
# Descriptions...: 未發足料之在製工單查詢
# Date & Author..: 93/05/28 BY Keith
# g_argv2: 1:在製工單未發料查詢
#          2:在製工單備料查詢
#
# Modify.........: No.FUN-4B0011 04/11/02 By Carol 新增 I,T,Q類 單身資料轉 EXCEL功能(包含假雙檔)
# Modify.........: No.FUN-4B0040 04/11/10 Yuna QBE開窗開不出來
 # Modify.........: No.MOD-530170 05/03/21 by Carol 直接執行此程式時,用滑鼠無法打X離開
# Modify.........: No.FUN-660128 06/06/19 By Xumin cl_err --> cl_err3
# Modify.........: No.FUN-680121 06/08/29 By huchenghao 類型轉換
# Modify.........: No.FUN-6A0090 06/10/27 By douzh l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/16 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-860081 08/06/06 By jamie ON IDLE問題
# Modify.........: No.FUN-940008 09/05/08 By hongmei 發料改善
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A20044 10/03/19 by dxfwo  於 GP5.2 Single DB架構中，因img_file 透過view 會過濾Plant Code，因此會造 
#                                                 成 ima26* 角色混亂的狀況，因此对ima26的调整
# Modify.........: No.FUN-A60081 10/06/08 By vealxu 製造功能優化-平行制程（批量修改）
# Modify.........: No.MOD-AC0336 10/12/28 By jan 重抓製程料號
# Modify.........: No.FUN-B10056 11/02/16 By vealxu 修改制程段號的管控
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
        	wc  	LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(600)# Head Where condition
        	wc2  	LIKE type_file.chr1000        #No.FUN-680121 VARCHAR(600)# Body Where condition
        END RECORD,
    g_sfb RECORD
            sfb01		LIKE sfb_file.sfb01,
            sfb05		LIKE sfb_file.sfb05,
            sfb82		LIKE sfb_file.sfb82,
            sfb15		LIKE sfb_file.sfb15,
            sum_sfb08    LIKE sfb_file.sfb08,
            sum_sfb09    LIKE sfb_file.sfb09,
            sum_sfb10    LIKE sfb_file.sfb10,
            sum_sfb11    LIKE sfb_file.sfb11,
            sum_sfb12    LIKE sfb_file.sfb12
          END RECORD,
    g_sfa DYNAMIC ARRAY OF RECORD
            sfa03		LIKE sfa_file.sfa03,
            ima02		LIKE ima_file.ima02,
            ima021		LIKE ima_file.ima021,
            sfa05		LIKE sfa_file.sfa05,
            sfa06		LIKE sfa_file.sfa06,
            sfa25		LIKE sfa_file.sfa25,
            sfa07		LIKE sfa_file.sfa07,
#           unqty               LIKE ima_file.ima26        #No.FUN-680121 DECIMAL(12,3) 
            unqty   LIKE type_file.num15_3,   ###GP5.2  #NO.FUN-A20044   
            sfa012  LIKE sfa_file.sfa012,     #FUN-A60081
            ecu014  LIKE ecu_file.ecu014,     #FUN-A60081
            sfa013  LIKE sfa_file.sfa013,     #FUN-A60081
            sfa08   LIKE sfa_file.sfa08       #FUN-A60081         
        END RECORD,
    g_argv1     LIKE sfb_file.sfb01,          # INPUT ARGUMENT - 1
    g_argv2     LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)# INPUT ARGUMENT - 2
     g_sql           string, #WHERE CONDITION #No.FUN-580092 HCN
    g_rec_b LIKE type_file.num5   	      #單身筆數        #No.FUN-680121 SMALLINT
DEFINE   g_msg          LIKE type_file.chr1000      #No.FUN-680121 VARCHAR(72)
DEFINE   g_cnt          LIKE type_file.num10        #No.FUN-680121 INTEGER
DEFINE   g_row_count    LIKE type_file.num10        #No.FUN-680121 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10        #No.FUN-680121 INTEGER
DEFINE   g_jump         LIKE type_file.num10        #No.FUN-680121 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5         #No.FUN-680121 SMALLINT
DEFINE   g_short_qty    LIKE sfa_file.sfa07         #No.FUN-940008 add
DEFINE   g_sfa08        ARRAY[200] OF LIKE sfa_file.sfa08    #No.FUN-940008 add
DEFINE   g_sfa12        ARRAY[200] OF LIKE sfa_file.sfa27    #No.FUN-940008 add
DEFINE   g_sfa27        ARRAY[200] OF LIKE sfa_file.sfa27    #No.FUN-940008 add
 
MAIN
#    DEFINE  l_time LIKE type_file.chr8	    #No.FUN-6A0090
     DEFINE  l_errmsg      LIKE type_file.chr20,         #No.FUN-680121 VARCHAR(20)  #No.FUN-6A0090
             l_sl,p_row,p_col LIKE type_file.num5        #No.FUN-680121 SMALLINT
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ASF")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
    LET g_argv1      = ARG_VAL(1)          #參數值(1) W/O No.
    LET g_argv2      = ARG_VAL(2)          #參數值(2) Status
 
   LET p_row = 3 LET p_col = 20
   OPEN WINDOW asfq430_w AT p_row,p_col WITH FORM "asf/42f/asfq430"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
   CALL cl_ui_init()
   CALL cl_set_comp_visible("sfa012,ecu014,sfa013,sfa08",g_sma.sma541 = 'Y')    #No.FUN-A60081 add 
 
    #MOD-490201
   IF NOT cl_null(g_argv1) THEN
      CALL q430_q()
   END IF
   CALL q430_menu()
   #--
 
     CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0090
         RETURNING g_time    #No.FUN-6A0090
END MAIN
 
#QBE 查詢資料
FUNCTION q430_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680121 SMALLINT
 
      CLEAR FORM #清除畫面
      CALL g_sfa.clear()
      CALL cl_opmsg('q')
      INITIALIZE tm.* TO NULL			   # Default condition
      IF cl_null(g_argv1) THEN
       CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031   
   INITIALIZE g_sfb.* TO NULL    #No.FUN-750051
       CONSTRUCT BY NAME tm.wc ON sfb01,sfb05,sfb82,sfb15
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
           #--No.FUN-4B0040-------
           ON ACTION CONTROLP
             CASE WHEN INFIELD(sfb01)
                       CALL cl_init_qry_var()
                       LET g_qryparam.state= "c"
                       LET g_qryparam.form = "q_sfb12"
                       CALL cl_create_qry() RETURNING g_qryparam.multiret
                       DISPLAY g_qryparam.multiret TO sfb01
                       NEXT FIELD sfb01
             OTHERWISE EXIT CASE
             END CASE
           #--END---------------
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
         END CONSTRUCT
         IF INT_FLAG THEN
            RETURN
         END IF
         CALL q430_b_askkey()
      END IF
      IF INT_FLAG THEN
         RETURN
      END IF
   IF cl_null(tm.wc) THEN
      LET tm.wc = " 1=1"
   END IF
   IF cl_null(tm.wc2) THEN
      LET tm.wc2 = " 1=1"
   END IF
 
   IF cl_null(g_argv2) THEN
   LET g_sql=" SELECT UNIQUE sfb01 FROM sfa_file,sfb_file",
             " WHERE ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
			 " AND (sfaacti ='Y' OR sfaacti = 'y') ",
                " AND sfb04 IN ('3','4','5','6','7') ",
                " AND sfb01 = sfa01 AND sfa05 > sfa06 ",
             " ORDER BY sfb01"
  ELSE
   LET g_sql=" SELECT UNIQUE sfb01 FROM sfa_file,sfb_file",
             " WHERE (sfaacti ='Y' OR sfaacti = 'y') ",
                " AND sfb04 IN ('1','2','3','4','5','6','7') ",
                " AND sfb01 = sfa01 "
  END IF
 
    #Begin:FUN-980030
    #    IF g_priv2='4' THEN                            # 只能使用自己的資料
    #        LET g_sql= g_sql clipped," AND sfbuser = '",g_user,"'"
    #    END IF
    #    IF g_priv3='4' THEN                            # 只能使用相同群的資料
    #        LET g_sql= g_sql clipped," AND sfbgrup MATCHES '",g_grup CLIPPED,"*'"
    #    END IF
 
    #    IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
    #        LET g_sql= g_sql clipped," AND sfbgrup IN ",cl_chk_tgrup_list()
    #    END IF
    LET g_sql = g_sql CLIPPED,cl_get_extra_cond('sfbuser', 'sfbgrup')
    #End:FUN-980030
 
 
  IF g_argv2 = '1' THEN
     LET g_sql = g_sql CLIPPED," AND sfa05 > sfa06 AND sfb01 = '",g_argv1,
                 "' ORDER BY sfb01"
  END IF
  IF g_argv2 = '2' THEN
     LET g_sql = g_sql CLIPPED," AND sfb01 = '",g_argv1,"' ORDER BY sfb01"
  END IF
   PREPARE q430_prepare FROM g_sql
   DECLARE q430_cs                         #SCROLL CURSOR
           SCROLL CURSOR FOR q430_prepare
 
   # 取合乎條件筆數
   #若使用組合鍵值, 則可以使用本方法去得到筆數值
 
  IF cl_null(g_argv2) THEN
   LET g_sql=" SELECT COUNT(UNIQUE sfb01) FROM sfa_file,sfb_file",
             " WHERE ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
			 " AND (sfaacti ='Y' OR sfaacti = 'y') ",
                " AND sfb04 IN ('3','4','5','6','7') ",
                " AND sfb01 = sfa01 AND sfa05 > sfa06 "
  ELSE
   LET g_sql=" SELECT COUNT(UNIQUE sfb01) FROM sfa_file,sfb_file",
             " WHERE (sfaacti ='Y' OR sfaacti = 'y') ",
                " AND sfb04 IN ('1','2','3','4','5','6','7') ",
                " AND sfb01 = sfa01 "
  END IF
  IF g_argv2 = '1' THEN
     LET g_sql = g_sql CLIPPED," AND sfa05 > sfa06 AND sfb01 = '",g_argv1,"' "
  END IF
  IF g_argv2 = '2' THEN
     LET g_sql = g_sql CLIPPED," AND sfb01 = '",g_argv1,"' "
  END IF
{
   #IF g_wc2 =  " 1=1" THEN            # 取合乎條件筆數
    IF cl_null(g_argv1) THEN
      LET g_sql=" SELECT COUNT(*) FROM sfa_file ",
                " WHERE ",tm.wc CLIPPED,
			 " AND (sfaacti ='Y' OR sfaacti = 'y') "
    ELSE
      LET g_sql=" SELECT COUNT(DISTINCT sfa03) FROM sfb_file,sfa_file ",
                " WHERE ",tm.wc CLIPPED," AND ",tm.wc2 CLIPPED,
 		     " AND (sfaacti ='Y' OR sfaacti = 'y') ",
                " AND sfb01 = sfa01 AND sfa05 > sfa06 ",
                " AND sfb01 = '",g_argv1,"'"
    END IF
}
    DISPLAY "g_sql=",g_sql
    PREPARE q430_pp FROM g_sql
    DECLARE q430_count CURSOR FOR q430_pp
 
END FUNCTION
 
FUNCTION q430_b_askkey()
      CONSTRUCT  tm.wc2 ON  # 螢幕上取單身條件
               sfa03,sfa05,sfa06,sfa25,sfa07,sfa012,sfa013,sfa08                              #FUN-A60081 add sfa012,sfa013,sfa08
                      FROM s_sfa[1].sfa03,s_sfa[1].sfa05,
                           s_sfa[1].sfa06,s_sfa[1].sfa25,
                           s_sfa[1].sfa07,s_sfa[1].sfa012,s_sfa[1].sfa013,s_sfa[1].sfa08      #FUN-A60081 add sfa012,sfa013,sfa08
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
END FUNCTION
 
FUNCTION q430_menu()
 
   WHILE TRUE
      CALL q430_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q430_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
#FUN-4B0011
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_sfa),'','')
            END IF
##
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q430_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    MESSAGE ""
  # DISPLAY '   ' TO FORMONLY.cnt
    CALL q430_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    MESSAGE " SEARCHING ! "
    OPEN q430_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q430_count
        FETCH q430_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q430_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ""
 
END FUNCTION
 
FUNCTION q430_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,                 #處理方式        #No.FUN-680121 VARCHAR(1)
    l_abso          LIKE type_file.num10                 #絕對的筆數        #No.FUN-680121 INTEGER
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q430_cs INTO g_sfb.sfb01
        WHEN 'P' FETCH PREVIOUS q430_cs INTO g_sfb.sfb01
        WHEN 'F' FETCH FIRST    q430_cs INTO g_sfb.sfb01
        WHEN 'L' FETCH LAST     q430_cs INTO g_sfb.sfb01
        WHEN '/'
             IF (NOT mi_no_ask) THEN
                 CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                 LET INT_FLAG = 0  ######add for prompt bug
                 PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
 
                 END PROMPT
                 IF INT_FLAG THEN
                     LET INT_FLAG = 0
                     EXIT CASE
                 END IF
            END IF
            FETCH ABSOLUTE g_jump q430_cs INTO g_sfb.sfb01
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,0)
        INITIALIZE g_sfb.* TO NULL  #TQC-6B0105
        RETURN
    ELSE
       CASE p_flag
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF
    SELECT sfb01,sfb05,sfb82,sfb15,sfb08,sfb09,sfb10,sfb11,sfb12 INTO g_sfb.*
      FROM sfb_file
     WHERE sfb01 = g_sfb.sfb01
    IF SQLCA.sqlcode THEN
#      CALL cl_err(g_sfb.sfb01,SQLCA.sqlcode,1)   #No.FUN-660128
       CALL cl_err3("sel","sfb_file",g_sfb.sfb01,"",SQLCA.sqlcode,"","",1)    #No.FUN-660128
       RETURN
    END IF
 
    CALL q430_show()
 
END FUNCTION
 
FUNCTION q430_show()
   DISPLAY BY NAME g_sfb.*   # 顯示單頭值
   CALL q430_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q430_b_fill()              #BODY FILL UP
   DEFINE l_sql     LIKE type_file.chr1000,       #No.FUN-680121 VARCHAR(430)
#         l_qty     LIKE ima_file.ima26,          #No.FUN-680121 DECIMAL(12,3)
#         l_tt      LIKE ima_file.ima26           #No.FUN-680121 DECIMAL(12,3)
          l_qty     LIKE type_file.num15_3,       ###GP5.2  #NO.FUN-A20044
          l_tt      LIKE type_file.num15_3        ###GP5.2  #NO.FUN-A20044
   DEFINE l_ecu014  LIKE ecu_file.ecu014          #FUN-A60081
   DEFINE l_sfb06   LIKE sfb_file.sfb06           #FUN-A60081
   DEFINE l_sfb05   LIKE sfb_file.sfb05           #MOD-AC0336
   DEFINE l_flag    LIKE type_file.num5           #MOD-AC0336
 
  IF cl_null(g_argv2) THEN
     LET l_sql =
         "SELECT sfa03,ima02,ima021,sfa05,sfa06,sfa25,'',sfa05-sfa06,sfa012,' ',sfa013,sfa08,", #FUN-940008 sfa07-->''  #FUN-A60081 add sfa012,sfa013,sfa08 ''
         "       sfa08,sfa12,sfa27",  #FUN-940008 add
         " FROM sfa_file, OUTER ima_file",
         " WHERE sfa01 = '",g_sfb.sfb01,
         "' AND sfa_file.sfa03=ima_file.ima01 AND ",tm.wc2 CLIPPED,
         " AND sfa05 - sfa06 > 0  ORDER BY sfa03 "
  ELSE
     LET l_sql =
         "SELECT sfa03,ima02,ima021,sfa05,sfa06,sfa25,'',sfa05-sfa06,sfa012, ' ',sfa013,sfa08,", #FUN-940008 sfa07-->''  #FUN-A60081 add sfa012,sfa013,sfa08 ''
         "       sfa08,sfa12,sfa27",  #FUN-940008 add
         " FROM sfa_file,OUTER ima_file",
         " WHERE sfa01 = '",g_sfb.sfb01,"'",
         " AND sfa_file.sfa03=ima_file.ima01 "
  END IF
  IF g_argv2 = '1' THEN
     LET l_sql = l_sql CLIPPED," AND sfa05>sfa06 ORDER BY sfa03"
  END IF
  IF g_argv2 = '2' THEN
     LET l_sql = l_sql CLIPPED," ORDER BY sfa03"
  END IF
 
  PREPARE q430_pb FROM l_sql
  DECLARE q430_bcs CURSOR FOR q430_pb
 
  CALL g_sfa.clear()
  LET g_rec_b=0
  LET g_cnt = 1
  FOREACH q430_bcs INTO g_sfa[g_cnt].*,
                        g_sfa08[g_cnt],g_sfa12[g_cnt],g_sfa27[g_cnt]  #FUN-940008 add
    IF SQLCA.sqlcode THEN
        CALL cl_err('Foreach:',SQLCA.sqlcode,1)
        EXIT FOREACH
    END IF
    #FUN-A60081 -------------------start-----------------------------
    SELECT sfb06 INTO l_sfb06 FROM sfb_file WHERE sfb01=g_sfb.sfb01
    CALL s_schdat_sel_ima571(g_sfb.sfb01) RETURNING l_flag,l_sfb05  #MOD-AC0336
    LET l_ecu014 = NULL
   #FUN-B10056 -----------mod start--------
   #SELECT ecu014 INTO l_ecu014 
   #  FROM ecu_file 
   # WHERE ecu012 = g_sfa[g_cnt].sfa012
   #   AND ecu01=l_sfb05  #MOD-AC0336
   #   AND ecu02=l_sfb06
    CALL s_schdat_ecm014(g_sfb.sfb01,g_sfa[g_cnt].sfa012)RETURNING l_ecu014
   #FUN-B10056 -----------mod end--------
    LET g_sfa[g_cnt].ecu014 = l_ecu014
    #FUN-A60081 -------------------end----------------------------------
    #FUN-940008---Begin add
    #欠料量計算
    CALL s_shortqty(g_sfb.sfb01,g_sfa[g_cnt].sfa03,g_sfa08[g_cnt],
                    g_sfa12[g_cnt],g_sfa27[g_cnt],g_sfa[g_cnt].sfa012,g_sfa[g_cnt].sfa013)   #FUN-A60081 add asfa012,sfa013
       RETURNING g_short_qty
    IF cl_null(g_short_qty) THEN LET g_short_qty = 0 END IF 
    LET g_sfa[g_cnt].sfa07 = g_short_qty
    #FUN-940008---End
    IF g_sfa[g_cnt].sfa05 IS NULL THEN
           LET g_sfa[g_cnt].sfa05 = 0
    END IF
    IF g_sfa[g_cnt].sfa06 IS NULL THEN
           LET g_sfa[g_cnt].sfa06 = 0
    END IF
    IF g_sfa[g_cnt].sfa25 IS NULL THEN
           LET g_sfa[g_cnt].sfa25 = 0
    END IF
    IF g_sfa[g_cnt].sfa07 IS NULL THEN
           LET g_sfa[g_cnt].sfa07 = 0
    END IF
    IF g_sfa[g_cnt].unqty IS NULL THEN
           LET g_sfa[g_cnt].unqty = 0
    END IF
 
    LET g_cnt = g_cnt + 1
 
    IF g_cnt > g_max_rec THEN
       CALL cl_err( '', 9035, 0 )
       EXIT FOREACH
    END IF
 
  END FOREACH
 
  LET g_rec_b=g_cnt-1
  DISPLAY g_rec_b TO FORMONLY.cn2
 
  DISPLAY ARRAY g_sfa TO s_sfa.* ATTRIBUTE(COUNT=g_rec_b)
    BEFORE DISPLAY
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
 
END FUNCTION
 
FUNCTION q430_bp(p_ud)
   DEFINE   p_ud          LIKE type_file.chr1,          #No.FUN-680121 VARCHAR(1)
            l_sql         LIKE type_file.chr1000,       #No.FUN-680121 SMALLINT
            l_ac          LIKE type_file.num5,          #No.FUN-680121 SMALLINT
            l_n           LIKE type_file.num5,          #No.FUN-680121 SMALLINT
            l_sl          LIKE type_file.num5           #No.FUN-680121 SMALlINT
 
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_sfa TO s_sfa.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET l_sl = SCR_LINE()
 
      ##########################################################################
      # Standard 4ad ACTIO
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL q430_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION previous
         CALL q430_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION jump
         CALL q430_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION next
         CALL q430_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION last
         CALL q430_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         EXIT DISPLAY
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
 #MOD-530170
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
##
 
      ##########################################################################
      # Special 4ad ACTION
      ##########################################################################
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION query_dynamic_details #動態資料查詢
         LET l_ac = ARR_CURR()
         IF NOT cl_null(g_sfa[l_ac].sfa03) THEN
            LET l_sql = "aimq102 1 '",g_sfa[l_ac].sfa03,"'"
            CALL cl_cmdrun_wait(l_sql CLIPPED)
         END IF
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
#FUN-4B0011
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
##
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
