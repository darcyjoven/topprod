# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: aglq130.4gl
# Descriptions...: 各期統計資料查詢 
# Date & Author..: NO.FUN-5C0015 05/12/20 By TSD.kevin
# Modify.........: No.FUN-630058 06/04/09 By Sarah 按action帳款明細開窗後,應增加action'帳款憑單',點選單身後,可按此action call到憑單資料(例:aglq200 的明細查詢)
# Modify.........: No.FUN-680098 06/08/29 By yjkhero  欄位類型轉換為 LIKE型  
# Modify.........: No.FUN-690114 06/10/18 By atsea cl_used位置調整及EXIT PROGRAM后加cl_used
# Modify.........: No.FUN-6A0073 06/10/26 By xumin l_time轉g_time
# Modify.........: No.FUN-6B0029 06/11/10 By hongmei 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740020 07/04/05 By mike    會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-860018 08/06/09 By Smapmin 增加on idle控管
# Modify.........: No.MOD-880113 08/08/14 By Sarah 修改q130_amount(),1.DISPLAY ARRAY段增加ON ACTION cancel
#                                                                    2.一開始的IF判斷式,g_head_1.npr04 = 0改成(cl_null(g_head_1.npr04) OR g_head_1.npr04 = 0)
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-9A0024 09/10/10 By destiny display xxx.*改為display對應欄位
# Modify.........: No:MOD-9A0108 09/10/16 By mike aglq130点选[帐款资料],无法开启AR单据  
# Modify.........: No:MOD-9A0198 09/10/30 By Sarah q130_detail()段增加串查aapt121/151/210/220/331
# Modify.........: No:CHI-A70007 10/07/13 By Summer 多帳期改用s_azmm,並依據畫面上的帳別傳遞使用

DATABASE ds
 
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
    tm      RECORD
       	    wc  	LIKE type_file.chr1000,  # Head Where condition   #No.FUN-680098  VARCHAR(600) 
            aag04       LIKE aag_file.aag04
        END RECORD,
    g_head_1  RECORD
            npr08		LIKE npr_file.npr08,
            npr09		LIKE npr_file.npr09,
            npr00		LIKE npr_file.npr00,
            aag02		LIKE aag_file.aag02,
            npr01		LIKE npr_file.npr01,
            npr02		LIKE npr_file.npr02,
            npr03		LIKE npr_file.npr03,
            npr11		LIKE npr_file.npr11,
            npr04		LIKE npr_file.npr04,
            aag04		LIKE aag_file.aag04
        END RECORD,
            g_npr10		LIKE npr_file.npr10,
    g_npr   DYNAMIC ARRAY OF RECORD
            npr05               LIKE npr_file.npr05,
            npr06f              LIKE npr_file.npr06f,
            npr07f              LIKE npr_file.npr07f,
            balf                LIKE npr_file.npr07,
            npr06               LIKE npr_file.npr06,
            npr07               LIKE npr_file.npr07,
            bal                 LIKE npr_file.npr07 
        END RECORD,
    g_npq   DYNAMIC ARRAY OF RECORD
            npqsys              LIKE npq_file.npqsys,
	    npq00               LIKE npq_file.npq00,
            npp02               LIKE npp_file.npp02,
            npp01               LIKE npp_file.npp01,
            nppglno             LIKE npp_file.nppglno,
            npq06               LIKE npq_file.npq06,
            npq24               LIKE npq_file.npq24,
            npq07f              LIKE npq_file.npq07f,
            npq07               LIKE npq_file.npq07,
            npq04               LIKE npq_file.npq04
        END RECORD,
    g_sql      LIKE type_file.chr1000, # WHERE CONDITION  #No.FUN-680098  VARCHAR(1000) 
    l_ac       LIKE type_file.num5,    #No.FUN-680098 smallint
    g_rec_b    LIKE type_file.num5     # 單身筆數         #No.FUN-680098 smallint
 
