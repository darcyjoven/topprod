# Prog. Version..: '5.30.07-13.06.13(00010)'     #
#
# Pattern name...: gnmq600.4gl
# Descriptions...: 外幣存款月底重評價異動記錄查詢
# Date & Author..: 02/03/14 By Danny
# Modify.........: No.FUN-4B0047 04/11/18 By Yuna 加轉excel檔功能
# Modify.........: No.FUN-4C0010 04/12/06 By Nicola 單價、金額欄位改為DEC(20,6)
# Modify.........: No.FUN-550037 05/05/13 By saki   欄位comment顯示
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.TQC-5B0076 05/11/09 By Claire excel匯出失效 
# Modify.........: FUN-5C0015 05/12/20 BY GILL (1)多Update 異動碼5~10, 關係人
#                  (2)若該科目有設彈性異動碼(agli120),則default帶出
#                     彈性異動碼的設定值(call s_def_npq: 抓取異動碼default值)
# Modify.........: No.MOD-630033 06/03/08 By Smapmin 因主鍵值有兩個故所抓出資料筆數有誤
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680034 06/08/29 By yjkhero 兩套帳修改
# Modify.........: No.FUN-680145 06/09/15 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0098 06/10/26 By atsea l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740028 07/04/10 By hongmei 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760156 07/07/02 By Rayven 修改s_def_npq的參數
# Modify.........: NO.MOD-860078 08/06/10 BY yiting ON IDLE
# Modify.........: No.MOD-910128 09/01/13 By chenyu s_get_bookno(放的位置不對，傳入的參數也有問題
# Modify.........: No.MOD-920264 09/02/19 By chenl 調整臨時表字段大小。
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A30028 10/03/30 By wujie 增加来源单据串查
# Modify.........: No:CHI-A30015 10/05/20 By Summer  1.單身增加顯示項次,2.勾選細項查詢時，改抓npk_file
# Modify.........: No:MOD-A50187 10/05/28 By Elva 增加接收参数，供aglq200串查
# Modify.........: No:MOD-AC0294 10/12/27 By Dido 變數宣告調整 
# Modify.........: No.FUN-AA0087 11/01/27 By chenmoyan 異動碼類型設定改善
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:MOD-C10158 12/01/18 By Polly 1.將q600_sortb_curs的SQL改用 PREPARE q600_pre1方式處理
#                                                  2.l_sql 改為 STRING
# Modify.........: No:TQC-C60038 12/06/04 By lujh 細項查詢不勾選時，點帳單明細查詢沒有值
# Modify.........: No:TQC-C80024 12/08/03 By lujh 生成分錄時，應按照aag42按餘額方向生成
# Modify.........: No:MOD-CB0166 12/11/16 By yinhy 查詢時默認anms101中的nmz21,nmz22
# Modify.........: No.FUN-D10065 13/01/15 By wangrr 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No:FUN-D40107 13/05/23 By lujh 新增狀態頁簽、畫面上的按鈕增加順序為:重評價產生,重評價還原,分錄底稿產生,分錄底稿,拋轉憑證,拋轉憑證還原
# Modify.........: No:FUN-D70002 13/08/27 By yangtt 新增時給原幣未沖金額(oox11)賦值
 
DATABASE ds
 
GLOBALS "../../config/top.global"
 
#模組變數(Module Variables)
DEFINE 
     g_oox00   LIKE oox_file.oox00,
    g_oox01   LIKE oox_file.oox01,
    g_oox02   LIKE oox_file.oox02,
    g_oox     DYNAMIC ARRAY OF RECORD
              oox03    LIKE oox_file.oox03,
              oox04    LIKE oox_file.oox04,  #CHI-A30015 add
              oox05    LIKE oox_file.oox05,
              oox06    LIKE oox_file.oox06,
              oox07    LIKE oox_file.oox07,
              oox11    LIKE oox_file.oox11,  #No.FUN-D70002   Add
              oox08    LIKE oox_file.oox08,
              oox09    LIKE oox_file.oox09,
              oox10    LIKE oox_file.oox10
              END RECORD,
     g_wc,g_wc2,g_sql string,  #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b          LIKE type_file.num10,   #NO.FUN-680145 INTEGER    #單身筆數
    g_trno           LIKE type_file.chr20,   #NO.FUN-680145 VARCHAR(20)
    g_tot            LIKE oox_file.oox09,    #NO.FUN-680145 DEC(20,6)  #No.FUN-4C0010
    g_detail         LIKE type_file.chr1     #NO.FUN-680145 CHAR(01)   #CHI-A30015 add,
   #oox01            LIKE oox_file.oox01,    #CHI-A30015 add   #MOD-AC0294 mark
   #oox02            LIKE oox_file.oox02     #CHI-A30015 add   #MOD-AC0294 mark
 
DEFINE   g_chr           LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #NO.FUN-680145 INTEGER   
DEFINE   g_msg           LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(72)
 
