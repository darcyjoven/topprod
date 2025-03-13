# Prog. Version..: '5.30.07-13.06.13(00010)'     #
#
# Pattern name...: gnmq610.4gl
# Descriptions...: 應收/付票據月底重評價異動記錄查詢
# Date & Author..: 02/04/22 By Carrier
# Modify.........: No.FUN-4B0047 04/11/18 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-550037 05/05/13 By saki    欄位comment顯示
# Modify.........: No.FUN-550057 05/05/25 By vivien 單據編號格式放大 
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: FUN-5C0015 05/12/20 BY GILL (1)多Update 異動碼5~10, 關係人
#                  (2)若該科目有設彈性異動碼(agli120),則default帶出
#                     彈性異動碼的設定值(call s_def_npq: 抓取異動碼default值)
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680034 06/08/29 By Jackho 兩套帳修改
# Modify.........: No.FUN-680145 06/09/18 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740028 07/04/10 By hongmei 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.MOD-790082 07/09/17 By Smapmin 分錄科目預設值抓不出來
# Modify.........: No.MOD-910128 09/01/13 By chenyu s_get_bookno(放的位置不對，傳入的參數也有問題
# Modify.........: No.MOD-920090 09/02/10 By liuxqa 單頭不輸入條件時，只能查出一筆資料
# Modify.........: No.TQC-920078 09/02/24 By zhaijie修改單身筆數顯示
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A30028 10/03/30 By wujie 增加来源单据串查
# Modify.........: No:MOD-A50187 10/05/28 By Elva 增加接收参数，供aglq200串查
# Modify.........: No.FUN-AA0087 11/01/30 By chenmoyan 異動碼類型設定改善
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料 
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:TQC-C80024 12/08/03 By lujh 生成分錄時，應按照aag42按餘額方向生成
# Modify.........: No.FUN-D10065 13/01/15 By wangrr 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No:FUN-D40107 13/05/23 By lujh 新增狀態頁簽、畫面上的按鈕增加順序為:重評價產生,重評價還原,分錄底稿產生,分錄底稿,拋轉憑證,拋轉憑證還原 
# Modify.........: No:FUN-D70002 13/08/27 By yangtt 新增時給原幣未沖金額(oox11)賦值
# Modify.........: No:CHI-D50024 13/08/29 By yinhy  产生分录底稿，应该增加逻辑，若科目有做部门管理，则需要将对应单据上单头的部门或者成本中心抓取（若agls103 有启用利润中心，则抓成本中心，否则抓取部门）
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE 
    g_oox00   LIKE oox_file.oox00,
    g_oox01   LIKE oox_file.oox01,
    g_oox02   LIKE oox_file.oox02,
    g_oox     DYNAMIC ARRAY OF RECORD
              oox03v   LIKE oox_file.oox03v,
              oox03    LIKE oox_file.oox03,
              oox05    LIKE oox_file.oox05,
              oox06    LIKE oox_file.oox06,
              oox07    LIKE oox_file.oox07,
              oox11    LIKE oox_file.oox11,   #No.FUN-D70002   Add
              oox08    LIKE oox_file.oox08,
              oox09    LIKE oox_file.oox09,
              oox10    LIKE oox_file.oox10
              END RECORD,
    g_wc,g_wc2,g_sql string,  #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b          LIKE type_file.num10,   #NO.FUN-680145 INTEGER    #單身筆數
    g_trno           LIKE type_file.chr20,   #NO.FUN-680145 VARCHAR(20)
    g_tot            LIKE oox_file.oox09,    #NO.FUN-680145 DEC(20,6)  #No.FUN-4C0010
    g_detail         LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(01)
DEFINE   g_argv1         LIKE type_file.chr1   # MOD-A50187
DEFINE   g_argv2         STRING   # MOD-A50187
DEFINE   g_chr           LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #NO.FUN-680145 INTEGER   
DEFINE   g_msg           LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #NO.FUN-680145 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #NO.FUN-680145 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #NO.FUN-680145 INTEGER
DEFINE   g_no_ask        LIKE type_file.num5     #NO.FUN-680145 SMALLINT
DEFINE   g_bookno1       LIKE aza_file.aza81     #No.FUN-740028
DEFINE   g_bookno2       LIKE aza_file.aza82     #No.FUN-740028                                                                     
DEFINE   g_bookno3       LIKE aag_file.aag00     #TQC-C80024 add
DEFINE   g_flag          LIKE type_file.chr1     #No.FUN-740028
DEFINE   g_aag44         LIKE aag_file.aag44     #FUN-D40118 add
#FUN-D40107--add--str--
DEFINE   g_ooxacti       LIKE oox_file.ooxacti
DEFINE   g_ooxuser       LIKE oox_file.ooxuser             
DEFINE   g_ooxoriu       LIKE oox_file.ooxorig
DEFINE   g_ooxorig       LIKE oox_file.ooxorig
DEFINE   g_ooxgrup       LIKE oox_file.ooxgrup
DEFINE   g_ooxmodu       LIKE oox_file.ooxmodu
DEFINE   g_ooxdate       LIKE oox_file.ooxdate       
DEFINE   g_ooxcrat       LIKE oox_file.ooxcrat
#FUN-D40107--add--end--
 
MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GNM")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1  = ARG_VAL(1) # MOD-A50187
   LET g_argv2  = ARG_VAL(2) # MOD-A50187

    DROP TABLE sort_file;                                                           
    CREATE TEMP TABLE sort_file(
     nmh01 LIKE nmh_file.nmh01,
     nmh15 LIKE nmh_file.nmh15,
     nmh11 LIKE nmh_file.nmh11,
     nmh30 LIKE nmh_file.nmh30,
     nmh26 LIKE nmh_file.nmh26,
     nmh261 LIKE nmh_file.nmh261,
     oox05 LIKE oox_file.oox05,
     oox07 LIKE oox_file.oox07,
     oox10 LIKE oox_file.oox10,
     nms12 LIKE nms_file.nms12,
     nmd18 LIKE nmd_file.nmd18);  #CHI-D50024      
    IF STATUS THEN CALL cl_err('cre tmp',STATUS,0) EXIT PROGRAM END IF 
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0098
 
    OPEN WINDOW q610_w WITH FORM "gnm/42f/gnmq610" 
     ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL cl_set_act_visible("entry_sheet2",g_aza.aza63='Y')      #No.FUN-680034
 
    # MOD-A50187 --begin
    IF NOT cl_null(g_argv1) AND NOT cl_null(g_argv2) THEN
       CALL q610_q()
    END IF
    # MOD-A50187 --end
    CALL q610_menu()
    CLOSE WINDOW q610_w
 
    CALL cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0098
END MAIN
 
 
 
