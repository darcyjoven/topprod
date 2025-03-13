# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Pattern name...: apmi300.4gl
# Descriptions...: 已入庫采購金額變更作業
# Date & Author..: 05/06/14 By jackie
# Modify.........: No.FUN-610018 06/01/11 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/05 By Jackho 欄位類型修改
# Modify.........: No.FUN-6A0162 06/11/07 By jamie 1.FUNCTION _q() 一開始應清空key值
# Modify.........: No.FUN-6B0032 06/11/16 By Czl 增加雙檔單頭折疊功能
# Modify.........: No.CHI-710005 07/01/18 By Elva 去掉aza26的判斷
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: NO.TQC-750115 07/05/24 BY yiting AFTER FIELD rvv38有-239錯誤
# Modify.........: No.FUN-790031 07/09/13 By Nicole 正Primary Key後,程式判斷錯誤訊息-239時必須改變做法
# Modify.........: No.FUN-840027 08/04/10 By Dido rvx_file 新增紀錄時間欄位
# Modify.........: No.MOD-8A0087 08/10/09 By wujie  入庫單有對應的apb資料后，單價不可更改
# Modify.........: No.MOD-8B0273 08/12/02 By chenyu 單價含稅時，未稅單價=未稅金額/計價數量
# Modify.........: No.MOD-970003 09/07/01 By sherry 多角貿易入庫單不可以變更單價
# Modify.........: No.FUN-980006 09/08/13 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.TQC-980183 09/08/26 By xiaofeizhu 還原MOD-8B0273修改的內容
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-A80052 10/08/09 By Dido 若為運輸發票(gec05='T')時,稅額與未稅金額邏輯調整 
# Modify.........: No:CHI-A80025 10/08/24 By Summer 1.計算金額時未使用計價數量來乘算
#                                                   2.畫面加上計價單位與計價數量,做法與規則同入庫單單身
#                                                   3.確定修改完後,要update 修改人員與修改日期
# Modify.........: No:MOD-AB0015 10/11/04 By Smapmin 回寫入庫單價時,日期大於成會關帳日才回寫
# Modify.........: No:MOD-AB0019 10/11/04 By Smapmin 入庫單AP已立帳,計價數量不可修改
# Modify.........: No:MOD-AB0072 10/11/09 By Smapmin 計價數量為0時,金額未重算
# Modify.........: No:MOD-B10105 11/01/14 By Summer 在IF g_gec07='Y'then少做了rvv39t的取位else少做了rvv39的取位
# Modify.........: No:MOD-B10138 11/01/20 By Summer 調整取位方式 
# Modify.........: No:FUN-B30211 11/03/30 By lixiang  加cl_used(g_prog,g_time,2)
# Modify.........: No:MOD-B40012 11/04/03 By lilingyu JIT收貨時,稅率和稅別沒有抓出來值
# Modify.........: No:MOD-B30669 11/04/06 By Summer 已入庫單身為MISC的料件無法被查出
# Modify.........: No:TQC-B40112 11/04/14 By lilingyu sql變量長度定義過短
# Modify.........: No:MOD-B40213 11/04/26 By Summer 增加倉退單 
# Modify.........: No:MOD-B80063 11/08/05 By johung 單價使用原幣取位
# Modify.........: No:FUN-BB0086 11/11/24 By tanxc 增加數量欄位小數取位
# Modify.........: No:MOD-C10082 12/02/16 By Elise 增加FUNCTION t300_b()的BEFORE ROW抓pmm21/pmm43的地方
# Modify.........: No:TQC-C20183 12/02/20 By tanxc 增加數量欄位小數取位
# Modify.........: No.TQC-C30225 12/04/06 By SunLM 若為運輸發票(gec05='T')時,未稅單價邏輯調整
# Modify.........: No.MOD-C40212 12/04/27 By SunLM 修正JIT收貨抓不到稅別,稅率資料
# Modify.........: No.CHI-C30115 12/05/29 By yuhuabao -239的錯誤判斷,應全部改成IF cl_sql_dup_value(SQLCA.sqlcode)
# Modify.........: No.MOD-C90212 12/10/09 By SunLM 若此入庫單有對應apb資料,但存在某個項次不存在apb資料,則此項次仍然可以變更單價等信息
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
   g_rvv01         LIKE rvv_file.rvv01,   #類別代號 (假單頭)
   g_rvv06         LIKE rvv_file.rvv06,   #送貨廠商
   g_rvv09         LIKE rvv_file.rvv09,   #送貨日期
   g_rvv01_t       LIKE rvv_file.rvv01,   #類別代號 (舊值)
   g_rvv  DYNAMIC  ARRAY OF RECORD        #程式變數(Program Variables)
            rvv02  LIKE rvv_file.rvv02,   #項次
            rvv36  LIKE rvv_file.rvv36,   #采購單號
            rvv37  LIKE rvv_file.rvv37,   #采購序號
            rvv31  LIKE rvv_file.rvv31,   #料件編號
            ima02  LIKE ima_file.ima02,   #品名
            ima021 LIKE ima_file.ima021,  #規格
            rvv17  LIKE rvv_file.rvv17,   #數量
            rvv86  LIKE rvv_file.rvv86,   #計價單位 #CHI-A80025 add
            rvv87  LIKE rvv_file.rvv87,   #計價數量 #CHI-A80025 add
            rvv38  LIKE rvv_file.rvv38,   #單價
            rvv38t LIKE rvv_file.rvv38t,  #單價(含稅)
            rvv39  LIKE rvv_file.rvv39,   #金額
            rvv39t LIKE rvv_file.rvv39t,  #金額(含稅)
            pmm21  LIKE pmm_file.pmm21,   #稅別
            pmm43  LIKE pmm_file.pmm43    #稅率
            #gec07  LIKE gec_file.gec07   #含稅否  FUN-610018
               END RECORD,
   g_rvv_t         RECORD                 #程式變數 (舊值)
            rvv02  LIKE rvv_file.rvv02,
            rvv36  LIKE rvv_file.rvv36,
            rvv37  LIKE rvv_file.rvv37,
            rvv31  LIKE rvv_file.rvv31,
            ima02  LIKE ima_file.ima02,
            ima021 LIKE ima_file.ima021,
            rvv17  LIKE rvv_file.rvv17,
            rvv86  LIKE rvv_file.rvv86, #CHI-A80025 add
            rvv87  LIKE rvv_file.rvv87, #CHI-A80025 add
            rvv38  LIKE rvv_file.rvv38,
            rvv38t LIKE rvv_file.rvv38t,
            rvv39  LIKE rvv_file.rvv39,
            rvv39t LIKE rvv_file.rvv39t,
            pmm21  LIKE pmm_file.pmm21,
            pmm43  LIKE pmm_file.pmm43
            #gec07  LIKE gec_file.gec07   #含稅否  FUN-610018
               END RECORD,
   g_argv1         LIKE rvv_file.rvv01,
   g_gec07         LIKE gec_file.gec07,
   g_wc,g_sql      STRING,      #No.FUN-680136 VARCHAR(300)       #TQC-B40112 chr1000->STRING
   g_rec_b         LIKE type_file.num5,         #單身筆數                #No.FUN-680136 SMALLINT
   l_ac            LIKE type_file.num5          #目前處理的ARRAY CNT     #No.FUN-680136 SMALLINT