DEFINE   g_row_count     LIKE type_file.num10    #NO.FUN-680145 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #NO.FUN-680145 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #NO.FUN-680145 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #NO.FUN-680145 SMALLINT
DEFINE   g_bookno1       LIKE aza_file.aza81     #No.FUN-740028
DEFINE   g_bookno2       LIKE aza_file.aza82     #No.FUN-740028
DEFINE   g_bookno3       LIKE aag_file.aag00     #TQC-C80024  add
DEFINE   g_flag          LIKE type_file.chr1     #No.FUN-740028
DEFINE   g_argv1         STRING   # MOD-A50187
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
#     DEFINEl_time    LIKE type_file.chr8	     #No.FUN-6A0098
DEFINE    p_row,p_col    LIKE type_file.num5,    #NO.FUN-680145 SMALLINT
	  l_sl 		 LIKE type_file.num10    #NO.FUN-680145 INTEGER
 
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
 
    #add 030226 NO.A048
    DROP TABLE SORT_FILE;                                                           
    CREATE TEMP TABLE sort_file(
     nma01 LIKE nma_file.nma01,
     nma02 LIKE type_file.chr50,      #No.MOD-920264 nma02->chr50
     nma05 LIKE nma_file.nma05,
     nma051 LIKE nma_file.nma051,
     oox05 LIKE oox_file.oox05,
     oox07 LIKE oox_file.oox07,
     oox10 LIKE oox_file.oox10);
    IF STATUS THEN CALL cl_err('cre tmp',STATUS,0) EXIT PROGRAM END IF 
      CALL  cl_used(g_prog,g_time,1)       #計算使用時間 (進入時間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
         RETURNING g_time    #No.FUN-6A0098
    LET p_row = 3 LET p_col =5
    OPEN WINDOW q600_w AT p_row,p_col
         WITH FORM "gnm/42f/gnmq600" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    
    CALL cl_ui_init()
    CALL cl_set_act_visible("entry_sheet1",g_aza.aza63='Y')                      #No.FUN-680034
    #modify 030312 NO.A048
 
 
#    IF cl_chk_act_auth() THEN
#       CALL q600_q() 
#    END IF
    # MOD-A50187 --begin
    IF NOT cl_null(g_argv1) THEN
       CALL q600_q()
    END IF
    # MOD-A50187 --end

    CALL q600_menu()
    CLOSE WINDOW q600_w
    CALL  cl_used(g_prog,g_time,2)       #計算使用時間 (退出使間) #No.MOD-580088  HCN 20050818  #No.FUN-6A0098
         RETURNING g_time    #No.FUN-6A0098
END MAIN
 
#QBE 查詢資料
FUNCTION q600_cs()
   DEFINE l_wc      STRING              #CHI-A30015 add
   DEFINE l_bdate   LIKE type_file.dat  #CHI-A30015 add
   DEFINE l_edate   LIKE type_file.dat  #CHI-A30015 add

   CLEAR FORM #清除畫面
   CALL g_oox.clear()
   CALL cl_opmsg('q')
   LET g_detail = 'N'
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
 
   # MOD-A50187 --begin
   IF NOT cl_null(g_argv1) THEN
      LET g_detail = 'N'
      LET g_wc = g_argv1
   ELSE
   INPUT BY NAME g_detail WITHOUT DEFAULTS  
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)
 
 
      AFTER FIELD g_detail 
         IF cl_null(g_detail) OR g_detail NOT MATCHES '[YN]' THEN
            NEXT FIELD g_detail
     #No.MOD-910128 mark --begin
     ##No.FUN-740028 ---Begin
     #      CALL s_get_bookno(g_detail) RETURN g_flag,g_bookno1,g_bookno2                
     #        IF g_flag =  '1' THEN  #抓不到帳別                                          
     #           CALL cl_err(g_detail,'aoo-081',1)                                         
     #           NEXT FIELD g_detail 
     #        END IF
     ##No.FUN-740028 ---End
     #No.MOD-910128 mark --end
         END IF                                                                      
 
       ON IDLE g_idle_seconds   #NO.MOD-860078 
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
 
   INITIALIZE g_oox00 TO NULL    #No.FUN-750051
   INITIALIZE g_oox01 TO NULL    #No.FUN-750051
   INITIALIZE g_oox02 TO NULL    #No.FUN-750051

   IF g_detail = 'N' THEN   #CHI-A30015 add
      CONSTRUCT g_wc
         ON oox01,oox02,oox03,oox04,oox05,oox06,oox07,oox11,oox08,oox09,oox10  #CHI-A30015 add oox04  #No.FUN-D70002   Add oox11
         FROM oox01,oox02,s_oox[1].oox03,s_oox[1].oox04,                 #CHI-A30015 add s_oox[1].oox04 
              s_oox[1].oox05,s_oox[1].oox06,s_oox[1].oox07,
              s_oox[1].oox11,   #No.FUN-D70002   Add
              s_oox[1].oox08,s_oox[1].oox09,s_oox[1].oox10
                 #No.FUN-580031 --start--     HCN
                 BEFORE CONSTRUCT
                    DISPLAY g_nmz.nmz21 TO oox01  #MOD-CB0166
                    DISPLAY g_nmz.nmz22 TO oox02  #MOD-CB0166
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
 
      IF INT_FLAG THEN 
         RETURN 
      END IF
   #CHI-A30015 add  --start--
   ELSE
     #INPUT BY NAME oox01,oox02 #WITHOUT DEFAULTS               #MOD-AC0294 mark 
      INPUT g_oox01,g_oox02 WITHOUT DEFAULTS FROM oox01,oox02   #MOD-AC0294
         ON ACTION locale
           CALL cl_dynamic_locale()
           CALL cl_show_fld_cont()

         AFTER FIELD oox01 
            IF cl_null(g_oox01)  THEN    #MOD-AC0294 mod oox01 -> g_oox01
               NEXT FIELD oox01
            END IF                                                                      

         AFTER FIELD oox02 
            IF cl_null(g_oox02)  THEN    #MOD-AC0294 mod oox02 -> g_oox02
               NEXT FIELD oox02
            END IF             
                                                         
         ON IDLE g_idle_seconds 
            CALL cl_on_idle()
            CONTINUE INPUT
 
         ON ACTION about 
            CALL cl_about() 
 
         ON ACTION help
            CALL cl_show_help()
 
         ON ACTION controlg
            CALL cl_cmdask()
   
      END INPUT

      IF INT_FLAG THEN
         RETURN 
      END IF

      INITIALIZE g_oox00 TO NULL
     #INITIALIZE g_oox01 TO NULL                #MOD-AC0294 mark
     #INITIALIZE g_oox02 TO NULL                #MOD-AC0294 mark
      CONSTRUCT g_wc
         ON oox03,oox04,oox05,oox06,oox08
         FROM s_oox[1].oox03,s_oox[1].oox04, 
              s_oox[1].oox05,s_oox[1].oox06,s_oox[1].oox08
                 BEFORE CONSTRUCT
                    CALL cl_qbe_init()
         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE CONSTRUCT

         ON ACTION about
            CALL cl_about()

         ON ACTION help
            CALL cl_show_help()

         ON ACTION controlg
            CALL cl_cmdask()

         ON ACTION qbe_select
            CALL cl_qbe_select() 

         ON ACTION qbe_save
            CALL cl_qbe_save()

      END CONSTRUCT
      LET g_wc = g_wc CLIPPED,cl_get_extra_cond(null, null)

      IF INT_FLAG THEN 
         RETURN 
      END IF
   END IF
   #CHI-A30015 add  --end--
   END IF
   # MOD-A50187 --end
 
   MESSAGE ' WAIT ' 

   IF g_detail = 'N' THEN   #CHI-A30015 add
      LET g_sql="SELECT DISTINCT oox00,oox01,oox02 ",
                "  FROM oox_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND oox00 = 'NM' ", 
                " ORDER BY oox00,oox01 "
   #CHI-A30015 add --start--
   ELSE
       CALL cl_replace_str(g_wc,"oox03","npk00") RETURNING l_wc
       CALL cl_replace_str(l_wc,"oox04","npk01") RETURNING l_wc
       CALL cl_replace_str(l_wc,"oox05","npk05") RETURNING l_wc
       CALL cl_replace_str(l_wc,"oox06","npk06") RETURNING l_wc
       CALL cl_replace_str(l_wc,"oox08","npk09") RETURNING l_wc
      #CALL s_azn01(oox01,oox02) RETURNING l_bdate,l_edate       #MOD-AC0294 mark
       CALL s_azn01(g_oox01,g_oox02) RETURNING l_bdate,l_edate   #MOD-AC0294

      LET g_sql="SELECT COUNT(*) ",
                "  FROM nmg_file,npk_file ",
                " WHERE nmg00 = npk00 ",
                "   AND ",l_wc CLIPPED,
                "   AND nmg01 BETWEEN '", l_bdate ,"' AND '", l_edate,"'"
   END IF
   #CHI-A30015 add --end--
   PREPARE q600_prepare FROM g_sql
   IF STATUS THEN
      CALL cl_err('q600_pre',STATUS,1)
   END IF
   DECLARE q600_cs SCROLL CURSOR WITH HOLD FOR q600_prepare
