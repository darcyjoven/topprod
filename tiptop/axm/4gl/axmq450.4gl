# Prog. Version..: '5.30.06-13.03.12(00007)'     #
#
# Pattern name...: axmq450.4gl
# Descriptions...: 產品庫存受訂明細查詢
# Date & Author..: 95/04/19 By Roger
# Modify.........: No.MOD-480357 04/08/20 Wiky 修改設定功能,ON ACTION first,next,...CALL cl_navigator_setting以下四行拿掉加EXIT DISPLAY
# Modify.........: No.MOD-4B0102 04/11/15 Mandy axmt620 於單身維護時，按功能鍵「產品庫存受訂明細查詢」，無法正常顯示各倉、儲批之明細庫存資料。
# Modify.........: No.FUN-4B0038 04/11/15 By pengu ARRAY轉為EXCEL檔
# Modify.........: No.FUN-4B0043 04/11/16 By Nicola 加入開窗功能
# Modify.........: No.MOD-4B0136 04/12/13 By Mandy 在進行功能鍵「受訂庫存明細查詢」時，系統應自動帶出所有訂單單身之料號，而不是讓使用者自行輸入料號查詢。
# Modify.........: No.FUN-610058 06/01/16 By Sarah 左側視窗應增加「儲位」(img03)之顯示
# Modify.........: No.FUN-680137 06/09/04 By bnlent 欄位型態定義，改為LIKE
# Modify.........: No.FUN-6A0094 06/10/25 By yjkhero l_time轉g_time
# Modify.........: No.FUN-6B0031 06/11/13 By yjkhero 新增動態切換單頭部份顯示的功能
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: NO.MOD-860078 08/06/06 BY Yiting ON IDLE 處理
 
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-A20044 10/03/20 By  jiachenchao 刪除字段ima26* 
# Modify.........: No.TQC-B60221 11/06/21 By lixiang 講組SQL的變量類型由chr1000->STRING
# Modify.........: No.CHI-C30042 12/09/20 By pauline 將庫存單位及訂單的銷售單位都顯示出來
# Modify.........: No.MOD-DA0194 13/10/29 By SunLM 調整CHI-C30042，將庫存單位以及正確的數量顯示出來

DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE
    tm  RECORD
              #  wc      LIKE type_file.chr1000,# Head Where condition  #No.FUN-680137 VARCHAR(500) #No.TQC-B60221                                            
              #  wc2     LIKE type_file.chr1000 # Body Where condition  #No.FUN-680137 VARCHAR(500) #No.TQC-B60221
                 wc      STRING,      #No.TQC-B60221
                 wc2     STRING       #No.TQC-B60221
        END RECORD,
    g_ima  RECORD
            ima01	LIKE ima_file.ima01, # 料件編號
            ima02	LIKE ima_file.ima02, # 品名
            ima021	LIKE ima_file.ima021# 規格
          # ima262      LIKE type_file.num10          #No.FUN-680137 INTEGER #FUN-A20044
          #  vl_stk      LIKE type_file.num15_3        #FUN-A20044
        END RECORD,
    g_img DYNAMIC ARRAY OF RECORD
            img04   LIKE img_file.img04, #存放批號
            img02   LIKE img_file.img02, #倉庫編號
            img03   LIKE img_file.img03, #儲位       #FUN-610058
            img09   LIKE img_file.img09, #库存单位 #MOD-DA0194
            img10   LIKE type_file.num10         #No.FUN-680137 INTEGER     #庫存數量
        END RECORD,
    g_oeb DYNAMIC ARRAY OF RECORD
            oeb01   LIKE oeb_file.oeb01,
            oea032  LIKE oea_file.oea032,
            oeb092  LIKE oeb_file.oeb092,
            oeb15   LIKE oeb_file.oeb15,
            oeb12   LIKE type_file.num10,        #No.FUN-680137 INTEGER
            oeb05   LIKE oeb_file.oeb05,         #CHI-C30042 add   #銷售單位
            oeb12_1 LIKE type_file.num10         #CHI-C30042 add   #轉換為庫存單位的數量
        END RECORD,
    g_argv1         LIKE ima_file.ima01,      # INPUT ARGUMENT - 1
     g_argv2         LIKE oeb_file.oeb01,      # INPUT ARGUMENT - 2 #MOD-4B0136
     g_min_qty	    LIKE type_file.num10,   #No.MOD-480357   #No.FUN-680137 INTEGER
     g_max_qty      LIKE type_file.num10,   #No.MOD-480357   #No.FUN-680137 INTEGER
    g_query_flag    LIKE type_file.num5,   #第一次進入程式時即進入Query之後進入next   #No.FUN-680137 SMALLINT
    tot1,tot2,tot3,tot4  LIKE type_file.num10,               #No.FUN-680137 INTEGER
     g_sql         STRING, #WHERE CONDITION  #No.FUN-580092 HCN  
    g_rec_b  LIKE type_file.num5,  	      #單身筆數      #No.FUN-680137 SMALLINT
    g_rec_b2 LIKE type_file.num5   	      #單身筆數      #No.FUN-680137 SMALLINT