#CHI-A80025 add --start--
DEFINE g_ima25     LIKE ima_file.ima25,         #庫存單位
       g_ima44     LIKE ima_file.ima44,
       g_ima906    LIKE ima_file.ima906,
       g_ima907    LIKE ima_file.ima907,
       g_ima908    LIKE ima_file.ima908,
       g_img09     LIKE img_file.img09,         ##庫存單位
       g_unit      LIKE imgg_file.imgg09,
       g_change    LIKE type_file.chr1,
       g_factor    LIKE ima_file.ima31_fac,
       g_before_input_done LIKE type_file.num5
#CHI-A80025 add --end--
DEFINE   g_forupd_sql   STRING                  #SELECT ... FOR UPDATE  SQL
DEFINE   g_cnt          LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_msg          LIKE ze_file.ze03       #No.FUN-680136 VARCHAR(72)
DEFINE   g_row_count    LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_curs_index   LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_jump         LIKE type_file.num10    #No.FUN-680136 INTEGER
DEFINE   g_no_ask      LIKE type_file.num5     #No.FUN-680136 SMALLINT
DEFINE li_cnt        LIKE type_file.num5        #No.FUnFUN00FUN
DEFINE   g_rvv86_t      LIKE rvv_file.rvv86     #No.FUN-BB0086 add
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   LET g_argv1   = ARG_VAL(1)             #入庫單號

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time

   LET g_rvv01   = NULL                   #清除鍵值
   LET g_rvv01_t = NULL
   
   OPEN WINDOW t300_w WITH FORM "apm/42f/apmi300"
      ATTRIBUTE (STYLE = g_win_style CLIPPED)
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv1) THEN
      CALL t300_q()
   END IF
   CALL i300_def_form() #CHI-A80025 add
   CALL t300_menu()
   CLOSE WINDOW t300_w                    #結束畫面
 
 # CALL cl_used('apmi300',g_time,2) RETURNING g_time
   CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-B30211

END MAIN
 
FUNCTION t300_curs()
   CLEAR FORM                             #清除畫面
   CALL g_rvv.clear()
   IF cl_null(g_argv1) THEN
      CALL cl_set_head_visible("","YES")           #No.FUN-6B0032
   INITIALIZE g_rvv01 TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON rvv01,rvv06,rvv09
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN
         ON ACTION controlp
            CASE
               WHEN INFIELD(rvv01)        #入庫單號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state ="c"
                  LET g_qryparam.form ="q_rvv5"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                       
                  DISPLAY g_qryparam.multiret TO rvv01
                  NEXT FIELD rvv01
               WHEN INFIELD(rvv06)        #廠商編號
                  CALL cl_init_qry_var()
                  LET g_qryparam.state ="c"
                  LET g_qryparam.form ="q_pmc1"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret                                                       
                  DISPLAY g_qryparam.multiret TO rvv06
                  NEXT FIELD rvv06
               OTHERWISE EXIT CASE
            END CASE
 
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
                 ON ACTION qbe_save
		   CALL cl_qbe_save()
		#No.FUN-580031 --end--       HCN
      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
      IF INT_FLAG THEN RETURN END IF
   ELSE
      LET g_wc = " rvv01 = '",g_argv1,"'"
   END IF
  #LET g_wc = g_wc CLIPPED," AND rvv03='1' AND rvv23=0 "          #MOD-B40213 mark
   LET g_wc = g_wc CLIPPED," AND rvv03 IN ('1','3') AND rvv23=0 " #MOD-B40213
   LET g_sql = " SELECT DISTINCT rvv01 ",
               "   FROM rvv_file ",
               "  WHERE ", g_wc CLIPPED,
               "  ORDER BY rvv01"
   PREPARE t300_prepare FROM g_sql        #預備一下
   DECLARE t300_b_curs                    #宣告成可卷動的
      SCROLL CURSOR WITH HOLD FOR t300_prepare
 
   LET g_sql = " SELECT COUNT(DISTINCT rvv01) ",
               "   FROM rvv_file  ",
               "  WHERE  ",g_wc CLIPPED
   PREPARE t300_precount FROM g_sql
   DECLARE t300_count CURSOR FOR t300_precount
 
END FUNCTION
 
FUNCTION t300_menu()
   WHILE TRUE
      CALL t300_bp("G")
 
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL t300_q()
            END IF
 
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL t300_b()
            ELSE
               LET g_action_choice = NULL
            END IF
 
         WHEN "help" 
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"    
            CALL cl_cmdask()
 
         WHEN "price_change"              #價格變更查詢
            CALL t300_1()
 
         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvv),'','')
            END IF
 
         WHEN "next"
            CALL t300_fetch('N')                                                                                                    
 
         WHEN "previous"
            CALL t300_fetch('P')  
 
         WHEN "jump"                                                                                                             
            CALL t300_fetch('/')                                                                                                    
 
         WHEN "first"                                                                                                           
            CALL t300_fetch('F')                                                                                                    
 
         WHEN "last"                                                                                                            
            CALL t300_fetch('L')   
 
         #No.FUN-6A0162-------add--------str----
         WHEN "related_document"  #相關文件
              IF cl_chk_act_auth() THEN
                 IF g_rvv01 IS NOT NULL THEN
                 LET g_doc.column1 = "rvv01"
                 LET g_doc.value1 = g_rvv01
                 CALL cl_doc()
               END IF
         END IF
         #No.FUN-6A0162-------add--------end----
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION t300_q()
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting( g_curs_index, g_row_count )
   INITIALIZE g_rvv01 TO NULL             #No.FUN-6A0162
 
   MESSAGE ""
   CALL cl_opmsg('q')
   CALL t300_curs()                       #取得查詢條件
 
   IF INT_FLAG THEN                       #使用者不玩了
      LET INT_FLAG = 0
      INITIALIZE g_rvv01 TO NULL
      RETURN
   END IF
   OPEN t300_b_curs                       #從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN                  #有問題
      CALL cl_err('',SQLCA.sqlcode,0)
      INITIALIZE g_rvv01 TO NULL
   ELSE
      OPEN t300_count
      FETCH t300_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
      CALL t300_fetch('F')               #讀出TEMP第一筆并顯示
   END IF
 
END FUNCTION
 
#處理資料的讀取
FUNCTION t300_fetch(p_flag)
DEFINE   p_flag LIKE type_file.chr1      #處理方式  #No.FUN-680136 VARCHAR(1) 
 
   MESSAGE ""
   CASE p_flag
      WHEN 'N' FETCH NEXT     t300_b_curs INTO g_rvv01
      WHEN 'P' FETCH PREVIOUS t300_b_curs INTO g_rvv01
      WHEN 'F' FETCH FIRST    t300_b_curs INTO g_rvv01
      WHEN 'L' FETCH LAST     t300_b_curs INTO g_rvv01
      WHEN '/' 
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0              #add for prompt mod
            PROMPT g_msg CLIPPED,': ' FOR g_jump
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
               ON ACTION about         
                  CALL cl_about()      
 
               ON ACTION help          
                  CALL cl_show_help()  
 
               ON ACTION controlg      
                  CALL cl_cmdask()     
                
            END PROMPT
            IF INT_FLAG THEN
               LET INT_FLAG = 0
               EXIT CASE
            END IF
         END IF
         FETCH ABSOLUTE g_jump t300_b_curs INTO g_rvv01
         LET g_no_ask = FALSE
   END CASE
 
   IF SQLCA.sqlcode THEN                  #有麻煩
      CALL cl_err(g_rvv01,SQLCA.sqlcode,0)
      INITIALIZE g_rvv01 TO NULL
   ELSE
      CALL t300_show()
      CASE p_flag
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
      CALL cl_navigator_setting( g_curs_index, g_row_count )
   END IF
  