#-----MOD-630033---------
   DROP TABLE x
   IF g_detail = 'N' THEN   #CHI-A30015 add
      LET g_sql="SELECT DISTINCT oox01,oox02 ",
                "  FROM oox_file ",
                " WHERE ",g_wc CLIPPED,
                "   AND oox00 = 'NM'  INTO TEMP x "
   #CHI-A30015 add --start--
   ELSE
      LET g_sql="SELECT DISTINCT nmg01 ",
                "  FROM nmg_file,npk_file ",
                " WHERE nmg00 = npk00 ",
                "   AND ",l_wc CLIPPED,
                "   AND nmg01 BETWEEN '", l_bdate ,"' AND '", l_edate ,"'",
                "   INTO TEMP x "
   END IF
   #CHI-A30015 add --end--
    PREPARE q600_precount_x FROM g_sql
    EXECUTE q600_precount_x
    LET g_sql = " SELECT COUNT(*) FROM x"
    PREPARE q600_precount FROM g_sql
    DECLARE q600_count CURSOR FOR q600_precount
{
   LET g_sql="SELECT COUNT(DISTINCT oox00) ",
             "  FROM oox_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND oox00 = 'NM' "  
    PREPARE q600_precount FROM g_sql
    DECLARE q600_count CURSOR FOR q600_precount
}
#-----END MOD-630033-----
END FUNCTION
 
FUNCTION q600_menu()
DEFINE l_ac     LIKE type_file.num5         #No.FUN-A30028
 
   WHILE TRUE
      CALL q600_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q600_q()
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
               CALL q600_v()
            END IF
         #WHEN "分錄底稿" 
         WHEN "entry_sheet" 
            #modify 030317 NO.A048
            IF cl_chk_act_auth() AND g_detail = 'N' THEN 
               LET g_trno = g_oox00,g_oox01 USING '&&&&',g_oox02 USING '&&'
#No.FUN-680034--begin
      #         CALL s_fsgl(g_oox00,13,g_trno,0,g_nmz.nmz02b,1,'N')
                CALL s_fsgl(g_oox00,13,g_trno,0,g_nmz.nmz02b,1,'N','0',g_ooz.ooz02p)
#No.FUN-680034--end
       END IF
#No.FUN-680034--begin
          WHEN "entry_sheet1"                                                                                                         
            IF cl_chk_act_auth() AND g_detail = 'N' THEN                                                                            
               LET g_trno = g_oox00,g_oox01 USING '&&&&',g_oox02 USING '&&'        
               CALL s_fsgl(g_oox00,13,g_trno,0,g_nmz.nmz02c,1,'N','1',g_ooz.ooz02p)                                                     
            END IF                                                             
#No.FUN-680034--end
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
                  IF g_detail ='N' THEN
                     #LET g_msg = "anmt300 '",g_oox[l_ac].oox03 CLIPPED,"'"          #TQC-C60038  mark
                     LET g_msg = "anmt300 '",g_oox[l_ac].oox03 CLIPPED,"' '' 'N'"     #TQC-C60038   add
                     CALL cl_cmdrun(g_msg)
                  END IF
                  IF g_detail ='Y' THEN
                     LET g_msg = "anmt302 '",g_oox[l_ac].oox03 CLIPPED,"'"
                     CALL cl_cmdrun(g_msg)
                  END IF
               END IF
            END IF
#No.FUN-A30028 --end
      END CASE
   END WHILE
END FUNCTION
 