#QBE 查詢資料
FUNCTION q610_cs()
   CLEAR FORM #清除畫面
   CALL g_oox.clear()
   CALL cl_opmsg('q')
 
   # MOD-A50187 --begin
   IF NOT cl_null(g_argv2) AND NOT cl_null(g_argv1) THEN
      LET g_detail = g_argv1
      DISPLAY BY NAME g_detail
      LET g_wc = g_argv2
   ELSE

   LET g_detail = '1'
 
   INPUT BY NAME g_detail WITHOUT DEFAULTS  
 
      AFTER FIELD g_detail 
         IF cl_null(g_detail) OR g_detail NOT MATCHES '[12]' THEN
            NEXT FIELD g_detail
        #No.MOD-910128 mark --begin
        ##No.FUN-740028 ---Begin                                                                                                       
        #   CALL s_get_bookno(g_detail) RETURN g_flag,g_bookno1,g_bookno2                                                            
        #     IF g_flag =  '1' THEN  #抓不到帳別                                                                                    
        #        CALL cl_err(g_detail,'aoo-081',1)                                                                                   
        #        NEXT FIELD g_detail                                                                                                
        #     END IF                                                                                                                
        ##No.FUN-740028 ---End
        #No.MOD-910128 mark --end
         END IF
 
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
 
   IF INT_FLAG THEN
      RETURN
   END IF
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
   INITIALIZE g_oox00 TO NULL    #No.FUN-750051
   INITIALIZE g_oox01 TO NULL    #No.FUN-750051
   INITIALIZE g_oox02 TO NULL    #No.FUN-750051
   CONSTRUCT g_wc
      ON oox01,oox02,oox03v,oox03,oox05,oox06,oox07,oox11,  #No.FUN-D70002   Add  oox11
      oox08,oox09,oox10
      FROM oox01,oox02,s_oox[1].oox03v,s_oox[1].oox03,
      s_oox[1].oox05,s_oox[1].oox06,s_oox[1].oox07,
      s_oox[1].oox11,    #No.FUN-D70002   Add
      s_oox[1].oox08,s_oox[1].oox09,s_oox[1].oox10
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
   END IF
   # MOD-A50187 --end
   LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null) #FUN-980030
 
   IF INT_FLAG THEN
      RETURN 
   END IF
 
   MESSAGE ' WAIT ' 
   LET g_sql="SELECT DISTINCT oox00,oox01,oox02 ",
             "  FROM oox_file ",
             " WHERE ",g_wc CLIPPED
   IF g_detail = '1' THEN
      LET g_sql = g_sql CLIPPED,
             "   AND oox00 = 'NR' ", 
             " ORDER BY oox00,oox01 "
   END IF
   IF g_detail = '2' THEN
      LET g_sql = g_sql CLIPPED,
             "   AND oox00 = 'NP' ", 
             " ORDER BY oox00,oox01 "
   END IF
   PREPARE q610_prepare FROM g_sql
   IF STATUS THEN
      CALL cl_err('q610_pre',STATUS,1)
   END IF
   DECLARE q610_cs SCROLL CURSOR WITH HOLD FOR q610_prepare
#No.MOD-920090 add by liuxqa --begin---
   DROP TABLE x
   LET g_sql="SELECT DISTINCT oox01,oox02 ",
             " FROM oox_file ",
             " WHERE ",g_wc CLIPPED
   IF g_detail = '1' THEN
      LET g_sql = g_sql CLIPPED,
                  #"AND oox00 = 'NR' INTO TEMP x "  #TQC-920078
                  " AND oox00 = 'NR' INTO TEMP x "  #TQC-920078
   END IF
   IF g_detail = '2' THEN
      LET g_sql = g_sql CLIPPED,
                  #"AND oxx00 = 'NP' INTO TEMP x "  #TQC-920078
                  " AND oox00 = 'NP' INTO TEMP x "  #TQC-920078
   END IF
  
   PREPARE q610_precount_x FROM g_sql
   EXECUTE q610_precount_x
   LET g_sql =" SELECT COUNT(*) FROM x"
#No.MOD-920090 add by liuxqa --end---
#No.MOD-920090 mark by liuxqa --begin--
{
   LET g_sql="SELECT COUNT(DISTINCT oox00) ",
             "  FROM oox_file ",
             " WHERE ",g_wc CLIPPED 
   IF g_detail = '1' THEN
      LET g_sql = g_sql CLIPPED,
             "   AND oox00 = 'NR' "  
   END IF
   IF g_detail = '2' THEN
      LET g_sql = g_sql CLIPPED,
             "   AND oox00 = 'NP' "  
   END IF
}
#No.MOD-920090 mark by liuxqa --end--
   PREPARE q610_precount FROM g_sql
   DECLARE q610_count CURSOR FOR q610_precount
 
END FUNCTION
 
FUNCTION q610_menu()
DEFINE l_ac     LIKE type_file.num5         #No.FUN-A30028
 
   WHILE TRUE
      CALL q610_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q610_q()
            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask()
         #FUN-D40107--add--str--
         #@WHEN "重評價產生"
         WHEN "weight_evaluation"
            IF cl_chk_act_auth() THEN 
               CALL weight_evaluation()
            END IF
         #@WHEN "重評價還原"
         WHEN "evaluation_of_reduction"
            IF cl_chk_act_auth() THEN 
               CALL evaluation_of_reduction()
            END IF
         #FUN-D40107--add--end--
         #@WHEN "產生分錄"
         WHEN "gen_entry"
            IF cl_chk_act_auth() THEN 
               CALL q610_v()
            END IF
         #@WHEN "分錄底稿" 
         WHEN "entry_sheet" 
            IF cl_chk_act_auth() THEN 
               LET g_trno = 'NM',g_oox01 USING '&&&&',g_oox02 USING '&&'
               IF g_detail = '1' THEN
                  CALL s_fsgl('NM',14,g_trno,0,g_nmz.nmz02b,1,'N','0',g_ooz.ooz02p) #NO.FUN-680034
               ELSE
                  CALL s_fsgl('NM',15,g_trno,0,g_nmz.nmz02b,1,'N','0',g_ooz.ooz02p) #NO.FUN-680034
               END IF
            END IF
#NO.FUN-680034--BEGIN
         WHEN "entry_sheet2"                                                                                                         
            IF cl_chk_act_auth() THEN                                                                                               
               LET g_trno = 'NM',g_oox01 USING '&&&&',g_oox02 USING '&&'                                                            
               IF g_detail = '1' THEN                                                                                               
                  CALL s_fsgl('NM',14,g_trno,0,g_nmz.nmz02b,1,'N','1',g_ooz.ooz02p)    #NO.FUN-680034                                             
               ELSE                                                                                                                 
                  CALL s_fsgl('NM',15,g_trno,0,g_nmz.nmz02b,1,'N','1',g_ooz.ooz02p)    #NO.FUN-680034                                                              
               END IF                                                                                                               
            END IF                  
#NO.FUN-680034--END  
        #FUN-D40107--add--str--
        #@WHEN "拋轉憑證"
        WHEN "carry_voucher"
           IF cl_chk_act_auth() THEN 
              CALL carry_voucher()
           END IF
        #@WHEN "拋轉憑證還原"
        WHEN "undo_carry_voucher"
           IF cl_chk_act_auth() THEN 
              CALL undo_carry_voucher()
           END IF
        #FUN-D40107--add--end--
        WHEN "exporttoexcel"     #FUN-4B0047
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_oox),'','')
            END IF
#No.FUN-A30028 --begin
         WHEN "qry_oox"
            IF cl_chk_act_auth() THEN 
               LET l_ac = ARR_CURR()
               IF NOT cl_null(l_ac) AND l_ac <> 0 THEN
                  IF g_detail ='1' THEN
                     LET g_msg = "anmt200 '",g_oox[l_ac].oox03 CLIPPED,"'"
                     CALL cl_cmdrun(g_msg)
                  END IF
                  IF g_detail ='2' THEN
                     LET g_msg = "anmt100 '",g_oox[l_ac].oox03 CLIPPED,"'"
                     CALL cl_cmdrun(g_msg)
                  END IF
               END IF
            END IF