DEFINE   g_cnt           LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_msg           LIKE ze_file.ze03           #No.FUN-680098  VARCHAR(72) 
DEFINE   g_row_count     LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_curs_index    LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   g_jump          LIKE type_file.num10         #No.FUN-680098 integer
DEFINE   mi_no_ask       LIKE type_file.num5          #No.FUN-680098 smallint
DEFINE   g_chr           LIKE type_file.chr1          #No.FUN-680098 VARCHAR(1)  
DEFINE   b_date,e_date   LIKE type_file.dat           #No.FUN-680098 date
 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0073
   DEFINE p_row,p_col   LIKE type_file.num5        #No.FUN-680098    smallint
 
   OPTIONS                                 # 改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        # 擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("AGL")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time #No.FUN-690114
 
 
   LET p_row = 2 LET p_col = 3 
   OPEN WINDOW q130_w AT p_row,p_col WITH FORM "agl/42f/aglq130"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    
   CALL cl_ui_init()
 
   CALL q130_menu()
   CLOSE WINDOW q130_w                     # 結束畫面
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690114
END MAIN
 
#QBE 查詢資料
FUNCTION q130_cs()
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01         #No.FUN-580031
DEFINE   l_cnt        LIKE type_file.num5         #No.FUN-680098 smallint
 
   CLEAR FORM                              # 清除畫面
   CALL g_npr.clear()
   CALL cl_opmsg('q')
   CALL cl_set_act_visible("query_customer1",TRUE)
   INITIALIZE tm.* TO NULL		   # Default condition
   CALL cl_set_head_visible("","YES")      #No.FUN-6B0029
 
   INITIALIZE g_head_1.* TO NULL    #No.FUN-750051
   INITIALIZE g_npr10 TO NULL    #No.FUN-750051
   CONSTRUCT BY NAME tm.wc ON npr08,npr09,npr00,npr01,npr02,npr03,npr11,npr04 
   
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(npr08) # 工廠別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azp"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO npr08	
                 NEXT FIELD npr08
            WHEN INFIELD(npr00) # 科目
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_aag"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO npr00
                 NEXT FIELD npr00
            WHEN INFIELD(npr01) # 付款廠商
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_pmc"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO npr01
                 NEXT FIELD npr01
            WHEN INFIELD(npr03) # 部門
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_gem"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO npr03
                 NEXT FIELD npr03
            WHEN INFIELD(npr11) # 幣別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_azi"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO npr11
                 NEXT FIELD npr11
            WHEN INFIELD(npr09) # 帳別
                 CALL cl_init_qry_var()
                 LET g_qryparam.state = "c"
                 LET g_qryparam.form ="q_aaa"
                 CALL cl_create_qry() RETURNING g_qryparam.multiret
                 DISPLAY g_qryparam.multiret TO npr09
                 NEXT FIELD npr09
           END CASE
 
      ON ACTION query_customer1  # 查詢客戶
         CALL cl_init_qry_var()
         LET g_qryparam.form ="q_occ"
         CALL cl_create_qry() RETURNING g_head_1.npr01
         DISPLAY BY NAME g_head_1.npr01
         NEXT FIELD npr01
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about    
         CALL cl_about()  
 
      ON ACTION help       
         CALL cl_show_help()
 
      ON ACTION controlg     
         CALL cl_cmdask()   
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select() 
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
   LET tm.wc = tm.wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   IF INT_FLAG THEN RETURN END IF
 
   LET tm.aag04 = '1'
   INPUT BY NAME tm.aag04 WITHOUT DEFAULTS
         #No.FUN-580031 --start--
            BEFORE INPUT
            CALL cl_qbe_display_condition(lc_qbe_sn)
         #No.FUN-580031 ---end---
 
 
      AFTER FIELD aag04 
         IF NOT cl_null(tm.aag04) THEN
            IF tm.aag04 != '1' AND tm.aag04 != '2' THEN
               NEXT FIELD aag04
            END IF
         END IF
   
      ON ACTION about
         CALL cl_about()
 
      ON ACTION help
         CALL cl_show_help()
 
      ON ACTION controlg
         CALL cl_cmdask()
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END INPUT
   IF INT_FLAG THEN RETURN END IF
 
   LET g_sql ="SELECT UNIQUE npr08,npr09,npr00,aag02,npr01,npr02,",
              "       npr03,npr11,npr04,aag04,npr10",
              "  FROM npr_file,aag_file",
              " WHERE ",tm.wc CLIPPED,
              "   AND aag01 = npr00 AND aag00=npr09",    #No.FUN-740020 
              "   AND aag04 = '",tm.aag04,"' ",
              " ORDER BY 1,2,3,5,6,7,8,9 "
   PREPARE q130_prepare FROM g_sql
   DECLARE q130_cs SCROLL CURSOR FOR q130_prepare
 
   LET g_sql ="SELECT UNIQUE npr08,npr09,npr00,npr01,npr02,npr03,npr11,npr04",
              "  FROM npr_file,aag_file ",
              " WHERE npr00 = aag01 AND npr09=aag00",   #No.FUN-740020
              "   AND ",tm.wc CLIPPED,
              "   AND aag04 = '",tm.aag04,"' ",
              "  INTO TEMP x "
  
   DROP TABLE x
   PREPARE q130_precount_x FROM g_sql
   EXECUTE q130_precount_x
 
   LET g_sql="SELECT COUNT(*) FROM x "
 
   PREPARE q130_precount FROM g_sql
   DECLARE q130_count CURSOR FOR q130_precount