FUNCTION q600_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting( g_curs_index, g_row_count )
    CALL cl_opmsg('q')
    CALL q600_cs()
    IF INT_FLAG THEN LET INT_FLAG = 0 RETURN END IF
    OPEN q600_count
    FETCH q600_count INTO g_row_count
    DISPLAY g_row_count TO FORMONLY.cnt  
    OPEN q600_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        CALL q600_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q600_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)     #處理方式
    l_abso          LIKE type_file.num10    #NO.FUN-680145 INTEGER    #絕對的筆數
 
    CASE p_flag
        WHEN 'N' FETCH NEXT     q600_cs INTO g_oox00,g_oox01,g_oox02
        WHEN 'P' FETCH PREVIOUS q600_cs INTO g_oox00,g_oox01,g_oox02
        WHEN 'F' FETCH FIRST    q600_cs INTO g_oox00,g_oox01,g_oox02
        WHEN 'L' FETCH LAST     q600_cs INTO g_oox00,g_oox01,g_oox02
        WHEN '/'
            IF (NOT mi_no_ask) THEN
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
            FETCH ABSOLUTE g_jump q600_cs INTO g_oox00,g_oox01,g_oox02
            LET mi_no_ask = FALSE
    END CASE
   #IF STATUS THEN  #CHI-A30015 mark
    IF STATUS OR g_row_count = 0 THEN   #CHI-A30015
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
 
    CALL q600_show()
 
END FUNCTION
 
FUNCTION q600_show()
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
   IF g_detail = 'N' THEN  #CHI-A30015 add
      DISPLAY g_oox01,g_oox02 TO oox01,oox02   # 顯示單頭值
   END IF                  #CHI-A30015 add
   CALL q600_b_fill() #單身
 
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION
 
FUNCTION q600_b_fill()              #BODY FILL UP
   #DEFINE l_sql     LIKE type_file.chr1000  #NO.FUN-680145  VARCHAR(1000) #MOD-C10158 mark
    DEFINE l_sql     STRING                  #MOD-C10158 add
    DEFINE l_bdate    LIKE type_file.dat  #CHI-A30015 add
    DEFINE l_edate    LIKE type_file.dat  #CHI-A30015 add

    #CHI-A30015 mark --start--
    #LET l_sql = "SELECT oox03,oox04,oox05,oox06,oox07,oox08,oox09,oox10",  #CHI-A30015 add oox04
    #            "  FROM oox_file ",
    #            " WHERE oox00 = '",g_oox00,"'",
    #            "   AND oox01 = ",g_oox01, 
    #            "   AND oox02 = ",g_oox02 
    ##modify 030312 NO.A048
    #IF g_detail = 'Y' THEN 
    #   LET l_sql = l_sql CLIPPED," AND oox03v = '2' "
    #ELSE
    #   LET l_sql = l_sql CLIPPED," AND oox03v = '1' "
    #END IF
    #LET l_sql = l_sql CLIPPED," ORDER BY oox03,oox05 "
    #CHI-A30015 mark --end--

    #CHI-A30015 add  --start--
    IF g_detail = 'N' THEN 
       LET l_sql = "SELECT oox03,oox04,oox05,oox06,oox07,oox11,oox08,oox09,oox10",  #No.FUN-D70002   Add oox11
                   "  FROM oox_file ",
                   " WHERE oox00 = '",g_oox00,"'",
                   "   AND oox01 = ",g_oox01, 
                   "   AND oox02 = ",g_oox02,
                   "   AND oox03v = '1' "
       LET l_sql = l_sql CLIPPED," ORDER BY oox03,oox05 "
    ELSE
      #CALL s_azn01(oox01,oox02) RETURNING l_bdate,l_edate        #MOD-AC0294 mark
       CALL s_azn01(g_oox01,g_oox02) RETURNING l_bdate,l_edate    #MOD-AC0294
       LET l_sql = "SELECT npk00,npk01,npk05,npk06,0,,0npk09,0,0",   #No.FUN-D70002   Add 0
                   "  FROM npk_file,nmg_file ",
                   " WHERE npk00 = nmg00 ",
                   "   AND nmg01 BETWEEN '",l_bdate,"' AND '",l_edate,"'"
       LET l_sql = l_sql CLIPPED," ORDER BY npk00,npk05 "
    END IF
    #CHI-A30015 add --end--
    PREPARE q600_pre2 FROM l_sql
    IF STATUS THEN CALL cl_err('q600_pre2',STATUS,1) END IF 
    DECLARE q600_bcs CURSOR FOR q600_pre2
 
    CALL g_oox.clear()
    LET g_cnt = 1
    LET g_tot = 0
    FOREACH q600_bcs INTO g_oox[g_cnt].*
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
 
FUNCTION q600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oox TO s_oox.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
#         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
#         LET l_sl = SCR_LINE()
         CALL cl_show_fld_cont()                #No.FUN-550037
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION first 
         CALL q600_fetch('F')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
           ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION previous
         CALL q600_fetch('P')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION jump 
         CALL q600_fetch('/')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION next
         CALL q600_fetch('N')
         CALL cl_navigator_setting(g_curs_index, g_row_count)   ###add in 040517
           IF g_rec_b != 0 THEN
         CALL fgl_set_arr_curr(1)  ######add in 040505
           END IF
	ACCEPT DISPLAY                   #No.FUN-530067 HCN TEST
                              
 
      ON ACTION last 
         CALL q600_fetch('L')
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
         CALL cl_show_fld_cont()   #FUN-550037(smin)
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
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
      #ON ACTION 會計分錄產生
      ON ACTION gen_entry    
         LET g_action_choice="gen_entry"   
         EXIT DISPLAY
      #ON ACTION 分錄底稿
      ON ACTION entry_sheet   
         LET g_action_choice="entry_sheet"
         EXIT DISPLAY