#No.FUN-A30028 --end 
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q610_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q610_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q610_count
    FETCH q610_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN q610_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
      ELSE
        CALL q610_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q610_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)      #處理方式
    l_abso          LIKE type_file.num10    #NO.FUN-680145 INTEGER      #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q610_cs INTO g_oox00,g_oox01,g_oox02
        WHEN 'P' FETCH PREVIOUS q610_cs INTO g_oox00,g_oox01,g_oox02
        WHEN 'F' FETCH FIRST    q610_cs INTO g_oox00,g_oox01,g_oox02
        WHEN 'L' FETCH LAST     q610_cs INTO g_oox00,g_oox01,g_oox02
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
            FETCH ABSOLUTE g_jump q610_cs INTO g_oox00,g_oox01,g_oox02
            LET g_no_ask = FALSE
    END CASE
    IF STATUS THEN
       CALL cl_err(g_oox00,STATUS,0) 
       INITIALIZE g_oox00 TO NULL  #TQC-6B0105
       INITIALIZE g_oox01 TO NULL  #TQC-6B0105
       INITIALIZE g_oox02 TO NULL  #TQC-6B0105
       RETURN
    ELSE
       CASE p_flag 
          WHEN 'F' LET g_curs_index = 1
          WHEN 'P' LET g_curs_index = g_curs_index - 1
          WHEN 'N' LET g_curs_index = g_curs_index + 1
          WHEN 'L' LET g_curs_index = g_row_count
          WHEN '/' LET g_curs_index = g_jump
       END CASE
      
       CALL cl_navigator_setting(g_curs_index, g_row_count)
    END IF
 
    CALL q610_show()
END FUNCTION
 
FUNCTION q610_show()
   #FUN-D40107--add--str--
   SELECT ooxacti,ooxuser,ooxoriu,ooxorig,
          ooxgrup,ooxmodu,ooxdate,ooxcrat
     INTO g_ooxacti,g_ooxuser,g_ooxoriu,g_ooxorig,
          g_ooxgrup,g_ooxmodu,g_ooxdate,g_ooxcrat
     FROM oox_file
    WHERE oox00 = g_oox00
      AND oox01 = g_oox01
      AND oox02 = g_oox02
   DISPLAY g_ooxacti,g_ooxuser,g_ooxoriu,g_ooxorig,
           g_ooxgrup,g_ooxmodu,g_ooxdate,g_ooxcrat
        TO ooxacti,ooxuser,ooxoriu,ooxorig,
           ooxgrup,ooxmodu,ooxdate,ooxcrat
   #FUN-D40107--add--end--
   DISPLAY g_oox01,g_oox02 TO oox01,oox02   # 顯示單頭值
   CALL q610_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q610_b_fill()              #BODY FILL UP
    DEFINE l_sql     LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(1000)
 
    LET l_sql = "SELECT oox03v,oox03,oox05,oox06,oox07,oox11,oox08,oox09,oox10",  #No.FUN-D70002   Add oox11
                "  FROM oox_file ",
                " WHERE oox00 = '",g_oox00,"'",
                "   AND oox01 = ",g_oox01, 
                "   AND oox02 = ",g_oox02,
                " ORDER BY oox00,oox01 "
    PREPARE q610_pre2 FROM l_sql
    IF STATUS THEN CALL cl_err('q610_pre2',STATUS,1) END IF 
    DECLARE q610_bcs CURSOR FOR q610_pre2
 
    CALL g_oox.clear()
    LET g_cnt = 1
    LET g_tot = 0
    FOREACH q610_bcs INTO g_oox[g_cnt].*
       IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
       LET g_tot = g_tot + g_oox[g_cnt].oox10
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
    END FOREACH
    LET g_rec_b = g_cnt - 1
    DISPLAY g_rec_b TO FORMONLY.cn2  
    DISPLAY BY NAME g_tot
END FUNCTION
 
FUNCTION q610_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   #DISPLAY ARRAY g_oox TO s_oox.*    #TQC-920078
   DISPLAY ARRAY g_oox TO s_oox.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
         CALL cl_show_fld_cont()                  #No.FUN-550037
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q610_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q610_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL q610_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q610_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL q610_fetch('L')
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
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      #FUN-D40107--add--str--
      #@WHEN "重評價產生"
      ON ACTION weight_evaluation
         LET g_action_choice="weight_evaluation"
         EXIT DISPLAY
      #@WHEN "重評價還原"
      ON ACTION evaluation_of_reduction
         LET g_action_choice="evaluation_of_reduction"
         EXIT DISPLAY
      #FUN-D40107--add--end--
      #@ON ACTION 會計分錄產生
      ON ACTION gen_entry
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
      #@ON ACTION 分錄底稿
      ON ACTION entry_sheet
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
      ON ACTION entry_sheet2                                                                                                         
         LET g_action_choice="entry_sheet2"                                                                                          
         EXIT DISPLAY   
      #FUN-D40107--add--str--
      #@WHEN "拋轉憑證"
      ON ACTION carry_voucher
         LET g_action_choice="carry_voucher"
         EXIT DISPLAY
      #@WHEN "拋轉憑證還原"
      ON ACTION undo_carry_voucher
         LET g_action_choice="undo_carry_voucher"
         EXIT DISPLAY
      #FUN-D40107--add--end--
 
   ON ACTION accept
#      LET l_ac = ARR_CURR()
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
 
      ON ACTION exporttoexcel       #FUN-4B0047
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY

#No.FUN-A30028 --begin
      ON ACTION qry_oox
         LET g_action_choice="qry_oox"
         EXIT DISPLAY
#No.FUN-A30028 --end 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION q610_v()
   DEFINE l_trno   LIKE npp_file.npp01
   DEFINE l_buf    LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(70)
   DEFINE l_n      LIKE type_file.num5     #NO.FUN-680145 SMALLINT
   DEFINE l_npp00  LIKE npp_file.npp00
   DEFINE l_npp011 LIKE npp_file.npp011
   DEFINE l_nma05  LIKE nma_file.nma05
 
   IF cl_null(g_oox00) OR cl_null(g_oox01) OR cl_null(g_oox02) THEN 
      RETURN 
   END IF
 
#  DELETE FROM sort_file;        #No.FUN-680034
 
   #單號為系統別+年度+月份 
   LET l_trno = 'NM',g_oox01 USING '&&&&',g_oox02 USING '&&'
 
   IF g_detail = '1' THEN
      LET l_npp00  = 14
      LET l_npp011 = 1
   ELSE
      LET l_npp00 = 15
      LET l_npp011 = 1
   END IF
   #已拋轉總帳
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE npp01 = l_trno  AND nppglno IS NOT NULL 
      AND npp00 = l_npp00 AND nppsys = 'NM' AND npp011 = l_npp011
   IF l_n > 0 THEN 
      CALL cl_err('sel npp','aap-122',0) RETURN 
   END IF
   SELECT COUNT(*) INTO l_n FROM npq_file 
    WHERE npq01 = l_trno  AND npq00 = l_npp00 
      AND npqsys= 'NM' AND npq011= l_npp011
   IF l_n > 0 THEN
      CALL cl_getmsg('axr-056',g_lang) RETURNING g_msg
      LET l_buf = '(',l_trno CLIPPED,')',g_msg
      WHILE TRUE
            LET INT_FLAG = 0  ######add for prompt bug
         PROMPT l_buf CLIPPED FOR CHAR g_chr
            ON IDLE g_idle_seconds
               CALL cl_on_idle()
#               CONTINUE PROMPT
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
      ON ACTION help          #MOD-4C0121
         CALL cl_show_help()  #MOD-4C0121
 
      ON ACTION controlg      #MOD-4C0121
         CALL cl_cmdask()     #MOD-4C0121
 
         
         END PROMPT
         IF g_chr MATCHES "[12]" THEN EXIT WHILE END IF
      END WHILE
      IF g_chr = '1' THEN RETURN END IF
   END IF
 
   LET g_success = 'Y' 
   BEGIN WORK
                                                                   
#NO.FUN-680034--BEGIN                                                                              
  # CALL q610_g_gl(l_npp00,l_npp011,l_trno)        
     CALL q610_g_gl(l_npp00,l_npp011,l_trno,'0')
     IF g_aza.aza63='Y' and g_success='Y' THEN
        CALL q610_g_gl(l_npp00,l_npp011,l_trno,'1')                               
     END IF              