DEFINE p_row,p_col     LIKE type_file.num5                   #No.FUN-680137 SMALLINT
 
DEFINE   g_cnt           LIKE type_file.num10                #No.FUN-680137 INTEGER
DEFINE   g_msg           LIKE type_file.chr1000              #No.FUN-680137 VARCHAR(72)
DEFINE   i               LIKE type_file.num5                 #No.FUN-680137 SMALLINT
DEFINE   l_ac            LIKE type_file.num5                 #No.FUN-680137 SMALLINT
 
# 2004/02/06 by Hiko : 為了上下筆資料的控制而加的變數.
DEFINE   g_row_count    LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   g_jump         LIKE type_file.num10         #No.FUN-680137 INTEGER
DEFINE   mi_no_ask      LIKE type_file.num5          #No.FUN-680137 SMALLINT
DEFINE   g_avl_stk_mpsmrp,g_unavl_stk,g_avl_stk LIKE type_file.num15_3 #FUN-A20044 
MAIN
#     DEFINE   l_time LIKE type_file.chr8	    #No.FUN-6A0094
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("AXM")) THEN
      EXIT PROGRAM
   END IF
 
 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
    LET g_query_flag=1
    LET g_argv1      = ARG_VAL(1)          #參數值(1) Part#
     LET g_argv2      = ARG_VAL(2)          #參數值(2) 訂單單號 #MOD-4B0136
    LET p_row = 3 LET p_col = 10
 
    OPEN WINDOW q450_w AT p_row,p_col WITH FORM "axm/42f/axmq450"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
 
    CALL cl_ui_init()
 
    CALL SET_COUNT(200)
#    IF cl_chk_act_auth() THEN
#       CALL q450_q()
#    END IF
     IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN CALL q450_q() END IF #MOD-4B0136 add g_argv2
    CALL q450_menu()
    CLOSE WINDOW q450_w
      CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0094
         RETURNING g_time    #No.FUN-6A0094
END MAIN
 
#QBE 查詢資料
FUNCTION q450_cs()
   DEFINE   l_cnt LIKE type_file.num5          #No.FUN-680137 SMALLINT
 #MOD-4B0136 MARK掉,改成下段
#  IF NOT cl_null(g_argv1)
#     THEN LET tm.wc = "ima01 = '",g_argv1,"'"
#                  LET tm.wc2=" 1=1 "
   IF NOT cl_null(g_argv1) OR NOT cl_null(g_argv2) THEN
       IF NOT cl_null(g_argv1) THEN
           LET tm.wc = "ima01 = '",g_argv1,"'"
	   LET tm.wc2=" 1=1 "
       END IF
       IF NOT cl_null(g_argv2) THEN
           LET tm.wc = "ima01 IN (SELECT oeb04 FROM oeb_file",
                       "           WHERE oeb01 ='",g_argv2,"'",
                       "             AND oeb04 IS NOT NULL) "
	   LET tm.wc2=" 1=1 "
       END IF
 #MOD-4B0136(end)
      ELSE CLEAR FORM #清除畫面
           CALL g_img.clear()
           CALL g_oeb.clear()
           CALL cl_opmsg('q')
           INITIALIZE tm.* TO NULL			# Default condition
           CALL cl_set_head_visible("","YES")  #NO.FUN-6B0031
   INITIALIZE g_ima.* TO NULL    #No.FUN-750051
           CONSTRUCT BY NAME tm.wc ON ima01 # 螢幕上取單頭條件
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
              ON ACTION CONTROLP    #FUN-4B0043
                 IF INFIELD(ima01) THEN
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_ima"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO ima01
                    NEXT FIELD ima01
                 END IF
 
              ON IDLE g_idle_seconds
                 CALL cl_on_idle()
                 CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
           END CONSTRUCT
           IF INT_FLAG THEN RETURN END IF
           CALL q450_b_askkey()
           IF INT_FLAG THEN RETURN END IF
   END IF
 
   MESSAGE ' WAIT '