# No.FUN-680034 --start--                                                                                                           
      ON ACTION entry_sheet1                                                                                                        
         LET g_action_choice="entry_sheet1"                                                                                         
         EXIT DISPLAY                                                                                                               
# No.FUN-680034 ---end---
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

#No.FUN-A30028 --begin
      ON ACTION qry_oox
         LET g_action_choice="qry_oox"
         EXIT DISPLAY
#No.FUN-A30028 --end 
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
         EXIT DISPLAY  #TQC-5B0076
      ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
#modify 030317 NO.A048
FUNCTION q600_v()
   DEFINE l_trno   LIKE npp_file.npp01
   DEFINE l_buf    LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(70)
   DEFINE l_n      LIKE type_file.num5     #NO.FUN-680145 SMALLINT
   DEFINE l_npp00  LIKE npp_file.npp00
   DEFINE l_npp011 LIKE npp_file.npp011
   DEFINE l_nma05  LIKE nma_file.nma05
 
   IF cl_null(g_oox00) OR cl_null(g_oox01) OR cl_null(g_oox02) THEN 
      RETURN 
   END IF
   IF g_detail = 'Y' THEN RETURN END IF
 
#  DELETE FROM sort_file;        #No.FUN-680034
 
   #單號為系統別+年度+月份 
   LET l_trno = g_oox00,g_oox01 USING '&&&&',g_oox02 USING '&&'
 
   LET l_npp00  = 13
   LET l_npp011 = 1
   #已拋轉總帳
   SELECT COUNT(*) INTO l_n FROM npp_file
    WHERE npp01 = l_trno  AND nppglno IS NOT NULL 
      AND npp00 = l_npp00 AND nppsys = g_oox00 AND npp011 = l_npp011
   IF l_n > 0 THEN 
      CALL cl_err('sel npp','aap-122',0) RETURN 
   END IF
   SELECT COUNT(*) INTO l_n FROM npq_file 
    WHERE npq01 = l_trno  AND npq00 = l_npp00 
      AND npqsys= g_oox00 AND npq011= l_npp011
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
                                   
#NO.FUN-680034--begin                                           
 #  CALL q600_g_gl(l_npp00,l_npp011,l_trno)      
    CALL q600_g_gl(l_npp00,l_npp011,l_trno,'0')
     IF g_aza.aza63='Y' and g_success='Y' THEN
      CALL q600_g_gl(l_npp00,l_npp011,l_trno,'1')
     END IF                                 
#NO.FUN-680034--end                                           
   IF g_success = 'Y' THEN                                                      
      COMMIT WORK                                                               
   ELSE                                                                         
      ROLLBACK WORK                                                             
   END IF                 
END FUNCTION
 
#add 030226 NO.A048                                                             
FUNCTION q600_g_gl(l_npp00,l_npp011,l_trno,l_npptype) #NO.FUN-680034
   DEFINE l_npp00  LIKE npp_file.npp00
   DEFINE l_npp011 LIKE npp_file.npp011
   DEFINE l_trno   LIKE npp_file.npp01
   DEFINE l_npp    RECORD LIKE npp_file.*
   DEFINE l_npq    RECORD LIKE npq_file.*
   DEFINE l_oox03  LIKE oox_file.oox03
   DEFINE l_oox05  LIKE oox_file.oox05
   DEFINE l_oox07  LIKE oox_file.oox07
   DEFINE l_aag06  LIKE aag_file.aag06     #TQC-C80024 add
   DEFINE l_aag42  LIKE aag_file.aag42     #TQC-C80024 add
   DEFINE l_npptype LIKE npp_file.npptype  #NO.FUN-680034
   DEFINE b_date,e_date  LIKE type_file.dat      #NO.FUN-680145 DATE
   DEFINE l_nms    RECORD LIKE nms_file.*
  #DEFINE l_sql    LIKE type_file.chr1000,       #NO.FUN-680145 VARCHAR(500) #MOD-C10158 mark
   DEFINE l_sql    STRING,                       #MOD-C10158 add
          l_sort   RECORD                                                       
                   nma01 LIKE nma_file.nma01,                                   
                   nma02 LIKE nma_file.nma02,                                   
                   nma05 LIKE nma_file.nma05,                                   
                   nma051 LIKE nma_file.nma051,                  #No.FUN-680034                               
                   oox05 LIKE oox_file.oox05,                                   
                   oox07 LIKE oox_file.oox07,                                   
                   oox10 LIKE oox_file.oox10                                    
                   END RECORD,                                                  
         l_sr      RECORD                                                       
                   nma05 LIKE nma_file.nma05,                                   
                   nma051 LIKE nma_file.nma051,                  #No.FUN-680034                               
                   oox05 LIKE oox_file.oox05,                                   
                   oox07 LIKE oox_file.oox07,                                   
                   npq06 LIKE npq_file.npq06,                                   
                   npq07f LIKE npq_file.npq07f,                                 
                   npq07 LIKE npq_file.npq07,                                   
                   nma01 LIKE nma_file.nma01                                    
                   END RECORD,                 
           l_sr2   RECORD                                                       
                   oox05 LIKE oox_file.oox05,                                   
                   oox07 LIKE oox_file.oox07,                                   
                   oox10 LIKE oox_file.oox10                                    
                   END RECORD                                                   
   DEFINE l_flag   LIKE type_file.chr1    #FUN-D40118 add
 
   DELETE FROM npp_file WHERE npp01 = l_trno  AND npp00 = l_npp00
                          AND nppsys= g_oox00 AND npp011= l_npp011  #異動序號
                          AND npptype=l_npptype                     #No.FUN-680034
   DELETE FROM npq_file WHERE npq01 = l_trno  AND npq00 = l_npp00
                          AND npqsys= g_oox00 AND npq011= l_npp011  #異動序號
                          AND npqtype=l_npptype                     #No.FUN-680034
   DELETE FROM tic_file WHERE tic04 = l_trno  #FUN-B40056

   DELETE FROM sort_file;        #No.FUN-680034
                          