END FUNCTION
 
#將資料顯示在畫面上
FUNCTION t300_show()
DEFINE l_sql        STRING       #No.FUN-680136 VARCHAR(300)         #TQC-B40112 chr1000->STRING
     
   LET l_sql = " SELECT DISTINCT rvv06,rvv09 ",
               "   FROM rvv_file  ",
               "  WHERE rvv01 = '",g_rvv01,"'"
   DECLARE t300_rvv06 CURSOR FROM l_sql
   OPEN t300_rvv06
   FETCH t300_rvv06 INTO g_rvv06,g_rvv09
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rvv01,SQLCA.sqlcode,0)
      LET g_rvv06 = ' '
      LET g_rvv09 = ' ' 
      RETURN
   END IF
 
   DISPLAY g_rvv01 TO rvv01               #單頭
   DISPLAY g_rvv06 TO rvv06               #單頭
   DISPLAY g_rvv09 TO rvv09               #單頭
   CALL t300_b_fill(g_wc)                 #單身
#No.FUN-610018
#  IF g_gec07 = 'Y' THEN
#     CALL cl_set_comp_visible("rvv38t,rvv39t,pmm21,pmm43,gec07",TRUE)                
#  ELSE                                                                        
#     CALL cl_set_comp_visible("rvv38t,rvv39t,pmm21,pmm43,gec07",FALSE)                
#  END IF                                                                      
 
END FUNCTION
 
FUNCTION t300_b()
DEFINE   l_ac_t         LIKE type_file.num5,      #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
         l_n            LIKE type_file.num5,      #檢查重復用         #No.FUN-680136 SMALLINT
         l_lock_sw      LIKE type_file.chr1,      #單身鎖住否         #No.FUN-680136 VARCHAR(1)
         p_cmd          LIKE type_file.chr1,      #處理狀態           #No.FUN-680136 VARCHAR(1)
         l_time         LIKE type_file.chr8,      #No.FUN-840027
         l_cmd          LIKE type_file.chr1000    #可新增否           #No.FUN-680136 VARCHAR(80)