END FUNCTION
 
#中文的MENU
FUNCTION q130_menu()
 
   WHILE TRUE
      CALL q130_bp("G")
      CASE g_action_choice
 
         WHEN "query"  
            IF cl_chk_act_auth() THEN 
               CALL q130_q()
            END IF
 
         WHEN "help" 
            CALL cl_show_help()
 
         WHEN "exit" 
            EXIT WHILE
 
         WHEN "controlg"    
            CALL cl_cmdask()
 
         WHEN "amount"
            CALL q130_amount()
 
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_npr),'','')
             END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q130_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
 
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    MESSAGE ""
    CALL cl_opmsg('q')
    DISPLAY '   ' TO FORMONLY.cnt 
 
    CALL q130_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
 
    OPEN q130_cs                              # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN q130_count
        FETCH q130_count INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q130_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
 
END FUNCTION
 
FUNCTION q130_fetch(p_flag)
 
DEFINE  p_flag          LIKE type_file.chr1,  # 處理方式        #No.FUN-680098  VARCHAR(1) 
        l_occacti       LIKE occ_file.occacti 
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q130_cs INTO g_head_1.*,g_npr10
        WHEN 'P' FETCH PREVIOUS q130_cs INTO g_head_1.*,g_npr10
        WHEN 'F' FETCH FIRST    q130_cs INTO g_head_1.*,g_npr10
        WHEN 'L' FETCH LAST     q130_cs INTO g_head_1.*,g_npr10
        WHEN '/'
            IF NOT mi_no_ask THEN
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
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
               #-----END TQC-860018-----
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump q130_cs INTO g_head_1.*,g_npr10  #No.TQC-6B0105
            LET mi_no_ask = FALSE
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_head_1.npr01,SQLCA.sqlcode,0)
        INITIALIZE g_head_1.* TO NULL  #TQC-6B0105
        INITIALIZE g_npr10    TO NULL  #TQC-6B0105
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
  
    CALL q130_show()
 
END FUNCTION
 
FUNCTION q130_show()
 
   #No.FUN-9A0024--begin   
   #DISPLAY BY NAME g_head_1.*  
   DISPLAY BY NAME g_head_1.npr08,g_head_1.npr09,g_head_1.npr00,g_head_1.aag02,g_head_1.npr01,
                   g_head_1.npr02,g_head_1.npr03,g_head_1.npr11,g_head_1.npr04,g_head_1.aag04
   #No.FUN-9A0024--end  
   IF g_head_1.aag04 = '2' THEN
      CALL cl_set_comp_visible("bal,balf",FALSE)
   ELSE 
      CALL cl_set_comp_visible("bal,balf",TRUE)
   END IF 
   CALL q130_b_fill()               # 單身
   CALL cl_show_fld_cont()     
 