#NO.FUN-680034--begin                                           
 #  CALL s_azn01(g_oox01,g_oox02) RETURNING b_date,e_date
    IF g_aza.aza63='Y' AND g_success='Y' THEN
      IF l_npptype='0' THEN
       CALL s_azmm01(g_oox01,g_oox02,g_nmz.nmz02p,g_nmz.nmz02b) RETURNING b_date,e_date
      ELSE
       CALL s_azmm01(g_oox01,g_oox02,g_nmz.nmz02p,g_nmz.nmz02c) RETURNING b_date,e_date
      END IF
    ELSE
      CALL s_azn01(g_oox01,g_oox02)RETURNING b_date,e_date
   END IF
#NO.FUN-680034--end
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
   DECLARE nmz01 CURSOR FOR
     SELECT * FROM nms_file
      ORDER BY nms01
   IF g_nmz.nmz11 = 'N' THEN   #是否依部門區分預設會計科目
      SELECT * INTO l_nms.* FROM nms_file WHERE nms01 = ' '
      IF STATUS THEN                                                       
#        CALL cl_err('sel nms',STATUS,1)        #No.FUN-660146
         CALL cl_err3("sel","nms_file","","",STATUS,"","sel nms",1)   #No.FUN-660146
         LET g_success = 'N' RETURN   
      END IF 
   ELSE
      FOREACH nmz01 INTO l_nms.*   #任一部門
         IF STATUS THEN                                                       
            CALL cl_err('sel nms',STATUS,1) LET g_success = 'N' EXIT FOREACH
         END IF 
         EXIT FOREACH
      END FOREACH
   END IF
   LET l_npp.nppsys= g_oox00
   LET l_npp.npp00 = l_npp00
   LET l_npp.npp01 = l_trno
   LET l_npp.npp011= l_npp011
   LET l_npp.npp02 = e_date
   LET l_npp.npp03 = NULL
   LET l_npp.npptype = l_npptype          #No.FUN-680034              
   LET l_npp.npplegal= g_legal            #FUN-980011 add
 
   INSERT INTO npp_file VALUES(l_npp.*)
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#     CALL cl_err('ins npp',STATUS,1)    #No.FUN-660146
      CALL cl_err3("ins","npp_file",l_npp.npp01,l_npp.npp011,STATUS,"","ins npp",1)   #No.FUN-660146
      LET g_success = 'N' RETURN 
   END IF
 
   #有關注釋請看gapq600
  #----------------------------------MOD-C10158----------------------start
  #DECLARE q600_sortb_curs CURSOR FOR
  # SELECT nma01,nma02,nma05,nma051,oox05,oox07,oox10    #FUN-680034
  #   FROM oox_file,nma_file
  #  WHERE oox00=g_oox00 AND oox01=g_oox01 AND oox02=g_oox02
  #    AND nma01=oox03
   LET l_sql = "SELECT nma01,nma02,nma05,nma051,oox05,oox07,oox10 ",
               "  FROM oox_file,nma_file ",
               " WHERE oox00 = '",g_oox00,"'",
               "   AND oox01 = ",g_oox01,
               "   AND oox02 = ",g_oox02,
               "   AND nma01 = oox03 "
   PREPARE q600_sortb FROM l_sql

   IF STATUS THEN
      CALL cl_err('q600_sortb',STATUS,0) LET g_success='N' RETURN
   END IF
   DECLARE q600_sortb_curs CURSOR FOR q600_sortb

  #IF STATUS THEN
  #   CALL cl_err('q600_sortb_curs',STATUS,0) LET g_success='N' RETURN
  #END IF
  #----------------------------------MOD-C10158------------------------end 

   FOREACH q600_sortb_curs INTO l_sort.*                                        
     IF SQLCA.sqlcode THEN                                                      
        CALL cl_err(l_sort.nma01,SQLCA.sqlcode,0)                               
        LET g_success = 'N' EXIT FOREACH                                                            
     END IF                                       
     INSERT INTO sort_file VALUES(l_sort.nma01,l_sort.nma02,l_sort.nma05,   #No.FUN-680034
        l_sort.nma051,l_sort.oox05,l_sort.oox07,l_sort.oox10)
     IF SQLCA.sqlcode THEN                                                      
#       CALL cl_err(l_sort.nma01,SQLCA.sqlcode,0)                                  #No.FUN-660146
        CALL cl_err3("ins","sort_file","","",SQLCA.sqlcode,"","",0)   #No.FUN-660146
        LET g_success = 'N' EXIT FOREACH                                                            
     END IF                                                                     
   END FOREACH     
   CASE g_nmz.nmz09                                                             
      WHEN '1'
        LET l_sql="SELECT nma05,nma051,oox05,oox07,'',0,SUM(oox10),nma01",        #NO.FUN-680034 
                  "  FROM sort_file ",                                            
                  " GROUP BY nma05,nma051,nma01,oox05,oox07 " 
      WHEN '2'                                                                  
        LET l_sql="SELECT nma05,nma051,oox05,oox07,'',0,SUM(oox10),''", 
                  "  FROM sort_file ",                                         
                  " GROUP BY nma05,nma051,oox05,oox07 "                           #NO.FUN-680034      
   END CASE                                              
   PREPARE q600_pre5 FROM l_sql                                                 
   IF STATUS THEN 
      CALL cl_err('q600_pre5',STATUS,1) LET g_success = 'N' RETURN 
   END IF
   DECLARE q600_npq1 CURSOR FOR q600_pre5
 
   LET l_npq.npqsys= g_oox00
   LET l_npq.npq00 = l_npp00
   LET l_npq.npq01 = l_trno
   LET l_npq.npq011= l_npp011
   LET l_npq.npq02 = 0
   LET l_npq.npq07f= 0
   LET l_npq.npq21 = 'MISC'
   LET l_npq.npq25 = 1
   LET l_npq.npqtype = l_npptype         #No.FUN-680034
   LET l_npq.npqlegal= g_legal            #FUN-980011 add

   #TQC-C80024--add--str--
   IF l_npq.npqtype = '0' THEN
      LET g_bookno3 = g_bookno1
   ELSE
      LET g_bookno3 = g_bookno2
   END IF
   #TQC-C80024--add--str--

   FOREACH q600_npq1 INTO l_sr.*                                                
      IF STATUS THEN                                                            
         CALL cl_err('q600_curs',STATUS,1) LET g_success = 'N' EXIT FOREACH                         
      END IF            
      LET l_npq.npq24 = l_sr.oox05                                              
      #FUN-D10065--mark--str--
      #LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<<.<<<<'
      #IF g_nmz.nmz09 = '1' THEN
      #   LET l_npq.npq04 = l_sr.nma01 CLIPPED,' ',
      #                     l_sr.oox05 CLIPPED,' ',
      #                     l_sr.oox07 USING '<<<<.<<<<'
      #END IF
      #FUN-D10065--mark--end
      LET l_npq.npq04=NULL #FUN-D10065
      IF cl_null(l_sr.npq07) THEN LET l_sr.npq07 = 0 END IF
      IF l_sr.npq07 > 0 THEN   #匯兌收益
         LET l_npq.npq02 = l_npq.npq02 + 1      