#NO.FUN-680034--END                                                      
   IF g_success = 'Y' THEN                                                      
      COMMIT WORK                                                               
   ELSE                                                                         
      ROLLBACK WORK                                                             
   END IF                 
END FUNCTION
 
FUNCTION q610_g_gl(l_npp00,l_npp011,l_trno,l_npptype)  #NO.FUN-680034
   DEFINE l_npp00  LIKE npp_file.npp00
   DEFINE l_npp011 LIKE npp_file.npp011
   DEFINE l_trno   LIKE npp_file.npp01
   DEFINE l_npptype LIKE npp_file.npptype  #NO.FUN-680034
   DEFINE l_npp    RECORD LIKE npp_file.*
   DEFINE l_npq    RECORD LIKE npq_file.*
   DEFINE l_oox03  LIKE oox_file.oox03
   DEFINE l_oox05  LIKE oox_file.oox05
   DEFINE l_oox07  LIKE oox_file.oox07
   DEFINE l_aag06  LIKE aag_file.aag06     #TQC-C80024 add
   DEFINE l_aag42  LIKE aag_file.aag42     #TQC-C80024 add
   DEFINE l_aag05  LIKE aag_file.aag05     #CHI-D50024 
   DEFINE b_date,e_date  LIKE type_file.dat      #NO.FUN-680145 DATE
   DEFINE l_i      LIKE type_file.num5     #NO.FUN-680145 SMALLINT
   DEFINE l_nms    RECORD LIKE nms_file.*
   DEFINE l_aap    DYNAMIC ARRAY OF RECORD
                   nms12 LIKE nms_file.nms12,
                   oox10 LIKE oox_file.oox10
                   END RECORD
   DEFINE l_sql    LIKE type_file.chr1000, #NO.FUN-680145 VARCHAR(500)                                                   
          l_nms12  LIKE nms_file.nms12,
          l_nms13  LIKE nms_file.nms13,
          l_sort   RECORD                                                       
                   nmh01 LIKE nmh_file.nmh01,                                   
                   nmh15 LIKE nmh_file.nmh15,                                   
                   nmh11 LIKE nmh_file.nmh11,
                   nmh30 LIKE nmh_file.nmh30,
                   nmh26 LIKE nmh_file.nmh26,                                   
                   nmh261 LIKE nmh_file.nmh261,               #No.FUN-680034        
                   oox03v LIKE oox_file.oox03v,                                   
                   oox05 LIKE oox_file.oox05,                                   
                   oox07 LIKE oox_file.oox07,                                   
                   oox10 LIKE oox_file.oox10,                                   
                   nms12 LIKE nms_file.nms12,
                   nmd18 LIKE nmd_file.nmd18                 #CHI-D50024
                   END RECORD,                                                  
         l_sr      RECORD                                                       
                   nmh26 LIKE nmh_file.nmh26,                                   
                   nmh261 LIKE nmh_file.nmh261,               #No.FUN-680034        
                   nmh15 LIKE nmh_file.nmh15,
                   nmh11 LIKE nmh_file.nmh11,
                   nmh30 LIKE nmh_file.nmh30,
                   nmh01 LIKE nmh_file.nmh01,                                   
                   oox05 LIKE oox_file.oox05,                                   
                   oox07 LIKE oox_file.oox07,                                   
                   oox10 LIKE oox_file.oox10,                                   
                   nms12 LIKE nms_file.nms12,
                   nmd18 LIKE nmd_file.nmd18                 #CHI-D50024                                   
                   END RECORD,                 
           l_sr2   RECORD                                                       
                   nms12 LIKE nms_file.nms12,
                   oox10 LIKE oox_file.oox10                                    
                   END RECORD                                                   
   DEFINE l_flag   LIKE type_file.chr1    #FUN-D40118 add
 
   DELETE FROM npp_file WHERE npp01 = l_trno  AND npp00 = l_npp00
                          AND nppsys= 'NM' AND npp011= l_npp011  #異動序號
                          AND npptype=l_npptype                  #No.FUN-680034 
   DELETE FROM npq_file WHERE npq01 = l_trno  AND npq00 = l_npp00
                          AND npqsys= 'NM' AND npq011= l_npp011  #異動序號
                          AND npqtype=l_npptype                  #No.FUN-680034 
   DELETE FROM tic_file WHERE tic04 = l_trno     #FUN-B40056
   DELETE FROM sort_file;        #No.FUN-680034
 
#NO.FUN-680034--BEGIN
 #  CALL s_azn01(g_oox01,g_oox02) RETURNING b_date,e_date
   IF g_aza.aza63='Y'   THEN
     IF l_npptype='0'   THEN
     CALL s_azmm01(g_oox01, g_oox02, g_nmz.nmz02p, g_nmz.nmz02b) RETURNING b_date,e_date
     ELSE
     CALL s_azmm01(g_oox01, g_oox02, g_nmz.nmz02p, g_nmz.nmz02c) RETURNING b_date,e_date     
     END IF  
   ELSE
     CALL s_azn01(g_oox01,g_oox02) RETURNING b_date,e_date
   END IF
#NO.FUN-680034--END
   #No.MOD-910128 add --begin
   CALL s_get_bookno(YEAR(e_date)) RETURNING g_flag,g_bookno1,g_bookno2                
   IF g_flag =  '1' THEN  #抓不到帳別                                          
      CALL cl_err(YEAR(e_date),'aoo-081',1)                                         
      LET g_success = 'N'
   END IF
   #No.MOD-910128 add --end
   INITIALIZE l_npp.* TO NULL
   INITIALIZE l_npq.* TO NULL
   INITIALIZE l_nms.* TO NULL
   LET l_npp.nppsys= 'NM'
   LET l_npp.npp00 = l_npp00
   LET l_npp.npp01 = l_trno
   LET l_npp.npp011= l_npp011
   LET l_npp.npp02 = e_date
   LET l_npp.npp03 = NULL
   LET l_npp.npptype=l_npptype            #No.FUN-680034
   LET l_npp.npplegal=g_legal             #FUN-980011 add
   INSERT INTO npp_file VALUES(l_npp.*)
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#     CALL cl_err('ins npp',STATUS,1) #No.FUN-660146
      CALL cl_err3("ins","npp_file",l_npp.npp01,l_npp.npp011,STATUS,"","ins npp",1)   #No.FUN-660146
      LET g_success = 'N' RETURN    
   END IF
 
   IF g_detail = '1' THEN
      LET g_sql = " SELECT nmh01,nmh15,nmh11,nmh30,nmh26,nmh261,oox03v,oox05,oox07,oox10,'',nmh15", #	NO.FUN-680034 #CHI-D50024 add nmh15
                  "   FROM nmh_file,oox_file ",
                  "  WHERE oox00 = '",g_oox00,"' AND oox01 = ",g_oox01,
                  "    AND oox02 = ",g_oox02," AND nmh01 = oox03"
   ELSE 
      IF g_detail = '2' THEN
         LET g_sql = " SELECT nmd01,nmd18,nmd08,nmd24,nmd23,nmd231,oox03v,oox05,oox07,oox10,'',nmd18 ",  #NO.FUN-68034 #CHI-D50024
                     "   FROM nmd_file,oox_file ",
                     "  WHERE oox00 = '",g_oox00,"' AND oox01 = ",g_oox01,
                     "    AND oox02 = ",g_oox02," AND nmd01 = oox03"
      END IF
   END IF
   PREPARE q610_pre1 FROM g_sql                                                 
   IF STATUS THEN 
      CALL cl_err('q610_pre1',STATUS,1) LET g_success = 'N' RETURN 
   END IF
   DECLARE q610_nmh1 CURSOR FOR q610_pre1
   IF STATUS THEN                                                               
      CALL cl_err('q610_pre1',STATUS,0) LET g_success='N' RETURN          
   END IF  
   INITIALIZE l_sort.* TO NULL
   FOREACH q610_nmh1 INTO l_sort.*                                        
     IF SQLCA.sqlcode THEN                                                      
        CALL cl_err(l_sort.nmh01,SQLCA.sqlcode,0)                               
        LET g_success = 'N' EXIT FOREACH                                                            
     END IF            
     IF g_detail = '1' THEN   #科目
        IF l_sort.oox03v = '2' THEN
           IF g_nmz.nmz11 = 'Y' THEN