END FUNCTION
 
FUNCTION q130_b_fill()              # BODY FILL UP
 
   DEFINE l_sql     LIKE type_file.chr1000,  #No.FUN-680098  VARCHAR(1000) 
          l_n       LIKE type_file.num5,     #No.FUN-680098  smallint
          l_tot     LIKE npr_file.npr06
   DEFINE l_totf    LIKE npr_file.npr06,
          l_aag06   LIKE aag_file.aag06
   DEFINE l_tot_o   LIKE npr_file.npr06,
          l_totf_o  LIKE npr_file.npr06
 
   LET l_sql =
        "SELECT npr05,npr06f,npr07f,0,npr06,npr07,0,aag06",
        "  FROM npr_file,aag_file",
        " WHERE npr00 = '",g_head_1.npr00,"'",
        "   AND npr01 = '",g_head_1.npr01,"'",
        "   AND npr02 = '",g_head_1.npr02,"'",
        "   AND npr03 = '",g_head_1.npr03,"'",
        "   AND npr04 = ",g_head_1.npr04,
        "   AND npr08 = '",g_head_1.npr08,"'",
        "   AND npr09 = '",g_head_1.npr09,"'",
        "   AND npr11 = '",g_head_1.npr11,"'",
        "   AND aag01 = npr00 ",
        "   AND aag00 = npr09 ",   #No.FUN-740020 
        " ORDER BY npr05 "
    PREPARE q130_pb FROM l_sql
    IF STATUS THEN CALL cl_err('q130_pb',STATUS,1) RETURN END IF
    DECLARE q130_bcs CURSOR FOR q130_pb
 
    CALL g_npr.clear()
    LET l_tot = 0
    LET l_ac = 1
    FOREACH q130_bcs INTO g_npr[l_ac].*,l_aag06
        IF SQLCA.sqlcode THEN
           CALL cl_err('q130(ckp#1):',SQLCA.sqlcode,1)
           EXIT FOREACH
        END IF
        IF l_aag06 = "1" THEN
           IF g_npr[l_ac].npr05 = 0 THEN
              LET l_tot = g_npr[l_ac].npr06 - g_npr[l_ac].npr07
              LET l_totf= g_npr[l_ac].npr06f- g_npr[l_ac].npr07f
           ELSE
              LET l_tot = l_tot + g_npr[l_ac].npr06 - g_npr[l_ac].npr07
              LET l_totf= l_totf+ g_npr[l_ac].npr06f- g_npr[l_ac].npr07f
           END IF
        ELSE
           IF g_npr[l_ac].npr05 = 0 THEN
              LET l_tot = g_npr[l_ac].npr07 - g_npr[l_ac].npr06
              LET l_totf= g_npr[l_ac].npr07f- g_npr[l_ac].npr06f
           ELSE
              LET l_tot = l_tot + g_npr[l_ac].npr07 - g_npr[l_ac].npr06
              LET l_totf= l_totf+ g_npr[l_ac].npr07f- g_npr[l_ac].npr06f
           END IF
        END IF
 
        IF l_ac = 1 THEN
           LET l_totf = 0
           LET l_tot  = 0
        ELSE  
           LET l_totf = l_totf_o
           LET l_tot  = l_tot_o
        END IF
        LET g_npr[l_ac].balf = l_totf + g_npr[l_ac].npr06f - g_npr[l_ac].npr07f
        LET g_npr[l_ac].bal  = l_tot  + g_npr[l_ac].npr06  - g_npr[l_ac].npr07
        LET l_totf_o = g_npr[l_ac].balf
        LET l_tot_o = g_npr[l_ac].bal
        IF l_aag06 = '2' AND g_npr[l_ac].balf < 0 THEN  #貸方科目
           LET g_npr[l_ac].balf = g_npr[l_ac].balf * -1 
           LET g_npr[l_ac].bal  = g_npr[l_ac].bal  * -1 
        END IF
        LET l_ac = l_ac + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_npr.deleteElement(l_ac)
    LET g_rec_b = l_ac - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    LET l_ac = 1
 