#NO.FUN-680034--begin
#        LET l_npq.npq03 = l_sr.nma05 
         IF  l_npptype='0' THEN
           LET l_npq.npq03=l_sr.nma05
         ELSE
           LET l_npq.npq03=l_sr.nma051
         END IF
#NO.FUN-680034--end
         LET l_npq.npq06 = '1'                                                  
         LET l_npq.npq07 = l_sr.npq07                  
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
         IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
 
         #NO.FUN-5C0015 ---start
#        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)       #No.FUN-740028  #No.TQC-760156 mark
         IF g_nmz.nmz09 = '1' THEN  #No.TQC-760156
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_sr.nma01,g_oox01,g_oox02,g_bookno1)  #No.TQC-760156
                 RETURNING l_npq.*
            #FUN-D10065--add--str--
            IF cl_null(l_npq.npq04) THEN
               LET l_npq.npq04 = l_sr.nma01 CLIPPED,' ',
                                 l_sr.oox05 CLIPPED,' ',
                                 l_sr.oox07 USING '<<<<.<<<<'
            END IF
            #FUN-D10065--add--end
            CALL s_def_npq31_npq34(l_npq.*,g_bookno1)                      #FUN-AA0087     
                 RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
         END IF  #No.TQC-760156
         #No.FUN-5C0015 ---end
         #FUN-D10065--add--str--
         IF g_nmz.nmz09 <> '1' THEN
            CALL s_def_npq3(g_bookno1,l_npq.npq03,g_prog,l_sr.nma01,g_oox01,g_oox02) RETURNING l_npq.npq04
            IF cl_null(l_npq.npq04) THEN
               LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<<.<<<<'
            END IF
         END IF
         #FUN-D10065--add--end
 
         #TQC-C80024--add--str--
         SELECT aag06,aag42 INTO l_aag06,l_aag42 FROM aag_file
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
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('ins npq #11',SQLCA.SQLCODE,1)    #No.FUN-660146
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ns npq #11",1)   #No.FUN-660146
            LET g_success = 'N' EXIT FOREACH
         END IF
      ELSE                #匯兌損失
         LET l_npq.npq07 = l_sr.npq07 * (-1)                                    
         LET l_npq.npq02 = l_npq.npq02 + 1
#NO.FUN-680034--begin
#         LET l_npq.npq03 = l_sr.nma05    
         IF l_npptype='0' THEN
           LET l_npq.npq03=l_sr.nma05
         ELSE
           LET l_npq.npq03=l_sr.nma051
         END IF                 
#NO.FUN-680034--end                       
         LET l_npq.npq06 = '2'                  
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
         IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
 
         #NO.FUN-5C0015 ---start
#        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)      #NO.FUN-740028  #No.TQC-760156 mark
         IF g_nmz.nmz09 = '1' THEN  #No.TQC-760156
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_sr.nma01,g_oox01,g_oox02,g_bookno1)  #No.TQC-760156
                 RETURNING l_npq.*
            #FUN-D10065--add--str--
            IF cl_null(l_npq.npq04) THEN
               LET l_npq.npq04 = l_sr.nma01 CLIPPED,' ',
                                 l_sr.oox05 CLIPPED,' ',
                                 l_sr.oox07 USING '<<<<.<<<<'
            END IF
            #FUN-D10065--add--end
            CALL s_def_npq31_npq34(l_npq.*,g_bookno1)                      #FUN-AA0087     
                 RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
         END IF  #No.TQC-760156
         #No.FUN-5C0015 ---end
         #FUN-D10065--add--str--
         IF g_nmz.nmz09 <> '1' THEN
            CALL s_def_npq3(g_bookno1,l_npq.npq03,g_prog,l_sr.nma01,g_oox01,g_oox02) RETURNING l_npq.npq04
            IF cl_null(l_npq.npq04) THEN
               LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<<.<<<<'
            END IF
         END IF
         #FUN-D10065--add--end
 
         #TQC-C80024--add--str--
         SELECT aag06,aag42 INTO l_aag06,l_aag42 FROM aag_file
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
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('ins npq #22',SQLCA.SQLCODE,1)   #No.FUN-660146
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq #22",1)   #No.FUN-660146
            LET g_success = 'N' EXIT FOREACH
         END IF
      END IF
   END FOREACH
   DECLARE q600_sortc_curs CURSOR FOR                                           
    SELECT oox05,oox07,SUM(oox10)                                               
      FROM sort_file                                                            
     GROUP BY oox05,oox07         #No.FUN-680034 
   IF STATUS THEN                                                               
      CALL cl_err('q600_oox05',STATUS,0) LET g_success='N' RETURN     
   END IF  
 
   #No.TQC-760156 --start--
   LET l_npq.npq11=''
   LET l_npq.npq12=''
   LET l_npq.npq13=''
   LET l_npq.npq14=''
   LET l_npq.npq31=''
   LET l_npq.npq32=''
   LET l_npq.npq33=''
   LET l_npq.npq34=''
   LET l_npq.npq35=''
   LET l_npq.npq36=''
   LET l_npq.npq37=''
   #No.TQC-760156 --end--
 
   FOREACH q600_sortc_curs INTO l_sr2.*                                         
      IF SQLCA.sqlcode THEN                                                        
         CALL cl_err(l_sr2.oox05,SQLCA.sqlcode,0)                                  
         LET g_success = 'N' EXIT FOREACH                                                              
      END IF                                                                       
      IF cl_null(l_sr2.oox10) THEN LET l_sr2.oox10 = 0 END IF                      
      LET l_npq.npq21 = 'MISC'                                                     
      LET l_npq.npq22 = ''                                                         
      #LET l_npq.npq04 = l_sr2.oox05 CLIPPED,' ',l_sr2.oox07 USING '<<<<.<<<<' #FUN-D10065 mark
      LET l_npq.npq23 = ''                                                         
      LET l_npq.npq24 = l_sr2.oox05                        
      IF l_sr2.oox10 > 0 THEN 
         LET l_npq.npq02 = l_npq.npq02 + 1
         LET l_npq.npq06 = '2'