DEFINE   l_rvv38        LIKE type_file.num10       #NO.TQC-750115
DEFINE   l_rvv38t       LIKE type_file.num10       #NO.TQC-750115
DEFINE   l_rvu08        LIKE rvu_file.rvu08       #MOD-970003 add
DEFINE   l_gec05        LIKE gec_file.gec05       #MOD-A80052
DEFINE   l_rvw06f       LIKE rvw_file.rvw06f      #MOD-A80052
DEFINE   l_rvv35        LIKE rvv_file.rvv35       #CHI-A80025 add
DEFINE   l_n1           LIKE type_file.num5       #No.FUN-BB0086
 
   LET g_action_choice = ""
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF g_rvv01 IS NULL THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   #MOD-970003---Begin
   SELECT rvu08 INTO l_rvu08 FROM rvu_file
    WHERE rvu01 = g_rvv01
   IF l_rvu08 = 'TAP' OR l_rvu08 = 'TRI' THEN 
      CALL cl_err(g_rvv01,'apm-089',1) 
      RETURN
   END IF   
   #MOD-970003---End

   #-----MOD-AB0019---------
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM apb_file WHERE apb21 =g_rvv01   
                                            AND apb22 = g_rvv[l_ac].rvv02 #MOD-C90212 add apb22  
   IF l_n >0 THEN                                                
      CALL cl_err(g_rvv01,'apm-922',0)                           
      RETURN
   END IF                                                        
   #-----END MOD-AB0019-----
   
   CALL cl_opmsg('b')
    
   LET g_forupd_sql = " SELECT rvv02,rvv36,rvv37,rvv31,' ',' ',",
                      "        rvv17,rvv86,rvv87,rvv38,rvv38t,rvv39,rvv39t,'',0,'' ", #CHI-A80025 add rvv86,rvv87
                      "   FROM rvv_file",
                       " WHERE rvv01=? AND rvv02=? FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE t300_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   INPUT ARRAY g_rvv WITHOUT DEFAULTS FROM s_rvv.*
      ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                INSERT ROW=FALSE,DELETE ROW=FALSE ,
                APPEND ROW=TRUE)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
         #CHI-A80025 add --start--
         LET g_before_input_done = FALSE
         CALL i300_set_entry(p_cmd)
         CALL i300_set_no_entry(p_cmd)
         CALL i300_set_no_required(p_cmd)
         CALL i300_set_required(p_cmd)
         LET g_before_input_done = TRUE
         #CHI-A80025 add --end--
 
      BEFORE ROW
         LET p_cmd = ''
         LET l_ac = ARR_CURR()
         LET l_lock_sw = 'N'              #DEFAULT
         LET l_n  = ARR_COUNT()
 
         IF g_rec_b >= l_ac THEN
            BEGIN WORK
            LET p_cmd='u'
            LET g_rvv_t.* = g_rvv[l_ac].* #BACKUP
            LET g_rvv86_t = g_rvv[l_ac].rvv86   #No.FUN-BB0086 add
            OPEN t300_bcl USING g_rvv01,g_rvv_t.rvv02
            IF STATUS THEN
               CALL cl_err("OPEN t300_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH t300_bcl INTO g_rvv[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err(g_rvv_t.rvv02,SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               ELSE
                  SELECT ima02,ima021
                    INTO g_rvv[l_ac].ima02,g_rvv[l_ac].ima021
                    FROM ima_file 
                   WHERE ima01 = g_rvv[l_ac].rvv31
                  #MOD-B30669 add --start--
                  IF STATUS THEN
                     IF g_rvv[l_ac].rvv31[1,4] = 'MISC' THEN
                        SELECT ima02,ima021 INTO g_rvv[l_ac].ima02,g_rvv[l_ac].ima021
                          FROM ima_file
                         WHERE ima01 = 'MISC'
                     END IF 
                  END IF
                  #MOD-B30669 add --end--
#MOD-C40212 add begin(JIT無採購單收貨,取不到採購單號的值)
                  IF cl_null(g_rvv[l_ac].rvv36) THEN #先從pmh_file抓取稅別,稅率
                     SELECT pmh17,pmh18,azi04,azi03
                       INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43,t_azi04,t_azi03
                       FROM pmh_file,azi_file,rvu_file
                      WHERE pmh01 = g_rvv[l_ac].rvv31
                        AND pmh02 = g_rvv06
                        AND pmh05 = '0'
                        AND pmhacti = 'Y' 
                        AND rvu01 = g_rvv01
                        AND rvu113 = azi01 
                        IF cl_null(g_rvv[l_ac].pmm21) THEN #如果還是沒有取到稅別,從供應商慣用稅別抓取 
                           SELECT pmc47,gec04,azi04,azi03 
                             INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43,t_azi04,t_azi03
                             FROM pmc_file,azi_file,gec_file
                            WHERE pmc01 = g_rvv06
                              AND pmc22 = azi01 
                              AND pmc47 = gec01
                        END IF    
                  ELSE    
#MOD-C40212 add end
                    #SELECT pmm21,pmm43 INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43                    #MOD-A80052 mark 
                    #  FROM pmm_file                                                                #MOD-A80052 mark
   #                 SELECT pmm21,pmm43,azi04 INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43,t_azi04      #MOD-A80052        #MOD-B800
                     SELECT pmm21,pmm43,azi04,azi03                                                 #MOD-B80063
                       INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43,t_azi04,t_azi03                     #MOD-B80063
                       FROM pmm_file,azi_file                                                       #MOD-A80052
                      WHERE pmm01 = g_rvv[l_ac].rvv36
                        AND pmm22 = azi01                                                           #MOD-A80052
                     #No.FUN-610018
                  END IF    #MOD-C40212 add
                 #MOD-C10082---add---str---
                  IF cl_null(g_rvv[l_ac].pmm43) THEN
                     SELECT gec01,gec04 
                     INTO g_rvv[l_ac].pmm21,g_rvv[l_ac].pmm43
                     FROM gec_file,pmc_file
                     WHERE gec01 = pmc47
                     AND pmc01 = g_rvv06
                     AND gec011='1'  #進項
                  END IF
                 #MOD-C10082---add---end---
                  CALL cl_set_comp_entry("rvv38,rvv38t",TRUE)
                 #SELECT gec07 INTO g_gec07                      #MOD-A80052 mark
                  SELECT gec05,gec07 INTO l_gec05,g_gec07        #MOD-A80052
                    FROM gec_file
                   WHERE gec01  = g_rvv[l_ac].pmm21
                     AND gec011 = '1'
                  IF cl_null(g_gec07) THEN LET g_gec07 = 'N' END IF
#No.MOD-8A0087 --begin                                                          
                  CALL cl_set_comp_entry("rvv38t",TRUE)                         
                  CALL cl_set_comp_entry("rvv38",TRUE)                          
#No.MOD-8A0087 --end 
                  IF g_gec07 = 'N' THEN
                     CALL cl_set_comp_entry("rvv38t",FALSE)
                  ELSE
                     CALL cl_set_comp_entry("rvv38",FALSE)
                  END IF
#No.MOD-8A0087 --begin                                                          
                  SELECT COUNT(*) INTO l_n FROM apb_file WHERE apb21 =g_rvv01   
                                                           AND apb22 = g_rvv[l_ac].rvv02 #MOD-C90212 add apb22  
                  IF l_n >0 THEN                                                
                     CALL cl_err(g_rvv01,'apm-922',0)                           
                     CALL cl_set_comp_entry("rvv38t",FALSE)                     
                     CALL cl_set_comp_entry("rvv38",FALSE)                      
                  END IF                                                        
#No.MOD-8A0087 --end 
                  LET g_rvv_t.*=g_rvv[l_ac].*
                  #CHI-A80025 add --start--
                  CALL i300_set_entry(p_cmd)
                  CALL i300_set_no_entry(p_cmd)
                  CALL i300_set_no_required(p_cmd)
                  CALL i300_set_required(p_cmd)
                  #CHI-A80025 add --end--
                  #-----BEG MOD-C90212---------
                  LET l_n = 0 
                  SELECT COUNT(*) INTO l_n FROM apb_file WHERE apb21 =g_rvv01
                                                           AND apb22 = g_rvv[l_ac].rvv02
                  IF l_n >0 THEN                                                
                     CALL cl_set_comp_entry("rvv87",FALSE) 
                  ELSE 
                     CALL cl_set_comp_entry("rvv87",TRUE)                         
                  END IF                                                        
                  #-----END MOD-C90212---------                   
               END IF
            END IF
         ELSE
            CALL g_rvv.deleteElement(l_ac)
            RETURN 
         END IF

      #CHI-A80025 add --start--
      BEFORE FIELD rvv86
          SELECT ima25,ima44,ima906,ima907,ima908
            INTO g_ima25,g_ima44,g_ima906,g_ima907,g_ima908
            FROM ima_file
           WHERE ima01=g_rvv[l_ac].rvv31

          IF NOT cl_null(g_img09) THEN LET g_unit=g_img09 ELSE LET g_unit=g_ima25 END IF
          CALL i300_set_no_required(p_cmd)
      
        AFTER FIELD rvv86
          IF g_rvv_t.rvv86 IS NULL AND g_rvv[l_ac].rvv86 IS NOT NULL OR
             g_rvv_t.rvv86 IS NOT NULL AND g_rvv[l_ac].rvv86 IS NULL OR
             g_rvv_t.rvv86 <> g_rvv[l_ac].rvv86 THEN
             LET g_change='Y'
          END IF
          IF NOT cl_null(g_rvv[l_ac].rvv86) THEN
             IF g_rvv_t.rvv86 IS NULL OR g_rvv[l_ac].rvv86 != g_rvv_t.rvv86 THEN
                CALL i300_unit(g_rvv[l_ac].rvv86)
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err(g_rvv[l_ac].rvv86,g_errno,0)
                   LET g_rvv[l_ac].rvv86 = g_rvv_t.rvv86
                   NEXT FIELD rvv86
                END IF
             END IF
             CALL s_du_umfchk(g_rvv[l_ac].rvv31,'','','',
                              g_ima25,g_rvv[l_ac].rvv86,'2')
                  RETURNING g_errno,g_factor
             IF NOT cl_null(g_errno) THEN
                CALL cl_err(g_rvv[l_ac].rvv86,g_errno,0)
                NEXT FIELD rvv86
             END IF
           END IF
           CALL i300_set_required(p_cmd)
           #FUN-BB0086--add--start--
       	   LET l_n1 = 0
           SELECT COUNT(*) INTO l_n1 FROM apb_file WHERE apb21 =g_rvv01
	   IF l_n1 <= 0 THEN     #TQC-C20183 modify
              IF NOT i300_rvv87_check() THEN
                 LET g_rvv86_t = g_rvv[l_ac].rvv86
                 NEXT FIELD rvv87
              END IF
           ELSE
              LET g_rvv[l_ac].rvv87 = s_digqty(g_rvv[l_ac].rvv87,g_rvv[l_ac].rvv86)
  	      DISPLAY BY NAME g_rvv[l_ac].rvv87
           END IF
           LET g_rvv86_t = g_rvv[l_ac].rvv86
           #FUN-BB0086--add--end--

        BEFORE FIELD rvv87
           IF g_change = 'Y' THEN
              CALL i300_set_rvv87()
           END IF

        AFTER FIELD rvv87
           IF NOT i300_rvv87_check()  THEN NEXT FIELD rvv87 END IF #FUN-BB0086--add--
           #FUN-BB0086--mark--start--
           #IF g_rvv[l_ac].rvv87 < 0 THEN
           #   CALL cl_err('','afa-043',0)
           #   NEXT FIELD rvv87
           #END IF
           ##-----MOD-AB0072---------
           #IF NOT cl_null(g_rvv[l_ac].rvv87) THEN
           #   IF g_rvv[l_ac].rvv87 < 0 THEN
           #      NEXT FIELD rvv87
           #   END IF
           #   #當金額為0時計算含稅金額
           #   IF g_rvv[l_ac].rvv87 > 0 THEN
           #      CALL i300_set_rvv39()
           #   END IF
           #END IF
           #CALL i300_set_rvv39()
           ##-----END MOD-AB0072-----
           #FUN-BB0086--mark--end--

      #CHI-A80025 add --end--
 
      AFTER FIELD rvv38
         IF NOT cl_null(g_rvv[l_ac].rvv38) THEN 
            IF g_rvv_t.rvv38 != g_rvv[l_ac].rvv38 THEN
               #SELECT COUNT(*) INTO l_n FROM rvx_file
               SELECT COUNT(*) INTO l_rvv38 FROM rvx_file   #NO.TQC-750115
                WHERE rvx01 = g_rvv01
                  AND rvx02 = g_rvv_t.rvv02
                  AND rvx03 = g_today 
                  #AND rvx04 = g_rvv_t.rvv38
                  AND rvx04 = g_rvv[l_ac].rvv38   #NO.TQC-750115
#NO.TQC-750115 mark--
               #IF l_n > 0 THEN
               #IF l_rvv38 > 0 THEN  
                  #CALL cl_err('',-239,0)
                  #LET g_rvv[l_ac].rvv38 = g_rvv_t.rvv38
                  #NEXT FIELD rvv38
               #END IF
#NO.TQC-750115 mark--
              #LET g_rvv[l_ac].rvv39  = g_rvv[l_ac].rvv38 * g_rvv[l_ac].rvv17 #CHI-A80025 mark 
               LET g_rvv[l_ac].rvv38t = g_rvv[l_ac].rvv38 *(1 + g_rvv[l_ac].pmm43/100)
              #LET g_rvv[l_ac].rvv39t = g_rvv[l_ac].rvv38t * g_rvv[l_ac].rvv17 #CHI-A80025 mark
#              LET g_rvv[l_ac].rvv38 = cl_digcut(g_rvv[l_ac].rvv38,g_azi03)       #MOD-B80063 mark
#              LET g_rvv[l_ac].rvv38t = cl_digcut(g_rvv[l_ac].rvv38t,g_azi03)     #MOD-B80063 mark
               LET g_rvv[l_ac].rvv38 = cl_digcut(g_rvv[l_ac].rvv38,t_azi03)       #MOD-B80063
               LET g_rvv[l_ac].rvv38t = cl_digcut(g_rvv[l_ac].rvv38t,t_azi03)     #MOD-B80063
              #LET g_rvv[l_ac].rvv39 = cl_digcut(g_rvv[l_ac].rvv39,t_azi04)       #MOD-A80052 g_azi04 -> t_azi04 #CHI-A80025 mark
              #LET g_rvv[l_ac].rvv39t = cl_digcut(g_rvv[l_ac].rvv39t,t_azi04)     #MOD-A80052 g_azi04 -> t_azi04 #CHI-A80025 mark
               CALL i300_set_rvv39() #CHI-A80025 add
            END IF
         END IF
 
      AFTER FIELD rvv38t
         IF NOT cl_null(g_rvv[l_ac].rvv38t) THEN 
            IF g_rvv_t.rvv38t != g_rvv[l_ac].rvv38t THEN
               #SELECT COUNT(*) INTO l_n FROM rvx_file
               SELECT COUNT(*) INTO l_rvv38t FROM rvx_file   #NO.TQC-750115
                WHERE rvx01 = g_rvv01
                  AND rvx02 = g_rvv_t.rvv02
                  AND rvx03 = g_today 
                  #AND rvx04 = g_rvv_t.rvv38
                  AND rvx04 = g_rvv[l_ac].rvv38t   #NO.TQC-750115
#NO.TQC-750115 mark--
               #IF l_n > 0 THEN
#               IF l_rvv38t > 0 THEN
#                 CALL cl_err('',-239,0)
#                  LET g_rvv[l_ac].rvv38t = g_rvv_t.rvv38t
#                  NEXT FIELD rvv38
#               END IF
#NO.TQC-750115 mark--
              #LET g_rvv[l_ac].rvv39t = g_rvv[l_ac].rvv38t * g_rvv[l_ac].rvv87 #CHI-A80025 mod rvv17->rvv87 #MOD-B10138 mark
              #No.MOD-8B0273 modify --begin 
              #LET g_rvv[l_ac].rvv38 = g_rvv[l_ac].rvv38t / (1 + g_rvv[l_ac].pmm43/100)
              #LET g_rvv[l_ac].rvv39 = g_rvv[l_ac].rvv38 * g_rvv[l_ac].rvv17 
#              LET g_rvv[l_ac].rvv39t = cl_digcut(g_rvv[l_ac].rvv39t,g_azi04)            #TQC-980183 Mark
#              LET g_rvv[l_ac].rvv39  = g_rvv[l_ac].rvv39t / (1 + g_rvv[l_ac].pmm43/100) #TQC-980183 Mark
#              LET g_rvv[l_ac].rvv39  = cl_digcut(g_rvv[l_ac].rvv39,g_azi04)             #TQC-980183 Mark
#              LET g_rvv[l_ac].rvv38  = g_rvv[l_ac].rvv39 / g_rvv[l_ac].rvv17            #TQC-980183 Mark           
              #No.MOD-8B0273 modify --end
              #No.TQC-980183--Add--Begin--#
               LET g_rvv[l_ac].rvv38 = g_rvv[l_ac].rvv38t / (1 + g_rvv[l_ac].pmm43/100)                                             
              #LET g_rvv[l_ac].rvv39 = g_rvv[l_ac].rvv38 * g_rvv[l_ac].rvv17               #MOD-A80052 mark
              #-MOD-A80052-add-
               IF l_gec05 = 'T' THEN
                  LET g_rvv[l_ac].rvv38 = g_rvv[l_ac].rvv38t * (1 - g_rvv[l_ac].pmm43/100) #TQC-C30225 add
                  LET g_rvv[l_ac].rvv38 = cl_digcut(g_rvv[l_ac].rvv38 , t_azi03) #TQC-C30225 add
                  LET g_rvv[l_ac].rvv39t = g_rvv[l_ac].rvv38t * g_rvv[l_ac].rvv87 #MOD-B10138 add
                  LET l_rvw06f = g_rvv[l_ac].rvv39t * (g_rvv[l_ac].pmm43/100)
                  LET l_rvw06f = cl_digcut(l_rvw06f , t_azi04)
                  LET g_rvv[l_ac].rvv39 = g_rvv[l_ac].rvv39t - l_rvw06f 
                  LET g_rvv[l_ac].rvv39 = cl_digcut(g_rvv[l_ac].rvv39 , t_azi04)  
              #MOD-B10138 mark --start--
              #ELSE
              #   LET g_rvv[l_ac].rvv39 = g_rvv[l_ac].rvv38 * g_rvv[l_ac].rvv87 #CHI-A80025 mod rvv17->rvv87
              #MOD-B10138 mark --end--
               END IF
              #-MOD-A80052-end-
              #No.TQC-980183--Add--End--#
#              LET g_rvv[l_ac].rvv38t = cl_digcut(g_rvv[l_ac].rvv38t,g_azi03)        #MOD-B80063 mark
#              LET g_rvv[l_ac].rvv38 = cl_digcut(g_rvv[l_ac].rvv38,g_azi03)          #MOD-B80063 mark
               LET g_rvv[l_ac].rvv38t = cl_digcut(g_rvv[l_ac].rvv38t,t_azi03)        #MOD-B80063
               LET g_rvv[l_ac].rvv38 = cl_digcut(g_rvv[l_ac].rvv38,t_azi03)          #MOD-B80063
               IF l_gec05 = 'T' THEN #MOD-B10138 add
                  LET g_rvv[l_ac].rvv39t = cl_digcut(g_rvv[l_ac].rvv39t,t_azi04)     #MOD-A80052 g_azi04 -> t_azi04
                  LET g_rvv[l_ac].rvv39 = cl_digcut(g_rvv[l_ac].rvv39,t_azi04)       #MOD-A80052 g_azi04 -> t_azi04
               #MOD-B10138 add --start--
               ELSE
                  CALL i300_set_rvv39()
               END IF
               #MOD-B10138 add --end--
            END IF
         END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_rvv[l_ac].* = g_rvv_t.*
            CLOSE t300_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_rvv[l_ac].rvv02,-263,1)
            LET g_rvv[l_ac].* = g_rvv_t.*
         ELSE 
            #CHI-A80025 add --start--
            IF g_sma.sma116 MATCHES '[02]' THEN #不使用計價單位時,計價單位/數量給原單據單位/數量
               SELECT rvv35 INTO l_rvv35 FROM rvv_file
                WHERE rvv01 = g_rvv01
                  AND rvv02 = g_rvv_t.rvv02
               LET g_rvv[l_ac].rvv86 = l_rvv35
               LET g_rvv[l_ac].rvv87 = g_rvv[l_ac].rvv17
            END IF
            #CHI-A80025 add --end--

            LET g_success = 'Y' #CHI-A80025 add
            IF g_rvv09 > g_sma.sma53 THEN    #MOD-AB0015
               UPDATE rvv_file
                  SET rvv38 = g_rvv[l_ac].rvv38,
                      rvv39 = g_rvv[l_ac].rvv39,
                      rvv38t= g_rvv[l_ac].rvv38t,
                      rvv39t= g_rvv[l_ac].rvv39t, #CHI-A80025 add ,
                      rvv86 = g_rvv[l_ac].rvv86,  #CHI-A80025 add
                      rvv87 = g_rvv[l_ac].rvv87   #CHI-A80025 add
                WHERE rvv01 = g_rvv01
                  AND rvv02 = g_rvv_t.rvv02
                 #AND rvv03 = '1' #MOD-B40213 mark
                  AND rvv23 = 0
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
#                   CALL cl_err(g_rvv[l_ac].rvv02,SQLCA.sqlcode,0)   #No.FUN-660129
                    CALL cl_err3("upd","rvv_file",g_rvv01,g_rvv_t.rvv02,SQLCA.sqlcode,"","",1)  #No.FUN-660129
                    LET g_rvv[l_ac].* = g_rvv_t.*
                   #ROLLBACK WORK      #CHI-A80025 mark
                    LET g_success ='N' #CHI-A80025 add
                 ELSE
                    MESSAGE 'UPDATE O.K'
                 END IF
            #-----MOD-AB0015---------
            ELSE
               CALL cl_err(g_rvv01,'apm1051',0)
               LET g_rvv[l_ac].* = g_rvv_t.*
            END IF   
            #-----END MOD-AB0015-----
            
              LET l_time = TIME  #FUN-840027
    
                INSERT INTO rvx_file(rvx01,rvx02,rvx03,rvx031,rvx04,rvx04t,   #FUN-840027
                                     rvx05,rvx05t,rvx06,rvx06t,rvxuser,rvxplant,rvxlegal,rvxoriu,rvxorig)  #FUN-980006 add rvxplant,rvxlegal       
                VALUES(g_rvv01,g_rvv[l_ac].rvv02,g_today,l_time,                #FUN-840027                  
                       g_rvv_t.rvv38,g_rvv_t.rvv38t,g_rvv[l_ac].rvv38,g_rvv[l_ac].rvv38t,
                       g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t,g_user,g_plant,g_legal, g_user, g_grup) #FUN-980006 add g_plant,g_legal      #No.FUN-980030 10/01/04  insert columns oriu, orig
                #IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN  #no.TQC-750115 mark
                ##FUN-790031 START
              ##IF (SQLCA.sqlcode AND SQLCA.sqlcode != -239) THEN   #NO.TQC-750115
                IF SQLCA.SQLCODE AND (NOT cl_sql_dup_value(SQLCA.SQLCODE)) THEN   #NO.TQC-750115
                ##FUN-790031 END
              ##   CALL cl_err(g_rvv[l_ac].rvv02,SQLCA.sqlcode,0)                    #No.FUN-660129
                   CALL cl_err3("ins","rvx_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
                  #ROLLBACK WORK      #CHI-A80025 mark                                              
                   LET g_success ='N' #CHI-A80025 add
    
                ELSE
                   #NO.TQC-750115 start--------
#                  IF SQLCA.sqlcode = -239 THEN #CHI-C30115 mark
                   IF cl_sql_dup_value(SQLCA.SQLCODE) THEN  #CHI-C30115 add
                       UPDATE rvx_file 
                          SET rvx04t = g_rvv_t.rvv38t,
                              rvx05t = g_rvv[l_ac].rvv38t,
                              rvx05  = g_rvv[l_ac].rvv38,  
                              rvx06  = g_rvv[l_ac].rvv39,
                              rvx06t = g_rvv[l_ac].rvv39t,
                              rvxuser = g_user  
                        WHERE rvx01 = g_rvv01
                          AND rvx02 = g_rvv[l_ac].rvv02
                         AND rvx03 = g_today        
                         AND rvx031 = l_time         #FUN-840027        
                        AND rvx04 = g_rvv_t.rvv38
                      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                         CALL cl_err3("upd","rvv_file",g_rvv01,g_rvv_t.rvv02,SQLCA.sqlcode,"","",1)  
                        #ROLLBACK WORK      #CHI-A80025 mark
                         LET g_success ='N' #CHI-A80025 add
                      END IF
                 END IF 

                 #CHI-A80025 add --start--
                 UPDATE rvu_file SET rvumodu=g_user,rvudate=g_today
                  WHERE rvu01 = g_rvv01
                 IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                    CALL cl_err3("upd","rvv_file",g_rvv01,g_rvv_t.rvv02,SQLCA.sqlcode,"","",1)  
                    LET g_success ='N'
                 END IF
                 #CHI-A80025 add --end--
 
                 #NO.TQC-750115 end------------
                 #COMMIT WORK   #CHI-A80025 mark
                 #CHI-A80025 add --start--
                 IF g_success ='Y' THEN
                    COMMIT WORK
                 ELSE
                    ROLLBACK WORK
                 END IF
                 #CHI-A80025 add --end--         
              END IF                                
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
         LET l_ac_t = l_ac
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN 
               LET g_rvv[l_ac].* = g_rvv_t.*
            END IF 
            CLOSE t300_bcl
            ROLLBACK WORK
            EXIT INPUT
         END IF
         CALL cl_set_comp_entry("rvv38",TRUE)
         CLOSE t300_bcl
         COMMIT WORK

      #CHI-A80025 add --start--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(rvv86) #計價單位
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_gfe"
               LET g_qryparam.default1 = g_rvv[l_ac].rvv86
               CALL cl_create_qry() RETURNING g_rvv[l_ac].rvv86
               DISPLAY BY NAME g_rvv[l_ac].rvv86
               NEXT FIELD rvv86
            OTHERWISE EXIT CASE
         END CASE
      #CHI-A80025 add --end--
 
      ON ACTION CONTROLR
         CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)
         
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
    
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END INPUT
 
   CLOSE t300_bcl
   COMMIT WORK