#   LET g_sql=" SELECT ima01,ima02,ima021,ima262 FROM ima_file ", #FUN-A20044
   LET g_sql=" SELECT ima01,ima02,ima021 FROM ima_file ", #FUN-A20044
             " WHERE ",tm.wc CLIPPED
 
   #資料權限的檢查
   #Begin:FUN-980030
   #   IF g_priv2='4' THEN#只能使用自己的資料
   #      LET g_sql = g_sql clipped," AND imauser = '",g_user,"'"
   #   END IF
   #   IF g_priv3='4' THEN#只能使用相同群的資料
   #     LET g_sql = g_sql clipped," AND imagrup MATCHES '",g_grup CLIPPED,"*'"
   #   END IF
 
   #   IF g_priv3 MATCHES "[5678]" THEN    #TQC-5C0134群組權限
   #     LET g_sql = g_sql clipped," AND imagrup IN ",cl_chk_tgrup_list()
   #   END IF
   LET g_sql = g_sql CLIPPED,cl_get_extra_cond('imauser', 'imagrup')
   #End:FUN-980030
 
   LET g_sql = g_sql clipped," ORDER BY ima01"
   PREPARE q450_prepare FROM g_sql
   DECLARE q450_cs SCROLL CURSOR FOR q450_prepare
 
   LET g_sql=" SELECT COUNT(*) FROM ima_file ",
             " WHERE ",tm.wc CLIPPED
   PREPARE q450_pp  FROM g_sql
   DECLARE q450_cnt CURSOR FOR q450_pp
END FUNCTION
 
FUNCTION q450_b_askkey()
  #CONSTRUCT tm.wc2 ON img04,img02 FROM s_img[1].img04,s_img[1].img02                        #FUN-610058 mark
   CONSTRUCT tm.wc2 ON img04,img02,img03 FROM s_img[1].img04,s_img[1].img02,s_img[1].img03   #FUN-610058
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE CONSTRUCT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
		#No.FUN-580031 --start--     HCN
                 ON ACTION qbe_select
         	   CALL cl_qbe_select()
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
   END CONSTRUCT
    #No.MOD-480357
   LET p_row = 8 LET p_col = 18
   OPEN WINDOW q4501_w1 AT p_row,p_col         #顯示畫面
        WITH FORM "axm/42f/axmq4501"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_locale("axmq4501")
   INPUT g_min_qty,g_max_qty FROM min_qty,max_qty
   AFTER FIELD max_qty
         IF NOT cl_null(g_min_qty) AND NOT cl_null(g_max_qty) THEN
            IF g_min_qty > g_max_qty THEN
               CALL cl_err('','9011',1)
               NEXT FIELD min_qty
            END IF
         END IF
 
#--no.MOD-860078---
        ON ACTION CONTROLG
            CALL cl_cmdask()
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about         
           CALL cl_about()      
 
        ON ACTION help          
           CALL cl_show_help()  
#--no.MOD-860078----
 
   END INPUT
   #IF cl_null(g_min_qty) THEN LET g_min_qty=0 END IF
   #IF cl_null(g_max_qty) THEN LET g_max_qty=0 END IF
   CLOSE WINDOW q4501_w1
    #No.MOD-480357(end)
 
