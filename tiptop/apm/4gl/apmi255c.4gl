# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: apmi255c.4gl
# Descriptions...: 維護分量計價資料
# Date & Author..: 05/03/30 By Mandy
# Modify.........: No.FUN-550019 05/05/13 By Danny 採購含稅單價
# Modify         : No.MOD-4A0299 05/04/20 by Echo 未確認，送簽時不可以修改資料,
#                                                 並且修改資料後狀態更新為"0:開立"。
# Modify.........: No.FUN-560102 05/06/18 By Danny 採購含稅單價取消判斷大陸版
# Modify         : No.MOD-560117 05/06/20 by Echo 單頭輸入勾選分量計價, 至單身輸完分量計價即down出
# Modify         : No.MOD-560241 05/08/24 by Echo FUN-580092 HCN 更改錯誤，tmp01欄位應宣告為char(1)，不是STRING
# Modify.........: No.TQC-5B0099 05/11/11 By Tracy 修改分量計價取位錯誤
# Modify.........: No.MOD-5A0222 05/12/15 By Nicola 數量、金額不可為負，且截止數量需大於起始數量
# Modify.........: No.FUN-610018 06/01/05 By ice 採購含稅單價功能調整
# Modify.........: No.FUN-660099 06/08/07 By Nicola 價格管理修改-新增欄位作業編號，用傳參數的方式決定採購委外
# Modify.........: No.FUN-660129 06/06/19 By Wujie cl_err --> cl_err3
# Modify.........: No.FUN-680136 06/09/13 By Jackho 欄位類型修改
# Modify.........: No.FUN-560205 06/09/15 By rainy 分量計價區料要控管
# Modify.........: No.CHI-6A0004 06/10/24 By bnlent g_azixx(本幣取位)與t_azixx(原幣取位)變數定義問題修改
# Modify.........: No.TQC-6B0105 07/03/07 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.TQC-740078 07/04/13 By chenl   
# Modify.........: No.TQC-740175 07/04/22 By Nicola 從其他程式串過來時，品名、規格、幣別沒有顯示
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: NO.MOD-7A0188 07/10/30 BY yiting sql語法錯誤
# Modify.........: No.CHI-860042 08/07/22 By xiaofeizhu 加入一般采購和委外采購的判斷
# Modify.........: No.CHI-8C0014 09/01/04 By xiaofeizhu 一般及委外問題處理
# Modify.........: No.MOD-910036 09/01/12 By Smapmin 修正幣別位數取位問題
# Modify.........: No.MOD-910185 09/01/16 By Smapmin 單身筆數未即時顯示
# Modify.........: No.FUN-920106 09/02/20 By sabrina 將apmi265加入判斷
# Modify.........: No.FUN-980006 09/08/13 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.MOD-9A0099 09/10/15 By Smapmin 啟始數量的預設值為+0.001
# Modify.........: No.TQC-BC0090 11/12/14 By SunLM 隱藏單頭pmj10欄位
# Modify.........: No:FUN-D30034 13/04/16 By xujing 修改單身新增時按下放棄鍵未執行AFTER INSERT的問題
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE g_argv01         LIKE pmj_file.pmj01,
       g_argv02         LIKE pmj_file.pmj02,
       g_argv03         LIKE pmj_file.pmj03,
       g_argv04         LIKE pmj_file.pmj031,
       g_argv05         LIKE pmj_file.pmj032,
       g_argv06         LIKE pmj_file.pmj05,
       g_argv07         LIKE zz_file.zz01,    #No.FUN-680136 VARCHAR(10)
       g_argv08         STRING,
       g_argv09         LIKE pmj_file.pmj10,  #No.FUN-670099
       g_pmj01          LIKE pmj_file.pmj01,
       g_pmj02          LIKE pmj_file.pmj02,
       g_pmj03          LIKE pmj_file.pmj03,
       g_pmj031         LIKE pmj_file.pmj031,
       g_pmj032         LIKE pmj_file.pmj032,
       g_pmj05          LIKE pmj_file.pmj05,
       g_pmj10          LIKE pmj_file.pmj10,  #No.FUN-670099
       g_pmj01_t        LIKE pmj_file.pmj01,
       g_pmj02_t        LIKE pmj_file.pmj02,
       g_pmj12          LIKE pmj_file.pmj12,
       g_pmr            DYNAMIC ARRAY OF RECORD    #程式變數(Program Variables)
                           pmr03    LIKE pmr_file.pmr03,   #起始數量
                           pmr04    LIKE pmr_file.pmr04,   #截止數量
                           pmr05    LIKE pmr_file.pmr05,   #單價
                           pmr05t   LIKE pmr_file.pmr05t   #含稅單價   No.FUN-550019
                        END RECORD,
       g_pmr_t          RECORD                 #程式變數 (舊值)
                           pmr03    LIKE pmr_file.pmr03,   #起始數量
                           pmr04    LIKE pmr_file.pmr04,   #截止數量
                           pmr05    LIKE pmr_file.pmr05,   #單價
                           pmr05t   LIKE pmr_file.pmr05t   #含稅單價   No.FUN-550019
                        END RECORD,
       g_pmi081         LIKE pmi_file.pmi081,  #No.Fun-550019
       g_gec07          LIKE gec_file.gec07,   #No.Fun-550019
       g_wc,g_wc2,g_sql STRING,  #No.FUN-580092 HCN
       g_flag           LIKE type_file.chr1,   #No.FUN-680136 VARCHAR(1)
       g_rec_b          LIKE type_file.num5,   #單身筆數  #No.FUN-680136 SMALLINT
       l_ac             LIKE type_file.num5    #目前處理的ARRAY CNT  #No.FUN-680136 SMALLINT