END FUNCTION
 
FUNCTION t300_b_fill(p_wc)                #BODY FILL UP
DEFINE   p_wc    LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(200)
DEFINE  l_rvu02  LIKE rvu_file.rvu02          #MOD-B40012
 
  #MOD-B30669 mod --start--
  #LET g_sql = " SELECT rvv02,rvv36,rvv37,rvv31,ima02, ",
  #            "        ima021,rvv17,rvv86,rvv87,rvv38,rvv38t,rvv39,rvv39t,pmm21,pmm43,'' ", #CHI-A80025 add rvv86,rvv87
  #            "   FROM rvv_file,ima_file,OUTER pmm_file",
   LET g_sql = " SELECT rvv02,rvv36,rvv37,rvv31,'', ", 
               "        '',rvv17,rvv86,rvv87,rvv38,rvv38t,rvv39,rvv39t,pmm21,pmm43,'' ", 
               "   FROM rvv_file,OUTER pmm_file",
               "  WHERE rvv01 = '",g_rvv01,"'",
  #            "    AND rvv31 = ima01", 
  #MOD-B30669 mod -end--
               "    AND rvv_file.rvv36 = pmm_file.pmm01",
               "    AND  ",p_wc CLIPPED,
               "  ORDER BY rvv02"
   PREPARE t300_prepare2 FROM g_sql       #預備一下
   DECLARE rvv_curs CURSOR FOR t300_prepare2
 
   CALL g_rvv.clear()
   LET g_cnt = 1
   LET g_gec07 = 'N'
 
   FOREACH rvv_curs INTO g_rvv[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('FOREACH:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #MOD-B30669 add --start--
      SELECT ima02,ima021 INTO g_rvv[g_cnt].ima02,g_rvv[g_cnt].ima021
        FROM ima_file
       WHERE ima01 = g_rvv[g_cnt].rvv31
      IF STATUS THEN
         IF g_rvv[g_cnt].rvv31[1,4] = 'MISC' THEN
            SELECT ima02,ima021 INTO g_rvv[g_cnt].ima02,g_rvv[g_cnt].ima021
              FROM ima_file
             WHERE ima01 = 'MISC'
         END IF 
      END IF
      #MOD-B30669 add --end--
      #MOD-B40213 add --start--
      IF cl_null(g_rvv[g_cnt].pmm43) THEN
         SELECT gec01,gec04 
           INTO g_rvv[g_cnt].pmm21,g_rvv[g_cnt].pmm43 
           FROM gec_file,pmc_file 
          WHERE gec01 = pmc47
            AND pmc01 = g_rvv06
            AND gec011='1'  #進項
      END IF
      #MOD-B40213 add --end--
#MOD-B40012 --begin--
      IF cl_null(g_rvv[g_cnt].rvv36) THEN 
         SELECT rvu02 INTO l_rvu02 FROM rvu_file
          WHERE rvu01 = g_rvv01
         SELECT rva115,rva116 INTO g_rvv[g_cnt].pmm21,g_rvv[g_cnt].pmm43
           FROM rva_file
          WHERE rva01 = l_rvu02  
      END IF 
#MOD-B40012 --end--        
      
      #No.FUN-610018
      #SELECT gec07 INTO g_rvv[g_cnt].gec07 FROM gec_file 
      # WHERE gec01 = g_rvv[g_cnt].pmm21
      #  AND gec011 = '1'
      #IF g_rvv[g_cnt].gec07 = 'Y' THEN LET g_gec07 = 'Y' END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
   END FOREACH
   CALL g_rvv.deleteElement(g_cnt)
   LET g_rec_b = g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
END FUNCTION
 
FUNCTION t300_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1          #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_rvv TO s_rvv.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL t300_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)  
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1) 
         END IF
 
      ON ACTION previous
         CALL t300_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
 
      ON ACTION jump
         CALL t300_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
           CALL fgl_set_arr_curr(1)  
         END IF
 
      ON ACTION next
         CALL t300_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
 
      ON ACTION last
         CALL t300_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count) 
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  
         END IF
                              
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION price_change              #入庫單單價變更查詢 
         LET g_action_choice="price_change"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL i300_def_form() #CHI-A80025 add
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
 
      ON ACTION cancel
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about        
         CALL cl_about()     
   
      ON ACTION exporttoexcel       
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
 
      ON ACTION related_document                #No.FUN-6A0162  相關文件
         LET g_action_choice="related_document"          
         EXIT DISPLAY 
 
      ON ACTION controls                           #No.FUN-6B0032             
         CALL cl_set_head_visible("","AUTO")       #No.FUN-6B0032
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION t300_1()                         #價格變更查詢
   DEFINE   l_cmd   LIKE type_file.chr1000       #No.FUN-680136 VARCHAR(80)
   IF cl_null(g_rvv01) THEN RETURN END IF
   LET l_cmd = "apmq300 ",g_rvv01         # 入庫單號
   CALL cl_cmdrun(l_cmd)