END FUNCTION
 
 
FUNCTION q450_menu()
 
   WHILE TRUE
      CALL q450_bp("G")
      CASE g_action_choice
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q450_q()
            END IF
         WHEN "query_detail"
            CALL q450_b()
            LET g_action_choice = ""
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
      {   WHEN "setting"
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT "僅查詢最少庫存量:" FOR min_qty
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
            END PROMPT
      }
         WHEN "exporttoexcel"     #FUN-4B0038
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_img),'','')
            END IF
 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q450_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q450_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q450_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('open cursor',SQLCA.sqlcode,0)
    ELSE
        OPEN q450_cnt
        FETCH q450_cnt INTO g_row_count
        DISPLAY g_row_count TO FORMONLY.cnt
        CALL q450_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q450_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1                  #處理方式        #No.FUN-680137 VARCHAR(1)
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q450_cs INTO g_ima.*
        WHEN 'P' FETCH PREVIOUS q450_cs INTO g_ima.*
        WHEN 'F' FETCH FIRST    q450_cs INTO g_ima.*
        WHEN 'L' FETCH LAST     q450_cs INTO g_ima.*
        WHEN '/'
            IF (NOT mi_no_ask) THEN
                CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
                LET INT_FLAG = 0  ######add for prompt bug
                PROMPT g_msg CLIPPED,': ' FOR g_jump
                    ON IDLE g_idle_seconds
                       CALL cl_on_idle()
#                       CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
                END PROMPT
                IF INT_FLAG THEN
                    LET INT_FLAG = 0
                    EXIT CASE
                END IF
            END IF
            LET mi_no_ask = FALSE
            FETCH ABSOLUTE g_jump q450_cs INTO g_ima.*
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_ima.ima01,SQLCA.sqlcode,0)
        INITIALIZE g_ima.* TO NULL  #TQC-6B0105
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
 
 
    CALL q450_show()
END FUNCTION
 
FUNCTION q450_show()
   DISPLAY BY NAME g_ima.*   # 顯示單頭值
   CALL s_getstock(g_ima.ima01,g_plant) RETURNING g_avl_stk_mpsmrp,g_unavl_stk,g_avl_stk #FUN-A20044
   DISPLAY g_avl_stk TO avl_stk
   CALL q450_b_fill()
   CALL q450_b2_fill()
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q450_b_fill()              #BODY FILL UP
  # DEFINE l_sql     LIKE type_file.chr1000       #No.FUN-680137 VARCHAR(1000)   #No.TQC-B60221 MARK
    DEFINE l_sql     STRING                       #No.TQC-B60221
    DEFINE l_oeb04   LIKE oeb_file.oeb04
 
   #start FUN-610058
   #LET l_sql =
   #     "SELECT img04,img02,SUM(img10*img21),''",
   #     " FROM  img_file",
   #     " WHERE img01 = '",g_ima.ima01,"' AND ", tm.wc2 CLIPPED,' AND img10>0',
   #     " GROUP BY img04,img02",  #No.MOD-480357
   #     " ORDER BY 1,2"
    LET l_sql =
         #"SELECT img04,img02,img03,SUM(img10*img21),''", #MOD-DA0194 mark
         "SELECT img04,img02,img03,img09,SUM(img10),''", #MOD-DA0194 add
         " FROM  img_file",
         " WHERE img01 = '",g_ima.ima01,"' AND ", tm.wc2 CLIPPED,' AND img10>0',
         " GROUP BY img04,img02,img03,img09",  #No.MOD-480357 #MOD-DA0194 add img09
         " ORDER BY 1,2,3,4" #MOD-DA0194 add 4
   #end FUN-610058
 
    DISPLAY "l_sql= ",l_sql
    PREPARE q450_pb FROM l_sql
    DECLARE q450_bcs CURSOR FOR q450_pb
    DISPLAY "l_sql",l_sql
    FOR g_cnt = 1 TO g_img.getLength() INITIALIZE g_img[g_cnt].* TO NULL END FOR
    LET g_cnt = 1
    LET tot1  = 0 LET tot2  = 0  LET tot3=0
    DROP TABLE x
   #SELECT oeb01,oea032,oeb092,oeb15,(oeb12-oeb24+oeb25) oeb12,oeb05_fac #BugNo:5950    #CHI-C30042 mark 
    SELECT oeb01,oea032,oeb092,oeb15,(oeb12-oeb24+oeb25) oeb12,oeb05,(oeb12-oeb24+oeb25) oeb12_1,oeb05_fac #BugNo:5950   #CHI-C30042 add
           FROM oeb_file, oea_file
          WHERE oeb04=g_ima.ima01 AND oeb70='N' AND oeb12>(oeb24-oeb25)
            AND oeb01=oea01 AND oeaconf = 'Y'
           INTO TEMP x
    UPDATE x SET oeb092=' ' WHERE oeb092 IS NULL
    UPDATE x SET oeb05_fac =1 WHERE oeb05_fac IS NULL OR oeb05_fac = ' '
    FOREACH q450_bcs INTO g_img[g_cnt].*
        IF STATUS THEN CALL cl_err('Foreach1:',STATUS,1) EXIT FOREACH END IF
        IF cl_null(g_img[g_cnt].img04) THEN LET g_img[g_cnt].img04 = ' ' END IF
        IF cl_null(g_img[g_cnt].img02) THEN LET g_img[g_cnt].img02 = ' ' END IF
        IF cl_null(g_img[g_cnt].img03) THEN LET g_img[g_cnt].img03 = ' ' END IF   #FUN-610058
        IF cl_null(g_img[g_cnt].img09) THEN LET g_img[g_cnt].img09 = ' ' END IF #MOD-DA0194 add
         #No.MOD-480357
        #IF cl_null(g_argv1) THEN #MOD-4B0102
         IF cl_null(g_argv1) AND cl_null(g_argv2) THEN #BUG-4B0102 #MOD-4B0136
            IF NOT cl_null(g_min_qty) THEN
               IF g_min_qty > g_img[g_cnt].img10 THEN
                  CONTINUE FOREACH
               END IF
            END IF
            IF NOT cl_null(g_max_qty) THEN
               IF g_max_qty < g_img[g_cnt].img10  THEN
                  CONTINUE FOREACH
               END IF
            END IF
         END IF #MOD-4B0102
         #No.MOD-480357(end)
        LET tot1  = tot1 + g_img[g_cnt].img10
        LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
    END FOREACH
    CALL g_img.deleteElement(g_cnt)
    LET g_rec_b= g_cnt - 1
    DISPLAY "g_rec_b=",g_rec_b
    DISPLAY BY NAME tot1