#NO.FUN-680034--BEGIN
    #          SELECT nms24 INTO l_sort.nmh26 FROM nms_file 
    #            WHERE nms01 = l_sort.nmh15
              IF l_npptype='0' THEN
                 SELECT nms24 INTO l_sort.nmh26 FROM nms_file
                 WHERE nms01 = l_sort.nmh15 
              ELSE
                 SELECT nms241 INTO l_sort.nmh261 FROM nms_file  
                 WHERE nms01 = l_sort.nmh15 
              END IF
           ELSE
    #          SELECT nms24 INTO l_sort.nmh26 FROM nms_file
    #           WHERE nms01 = ''
               IF l_npptype='0' THEN                                                                                         
                    SELECT nms24 INTO l_sort.nmh26 FROM nms_file                                                               
                    #WHERE nms01 = ''    #MOD-790082                                                                              
                    WHERE nms01 = ' '    #MOD-790082                                                                              
               ELSE                                                                                                          
 
                    SELECT nms241 INTO l_sort.nmh261 FROM nms_file                                                             
                    #WHERE nms01 = ''     #MOD-790082        
                    WHERE nms01 = ' '     #MOD-790082        
               END IF   
#NO.FUN-680034--END           
           END IF
        END IF
     END IF
     LET l_nms12 = ''
     LET l_nms13 = ''
     IF g_nmz.nmz11 = 'Y' THEN
#NO.FUN-680034--BEGIN
  #      SELECT nms12,nms13 INTO l_nms12,l_nms13 
  #        FROM nms_file WHERE nms01 = l_sort.nmh15
         IF l_npptype='0' THEN
           SELECT nms12,nms13 INTO l_nms12,l_nms13
           FROM nms_file WHERE nms01 = l_sort.nmh15
         ELSE
           SELECT nms121,nms131 INTO l_nms12,l_nms13
           FROM  nms_file WHERE nms01 = l_sort.nmh15
         END IF
     ELSE
 #       SELECT nms12,nms13 INTO l_nms12,l_nms13 
 #         FROM nms_file WHERE nms01 = ''
          IF l_npptype='0' THEN                                                                                               
              SELECT nms12,nms13 INTO l_nms12,l_nms13                                                                           
               #FROM nms_file WHERE nms01 = ''   #MOD-790082                                                                      
               FROM nms_file WHERE nms01 = ' '   #MOD-790082                                                                      
          ELSE                                                                                                                
               SELECT nms121,nms131 INTO l_nms12,l_nms13                                                                         
               #FROM  nms_file WHERE nms01 = ''  #MOD-790082
               FROM  nms_file WHERE nms01 = ' '  #MOD-790082
          END IF 
#NO.FUN-680034--END           
     END IF
     IF l_sort.oox10 > 0 THEN
        LET l_sort.nms12 = l_nms12
     ELSE
        LET l_sort.nms12 = l_nms13
     END IF
     INSERT INTO sort_file VALUES(l_sort.nmh01,l_sort.nmh15,l_sort.nmh11,
            l_sort.nmh30,l_sort.nmh26,l_sort.nmh261,l_sort.oox05,           #NO.FUN-680034
            l_sort.oox07,l_sort.oox10,l_sort.nms12,l_sort.nmd18)           #CHI-D50024
     IF SQLCA.sqlcode THEN                                                      