END FUNCTION

#CHI-A80025 add --start--
FUNCTION i300_unit(p_unit)  #單位
   DEFINE p_unit    LIKE gfe_file.gfe01,
          l_gfeacti LIKE gfe_file.gfeacti

   LET g_errno = ' '
   SELECT gfeacti INTO l_gfeacti
          FROM gfe_file WHERE gfe01 = p_unit
   CASE WHEN SQLCA.SQLCODE = 100  LET g_errno = 'mfg2605'
                                  LET l_gfeacti = NULL
        WHEN l_gfeacti='N'        LET g_errno = '9028'
        OTHERWISE                 LET g_errno = SQLCA.SQLCODE USING '-------'
   END CASE
END FUNCTION

FUNCTION i300_set_rvv39()
  LET g_rvv[l_ac].rvv39  = g_rvv[l_ac].rvv38 * g_rvv[l_ac].rvv87 
  LET g_rvv[l_ac].rvv39t = g_rvv[l_ac].rvv38t * g_rvv[l_ac].rvv87
  LET g_rvv[l_ac].rvv39 = cl_digcut(g_rvv[l_ac].rvv39 , t_azi04) #MOD-B10138 add
  LET g_rvv[l_ac].rvv39t = cl_digcut(g_rvv[l_ac].rvv39t , t_azi04) #MOD-B10138 add

  IF g_gec07='Y' THEN
     LET g_rvv[l_ac].rvv39 = g_rvv[l_ac].rvv39t / ( 1 + g_rvv[l_ac].pmm43/100)
     LET g_rvv[l_ac].rvv39 = cl_digcut(g_rvv[l_ac].rvv39 , t_azi04)
    #LET g_rvv[l_ac].rvv39t = cl_digcut(g_rvv[l_ac].rvv39t , t_azi04) #MOD-B10105 add #MOD-B10138 mark
  ELSE
     LET g_rvv[l_ac].rvv39t = g_rvv[l_ac].rvv39 * ( 1 + g_rvv[l_ac].pmm43/100)
     LET g_rvv[l_ac].rvv39t = cl_digcut(g_rvv[l_ac].rvv39t , t_azi04)
    #LET g_rvv[l_ac].rvv39 = cl_digcut(g_rvv[l_ac].rvv39 , t_azi04) #MOD-B10105 add #MOD-B10138
  END IF
  DISPLAY BY NAME g_rvv[l_ac].rvv39,g_rvv[l_ac].rvv39t