DEFINE g_forupd_sql     STRING   #SELECT ... FOR UPDATE SQL
DEFINE g_cnt            LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_i              LIKE type_file.num5    #count/index for any purpose  #No.FUN-680136 SMALLINT
DEFINE g_msg            LIKE ze_file.ze03      #No.FUN-680136 VARCHAR(72)
DEFINE g_row_count      LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_curs_index     LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_jump           LIKE type_file.num10   #No.FUN-680136 INTEGER
DEFINE g_no_ask        LIKE type_file.num5    #No.FUN-680136 SMALLINT
 
MAIN
   OPTIONS                                #改變一些系統預設值
      INPUT NO WRAP
   DEFER INTERRUPT
 
   LET g_argv01 = ARG_VAL(1)           #核價單號
   LET g_argv02 = ARG_VAL(2)           #項次
   LET g_argv03 = ARG_VAL(3)           
   LET g_argv04 = ARG_VAL(4)           
   LET g_argv05 = ARG_VAL(5)           
   LET g_argv06 = ARG_VAL(6)           
   LET g_argv07 = ARG_VAL(7)           #程式代號  #MOD-4A0299
   LET g_argv08 = ARG_VAL(8)           #tmp_file名稱  #MOD-560117
   LET g_argv09 = ARG_VAL(9)  #No.FUN-670099

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
   
   WHENEVER ERROR CONTINUE
   
   IF (NOT cl_setup("APM")) THEN
      EXIT PROGRAM
   END IF
 
   CALL cl_used(g_prog,g_time,1) RETURNING g_time
 
   LET g_pmj01 = g_argv01
   LET g_pmj02 = g_argv02
   LET g_pmj03 = g_argv03
   LET g_pmj031= g_argv04
   LET g_pmj032= g_argv05
   LET g_pmj05 = g_argv06
   LET g_pmj10 = g_argv09  #No.FUN-670099
 
   LET g_forupd_sql = "SELECT * FROM pmj_file WHERE pmj01=? AND pmj02=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i255c_cl CURSOR FROM g_forupd_sql 
 
   OPEN WINDOW i255c_w WITH FORM "apm/42f/apmi255c"
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
   CALL cl_ui_init()
 
   IF NOT cl_null(g_argv01) THEN
      LET g_flag = 'Y' 
 
      DISPLAY g_pmj01,g_pmj02,g_pmj03,g_pmj031,g_pmj032,g_pmj05,g_pmj10  #No.FUN-670099   #No.TQC-740175
           TO pmj01,pmj02,pmj03,pmj031,pmj032,pmj05,pmj10  #No.FUN-670099
 
      CALL i255c_q()
 
      LET g_pmj01 = g_argv01       #No.TQC-740078 
      LET g_pmj02 = g_argv02       #No.TQC-740078 
 
      DISPLAY g_pmj01,g_pmj02,g_pmj03,g_pmj031,g_pmj032,g_pmj05,g_pmj10  #No.FUN-670099   #No.TQC-740175
           TO pmj01,pmj02,pmj03,pmj031,pmj032,pmj05,pmj10  #No.FUN-670099
 
      #No.FUN-550019
      #SELECT pmj05 INTO g_pmj05 FROM pmj_file WHERE pmj01 = g_pmj01 #No.TQC-5B0099   #MOD-910036
      SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = g_pmj05    #No.CHI-6A0004
      LET g_gec07 = ''
 
      SELECT gec07,pmi081 INTO g_gec07,g_pmi081
        FROM gec_file,pmi_file
       WHERE gec01 = pmi08
         AND gec011 = '1'
         AND pmi01 = g_pmj01
      IF STATUS OR cl_null(g_gec07) THEN
         LET g_gec07 = 'N'
      END IF