#NO.FUN-680034--begin
#         LET l_npq.npq03 = l_nms.nms12
         IF l_npptype='0' THEN
          LET l_npq.npq03=l_nms.nms12
         ELSE
          LET l_npq.npq03=l_nms.nms121
         END IF
#NO.FUN-680034--end
         LET l_npq.npq07 = l_sr2.oox10
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
         IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
 
         #NO.FUN-5C0015 ---start
#        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)       #No.FUN-740028  #No.TQC-760156 mark
#        RETURNING l_npq.*    #No.TQC-760156 mark
         #No.FUN-5C0015 ---end
         #FUN-D10065--add--str--
         LET l_npq.npq04=NULL
         CALL s_def_npq3(g_bookno1,l_npq.npq03,g_prog,l_npq.npq01,'','') RETURNING l_npq.npq04
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = l_sr2.oox05 CLIPPED,' ',l_sr2.oox07 USING '<<<<.<<<<'
         END IF
         #FUN-D10065--add--end
 
         #TQC-C80024--add--str--
         SELECT aag06,aag42 INTO l_aag06,l_aag42 FROM aag_file
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
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('ins npq #12',SQLCA.SQLCODE,1)    #No.FUN-660146
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq #12",1)   #No.FUN-660146
            LET g_success = 'N' EXIT FOREACH
         END IF
      ELSE
         LET l_npq.npq02 = l_npq.npq02 + 1
#NO.FUN-680034--begin
   #      LET l_npq.npq03 = l_nms.nms13
          IF l_npptype='0' THEN
           LET  l_npq.npq03 =l_nms.nms13
          ELSE
           LET  l_npq.npq03= l_nms.nms131
         END IF   
#NO.FUN-680034--end
         LET l_npq.npq06 = '1'
         LET l_npq.npq07 = l_sr2.oox10 * -1
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
         IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
 
         #NO.FUN-5C0015 ---start
#        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno1)         #No.FUN-740028  #No.TQC-760156 mark
#        RETURNING l_npq.*    #No.TQC-760156 mark
         #No.FUN-5C0015 ---end
         #FUN-D10065--add--str--
         LET l_npq.npq04=NULL
         CALL s_def_npq3(g_bookno1,l_npq.npq03,g_prog,l_npq.npq01,'','') RETURNING l_npq.npq04
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = l_sr2.oox05 CLIPPED,' ',l_sr2.oox07 USING '<<<<.<<<<'
         END IF
         #FUN-D10065--add--end

 
         #TQC-C80024--add--str--
         SELECT aag06,aag42 INTO l_aag06,l_aag42 FROM aag_file
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
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('ins npq #21',SQLCA.SQLCODE,1)    #No.FUN-660146
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq #21",1)   #No.FUN-660146
            LET g_success = 'N' EXIT FOREACH
         END IF
      END IF
   END FOREACH
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021  
   MESSAGE ''
END FUNCTION

#FUN-D40107--add--str--
FUNCTION weight_evaluation()
   DEFINE l_str  STRING
   IF s_shut(0) THEN
       RETURN
   END IF
   LET l_str="gnmp600 '",g_oox01,"' '",g_oox02,"' 'N'"
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 

FUNCTION evaluation_of_reduction()
   DEFINE l_str  STRING
   IF s_shut(0) THEN
       RETURN
   END IF
   LET l_str="gnmp601 '",g_oox01,"' '",g_oox02,"' 'N'"
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 

FUNCTION carry_voucher()
   DEFINE l_str  STRING
   IF s_shut(0) THEN
       RETURN
   END IF
   LET l_str="gxrp610 '3' '' '' '' '' '' 'N'"
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 

FUNCTION undo_carry_voucher()
   DEFINE l_str  STRING
   DEFINE l_nppglno  LIKE npp_file.nppglno
   IF s_shut(0) THEN
       RETURN
   END IF
   LET g_trno = g_oox00,g_oox01 USING '&&&&',g_oox02 USING '&&'   
   SELECT nppglno INTO l_nppglno FROM npp_file WHERE npp01 = g_trno AND npp00 = 13
   LET l_str="gxrp620 '' '' '",l_nppglno,"' 'N'"
   CALL cl_cmdrun_wait(l_str)
END FUNCTION 
#FUN-D40107--add--end--