END FUNCTION
 
FUNCTION q130_amount()
   DEFINE l_sql   LIKE type_file.chr1000       #No.FUN-680098   VARCHAR(1200) 
   DEFINE l_cnt   LIKE type_file.num5          #No.FUN-680098   smallint
   DEFINE l_rec_b LIKE type_file.num5          #No.FUN-680098   smallint
   DEFINE g_i     LIKE type_file.num10   #FUN-630058 add    #No.FUN-680098   integer
 
   IF (cl_null(g_head_1.npr00) OR g_head_1.npr00 = ' ') AND
      (cl_null(g_head_1.npr01) OR g_head_1.npr01 = ' ') AND   
      (cl_null(g_head_1.npr03) OR g_head_1.npr03 = ' ') AND
     #g_head_1.npr04 = 0 AND                                  #MOD-880113 mark
      (cl_null(g_head_1.npr04) OR g_head_1.npr04 = 0  ) AND   #MOD-880113
      (cl_null(g_head_1.npr08) OR g_head_1.npr08 = ' ') AND
      (cl_null(g_head_1.npr09) OR g_head_1.npr09 = ' ') AND
      (cl_null(g_head_1.npr11) OR g_head_1.npr11 = ' ') THEN
      CALL cl_err('',-400,1) 
      RETURN
   END IF
 
   # 無單身資料，不可查詢帳款明細
   IF cl_null(g_npr[l_ac].npr05) THEN
      CALL cl_err('',-400,1)
      RETURN 
   END IF
    
   # (npr05 = 0)與開帳期別(npr10='0')：不提供明細查詢
   IF g_npr[l_ac].npr05 = '0' OR g_npr10 = '0' THEN
      CALL cl_err(' ','TSD0002',1)
      RETURN
   END IF
  
   OPEN WINDOW q130_a_w AT 2,3 WITH FORM "agl/42f/aglq130_a"
     ATTRIBUTE (STYLE = g_win_style CLIPPED)
  
   CALL cl_ui_locale("aglq130_a")
   CALL cl_load_act_list(NULL)   #FUN-630058 add
 
   #CALL s_azm(g_head_1.npr04,g_npr[l_ac].npr05) #CHI-A70007 mark
   #     RETURNING g_chr,b_date,e_date  #CHI-A70007 mark
   #CHI-A70007 add --start--
   IF g_aza.aza63 = 'Y' THEN
      CALL s_azmm(g_head_1.npr04,g_npr[l_ac].npr05,g_head_1.npr08,g_head_1.npr09) RETURNING g_chr,b_date,e_date
   ELSE
      CALL s_azm(g_head_1.npr04,g_npr[l_ac].npr05) RETURNING g_chr,b_date,e_date
   END IF
   #CHI-A70007 add --end--
   LET l_sql ="SELECT npqsys,npq00,npp02,npp01,nppglno, ",
              "       npq06,npq24,npq07f,npq07,npq04 ",
              "  FROM npp_file,npq_file ",
              " WHERE nppsys=npqsys AND npp00=npq00 ",
              "   AND npp01=npq01 AND npp011=npq011 ",
              "   AND npq03 = '",g_head_1.npr00,"' ",
              "   AND npp02 BETWEEN '",b_date,"' AND '",e_date,"' ",
              "   AND npp04 = '1' "
   
    IF cl_null(g_head_1.npr01) OR g_head_1.npr01 = ' ' THEN
       LET l_sql = l_sql," AND (npq21 IS NULL OR npq21 = ' ') "
    ELSE
       LET l_sql = l_sql,"AND npq21 = '",g_head_1.npr01,"' "
    END IF
 
    IF cl_null(g_head_1.npr03) OR g_head_1.npr03 = ' ' THEN
       LET l_sql = l_sql," AND (npq05 IS NULL OR npq05 = ' ') "
    ELSE
       LET l_sql = l_sql,"AND npq05 = '",g_head_1.npr03,"' "
    END IF
 
    IF cl_null(g_head_1.npr11) OR g_head_1.npr11 = ' ' THEN
       LET l_sql = l_sql," AND (npq24 IS NULL OR npq24 = ' ') "
    ELSE
       LET l_sql = l_sql,"AND npq24 = '", g_head_1.npr11,"' "
    END IF
 
    IF cl_null(g_head_1.npr08) OR g_head_1.npr08 = ' ' THEN
       LET l_sql = l_sql," AND (npp06 IS NULL OR npp06 = ' ') "
    ELSE
       LET l_sql = l_sql,"AND npp06 = '",g_head_1.npr08,"' "
    END IF
 
    IF cl_null(g_head_1.npr09) OR g_head_1.npr09 = ' ' THEN
       LET l_sql = l_sql," AND (npp07 IS NULL OR npp07 = ' ') "
    ELSE
       LET l_sql = l_sql,"AND npp07 = '",g_head_1.npr09,"' "
    END IF
 
    CALL g_npq.clear()
 
    PREPARE q130_a FROM l_sql
    IF STATUS THEN CALL cl_err('q130_a',STATUS,1) RETURN END IF
    DECLARE q130_a_cur CURSOR FOR q130_a
    LET l_cnt = 1
 
    FOREACH q130_a_cur INTO g_npq[l_cnt].*
       IF SQLCA.sqlcode THEN
          CALL cl_err('q130_a(ckp#1):',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       LET l_cnt = l_cnt + 1
       IF l_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    CALL g_npq.deleteElement(l_cnt)
    LET l_rec_b = l_cnt - 1    
 
    CALL cl_set_act_visible("accept,cancel",FALSE)
    DISPLAY ARRAY g_npq TO s_npq.* ATTRIBUTE(COUNT=l_rec_b,UNBUFFERED)
    
      BEFORE DISPLAY
         CALL cl_navigator_setting(0,0)
         CALL cl_set_act_visible("account_receipt",TRUE)   #FUN-630058 add
 
     #start FUN-630058 add 
      ON ACTION account_receipt    #帳款憑單
         LET g_i = ARR_CURR()
         IF g_i > 0 THEN
            IF g_npq[g_i].npp01 <> ' ' AND g_npq[g_i].npp01 IS NOT NULL THEN
               CALL q130_detail(g_i)
            END IF
         END IF
         CONTINUE DISPLAY
     #end FUN-630058 add 
 
      ON ACTION exit
         EXIT DISPLAY
 
     #str MOD-880113 add
      ON ACTION cancel
         LET INT_FLAG=FALSE             #MOD-570244     mars
         EXIT DISPLAY
     #end MOD-880113 add
 
      ON ACTION locale
         CALL cl_dynamic_locale()
 
      #-----TQC-860018---------
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
      
      ON ACTION about         
         CALL cl_about()      
      
      ON ACTION help          
         CALL cl_show_help()  
      
      ON ACTION controlg      
         CALL cl_cmdask()     
      #-----END TQC-860018-----
    END DISPLAY
    CALL cl_set_act_visible("accept,cancel",TRUE)
    CLOSE WINDOW q130_a_w
 
END FUNCTION
 
FUNCTION q130_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680098  VARCHAR(1) 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_npr TO s_npr.* ATTRIBUTE(UNBUFFERED)
 
       BEFORE DISPLAY
          CALL cl_navigator_setting(g_curs_index,g_row_count)
 
       BEFORE ROW
          LET l_ac = ARR_CURR()
          CALL cl_show_fld_cont()          
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q130_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
         ACCEPT DISPLAY        
                              
      ON ACTION previous
         CALL q130_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY               
                              
      ON ACTION jump
         CALL q130_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY                   
 
      ON ACTION next
         CALL q130_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
	 ACCEPT DISPLAY             
 
      ON ACTION last
         CALL q130_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)
         END IF
	ACCEPT DISPLAY          
                              
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont() 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      
      ON ACTION account_detail
         LET g_action_choice = 'amount'
         EXIT DISPLAY
     
      ON ACTION cancel                                                          
         LET INT_FLAG=FALSE 		
         LET g_action_choice="exit"                                             
         EXIT DISPLAY
   
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY                                                           
  
      AFTER DISPLAY
         CONTINUE DISPLAY