END FUNCTION
 
FUNCTION q450_b2_fill()              #BODY FILL UP
DEFINE l_oeb05_fac  LIKE oeb_file.oeb05_fac
    DECLARE c CURSOR FOR
           #SELECT oeb01,oea032,oeb092,oeb15,oeb12,oeb05_fac                 #CHI-C30042 mark 
            SELECT oeb01,oea032,oeb092,oeb15,oeb12,oeb05,oeb12_1,oeb05_fac   #CHI-C30042 add
              FROM x ORDER BY oeb15
    FOR g_cnt = 1 TO g_oeb.getLength() INITIALIZE g_oeb[g_cnt].* TO NULL END FOR
    LET g_cnt = 1
    FOREACH c INTO g_oeb[g_cnt].*,l_oeb05_fac
        IF STATUS THEN CALL cl_err('Foreach2:',STATUS,1) EXIT FOREACH END IF
        IF cl_null(l_oeb05_fac) THEN LET l_oeb05_fac = 1 END IF     #CHI-C30042 add
        LET g_oeb[g_cnt].oeb12_1 = g_oeb[g_cnt].oeb12_1 * l_oeb05_fac     #CHI-C30042 add
        LET tot3  = tot3 + g_oeb[g_cnt].oeb12 * l_oeb05_fac
        LET g_cnt = g_cnt + 1
    END FOREACH
    let tot2=tot3
    let tot4=tot1-tot2
    LET g_rec_b2= g_cnt - 1
    DISPLAY "g_rec_b2=",g_rec_b2
    DISPLAY BY NAME tot2,tot4