#TQC-BC0090 begin 
      IF g_argv07 CLIPPED = 'apmi255' THEN 
         CALL cl_set_comp_visible("pmj10",FALSE)
      END IF 
      IF g_argv07 CLIPPED = 'apmi265' THEN 
      	 CALL cl_set_comp_visible("pmj10",TRUE) 
      END IF  
#TQC-BC0090 end 
#No.FUN-610018
#     IF g_gec07 = 'Y' THEN         #No.FUN-560102
#        CALL cl_set_comp_visible("pmr05t",TRUE)
#     ELSE
#        CALL cl_set_comp_visible("pmr05t",FALSE)
#     END IF
#     #end No.FUN-550019
 
      IF NOT cl_null(g_argv02) THEN
         CALL i255c_b()
      END IF
 
      CALL i255c_show()
   ELSE 
      LET g_flag = 'N' 
   END IF
 
   CALL i255c_menu()
 
   CLOSE WINDOW i255c_w                 #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time
END MAIN
 
FUNCTION i255c_cs()
   DEFINE  l_i,l_j      LIKE type_file.num5,     #No.FUN-680136 SMALLINT
           l_buf        LIKE type_file.chr1000  #No.FUN-680136 VARCHAR(500)
 
   CLEAR FORM                             #清除畫面
   CALL g_pmr.clear()
 
   IF g_flag = 'N' THEN 
   INITIALIZE g_pmj01 TO NULL    #No.FUN-750051
   INITIALIZE g_pmj02 TO NULL    #No.FUN-750051
      CONSTRUCT BY NAME g_wc ON pmj01,pmj02
      
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
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
   ELSE 
      LET g_wc = " pmj01 ='",g_pmj01,"'"
      IF NOT cl_null(g_pmj02) THEN
         LET g_wc = g_wc CLIPPED," AND pmj02 =",g_pmj02
      END IF
   END IF
 
   IF INT_FLAG THEN
      RETURN
   END IF
 
   LET g_sql = "SELECT UNIQUE pmj01,pmj02,pmj10,pmj12,pmj13 FROM pmj_file ",
               " WHERE ",g_wc CLIPPED,
#              "   AND pmj10 = ' ' ",                           #CHI-860042   #CHI-8C0014 Mark                                                       
#              "   AND pmj12 = '1' ",                           #CHI-860042   #CHI-8C0014 Mark
               " ORDER BY pmj01,pmj02 "
 
   PREPARE i255c_prepare FROM g_sql
   DECLARE i255c_cs                         #SCROLL CURSOR
       SCROLL CURSOR WITH HOLD FOR i255c_prepare
 
   LET g_sql = "SELECT UNIQUE pmj01,pmj02,pmj10,pmj12,pmj13 FROM pmj_file ",
               " WHERE ",g_wc CLIPPED,
#              "   AND pmj10 = ' ' ",                           #CHI-860042   #CHI-8C0014 Mark                                                        
#              "   AND pmj12 = '1' ",                           #CHI-860042   #CHI-8C0014 Mark
               " GROUP BY pmj01,pmj02 ",
               "  INTO TEMP x "
   DROP TABLE x
   PREPARE i255c_precount_x FROM g_sql
   EXECUTE i255c_precount_x
 
   LET g_sql = "SELECT COUNT(*) FROM x "
 
   PREPARE i255c_precount FROM g_sql
   DECLARE i255c_count CURSOR FOR i255c_precount
 
END FUNCTION
 
FUNCTION i255c_menu()
 
   WHILE TRUE
      CALL i255c_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL i255c_q()
            END IF
         WHEN "detail" 
            IF cl_chk_act_auth() THEN
               CALL i255c_b()
            ELSE
               LET g_action_choice = NULL
            END IF
         WHEN "help" 
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"    
            CALL cl_cmdask()
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION i255c_q()
 
   LET g_row_count = 0
   LET g_curs_index = 0
   CALL cl_navigator_setting(g_curs_index,g_row_count)
   CALL cl_opmsg('q')
   MESSAGE ""
   CLEAR FORM
   CALL g_pmr.clear()
   DISPLAY '   ' TO FORMONLY.cnt  
 
   CALL i255c_cs()
 
   IF INT_FLAG THEN
      LET INT_FLAG = 0
      LET g_pmj01 = NULL
      LET g_pmj02 = NULL
      RETURN
   END IF
 
   OPEN i255c_cs                            # 從DB產生合乎條件TEMP(0-30秒)
   IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)
      LET g_pmj01 = NULL
      LET g_pmj02 = NULL
   ELSE
      OPEN i255c_count
      FETCH i255c_count INTO g_row_count
      DISPLAY g_row_count TO FORMONLY.cnt  
 
      CALL i255c_fetch('F')                  # 讀出TEMP第一筆並顯示
   END IF
 
END FUNCTION
 