END FUNCTION

FUNCTION i300_set_rvv87()
  DEFINE    l_ima44  LIKE ima_file.ima44,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_img09  LIKE img_file.img09,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE ima_file.ima31_fac, 
            l_rvv32  LIKE rvv_file.rvv32,
            l_rvv33  LIKE rvv_file.rvv33,
            l_rvv34  LIKE rvv_file.rvv34,
            l_rvv35  LIKE rvv_file.rvv35,
            l_rvv81  LIKE rvv_file.rvv81,
            l_rvv82  LIKE rvv_file.rvv82,
            l_rvv84  LIKE rvv_file.rvv84,
            l_rvv85  LIKE rvv_file.rvv85

   SELECT ima25,ima44,ima906 INTO g_ima25,l_ima44,l_ima906
     FROM ima_file WHERE ima01=g_rvv[l_ac].rvv31
   IF SQLCA.sqlcode = 100 THEN
      IF g_rvv[l_ac].rvv31 MATCHES 'MISC*' THEN
         SELECT ima25,ima44,ima906 INTO g_ima25,l_ima44,l_ima906
           FROM ima_file WHERE ima01='MISC'
      END IF
   END IF
   IF cl_null(l_ima44) THEN LET l_ima44=g_ima25 END IF

   SELECT rvv32,rvv33,rvv34,rvv35,rvv81,rvv82,rvv84,rvv85 
     INTO l_rvv32,l_rvv33,l_rvv34,l_rvv35,l_rvv81,l_rvv82,l_rvv84,l_rvv85 FROM rvv_file
    WHERE rvv01 = g_rvv01
      AND rvv02 = g_rvv_t.rvv02
   LET l_fac2=l_rvv84
   LET l_qty2=l_rvv85
   IF g_sma.sma115 = 'Y' THEN
      LET l_fac1=l_rvv81
      LET l_qty1=l_rvv82
   ELSE
     LET l_fac1=1
     LET l_qty1=g_rvv[l_ac].rvv17
     CALL s_umfchk(g_rvv[l_ac].rvv31,l_rvv35,l_ima44)
           RETURNING g_cnt,l_fac1
     IF g_cnt = 1 THEN
        LET l_fac1 = 1
     END IF
   END IF
   IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
   IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
   IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
   IF cl_null(l_qty2) THEN LET l_qty2=0 END IF

   SELECT img09 INTO l_img09 FROM img_file
    WHERE img01=g_rvv[l_ac].rvv31
      AND img02=l_rvv32
      AND img03=l_rvv33
      AND img04=l_rvv34
   IF l_img09 IS NULL THEN LET l_img09=l_ima44 END IF

   IF g_sma.sma115 = 'Y' THEN
      CASE l_ima906
         WHEN '1' LET l_tot=l_qty1*l_fac1
         WHEN '2' LET l_tot=l_qty1*l_fac1+l_qty2*l_fac2
         WHEN '3' LET l_tot=l_qty1*l_fac1
      END CASE
   ELSE  #不使用雙單位
      LET l_tot=l_qty1*l_fac1
   END IF
   IF cl_null(l_tot) THEN LET l_tot = 0 END IF
   LET l_factor = 1
   IF g_sma.sma115 = 'Y' THEN
      CALL s_umfchk(g_rvv[l_ac].rvv31,l_rvv35,g_rvv[l_ac].rvv86)
            RETURNING g_cnt,l_factor
   ELSE
      CALL s_umfchk(g_rvv[l_ac].rvv31,l_ima44,g_rvv[l_ac].rvv86)
            RETURNING g_cnt,l_factor
   END IF 
   IF g_cnt = 1 THEN
      LET l_factor = 1
   END IF
   LET l_tot = l_tot * l_factor

   LET g_rvv[l_ac].rvv87 = l_tot