#       CALL cl_err(l_sort.nmh01,SQLCA.sqlcode,0)                                  #No.FUN-660146
        CALL cl_err3("ins","sort_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-660146
        LET g_success = 'N' EXIT FOREACH                                                            
     END IF                                                                     
     INITIALIZE l_sort.* TO NULL
   END FOREACH     
   IF g_detail = '1' THEN
      CASE g_nmz.nmz62                                                             
      WHEN '1'
        LET l_sql="SELECT nmh26,'',nmh15,nmh11,nmh30,nmh01,oox05,oox07,SUM(oox10),'',nmd18",  #CHI-D50024
                  "  FROM sort_file ",                                            
                  " GROUP BY nmh26,nmh15,nmh11,nmh30,nmh01,oox05,oox07,nmd18 ",         #CHI-D50024   
                  " ORDER BY nmh26,nmh01"
      WHEN '2'                                                                  
        LET l_sql="SELECT nmh26,'','','','','',oox05,oox07,SUM(oox10),'',nmd18",  #CHI-D50024     
                  "  FROM sort_file ",                                         
                  " GROUP BY nmh26,oox05,oox07,nmd18 ",         #CHI-D50024  
                  " ORDER BY nmh26,oox05,oox07"
      WHEN '3'
        LET l_sql="SELECT nmh26,'','',nmh11,nmh30,'',oox05,oox07,SUM(oox10),'',nmd18",  #CHI-D50024
                  "  FROM sort_file ",                                            
                  " GROUP BY nmh26,nmh11,nmh30,oox05,oox07,nmd18 ",         #CHI-D50024 
                  " ORDER BY nmh26,nmh30"
      END CASE                                              
   ELSE
#NO.FUN-680034--BEGIN
      IF g_detail = '2' THEN
         CASE g_nmz.nmz66
         WHEN '1'
           LET l_sql="SELECT nmh26,nmh261,nmh15,nmh11,nmh30,nmh01,oox05,oox07,SUM(oox10),'',nmd18",  #NO.FUN-680034  #CHI-D50024
                     "  FROM sort_file ",                                            
                     " GROUP BY nmh26,nmh261,nmh15,nmh11,nmh30,nmh01,oox05,oox07,nmd18 ",            #NO.FUN-680034  #CHI-D50024
                     " ORDER BY nmh26,nmh01"
         WHEN '2'                                                                  
           LET l_sql="SELECT nmh26,''nmh261,'','','',oox05,oox07,SUM(oox10),'',nmd18",               #CHI-D50024           
                     "  FROM sort_file ",                                         
                     #" GROUP BY nmh26,nmh261,,oox05,oox07 ",
                     #" ORDER BY nmh26,nmh261oox05,oox07"
                     " GROUP BY nmh26,nmh261,oox05,oox07,nmd18 ",     #FUN-D40107 add                #CHI-D50024
                     " ORDER BY nmh26,nmh261,oox05,oox07"       #FUN-D40107 add
         WHEN '3'
           LET l_sql="SELECT nmh26,''nmh261,'',nmh11,nmh30,oox05,oox07,SUM(oox10),'',nmd18 ",        #CHI-D50024  
                     "  FROM sort_file ",                                            
                     " GROUP BY nmh26,nmh261,nmh11,nmh30,oox05,oox07,nmd18",                         #CHI-D50024               
                     " ORDER BY nmh26,nmh261,nmh30"
         END CASE                                              
      END IF
#NO.FUN-680034--END
   END IF
   PREPARE q610_pre5 FROM l_sql                                                 
   IF STATUS THEN 
      CALL cl_err('q610_pre5',STATUS,1) LET g_success = 'N' RETURN 
   END IF
   DECLARE q610_npq1 CURSOR FOR q610_pre5
 
   LET l_npq.npqsys= 'NM'
   LET l_npq.npq00 = l_npp00
   LET l_npq.npq01 = l_trno
   LET l_npq.npq011= l_npp011
   LET l_npq.npq02 = 0
   LET l_npq.npq07f= 0
   LET l_npq.npq25 = 1
   LET l_npq.npqtype=l_npptype      #No.FUN-680034
   LET l_npq.npqlegal=g_legal       #FUN-980011 add

   #TQC-C80024--add--str--
   IF l_npq.npqtype = '0' THEN
      LET g_bookno3 = g_bookno1
   ELSE
      LET g_bookno3 = g_bookno2
   END IF
   #TQC-C80024--add--end--

   FOREACH q610_npq1 INTO l_sr.*                                                
      IF STATUS THEN                                                            
         CALL cl_err('q610_curs',STATUS,1) LET g_success = 'N' EXIT FOREACH                         
      END IF 
#NO.FUN680034--BEGIN           
#      LET l_npq.npq03 = l_sr.nmh26
     IF l_npptype='0'  THEN
         LET l_npq.npq03 = l_sr.nmh26 
     ELSE
         LET l_npq.npq03 =l_sr.nmh261
     END IF
#NO.FUN680034--END
      LET l_npq.npq05 = l_sr.nmh15
      LET l_npq.npq21 = l_sr.nmh11
      LET l_npq.npq22 = l_sr.nmh30
      LET l_npq.npq04 = NULL  #FUN-D10065
      IF g_detail = '1' THEN
         #FUN-D10065--mark--str--
         #IF g_nmz.nmz62 = '1' THEN
         #   LET l_npq.npq04 = l_sr.nmh01 CLIPPED,' ',
         #                     l_sr.oox05 CLIPPED,' ',
         #                     l_sr.oox07 USING '<<<<.<<<<'
         #END IF
         #FUN-D10065--mark--end
         IF g_nmz.nmz62 = '2' THEN
            LET l_npq.npq21 = 'MISC'
            LET l_npq.npq22 = ''
            #LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<<.<<<<' #FUN-D10065 mark
         END IF
         #FUN-D10065--mark--str--
         #IF g_nmz.nmz62 = '3' THEN
         #   LET l_npq.npq04 = l_sr.nmh11 CLIPPED,' ',
         #                     l_sr.oox05 CLIPPED,' ',
         #                     l_sr.oox07 USING '<<<<.<<<<'
         #END IF
         #FUN-D10065--mark--end
      ELSE
         #FUN-D10065--mark--str--
         #IF g_nmz.nmz66 = '1' THEN
         #   LET l_npq.npq04 = l_sr.nmh01 CLIPPED,' ',
         #                     l_sr.oox05 CLIPPED,' ',
         #                     l_sr.oox07 USING '<<<<.<<<<'
         #END IF
         #FUN-D10065--mark--end
         IF g_nmz.nmz66 = '2' THEN
            LET l_npq.npq21 = 'MISC'
            LET l_npq.npq22 = ''
            #LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<<.<<<<' #FUN-D10065 mark
         END IF
         #FUN-D10065--mark--str--
         #IF g_nmz.nmz66 = '3' THEN
         #   LET l_npq.npq04 = l_sr.nmh11 CLIPPED,' ',
         #                     l_sr.oox05 CLIPPED,' ',
         #                     l_sr.oox07 USING '<<<<.<<<<'
         #END IF
         #FUN-D10065--mark--end
      END IF
      LET l_npq.npq23 = l_sr.nmh01      
      LET l_npq.npq24 = l_sr.oox05                                              
      IF cl_null(l_sr.oox10) THEN LET l_sr.oox10 = 0 END IF
      IF l_sr.oox10 > 0 THEN   #匯兌收益
         LET l_npq.npq02 = l_npq.npq02 + 1                                      
         LET l_npq.npq06 = '1'                                                  
         LET l_npq.npq07 = l_sr.oox10                  
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
         IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
        
         #NO.FUN-5C0015 ---start
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)       #No.FUN-740028
         RETURNING l_npq.*
         #No.FUN-5C0015 ---end
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            IF g_detail = '1' THEN
               IF g_nmz.nmz62 = '1' THEN
                  LET l_npq.npq04 = l_sr.nmh01 CLIPPED,' ',
                                    l_sr.oox05 CLIPPED,' ',
                                    l_sr.oox07 USING '<<<<.<<<<'
               END IF
               IF g_nmz.nmz62 = '2' THEN
                  LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<<.<<<<'
               END IF
               IF g_nmz.nmz62 = '3' THEN
                  LET l_npq.npq04 = l_sr.nmh11 CLIPPED,' ',
                                    l_sr.oox05 CLIPPED,' ',
                                    l_sr.oox07 USING '<<<<.<<<<'
               END IF
            ELSE
               IF g_nmz.nmz66 = '1' THEN
                  LET l_npq.npq04 = l_sr.nmh01 CLIPPED,' ',
                                    l_sr.oox05 CLIPPED,' ',
                                    l_sr.oox07 USING '<<<<.<<<<'
               END IF
               IF g_nmz.nmz66 = '2' THEN
                  LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<<.<<<<'
               END IF
               IF g_nmz.nmz66 = '3' THEN
                  LET l_npq.npq04 = l_sr.nmh11 CLIPPED,' ',
                                    l_sr.oox05 CLIPPED,' ',
                                    l_sr.oox07 USING '<<<<.<<<<'
               END IF
            END IF
         END IF
         #FUN-D10065--add--end
         CALL s_def_npq31_npq34(l_npq.*,g_bookno1)                 #FUN-AA0087
         RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
 
         #TQC-C80024--add--str--
         SELECT aag05,aag06,aag42 INTO l_aag05,l_aag06,l_aag42 FROM aag_file     #CHI-D50024 add aag05
          WHERE aag01 = l_npq.npq03 AND aag00 = g_bookno3

         IF l_aag42 = 'Y' AND l_npq.npq06<>l_aag06 THEN
            LET l_npq.npq06 = l_aag06
            LET l_npq.npq07 = l_npq.npq07 * -1
            LET l_npq.npq07f = l_npq.npq07f * -1
         END IF
         #TQC-C80024--add--end--

         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         #No.CHI-D50024  --Begin       
         LET l_npq.npq05 = ''
         IF l_aag05='Y' THEN
            IF g_aaz.aaz90 !='Y' THEN     
               IF g_aza.aza26='2' THEN
                  IF cl_null(l_npq.npq05) THEN
                     LET l_npq.npq05 = l_sr.nmd18
                  END IF
               END IF
            END IF  
         ELSE
            LET l_npq.npq05 = ''
         END IF
         #No.CHI-D50024  --end
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('ins npq #11',SQLCA.SQLCODE,1)    #No.FUN-660146
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq #11",1)   #No.FUN-660146
            LET g_success = 'N' EXIT FOREACH
         END IF
      ELSE                #匯兌損失
         LET l_npq.npq07 = l_sr.oox10 * (-1)                                    
         LET l_npq.npq02 = l_npq.npq02 + 1                                      
         LET l_npq.npq06 = '2'                  
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
         IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
        
         #NO.FUN-5C0015 ---start
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)       #No.FUN-740028
         RETURNING l_npq.*
         #No.FUN-5C0015 ---end
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            IF g_detail = '1' THEN
               IF g_nmz.nmz62 = '1' THEN
                  LET l_npq.npq04 = l_sr.nmh01 CLIPPED,' ',
                                    l_sr.oox05 CLIPPED,' ',
                                    l_sr.oox07 USING '<<<<.<<<<'
               END IF
               IF g_nmz.nmz62 = '2' THEN
                  LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<<.<<<<'
               END IF
               IF g_nmz.nmz62 = '3' THEN
                  LET l_npq.npq04 = l_sr.nmh11 CLIPPED,' ',
                                    l_sr.oox05 CLIPPED,' ',
                                    l_sr.oox07 USING '<<<<.<<<<'
               END IF
            ELSE
               IF g_nmz.nmz66 = '1' THEN
                  LET l_npq.npq04 = l_sr.nmh01 CLIPPED,' ',
                                    l_sr.oox05 CLIPPED,' ',
                                    l_sr.oox07 USING '<<<<.<<<<'
               END IF
               IF g_nmz.nmz66 = '2' THEN
                  LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<<.<<<<'
               END IF
               IF g_nmz.nmz66 = '3' THEN
                  LET l_npq.npq04 = l_sr.nmh11 CLIPPED,' ',
                                    l_sr.oox05 CLIPPED,' ',
                                    l_sr.oox07 USING '<<<<.<<<<'
               END IF
            END IF
         END IF
         #FUN-D10065--add--end
         CALL s_def_npq31_npq34(l_npq.*,g_bookno1)                 #FUN-AA0087
         RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
 
         #TQC-C80024--add--str--
         SELECT aag05,aag06,aag42 INTO l_aag05,l_aag06,l_aag42 FROM aag_file  #CHI-D50024 add aag05
          WHERE aag01 = l_npq.npq03 AND aag00 = g_bookno3

         IF l_aag42 = 'Y' AND l_npq.npq06<>l_aag06 THEN
            LET l_npq.npq06 = l_aag06
            LET l_npq.npq07 = l_npq.npq07 * -1
            LET l_npq.npq07f = l_npq.npq07f * -1
         END IF
         #TQC-C80024--add--end--
  
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         #No.CHI-D50024  --Begin        
         LET l_npq.npq05 = ''
         IF l_aag05='Y' THEN
            IF g_aaz.aaz90 !='Y' THEN    
               IF g_aza.aza26='2' THEN
                  IF cl_null(l_npq.npq05) THEN
                     LET l_npq.npq05 = l_sr.nmd18
                  END IF
               END IF
            END IF   
         ELSE
            LET l_npq.npq05 = ''
         END IF
         #No.CHI-D50024  --end 
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('ins npq #22',SQLCA.SQLCODE,1)   #No.FUN-660146
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq #22",1)   #No.FUN-660146
            LET g_success = 'N' EXIT FOREACH
         END IF
      END IF
   END FOREACH
 
   DECLARE q610_oox05 CURSOR FOR
    SELECT UNIQUE oox05,oox07 FROM sort_file
   IF STATUS THEN                                                               
      CALL cl_err('q610_oox05',STATUS,0) LET g_success='N' RETURN 
   END IF        
 
   DECLARE q610_oox05_1 CURSOR FOR
    SELECT nms12,SUM(oox10)
      FROM sort_file
     WHERE oox05 = l_oox05
       AND oox07 = l_oox07
     GROUP BY nms12
   IF STATUS THEN                                                               
      CALL cl_err('q610_oox05_1',STATUS,0) LET g_success='N' RETURN  
   END IF        
 
   FOREACH q610_oox05 INTO l_oox05,l_oox07
      IF SQLCA.sqlcode THEN 
         CALL cl_err(l_oox05,SQLCA.sqlcode,0)
         LET g_success = 'N' EXIT FOREACH
      END IF
      FOR l_i = 1 TO 300                   #單身 ARRAY 乾洗
          INITIALIZE l_aap[l_i].* TO NULL
      END FOR
      LET l_i = 1
      FOREACH q610_oox05_1 INTO l_aap[l_i].*
         IF SQLCA.sqlcode THEN 
            CALL cl_err(l_aap[l_i].nms12,SQLCA.sqlcode,0)
            LET g_success = 'N' EXIT FOREACH
         END IF
         LET l_i = l_i + 1
      END FOREACH
      LET l_i = l_i - 1
      IF l_i = 2 AND ((l_aap[1].oox10 <= 0 AND l_aap[2].oox10 >= 0) #一正一負
         OR (l_aap[1].oox10 >= 0 AND l_aap[2].oox10 <= 0 )) THEN
         LET l_npq.npq21 = 'MISC'                                                   
         LET l_npq.npq22 = ''                                                   
         #LET l_npq.npq04 = l_oox05 CLIPPED,' ',l_oox07 USING '<<<<.<<<<' #FUN-D10065 mark
         LET l_npq.npq04 = NULL #FUN-D10065
         LET l_npq.npq23 = ''                                                   
         LET l_npq.npq24 = l_oox05                                                   
         LET l_npq.npq02 = l_npq.npq02 + 1
         IF (l_aap[1].oox10 + l_aap[2].oox10)>=0 THEN  #合并成一個科目
            IF l_aap[1].oox10 > 0 THEN              #收益
               LET l_npq.npq03 = l_aap[1].nms12
            ELSE
               LET l_npq.npq03 = l_aap[2].nms12
            END IF
            LET l_npq.npq06 = '2'
            LET l_npq.npq07 = l_aap[1].oox10 + l_aap[2].oox10 #總收益
         ELSE
            IF l_aap[1].oox10 < 0 THEN     #損失
               LET l_npq.npq03 = l_aap[1].nms12
            ELSE
               LET l_npq.npq03 = l_aap[2].nms12
            END IF
            LET l_npq.npq06 = '1'
            LET l_npq.npq07 = (l_aap[1].oox10 + l_aap[2].oox10) * -1
         END IF
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
         IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
        
         #NO.FUN-5C0015 ---start
         CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)      #No.FUN-740028
         RETURNING l_npq.*
         #No.FUN-5C0015 ---end
         #FUN-D10065--add--str--
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = l_oox05 CLIPPED,' ',l_oox07 USING '<<<<.<<<<'
         END IF
         #FUN-D10065--add--end
         CALL s_def_npq31_npq34(l_npq.*,g_bookno1)                 #FUN-AA0087
         RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
 
         #TQC-C80024--add--str--
         SELECT aag05,aag06,aag42 INTO l_aag05,l_aag06,l_aag42 FROM aag_file  #CHI-D50024 add aag05
          WHERE aag01 = l_npq.npq03 AND aag00 = g_bookno3

         IF l_aag42 = 'Y' AND l_npq.npq06<>l_aag06 THEN
            LET l_npq.npq06 = l_aag06
            LET l_npq.npq07 = l_npq.npq07 * -1
            LET l_npq.npq07f = l_npq.npq07f * -1
         END IF
         #TQC-C80024--add--end--

         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = g_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         #No.CHI-D50024  --Begin         
         LET l_npq.npq05 = ''
         IF l_aag05='Y' THEN
            IF g_aaz.aaz90 !='Y' THEN   
               IF g_aza.aza26='2' THEN
                  IF cl_null(l_npq.npq05) THEN
                     LET l_npq.npq05 = l_sr.nmd18
                  END IF
               END IF
            END IF  
         ELSE
            LET l_npq.npq05 = ''
         END IF
         #No.CHI-D50024  --end  
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('ins npq #12',SQLCA.SQLCODE,1)    #No.FUN-660146
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq #12",1)   #No.FUN-660146
            LET g_success = 'N' EXIT FOREACH
         END IF
      ELSE  #不是合并到一個科目中去
         FOREACH q610_oox05_1 INTO l_sr2.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(l_sr2.nms12,SQLCA.sqlcode,0)
               LET g_success = 'N' 
               EXIT FOREACH
            END IF
            IF cl_null(l_sr2.oox10) THEN LET l_sr2.oox10 = 0 END IF
            LET l_npq.npq21 = 'MISC'                                                   
            LET l_npq.npq22 = ''                                                   
            #LET l_npq.npq04 = l_oox05 CLIPPED,' ',l_oox07 USING '<<<<.<<<<' #FUN-D10065 mark
            LET l_npq.npq04 = NULL #FUN-D10065
            LET l_npq.npq23 = ''                                                   
            LET l_npq.npq24 = l_oox05                 
            LET l_npq.npq03 = l_sr2.nms12
            IF l_sr2.oox10 > 0 THEN  #收益
               LET l_npq.npq02 = l_npq.npq02 + 1
               LET l_npq.npq06 = '2'
               LET l_npq.npq07 = l_sr2.oox10
               MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
               IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
        
               #NO.FUN-5C0015 ---start
               CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)      #No.FUN-740028
               RETURNING l_npq.*
               #No.FUN-5C0015 ---end
               #FUN-D10065--add--str--
               IF cl_null(l_npq.npq04) THEN
                  LET l_npq.npq04 = l_oox05 CLIPPED,' ',l_oox07 USING '<<<<.<<<<'
               END IF
               #FUN-D10065--add--end
               CALL s_def_npq31_npq34(l_npq.*,g_bookno1)                 #FUN-AA0087
               RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
 
               #TQC-C80024--add--str--
               SELECT aag05,aag06,aag42 INTO l_aag05,l_aag06,l_aag42 FROM aag_file  #CHI-D50024 add aag05
                WHERE aag01 = l_npq.npq03 AND aag00 = g_bookno3

               IF l_aag42 = 'Y' AND l_npq.npq06<>l_aag06 THEN
                  LET l_npq.npq06 = l_aag06
                  LET l_npq.npq07 = l_npq.npq07 * -1
                  LET l_npq.npq07f = l_npq.npq07f * -1
               END IF
               #TQC-C80024--add--end--

               #FUN-D40118--add--str--
               SELECT aag44 INTO g_aag44 FROM aag_file
                WHERE aag00 = g_bookno3
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
               #FUN-D40118--add--end--
               #No.CHI-D50024  --Begin        
               LET l_npq.npq05 = ''
               IF l_aag05='Y' THEN
                  IF g_aaz.aaz90 !='Y' THEN  
                     IF g_aza.aza26='2' THEN
                        IF cl_null(l_npq.npq05) THEN
                           LET l_npq.npq05 = l_sr.nmd18
                        END IF
                     END IF
                  END IF 
               ELSE
                  LET l_npq.npq05 = ''
               END IF
               #No.CHI-D50024  --end  
               INSERT INTO npq_file VALUES (l_npq.*)
               IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#                 CALL cl_err('ins npq #12',SQLCA.SQLCODE,1)    #No.FUN-660146
                  CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq #12",1)   #No.FUN-660146
                  LET g_success = 'N' EXIT FOREACH
               END IF
            ELSE   #損失
               LET l_npq.npq02 = l_npq.npq02 + 1
               LET l_npq.npq06 = '1'
               LET l_npq.npq07 = l_sr2.oox10 * -1
               MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
               IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
        
               #NO.FUN-5C0015 ---start
               CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)       #No.FUN-740028
               RETURNING l_npq.*
               #No.FUN-5C0015 ---end
               #FUN-D10065--add--str--
               IF cl_null(l_npq.npq04) THEN
                  LET l_npq.npq04 = l_oox05 CLIPPED,' ',l_oox07 USING '<<<<.<<<<'
               END IF
               #FUN-D10065--add--end
               CALL s_def_npq31_npq34(l_npq.*,g_bookno1)                 #FUN-AA0087
               RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
 
               #TQC-C80024--add--str--
               SELECT aag05,aag06,aag42 INTO l_aag05,l_aag06,l_aag42 FROM aag_file   #CHI-D50024 add aag05
                WHERE aag01 = l_npq.npq03 AND aag00 = g_bookno3

               IF l_aag42 = 'Y' AND l_npq.npq06<>l_aag06 THEN
                  LET l_npq.npq06 = l_aag06
                  LET l_npq.npq07 = l_npq.npq07 * -1
                  LET l_npq.npq07f = l_npq.npq07f * -1
               END IF
               #TQC-C80024--add--end--

               #FUN-D40118--add--str--
               SELECT aag44 INTO g_aag44 FROM aag_file
                WHERE aag00 = g_bookno3
                  AND aag01 = l_npq.npq03
               IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
                  CALL s_chk_ahk(l_npq.npq03,g_bookno3) RETURNING l_flag
                  IF l_flag = 'N'   THEN
                     LET l_npq.npq03 = ''
                  END IF
               END IF
               #FUN-D40118--add--end--
               #No.CHI-D50024  --Begin        
               LET l_npq.npq05 = ''
               IF l_aag05='Y' THEN
                  IF g_aaz.aaz90 !='Y' THEN   
                     IF g_aza.aza26='2' THEN
                        IF cl_null(l_npq.npq05) THEN
                           LET l_npq.npq05 = l_sr.nmd18
                        END IF
                     END IF
                  END IF  
               ELSE
                  LET l_npq.npq05 = ''
               END IF
               #No.CHI-D50024  --end  
               INSERT INTO npq_file VALUES (l_npq.*)
               IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#                 CALL cl_err('ins npq #21',SQLCA.SQLCODE,1)    #No.FUN-660146
                  CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq #21",1)   #No.FUN-660146
                  LET g_success = 'N' EXIT FOREACH
               END IF
            END IF
         END FOREACH
      END IF
   END FOREACH
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021   
END FUNCTION