FUNCTION i255c_fetch(p_flag)
   DEFINE p_flag   LIKE type_file.chr1                  #處理方式  #No.FUN-680136 VARCHAR(1)
 
   CASE p_flag
      WHEN 'N' FETCH NEXT     i255c_cs INTO g_pmj01,g_pmj02,g_pmj10,g_pmj12
      WHEN 'P' FETCH PREVIOUS i255c_cs INTO g_pmj01,g_pmj02,g_pmj10,g_pmj12
      WHEN 'F' FETCH FIRST    i255c_cs INTO g_pmj01,g_pmj02,g_pmj10,g_pmj12
      WHEN 'L' FETCH LAST     i255c_cs INTO g_pmj01,g_pmj02,g_pmj10,g_pmj12
      WHEN '/'
         IF (NOT g_no_ask) THEN
            CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
            LET INT_FLAG = 0  ######add for prompt bug
            PROMPT g_msg CLIPPED,': ' FOR g_jump
 
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
 
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
         LET g_no_ask = FALSE
         FETCH ABSOLUTE g_jump i255c_cs INTO g_pmj01,g_pmj02,g_pmj10,g_pmj12
   END CASE
 
   IF SQLCA.sqlcode THEN
      LET g_msg=g_pmj01 CLIPPED
      CALL cl_err(g_msg,SQLCA.sqlcode,0)
      INITIALIZE g_pmj01 TO NULL  #TQC-6B0105
      INITIALIZE g_pmj02 TO NULL  #TQC-6B0105
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
 
   SELECT pmj01,pmj02 INTO g_pmj01,g_pmj02
     FROM pmj_file
    WHERE pmj01=g_pmj01 AND pmj02=g_pmj02 AND pmj10=g_pmj10 AND pmj12=g_pmj12
   IF SQLCA.sqlcode THEN
      LET g_msg = g_pmj01 CLIPPED