END FUNCTION

FUNCTION i300_set_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1
   CALL cl_set_comp_entry("rvv86,rvv87",TRUE)
END FUNCTION

FUNCTION i300_set_no_entry(p_cmd)
DEFINE   p_cmd     LIKE type_file.chr1,
         l_n       LIKE type_file.num5   #MOD-AB0019

   IF NOT g_before_input_done OR p_cmd = 'u' THEN
      CALL cl_set_comp_entry("rvv86",FALSE)
   END IF

   IF g_sma.sma116 MATCHES '[02]' THEN
      CALL cl_set_comp_entry("rvv86,rvv87",FALSE)
   END IF

   #-----MOD-AB0019---------
   LET l_n = 0 
   SELECT COUNT(*) INTO l_n FROM apb_file WHERE apb21 =g_rvv01   
   IF l_n >0 THEN                                                
      CALL cl_set_comp_entry("rvv87",FALSE)                      
   END IF                                                        
   #-----END MOD-AB0019-----
END FUNCTION

FUNCTION i300_set_required(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   IF p_cmd IS NOT NULL THEN
      IF g_sma.sma116 MATCHES '[13]' THEN    #使用計價單位時
         CALL cl_set_comp_required("rvv87",TRUE)
      END IF
   END IF
END FUNCTION

FUNCTION i300_set_no_required(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
   CALL cl_set_comp_required("rvv86,rvv87",FALSE)
END FUNCTION

FUNCTION i300_def_form()
  IF g_sma.sma116 MATCHES '[02]' THEN    #不使用計價單位
     CALL cl_set_comp_visible("rvv86,rvv87",FALSE)
  END IF
END FUNCTION
#CHI-A80025 add --end--

#No.FUN-BB0086---start---add---
FUNCTION i300_rvv87_check()
   IF NOT cl_null(g_rvv[l_ac].rvv86) AND NOT cl_null(g_rvv[l_ac].rvv87) THEN
      IF cl_null(g_rvv_t.rvv87) OR cl_null(g_rvv86_t) OR g_rvv_t.rvv87 != g_rvv[l_ac].rvv87 OR g_rvv86_t != g_rvv[l_ac].rvv86 THEN
         LET g_rvv[l_ac].rvv87=s_digqty(g_rvv[l_ac].rvv87, g_rvv[l_ac].rvv86)
         DISPLAY BY NAME g_rvv[l_ac].rvv87
      END IF
   END IF
   IF g_rvv[l_ac].rvv87 < 0 THEN
      CALL cl_err('','afa-043',0)
      RETURN FALSE 
   END IF
   CALL i300_set_rvv39()
   RETURN TRUE 
END FUNCTION 
#No.FUN-BB0086---end---add---