#FUN-D40107--add--str--
FUNCTION weight_evaluation()
   DEFINE l_str  STRING
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_detail = '1' THEN 
      LET l_str="gnmp610 '",g_oox01,"' '",g_oox02,"' 'N'"
   ELSE
      LET l_str="gnmp620 '",g_oox01,"' '",g_oox02,"' 'N'"
   END IF  
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 

FUNCTION evaluation_of_reduction()
   DEFINE l_str  STRING
   IF s_shut(0) THEN
      RETURN
   END IF
   IF g_detail = '1' THEN 
      LET l_str="gnmp611 '",g_oox01,"' '",g_oox02,"' 'N'"
   ELSE
      LET l_str="gnmp621 '",g_oox01,"' '",g_oox02,"' 'N'"
   END IF  
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 

FUNCTION carry_voucher()
   DEFINE l_str  STRING
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_detail) THEN 
      CALL cl_err('',-400,1)
      RETURN
   END IF 
   IF g_detail = '1' THEN 
      LET l_str="gxrp610 '4' '' '' '' '' '' 'N'"
   ELSE
      LET l_str="gxrp610 '5' '' '' '' '' '' 'N'"
   END IF  
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 

FUNCTION undo_carry_voucher()
   DEFINE l_str  STRING
   DEFINE l_nppglno  LIKE npp_file.nppglno
   IF s_shut(0) THEN
       RETURN
   END IF
   IF cl_null(g_detail) THEN 
      CALL cl_err('',-400,1)
      RETURN
   END IF 
   LET g_trno = 'NM',g_oox01 USING '&&&&',g_oox02 USING '&&'   
   IF g_detail = '1' THEN
      SELECT nppglno INTO l_nppglno FROM npp_file WHERE npp01 = g_trno AND npp00 = 14
   ELSE
      SELECT nppglno INTO l_nppglno FROM npp_file WHERE npp01 = g_trno AND npp00 = 15
   END IF  
   LET l_str="gxrp620 '' '' '",l_nppglno,"' 'N'"
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 
#FUN-D40107--add--end--
 