#     CALL cl_err(g_msg,SQLCA.sqlcode,0)   #No.FUN-660129
      CALL cl_err3("sel","pmj_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
      LET g_pmj01 = NULL
      LET g_pmj02 = NULL
      RETURN
   END IF
 
   CALL i255c_show()
 
END FUNCTION
 
FUNCTION i255c_show()
   DEFINE l_pmj   RECORD LIKE pmj_file.*
 
   IF g_flag = 'N' THEN   #MOD-910036
      LET g_pmj01_t = g_pmj01                    #保存單頭舊值
      LET g_pmj02_t = g_pmj02                    #保存單頭舊值
      
      SELECT * INTO l_pmj.*
        FROM pmj_file
       WHERE pmj01 = g_pmj01
         AND pmj02 = g_pmj02
#        AND pmj10 = " "                           #CHI-860042     #CHI-8C0014 Mark                                                                       
#        AND pmj12 = '1'                           #CHI-860042     #CHI-8C0014 Mark
      
      DISPLAY g_pmj01,g_pmj02,l_pmj.pmj03,l_pmj.pmj031,l_pmj.pmj032,l_pmj.pmj05,l_pmj.pmj10  #No.FUN-670099
           TO pmj01,pmj02,pmj03,pmj031,pmj032,pmj05,pmj10  #No.FUN-670099
      SELECT azi03 INTO t_azi03 FROM azi_file WHERE azi01 = l_pmj.pmj05  #MOD-910036
   END IF   #MOD-910036
 
   CALL i255c_b_fill()                 #單身
   
   CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
   
END FUNCTION
 
FUNCTION i255c_b()
   DEFINE l_ac_t          LIKE type_file.num5,                #未取消的ARRAY CNT  #No.FUN-680136 SMALLINT
          l_n             LIKE type_file.num5,                #檢查重複用  #No.FUN-680136 SMALLINT
          l_lock_sw       LIKE type_file.chr1,                 #單身鎖住否  #No.FUN-680136 VARCHAR(1)
          p_cmd           LIKE type_file.chr1,                 #處理狀態  #No.FUN-680136 VARCHAR(1)
          l_flag          LIKE type_file.chr1,                 #判斷必要欄位是否有輸入  #No.FUN-680136 VARCHAR(1)
          l_allow_insert  LIKE type_file.num5,                #可新增否  #No.FUN-680136 SMALLINT
          l_allow_delete  LIKE type_file.num5,                #可刪除否  #No.FUN-680136 SMALLINT
          l_pmiconf       LIKE pmi_file.pmiconf,
          l_pmi06         LIKE pmi_file.pmi06,
          l_pmi06_t       LIKE pmi_file.pmi06
 
   LET g_action_choice = ""
 
   IF s_shut(0) THEN RETURN END IF                #檢查權限
 
   IF cl_null(g_pmj01) THEN
      RETURN
   END IF
 
   #檢查資料是否已作廢,或已確認
   SELECT pmiconf,pmi06 INTO l_pmiconf,l_pmi06   #MOD-4A0299
     FROM pmi_file
    WHERE pmi01 = g_pmj01
 
   IF l_pmiconf<> 'N' THEN
      CALL cl_err(g_pmj01,'apm-267',0)
      RETURN
   END IF
 
   IF l_pmi06 MATCHES '[Ss]' THEN          #MOD-4A0299
      CALL cl_err("","apm-030",0)
      RETURN
   END IF
 
   CALL cl_opmsg('b')
 
   LET g_forupd_sql = "SELECT pmr03,pmr04,pmr05,pmr05t",     #No.FUN-550019
                      "  FROM pmr_file ",
                      "  WHERE pmr01 = ? ",  
                      "   AND pmr02 = ? ",
                      "   AND pmr03 = ? ",
                      "   AND pmr04 = ? ",
                      "   FOR UPDATE "
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE i255c_bcl CURSOR FROM g_forupd_sql      # LOCK CURSOR
 
   LET l_ac_t = 0
 
   LET l_allow_insert = cl_detail_input_auth("insert")
   LET l_allow_delete = cl_detail_input_auth("delete")
 
   LET l_ac = 1
 
   #MOD-560117
  #FUN-920106---easyflow---add---start
   #apmi265也有分量計價功能，所以要加進來做判斷
   #否則執行apmi265時apmi255.4gl會讀取不到暫存檔資料
   #而導致pmi06狀況碼會空值，畫面上無法顯示
   #FUN-920106---easyflow---add---end---
    IF g_argv07 CLIPPED = "apmi255" or g_argv07 CLIPPED = "apmi265" THEN     #FUN-920106 add apmi265
      LET g_sql = "DROP TABLE ",g_argv08 CLIPPED
      PREPARE drop_prep FROM g_sql
      EXECUTE drop_prep
 
      #LET g_sql = " (tmp01 LIKE type_file.chr1)"  #No.FUN-580092 HCN     #MOD-560241   #No.FUN-680136
      LET g_sql = " (tmp01 VARCHAR(1))"  #no.MOD-7A0188
 
      LET g_sql = "CREATE TABLE ",g_argv08 CLIPPED, g_sql CLIPPED
 
      PREPARE create_prep FROM g_sql
      IF STATUS THEN
         CALL cl_err('create_prep:',status,1)
         RETURN -1
      END IF
      EXECUTE create_prep
   END IF
   #END MOD-560117
 
   INPUT ARRAY g_pmr WITHOUT DEFAULTS FROM s_pmr.*  
         ATTRIBUTE(COUNT=g_rec_b,MAXCOUNT=g_max_rec,UNBUFFERED,
                   INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                   APPEND ROW=l_allow_insert)
 
      BEFORE INPUT
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(l_ac)
         END IF
 
      BEFORE ROW
         LET p_cmd = ""
         LET l_ac = ARR_CURR() 
         LET l_lock_sw = "N"
         BEGIN WORK
         LET g_success = "Y"
         IF g_rec_b >= l_ac THEN
            LET p_cmd = "u"
            LET g_pmr_t.* = g_pmr[l_ac].*
            OPEN i255c_bcl USING g_pmj01,g_pmj02,g_pmr_t.pmr03,g_pmr_t.pmr04 
            IF STATUS THEN
               CALL cl_err("OPEN i255c_bcl:", STATUS, 1)
               LET l_lock_sw = "Y"
            ELSE
               FETCH i255c_bcl INTO g_pmr[l_ac].* 
               IF SQLCA.sqlcode THEN
                  CALL cl_err('lock pmr',SQLCA.sqlcode,1)
                  LET l_lock_sw = "Y"
               END IF
            END IF
            CALL i255c_set_entry_b(p_cmd)      #No.FUN-610018
            CALL i255c_set_no_entry_b(p_cmd)   #No.FUN-610018
            CALL cl_show_fld_cont()     #FUN-550037(smin)
         END IF
 
      BEFORE INSERT
         LET l_n = ARR_COUNT()
         LET p_cmd = "a"
         INITIALIZE g_pmr[l_ac].* TO NULL
         LET g_pmr_t.* = g_pmr[l_ac].* 
         CALL i255c_set_entry_b(p_cmd)      #No.FUN-610018
         CALL i255c_set_no_entry_b(p_cmd)   #No.FUN-610018
         CALL cl_show_fld_cont()     #FUN-550037(smin)
         NEXT FIELD pmr03 
 
      AFTER INSERT
         IF INT_FLAG THEN
            CALL cl_err("",9001,0)
            LET INT_FLAG = 0
            CANCEL INSERT
         END IF
 
         #No.FUN-550019
         INSERT INTO pmr_file(pmr01,pmr02,pmr03,pmr04,pmr05,pmr05t,pmrplant,pmrlegal)  #FUN-980006 add pmrplant,pmrlegal
              VALUES(g_pmj01,g_pmj02,g_pmr[l_ac].pmr03,g_pmr[l_ac].pmr04,
                     g_pmr[l_ac].pmr05,g_pmr[l_ac].pmr05t,g_plant,g_legal) #FUN-980006 add g_plant,g_legal
         #end No.FUN-550019
 
         IF SQLCA.sqlcode THEN
#           CALL cl_err(g_pmr[l_ac].pmr03,SQLCA.sqlcode,0)   #No.FUN-660129
            CALL cl_err3("ins","pmr_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
            CANCEL INSERT
         ELSE
            MESSAGE "INSERT O.K"
            LET l_pmi06 = "0"         #MOD-4A0299
            LET g_rec_b=g_rec_b+1
            DISPLAY g_rec_b TO FORMONLY.cn2   #MOD-910185
           #COMMIT WORK 
         END IF
 
      BEFORE FIELD pmr03               #default 起始數量
         IF cl_null(g_pmr[l_ac].pmr03) THEN
            #SELECT MAX(pmr04)+1 INTO g_pmr[l_ac].pmr03   #MOD-9A0099
            SELECT MAX(pmr04)+0.001 INTO g_pmr[l_ac].pmr03   #MOD-9A0099
              FROM pmr_file
             WHERE pmr01 = g_pmj01 #核價單號
               AND pmr02 = g_pmj02     #項次
            IF cl_null(g_pmr[l_ac].pmr03) THEN
               LET g_pmr[l_ac].pmr03 = 1
            END IF
         END IF
         CALL i255c_set_entry_b(p_cmd)       #No.FUN-550019
 
      AFTER FIELD pmr03 
         #-----No.MOD-5A0222-----
         IF g_pmr[l_ac].pmr03 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD pmr03
         END IF
         IF g_pmr[l_ac].pmr04 < g_pmr[l_ac].pmr03 THEN
            CALL cl_err("","mfg1323",0)
            NEXT FIELD pmr03
         END IF
         #-----No.MOD-5A0222 END-----
         IF p_cmd='a' OR (p_cmd='u' AND g_pmr_t.pmr03 !=g_pmr[l_ac].pmr03) THEN
            SELECT COUNT(*) INTO g_i
              FROM pmr_file
             WHERE pmj01 = g_pmj01   #核價單號
               AND pmj02 = g_pmj02   #項次
               AND g_pmr[l_ac].pmr03 BETWEEN pmr03 AND pmr04
            IF g_i >= 1 THEN
               #起始數量重疊到已輸入的起迄數量
               CALL cl_err("","axm-362",0)
               LET g_pmr[l_ac].pmr03 = g_pmr_t.pmr03
               NEXT FIELD pmr03
            END IF
         END IF
         CALL i255c_set_no_entry_b(p_cmd)       #No.FUN-550019
 
      AFTER FIELD pmr04 #截止數量
         #-----No.MOD-5A0222-----
         IF g_pmr[l_ac].pmr04 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD pmr04
         END IF
         #-----No.MOD-5A0222 END-----
         IF NOT cl_null(g_pmr[l_ac].pmr03) AND NOT cl_null(g_pmr[l_ac].pmr04) THEN
            
            #FUN-560205--start
             SELECT COUNT(*) INTO l_n FROM pmr_file
              WHERE pmr01 = g_pmj01
                AND pmr02 = g_pmj02
                AND pmr03 > g_pmr[l_ac].pmr03
                AND pmr03 <= g_pmr[l_ac].pmr04
             IF l_n > 0 THEN
               CALL cl_err("","apm-919",1)
               LET g_pmr[l_ac].pmr04 = g_pmr_t.pmr04
               DISPLAY BY NAME g_pmr[l_ac].pmr04
               NEXT FIELD pmr04
             END IF
            #FUN-560205--end
 
            #-----No.MOD-5A0222-----
            IF g_pmr[l_ac].pmr04 < g_pmr[l_ac].pmr03 THEN
               CALL cl_err("","mfg1323",0)
               NEXT FIELD pmr04
            END IF
            #-----No.MOD-5A0222 END-----
            IF p_cmd="a" OR (p_cmd="u" AND (g_pmr_t.pmr03 !=g_pmr[l_ac].pmr03
               OR g_pmr_t.pmr04 !=g_pmr[l_ac].pmr04)) THEN 
               SELECT COUNT(*) INTO l_n 
                 FROM pmr_file 
                WHERE pmr01 = g_pmj01 
                  AND pmr02 = g_pmj02
                  AND pmr03 = g_pmr[l_ac].pmr03 
                  AND pmr04 = g_pmr[l_ac].pmr04 
               IF l_n > 0 THEN 
                  #資料重覆，請重新輸入!
                  CALL cl_err("sel-pmr","axm-298",0) 
                  NEXT FIELD pmr04
               END IF
            END IF 
         END IF 
 
      #No.FUN-550019
      AFTER FIELD pmr05
         #-----No.MOD-5A0222-----
         IF g_pmr[l_ac].pmr05 < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD pmr05
         END IF
         #-----No.MOD-5A0222 END-----
         IF NOT cl_null(g_pmr[l_ac].pmr05) THEN
            LET g_pmr[l_ac].pmr05 = cl_digcut(g_pmr[l_ac].pmr05,t_azi03)   #No.CHI-6A0004
            LET g_pmr[l_ac].pmr05t = g_pmr[l_ac].pmr05 * (1 + g_pmi081/100)
            LET g_pmr[l_ac].pmr05t = cl_digcut(g_pmr[l_ac].pmr05t,t_azi03)   #No.CHI-6A0004
         END IF 
 
      AFTER FIELD pmr05t
         #-----No.MOD-5A0222-----
         IF g_pmr[l_ac].pmr05t < 0 THEN
            CALL cl_err("","mfg5034",0)
            NEXT FIELD pmr05t
         END IF
         #-----No.MOD-5A0222 END-----
         IF NOT cl_null(g_pmr[l_ac].pmr05t) THEN
            LET g_pmr[l_ac].pmr05t = cl_digcut(g_pmr[l_ac].pmr05t,t_azi03)   #No.CHI-6A0004
            LET g_pmr[l_ac].pmr05 = g_pmr[l_ac].pmr05t / (1 + g_pmi081/100)
            LET g_pmr[l_ac].pmr05 = cl_digcut(g_pmr[l_ac].pmr05,t_azi03)   #No.CHI-6A0004
         END IF 
      #end No.FUN-550019
 
       BEFORE DELETE                            #是否取消單身
          IF g_pmr_t.pmr03 > 0 AND g_pmr_t.pmr04 > 0 THEN 
            #FUN-560205--add--start
             SELECT COUNT(*) INTO l_n from pmr_file
              WHERE pmr01 = g_pmj01
                AND pmr02 = g_pmj02
                AND pmr03 > g_pmr_t.pmr03
             IF l_n > 0 THEN
               CALL cl_err("","apm-918",1)
               CANCEL DELETE
             END IF
            #FUN-560205 add--end
 
             IF NOT cl_delb(0,0) THEN
                CANCEL DELETE
             END IF
             IF l_lock_sw = "Y" THEN 
                CALL cl_err("", -263, 1) 
                CANCEL DELETE 
             END IF 
             DELETE FROM pmr_file
              WHERE pmr01 = g_pmj01 
                AND pmr02 = g_pmj02
                AND pmr03 = g_pmr_t.pmr03
                AND pmr04 = g_pmr_t.pmr04
             IF SQLCA.sqlcode THEN
#               CALL cl_err(g_pmr_t.pmr03,SQLCA.sqlcode,0)   #No.FUN-660129
                CALL cl_err3("del","pmr_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               #ROLLBACK WORK
                LET g_success = 'N'
                CANCEL DELETE 
             ELSE
                LET g_rec_b=g_rec_b-1
                DISPLAY g_rec_b TO FORMONLY.cn2   #MOD-910185
                LET l_pmi06 = '0'         #MOD-4A0299
               #COMMIT WORK
             END IF 
          END IF
 
      ON ROW CHANGE
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            LET g_pmr[l_ac].* = g_pmr_t.*
            CLOSE i255c_bcl
           #ROLLBACK WORK
            LET g_success = 'N'
            EXIT INPUT
         END IF
         IF l_lock_sw = 'Y' THEN
            CALL cl_err(g_pmr[l_ac].pmr03,-263,1)
            LET g_pmr[l_ac].* = g_pmr_t.*
         ELSE
            UPDATE pmr_file SET pmr01 = g_pmj01,
                                pmr02 = g_pmj02,
                                pmr03 = g_pmr[l_ac].pmr03,
                                pmr04 = g_pmr[l_ac].pmr04,
                                pmr05 = g_pmr[l_ac].pmr05,
                                pmr05t = g_pmr[l_ac].pmr05t      #No.FUN-550019
             WHERE pmr01 = g_pmj01 
               AND pmr02 = g_pmj02
               AND pmr03 = g_pmr_t.pmr03 
               AND pmr04 = g_pmr_t.pmr04 
            IF SQLCA.sqlcode THEN
#              CALL cl_err(g_pmr[l_ac].pmr03,SQLCA.sqlcode,0)   #No.FUN-660129
               CALL cl_err3("upd","pmr_file","","",SQLCA.sqlcode,"","",1)  #No.FUN-660129
               LET g_pmr[l_ac].* = g_pmr_t.*
            ELSE
               MESSAGE 'UPDATE O.K'
               LET l_pmi06 = '0'         #MOD-4A0299
               COMMIT WORK 
            END IF
         END IF
 
      AFTER ROW
         LET l_ac = ARR_CURR()
#        LET l_ac_t = l_ac           #FUN-D30034 mark
         IF INT_FLAG THEN
            CALL cl_err('',9001,0)
            LET INT_FLAG = 0
            IF p_cmd = 'u' THEN
               LET g_pmr[l_ac].* = g_pmr_t.*
            #FUN-D30034---add---str---
            ELSE
               CALL g_pmr.deleteElement(l_ac)
               IF g_rec_b != 0 THEN
                  LET g_action_choice = "detail"
                  LET l_ac = l_ac_t
               END IF
            #FUN-D30034---add---end---
            END IF
            CLOSE i255c_bcl
            ROLLBACK WORK
            LET g_success = 'N'
            EXIT INPUT
         END IF
         LET l_ac_t = l_ac           #FUN-D30034 add
         CLOSE i255c_bcl
         COMMIT WORK
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
      
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
      
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
       
   END INPUT
 
   CLOSE i255c_bcl
 
   IF g_argv07 CLIPPED = "apmi255" OR g_argv07 CLIPPED = "apmi265" THEN  #MOD-560117  #FUN-920106 add apmi265
      LET g_sql = "INSERT INTO ",g_argv08 CLIPPED,"(tmp01) VALUES(",l_pmi06,")"
      PREPARE insert_prep FROM g_sql
      EXECUTE insert_prep
   END IF
 
   COMMIT WORK
 
END FUNCTION
 
FUNCTION i255c_b_fill()              #BODY FILL UP
DEFINE l_flag          LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   LET g_sql = "SELECT pmr03,pmr04,pmr05,pmr05t ",         #No.FUN-550019
               "  FROM pmr_file ",
               " WHERE pmr01 ='",g_pmj01,"'", #單頭-1
               "   AND pmr02 = ",g_pmj02,
               " ORDER BY pmr03,pmr04,pmr05 "
   PREPARE i255c_pb FROM g_sql
   DECLARE pmr_cs CURSOR FOR i255c_pb
 
   CALL g_pmr.clear()
   LET g_cnt = 1
   LET g_rec_b=0
 
   FOREACH pmr_cs INTO g_pmr[g_cnt].*   #單身 ARRAY 填充
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      LET g_cnt = g_cnt + 1
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
         EXIT FOREACH
      END IF
   END FOREACH
 
   CALL g_pmr.deleteElement(g_cnt)
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2  
   LET g_cnt = 0
 
END FUNCTION
 
FUNCTION i255c_bp(p_ud)
   DEFINE p_ud   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_pmr TO s_pmr.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
#     BEFORE ROW
#        LET l_ac = ARR_CURR()
#        CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
 
      ON ACTION first
         CALL i255c_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
 
      ON ACTION previous
         CALL i255c_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION jump
         CALL i255c_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION next
         CALL i255c_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION last
         CALL i255c_fetch('L')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
         IF g_rec_b != 0 THEN
            CALL fgl_set_arr_curr(1)  ######add in 040505
         END IF
         ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
      ON ACTION detail
         LET g_action_choice="detail"
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
 
      ON ACTION accept
         LET g_action_choice="detail"
         LET l_ac = ARR_CURR()
         EXIT DISPLAY
   
      ON ACTION cancel
         LET INT_FLAG=FALSE             #MOD-570244 mars
         LET g_action_choice="exit"
         EXIT DISPLAY
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
 
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
END FUNCTION
 
#No.FUN-550019
FUNCTION i255c_set_entry_b(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1    #No.FUN-680136 VARCHAR(1)
 
   IF INFIELD(pmr03) THEN
      CALL cl_set_comp_entry("pmr05,pmr05t",TRUE)   
   END IF 
   CALL cl_set_comp_entry("pmr05,pmr05t",TRUE)     #No.FUN-610018
 
END FUNCTION
#end No.FUN-550019
 
#No.FUN-550019
FUNCTION i255c_set_no_entry_b(p_cmd) 
   DEFINE p_cmd   LIKE type_file.chr1     #No.FUN-680136 VARCHAR(1)
 
   #No.FUN-610018 
   IF g_gec07 = 'N' THEN        #No.FUN-560102
      CALL cl_set_comp_entry("pmr05t",FALSE)
   ELSE
      CALL cl_set_comp_entry("pmr05",FALSE)
   END IF
 
END FUNCTION
#end No.FUN-550019