#No.FUN-6B0029--begin                                             
      ON ACTION controls                                        
         CALL cl_set_head_visible("","AUTO")                    
#No.FUN-6B0029--end
  
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#start FUN-630058 add
FUNCTION q130_detail(l_i)
   DEFINE l_i       LIKE type_file.num10      #No.FUN-680098 integer
   DEFINE l_cmd     LIKE type_file.chr1000    #No.FUN-680098 VARCHAR(200)
   DEFINE l_apa00   LIKE apa_file.apa00     
   DEFINE l_apf00   LIKE apf_file.apf00       #MOD-9A0198 add 
 
   SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01=g_npq[l_i].npp01
   IF STATUS THEN LET l_apa00 = '' END IF
   SELECT apf00 INTO l_apf00 FROM apf_file WHERE apf01=g_npq[l_i].npp01  #MOD-9A0198 add
   IF STATUS THEN LET l_apf00 = '' END IF                                #MOD-9A0198 add
   
   CASE
     WHEN g_npq[l_i].npqsys = 'NM' AND g_npq[l_i].npq00 = '1'
          LET l_cmd =  "anmt150 ","'",g_npq[l_i].npp01,"' "
     WHEN g_npq[l_i].npqsys = 'NM' AND g_npq[l_i].npq00 = '2'
          LET l_cmd =  "anmt250 ","'",g_npq[l_i].npp01,"' "
     WHEN g_npq[l_i].npqsys = 'NM' AND g_npq[l_i].npq00 = '3'
          LET l_cmd =  "anmt302 ","'",g_npq[l_i].npp01,"' "
     WHEN g_npq[l_i].npqsys = 'AP' AND g_npq[l_i].npq00 = '1' AND l_apa00 ='11'
          LET l_cmd =  "aapt110 ","'",g_npq[l_i].npp01,"' "
     WHEN g_npq[l_i].npqsys = 'AP' AND g_npq[l_i].npq00 = '1' AND l_apa00 ='12'
          LET l_cmd =  "aapt120 ","'",g_npq[l_i].npp01,"' "
     WHEN g_npq[l_i].npqsys = 'AP' AND g_npq[l_i].npq00 = '1' AND l_apa00 ='13'  #MOD-9A0198 add
          LET l_cmd =  "aapt121 ","'",g_npq[l_i].npp01,"' "                      #MOD-9A0198 add
     WHEN g_npq[l_i].npqsys = 'AP' AND g_npq[l_i].npq00 = '1' AND l_apa00 ='15'
          LET l_cmd =  "aapt150 ","'",g_npq[l_i].npp01,"' "
     WHEN g_npq[l_i].npqsys = 'AP' AND g_npq[l_i].npq00 = '1' AND l_apa00 ='16'  #MOD-9A0198 add
          LET l_cmd =  "aapt160 ","'",g_npq[l_i].npp01,"' "                      #MOD-9A0198 add
     WHEN g_npq[l_i].npqsys = 'AP' AND g_npq[l_i].npq00 = '1' AND l_apa00 ='17'  #MOD-9A0198 add
          LET l_cmd =  "aapt151 ","'",g_npq[l_i].npp01,"' "                      #MOD-9A0198 add
     WHEN g_npq[l_i].npqsys = 'AP' AND g_npq[l_i].npq00 = '1' AND l_apa00 ='21'  #MOD-9A0198 add
          LET l_cmd =  "aapt210 ","'",g_npq[l_i].npp01,"' "                      #MOD-9A0198 add
     WHEN g_npq[l_i].npqsys = 'AP' AND g_npq[l_i].npq00 = '1' AND l_apa00 ='22'  #MOD-9A0198 add
          LET l_cmd =  "aapt220 ","'",g_npq[l_i].npp01,"' "                      #MOD-9A0198 add
     WHEN g_npq[l_i].npqsys = 'AP' AND g_npq[l_i].npq00 = '1' AND l_apa00 ='26'  #MOD-9A0198 add
          LET l_cmd =  "aapt260 ","'",g_npq[l_i].npp01,"' "                      #MOD-9A0198 add
     WHEN g_npq[l_i].npqsys = 'AP' AND g_npq[l_i].npq00 = '3' AND l_apf00 ='33'  #MOD-9A0198 mod
          LET l_cmd =  "aapt330 ","'",g_npq[l_i].npp01,"' "
     WHEN g_npq[l_i].npqsys = 'AP' AND g_npq[l_i].npq00 = '3' AND l_apf00 ='34'  #MOD-9A0198 add
          LET l_cmd =  "aapt331 ","'",g_npq[l_i].npp01,"' "                      #MOD-9A0198 add
     WHEN g_npq[l_i].npqsys = 'LC' AND g_npq[l_i].npq00 = '4'
      #   LET l_cmd =  "aapt330 "
     WHEN g_npq[l_i].npqsys = 'LC' AND g_npq[l_i].npq00 = '5'
      #   LET l_cmd =  "aapt330 "
     WHEN g_npq[l_i].npqsys = 'AR' AND g_npq[l_i].npq00 = '1'
          LET l_cmd =  "axmt620 ","'",g_npq[l_i].npp01,"' "
     WHEN g_npq[l_i].npqsys = 'AR' AND g_npq[l_i].npq00 = '2'
         #LET l_cmd =  "axrt300 ","'",g_npq[l_i].npp01,"' '' '",g_npq[l_i].npq00  #MOD-9A0108                                        
          LET l_cmd =  "axrt300 ","'",g_npq[l_i].npp01,"' '' ''" #MOD-9A0108                
     WHEN g_npq[l_i].npqsys = 'AR' AND g_npq[l_i].npq00 = '3'
          LET l_cmd =  "axrt400 ","'",g_npq[l_i].npp01,"' ''" #TQC-630066
     WHEN g_npq[l_i].npqsys = 'FA' AND g_npq[l_i].npq00 = '1'
          LET l_cmd =  "afat101 ","'",g_npq[l_i].npp01,"' "
     WHEN g_npq[l_i].npqsys = 'FA' AND g_npq[l_i].npq00 = '7'
          LET l_cmd =  "afat105 ","'",g_npq[l_i].npp01,"' "
     WHEN g_npq[l_i].npqsys = 'FA' AND g_npq[l_i].npq00 = '8'
          LET l_cmd =  "afat106 ","'",g_npq[l_i].npp01,"' "
     WHEN g_npq[l_i].npqsys = 'FA' AND g_npq[l_i].npq00 = '4'
          LET l_cmd =  "afat110 ","'",g_npq[l_i].npp01,"' "
     WHEN g_npq[l_i].npqsys = 'FA' AND g_npq[l_i].npq00 = '5'
          LET l_cmd =  "afat108 ","'",g_npq[l_i].npp01,"' "
     WHEN g_npq[l_i].npqsys = 'FA' AND g_npq[l_i].npq00 = '6'
          LET l_cmd =  "afat109 ","'",g_npq[l_i].npp01,"' "
     WHEN g_npq[l_i].npqsys = 'FA' AND g_npq[l_i].npq00 = '9'
          LET l_cmd =  "afat107 ","'",g_npq[l_i].npp01,"' "
   END CASE
   CALL cl_cmdrun(l_cmd)
END FUNCTION
#end FUN-630058 add