END FUNCTION
 
 
FUNCTION q450_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680137 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
    DISPLAY ARRAY g_img TO s_img.* ATTRIBUTE(COUNT=g_rec_b)  #No.MOD-480357
      BEFORE DISPLAY
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
 
   END DISPLAY
 
    DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b2)  #No.MOD-480357
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#NO.FUN-6B0031--BEGIN                                                                                                               
        ON ACTION CONTROLS                                                                                                          
           CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first
         CALL q450_fetch('F')
         ACCEPT DISPLAY   #FUN-530067(smin)
          EXIT DISPLAY #No.MOD-480357
 
      ON ACTION previous
         CALL q450_fetch('P')
         ACCEPT DISPLAY   #FUN-530067(smin)
          EXIT DISPLAY   #No.MOD-480357
 
      ON ACTION jump
         CALL q450_fetch('/')
         ACCEPT DISPLAY   #FUN-530067(smin)
          EXIT DISPLAY   #No.MOD-480357
 
      ON ACTION next
         CALL q450_fetch('N')
         ACCEPT DISPLAY   #FUN-530067(smin)
          EXIT DISPLAY   #No.MOD-480357
 
      ON ACTION last
         CALL q450_fetch('L')
         ACCEPT DISPLAY   #FUN-530067(smin)
          EXIT DISPLAY   #No.MOD-480357
 
      ON ACTION query_detail
         LET g_action_choice="query_detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
    {  #No.MOD-480357
      ON ACTION setting
         LET g_action_choice="setting"
         EXIT DISPLAY
   }
      ON ACTION accept
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION exporttoexcel       #FUN-4B0038
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q450_b()
 
  DEFINE l_allow_insert,l_allow_delete  LIKE type_file.num5          #No.FUN-680137 SMALLINT
  DEFINE l_oeb05_fac                    LIKE oeb_file.oeb05_fac      #CHI-C30042 add
 
  INPUT ARRAY g_img WITHOUT DEFAULTS FROM s_img.*
        ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                  INSERT ROW=FALSE,DELETE ROW=FALSE,APPEND ROW=FALSE)
 
     ON ACTION qry_ord_detail
        LET i = ARR_CURR()
        IF cl_null(g_img[i].img04) THEN LET g_img[i].img04 = ' ' END IF
        IF cl_null(g_img[i].img02) THEN LET g_img[i].img02 = ' ' END IF
        IF cl_null(g_img[i].img03) THEN LET g_img[i].img03 = ' ' END IF   #FUN-610058
        IF cl_null(g_img[i].img09) THEN LET g_img[i].img09 = ' ' END IF  #MOD-DA0194 add
        DECLARE c2 CURSOR FOR
           SELECT oeb01,oea032,oeb092,oeb15,oeb12,oeb05,oeb12_1,   #CHI-C30042 add oeb05,oeb12_1
                  oeb05_fac #BugNo:5950
             FROM x
            WHERE oeb092=g_img[i].img04
            ORDER BY oeb15
        CALL g_oeb.clear()
        LET g_cnt = 1
        LET tot3=0
        FOREACH c2 INTO g_oeb[g_cnt].*,l_oeb05_fac    #CHI-C30042  add l_oeb05_fac
           IF STATUS THEN CALL cl_err('For2:',STATUS,1) EXIT FOREACH END IF
           IF cl_null(l_oeb05_fac) THEN LET l_oeb05_fac = 1 END IF     #CHI-C30042 add
           LET g_oeb[g_cnt].oeb12_1 = g_oeb[g_cnt].oeb12_1 * l_oeb05_fac     #CHI-C30042 add
           LET tot3  = tot3 + g_oeb[g_cnt].oeb12 * l_oeb05_fac   #CHI-C30042 add l_oeb05_fac
           LET g_cnt = g_cnt + 1
        END FOREACH
        let tot2=tot3
        let tot4=tot1-tot2
        LET g_rec_b2= g_cnt - 1
        DISPLAY BY NAME tot2,tot4
        DISPLAY ARRAY g_oeb TO s_oeb.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
          BEFORE DISPLAY
             EXIT DISPLAY
        END DISPLAY
 
#--NO.MOD-860078 start---
      ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE INPUT
#--NO.MOD-860078 end-----
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
#NO.FUN-6B0031--BEGIN                                                                                                               
      ON ACTION CONTROLS                                                                                                          
         CALL cl_set_head_visible("","AUTO")                                                                                      
#NO.FUN-6B0031--END 
  END INPUT
END FUNCTION
