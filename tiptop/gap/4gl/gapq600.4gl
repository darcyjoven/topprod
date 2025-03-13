# Prog. Version..: '5.30.07-13.06.13(00010)'     #
#
# Pattern name...: gapq600.4gl
# Descriptions...: 應付帳款月底重評價異動記錄查詢
# Date & Author..: 02/03/14 By Danny
# Modify.........: No.FUN-4B0009 04/11/02 By ching add '轉Excel檔' action
# Modify ........: No.FUN-4C0012 04/11/30 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: No.FUN-560011 05/06/07 By pengu CREATE TEMP TABLE 欄位放大
# Modify.........: No.MOD-580075 05/08/11 By Smapmin SQL語法修正
# Modify.........: FUN-5C0015 05/12/20 BY GILL (1)多Update 異動碼5~10, 關係人
#                  (2)若該科目有設彈性異動碼(agli120),則default帶出
#                     彈性異動碼的設定值(call s_def_npq: 抓取異動碼default值)
# Modify.........: No.TQC-630061 06/03/09 By Pengu 資料無法產生分錄底稿
# Modify.........: No.FUN-660071 06/06/13 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-680029 06/08/17 By Ray 多帳套修改
# Modify.........: No.FUN-690009 06/09/18 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0097 06/11/06 By hongmei l_time轉g_time
# Modify.........: No.TQC-6B0094 06/11/16 By Elva 匯出excel多一行空白
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740064 07/04/16 By lora    會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760156 07/07/02 By Rayven s_def_npq參數調整
# Modify.........: No.TQC-7B0088 07/11/15 By chenl   修改筆數統計sql
# Modify.........: No.FUN-7B0089 07/11/15 By Carrier 單身加入多帳期項次oox041
# Modify.........: No.MOD-830201 08/03/26 By Smapmin 修改2*的帳款,apa54的抓取方式
# Modify.........: No.FUN-850030 08/07/24 By dxfwo   加入傳參數功能
# Modify.........: No.FUN-920168 09/02/23 By dxfwo   把sql改為標准sql
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:FUN-A30028 10/03/30 By wujie   增加来源单据串查
#                                                    单头增加细项选择项，不选细项则按客户汇总
#                                                    单身增加供应商栏位
# Modify.........: No:CHI-A30012 10/05/20 By Summer 月底重評價產生分錄底稿的三種方式，都改為按單據apa54去匯總
#                                                   mark MOD-830201修改
# Modify.........: No:FUN-AA0087 11/01/26 By chenmoyan 異動碼類型設定改善
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:TQC-C80023 12/08/03 By lujh 生成分錄時，應按照aag42按餘額方向生成
# Modify.........: No:MOD-CB0160 12/11/16 By yinhy 查詢時默認aaps100中的apz21,apz22
# Modify.........: No:MOD-CB0187 12/11/21 By Polly 調整npq04欄位格式
# Modify.........: No.FUN-D10065 13/01/16 By wangrr 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                   判断若npq04 为空.则依原给值方式给值
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No:FUN-D40107 13/05/23 By zhangweib 新增狀態頁簽、畫面上的按鈕增加順序為:重評價產生,重評價還原,分錄底稿產生,分錄底稿,拋轉憑證,拋轉憑證還原
# Modify.........: No.FUN-D40121 13/06/27 By zhangweib 修改背景作業邏輯
# Modify.........: No.FUN-D70002 13/08/27 By yangtt 增加原幣未沖金額(oox11)的顯示
# Modify.........: No:CHI-D50024 13/08/29 By yinhy  产生分录底稿，应该增加逻辑，若科目有做部门管理，则需要将对应单据上单头的部门或者成本中心抓取（若agls103 有启用利润中心，则抓成本中心，否则抓取部门） 
# Modify.........: No.FUN-D90016 13/08/04 By yangtt 細項為Y,oma03和oma032欄位顯示；【賬款編號】欄位增加開窗功能

DATABASE ds

GLOBALS "../../config/top.global"

DEFINE
    g_oox00   LIKE oox_file.oox00,
    g_oox01   LIKE oox_file.oox01,
    g_oox02   LIKE oox_file.oox02,
    g_ooxacti LIKE oox_file.ooxacti,    #No.FUN-D40107   Add
    g_ooxuser LIKE oox_file.ooxuser,    #No.FUN-D40107   Add
    g_ooxgrup LIKE oox_file.ooxgrup,    #No.FUN-D40107   Add
    g_ooxmodu LIKE oox_file.ooxmodu,    #No.FUN-D40107   Add
    g_ooxdate LIKE oox_file.ooxdate,    #No.FUN-D40107   Add
    g_ooxcrat LIKE oox_file.ooxcrat,    #No.FUN-D40107   Add
    g_ooxoriu LIKE oox_file.ooxoriu,    #No.FUN-D40107   Add
    g_ooxorig LIKE oox_file.ooxorig,    #No.FUN-D40107   Add
    g_oox     DYNAMIC ARRAY OF RECORD
              #add 030306 NO.A048
              oox03v   LIKE oox_file.oox03v,
              oox03    LIKE oox_file.oox03,
              oox041   LIKE oox_file.oox041,  #No.FUN-7B0089
              apa05    LIKE apa_file.apa05,   #No.FUN-A30028
              pmc03    LIKE pmc_file.pmc03,   #No.FUN-A30028
              oox05    LIKE oox_file.oox05,
              oox06    LIKE oox_file.oox06,
              oox07    LIKE oox_file.oox07,
              oox11    LIKE oox_file.oox11,   #No.FUN-D70002   Add
              oox08    LIKE oox_file.oox08,
              oox09    LIKE oox_file.oox09,
              oox10    LIKE oox_file.oox10
              END RECORD,
    g_argv1          STRING,   #No.FUN-850030
    g_wc,g_wc2,g_sql STRING,  #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b          LIKE type_file.num10,   #NO.FUN-690009 INTEGER    #單身筆數
    g_trno           LIKE oox_file.oox03,    #NO.FUN-690009 VARCHAR(20)   #No.FUN-680029
    g_tot            LIKE oox_file.oox09     #NO.FUN-690009 DEC(20,6)  #FUN-4C0012

DEFINE g_sql_tmp         STRING                  #FUN-920168
DEFINE g_chr             LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(1)
DEFINE g_cnt             LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE g_msg             LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(72)
DEFINE g_row_count       LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE g_curs_index      LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE g_jump            LIKE type_file.num10    #NO.FUN-690009 INTEGER
DEFINE mi_no_ask         LIKE type_file.num5     #NO.FUN-690009 SMALLINT
DEFINE g_flag            LIKE type_file.chr1     #No.FUN-740064
DEFINE g_bookno1         LIKE aza_file.aza81     #No.FUN-740064
DEFINE g_bookno2         LIKE aza_file.aza82     #No.FUN-740064
DEFINE g_bookno3         LIKE aza_file.aza82     #No.FUN-740064
DEFINE g_detail          LIKE type_file.chr1     #NO.FUN-A30028
DEFINE l_ac              LIKE type_file.num5     #No.FUN-A30028
DEFINE g_aag44           LIKE aag_file.aag44     #FUN-D40118 add

MAIN
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理

   LET g_argv1  = ARG_VAL(1)  #No.FUN-850030

   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF

   WHENEVER ERROR CALL cl_err_msg_log

   IF (NOT cl_setup("GAP")) THEN
      EXIT PROGRAM
   END IF

    #add 030226 NO.A048
    DROP TABLE sort_file;
    CREATE TEMP TABLE sort_file(
     oox03v LIKE oox_file.oox03v,
     apa01 LIKE apa_file.apa01,
     apa54 LIKE apa_file.apa54,
     apa541 LIKE apa_file.apa541,
     apa06 LIKE apa_file.apa06,
     apa07 LIKE apa_file.apa07,
     apa22 LIKE apa_file.apa22,
     apa930 LIKE apa_file.apa930,      #CHI-D50024       
     oox05 LIKE oox_file.oox05,
     oox07 LIKE oox_file.oox07,
     oox10 LIKE oox_file.oox10,
     aps42 LIKE aps_file.aps42);
    IF STATUS THEN CALL cl_err('cre tmp',STATUS,0) EXIT PROGRAM END IF

    CALL cl_used(g_prog,g_time,1) RETURNING g_time    #No.FUN-6A0097

    OPEN WINDOW q600_w WITH FORM "gap/42f/gapq600"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN

    CALL cl_ui_init()

    IF NOT cl_null(g_argv1) THEN
       CALL q600_q()
    END IF

    CALL q600_menu()
    CLOSE WINDOW q600_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0097
END MAIN

#QBE 查詢資料
FUNCTION q600_cs()
DEFINE   l_sql      STRING      #No.TQC-7B0088

   CLEAR FORM #清除畫面
   CALL g_oox.clear()
   CALL cl_opmsg('q')
   #modify 030306 NO.A048
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
#No.FUN-A30028 --begin
   LET g_detail = 'Y'
   IF cl_null(g_argv1) THEN   #No.FUN-D40121   Add
   INPUT BY NAME g_detail WITHOUT DEFAULTS
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)

      AFTER FIELD g_detail
         IF cl_null(g_detail) OR g_detail NOT MATCHES '[YN]' THEN
            NEXT FIELD g_detail
         END IF
         CALL cl_set_comp_visible("oox03,oox041,apa05,pmc03,oox11",TRUE)  #No.FUN-D70002 add oox11
         CALL cl_set_act_visible("qry_apa", TRUE)
         IF g_detail ='N' THEN
            CALL cl_set_comp_visible("oox03,oox041,oox11", FALSE)  #No.FUN-D70002 add oox11
            CALL cl_set_act_visible("qry_apa", FALSE)
        #ELSE   #FUN-D90016 mark
        #   CALL cl_set_comp_visible("apa05,pmc03", FALSE)  #FUN-D90016 mark
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
#No.FUN-A30028 --end
   #No.FUN-D40121 ---Add--- Start
   ELSE
      IF g_detail ='N' THEN
         CALL cl_set_comp_visible("oox03,oox041,oox11", FALSE)    #No.FUN-D70002 add oox11
         CALL cl_set_act_visible("qry_apa", FALSE)
     #ELSE             #FUN-D90016 mark
     #   CALL cl_set_comp_visible("apa05,pmc03,oox11", FALSE)     #No.FUN-D70002 add oox11 #FUN-D90016 mark
      END IF
   END IF
  #No.FUN-D40121 ---Add--- End
   INITIALIZE g_oox00 TO NULL    #No.FUN-750051
   INITIALIZE g_oox01 TO NULL    #No.FUN-750051
   INITIALIZE g_oox02 TO NULL    #No.FUN-750051
   #No.FUN-850030  --Begin
   IF NOT cl_null(g_argv1) THEN
      LET g_wc = g_argv1
   ELSE
   CONSTRUCT g_wc ON oox01,oox02,oox03v,oox03,oox041,oox05,oox06,oox07,oox11,oox08,  #No.FUN-7B0089  #No.FUN-D70002 add oox11
                     oox09,oox10
                FROM oox01,oox02,s_oox[1].oox03v,s_oox[1].oox03,
                     s_oox[1].oox041,     #No.FUN-7B0089
                     s_oox[1].oox05,s_oox[1].oox06,s_oox[1].oox07,
                     s_oox[1].oox11,        #No.FUN-D70002   Add
                     s_oox[1].oox08,s_oox[1].oox09,s_oox[1].oox10

     #No.FUN-580031 --start--     HCN
     BEFORE CONSTRUCT
         DISPLAY g_apz.apz21 TO oox01  #MOD-CB0160
         DISPLAY g_apz.apz22 TO oox02  #MOD-CB0160
         CALL cl_qbe_init()
      #No.FUN-580031 --end--       HCN

      #FUN-D90016-----add---str--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oox03)  #genero要改查單據單(未改)
               CALL cl_init_qry_var()
               LET g_qryparam.state = "c"
               LET g_qryparam.form ="q_apa07"
              #LET g_qryparam.arg1 = g_oox[1].oox03v
               CALL cl_create_qry() RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO oox03
               NEXT FIELD oox03
         END CASE
      #FUN-D90016-----add---end--
                                 
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
   END IF
   #No.FUN-850030  --End
   IF INT_FLAG THEN RETURN END IF

   MESSAGE ' WAIT '
   LET g_sql="SELECT DISTINCT oox00,oox01,oox02 ",
             "  FROM oox_file ",
             " WHERE ",g_wc CLIPPED,
             "   AND oox00 = 'AP' ",
             " ORDER BY oox00,oox01 "
   PREPARE q600_prepare FROM g_sql
   IF STATUS THEN CALL cl_err('q600_pre',STATUS,1) END IF
   DECLARE q600_cs SCROLL CURSOR WITH HOLD FOR q600_prepare
  #No.TQC-7B0088--begin-- Modify
  #LET g_sql="SELECT COUNT(DISTINCT oox01) ",
  #          "  FROM oox_file ",
  #          " WHERE ",g_wc CLIPPED,
  #          "   AND oox00 = 'AP' "
  #PREPARE q600_precount FROM g_sql
#FUN-920168 ----- Begin-----
#   LET l_sql="SELECT COUNT(*) ",
#             "  FROM ( ",g_sql CLIPPED,")"
#   PREPARE q600_precount FROM l_sql
#  #No.TQC-7B0088---end--- Modify
#   DECLARE q600_count CURSOR FOR q600_precount

    LET g_sql_tmp = "SELECT DISTINCT oox00,oox01,oox02 ",
                "  FROM oox_file ",
                " WHERE ", g_wc CLIPPED,
                "   AND oox00 = 'AP' ",
         #      " ORDER BY oox00,oox01 ",
                " INTO TEMP x "
    DROP TABLE x
    PREPARE q600_pre_x FROM g_sql_tmp
    EXECUTE q600_pre_x

    LET g_sql = "SELECT COUNT(*) FROM x"
    PREPARE q600_precount FROM g_sql
    DECLARE q600_count CURSOR FOR q600_precount
#FUN-920168 ----- End -----
END FUNCTION

FUNCTION q600_menu()

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

         #FUN-4B0009
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_oox),'','')
             END IF
         #--

        #No.FUN-D40107 ---Add--- Start
         WHEN "Reveluation"
            IF cl_chk_act_auth() THEN
               CALL q600_gapp601()
            END IF
         WHEN "UndoReveluation"
            IF cl_chk_act_auth() THEN
               CALL q600_gapp600()
            END IF
        #No.FUN-D40107 ---Add--- End
         
         #@WHEN "產生分錄"
         WHEN "gen_entry"
            IF cl_chk_act_auth() THEN
               IF g_detail ='N' THEN             #No.FUN-A30028
                  CALL cl_err('','gxr-006',1)    #No.FUN-A30028
               ELSE                              #No.FUN-A30028
                  CALL q600_v()
               END IF                            #No.FUN-A30028
            END IF
         #@WHEN "分錄底稿"
         WHEN "entry_sheet"
            IF cl_chk_act_auth() THEN
               LET g_trno = g_oox00,g_oox01 USING '&&&&',g_oox02 USING '&&'
               CALL s_fsgl(g_oox00,5,g_trno,0,g_apz.apz02b,1,'N','0',g_ooz.ooz02p)     #No.FUN-680029
            END IF
         #No.FUN-680029 --begin
         #@WHEN "分錄底稿2"
         WHEN "entry_sheet2"
            IF cl_chk_act_auth() THEN
               LET g_trno = g_oox00,g_oox01 USING '&&&&',g_oox02 USING '&&'
               CALL s_fsgl(g_oox00,5,g_trno,0,g_apz.apz02c,1,'N','1',g_ooz.ooz02p)
            END IF
         #No.FUN-680029 --end
        #No.FUN-A30028 --begin
         WHEN "qry_apa"
            IF cl_chk_act_auth() THEN
               LET l_ac = ARR_CURR()
               IF NOT cl_null(l_ac) AND l_ac <> 0 THEN
                  CALL q600_apa_q()
               END IF
            END IF
        #No.FUN-A30028 --end
        #No.FUN-D40107 ---Add--- Start
         WHEN "carry_voucher"
            IF cl_chk_act_auth() THEN
               CALL q600_gxrp610()
            END IF
         WHEN "undo_carry_voucher"
            IF cl_chk_act_auth() THEN
               CALL q600_gxrp620()
            END IF
        #No.FUN-D40107 ---Add--- End
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
    OPEN q600_cs                            # 從DB產生合乎條件TEMP(0-30秒)
    IF SQLCA.sqlcode THEN
       CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
       OPEN q600_count
       FETCH q600_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt
       CALL q600_fetch('F')                  # 讀出TEMP第一筆並顯示
    END IF
    MESSAGE ''
END FUNCTION

FUNCTION q600_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #NO.FUN-690009 VARCHAR(1)     #處理方式
    l_abso          LIKE type_file.num10    #NO.FUN-690009 INTEGER     #絕對的筆數

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

       CALL cl_navigator_setting( g_curs_index, g_row_count )
    END IF

    CALL q600_show()
END FUNCTION

FUNCTION q600_show()
   DISPLAY g_oox01,g_oox02 TO oox01,oox02
  #No.FUN-D40107 ---Add--- Start
   SELECT DISTINCT ooxacti,ooxuser,ooxgrup,ooxmodu,
                   ooxdate,ooxcrat,ooxoriu,ooxorig
     INTO g_ooxacti,g_ooxuser,g_ooxgrup,g_ooxmodu,
          g_ooxdate,g_ooxcrat,g_ooxoriu,g_ooxorig
     FROM oox_file
    WHERE oox01 = g_oox01
      AND oox02 = g_oox02
      AND oox00 = g_oox00
   DISPLAY g_ooxacti,g_ooxuser,g_ooxgrup,g_ooxmodu,
           g_ooxdate,g_ooxcrat,g_ooxoriu,g_ooxorig
        TO ooxacti,ooxuser,ooxgrup,ooxmodu,
           ooxdate,ooxcrat,ooxoriu,ooxorig
  #No.FUN-D40107 ---Add--- Start
   CALL q600_b_fill() #單身
    CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
END FUNCTION

FUNCTION q600_b_fill()              #BODY FILL UP
    DEFINE l_sql     LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(1000)

    #modify 030306 NO.A048
#   LET l_sql = "SELECT oox03v,oox03,oox041,oox05,oox06,oox07,oox08,oox09,oox10",  #No.FUN-7B0089
   #LET l_sql = "SELECT oox03v,oox03,oox041,'','',oox05,oox06,oox07,oox11,oox08,oox09,oox10",  #No.FUN-7B0089   #No.FUN-A30028  #No.FUN-D70002   Add oox11 #FUN-D90016 mark
    LET l_sql = "SELECT oox03v,oox03,oox041,apa05,'',oox05,oox06,oox07,oox11,oox08,oox09,oox10",  #No.FUN-7B0089   #No.FUN-A30028   #No.FUN-D70002   Add oox11  #FUN-D90016 add
               #"  FROM oox_file ",            
                "  FROM oox_file,apa_file ",   #FUN-D90016 add
                " WHERE oox00 = '",g_oox00,"'",
                "   AND oox01 = ",g_oox01,
                "   AND oox02 = ",g_oox02,
                "   AND oox03 = apa01",    #FUN-D90016 add
                "   AND ",g_wc CLIPPED,
                " ORDER BY oox03v,oox03,oox041 "  #No.FUN-7B0089
#No.FUN-A30028 --begin
    IF g_detail = 'N' THEN
       LET l_sql = "SELECT oox03v,'','',apa05,'',oox05,oox06,oox07,0,SUM(oox08),SUM(oox09),SUM(oox10)", #No.FUN-D70002   Add 0
                   "  FROM oox_file,apa_file",
                   " WHERE oox00 = '",g_oox00,"'",
                   "   AND oox01 = ",g_oox01,
                   "   AND oox02 = ",g_oox02,
                   "   AND ",g_wc CLIPPED,
                   "   AND oox03 = apa01",
                   " GROUP BY oox03v,'','',apa05,'',oox05,oox06,oox07",
                   " ORDER BY oox03v,apa05,oox05,oox06,oox07"
    END IF
#No.FUN-A30028 --end
    PREPARE q600_pre2 FROM l_sql
    IF STATUS THEN CALL cl_err('q600_pre2',STATUS,1) END IF
    DECLARE q600_bcs CURSOR FOR q600_pre2

    FOR g_cnt = 1 TO g_oox.getLength()           #單身 ARRAY 乾洗
       INITIALIZE g_oox[g_cnt].* TO NULL
    END FOR
    LET g_cnt = 1
    LET g_tot = 0
    FOREACH q600_bcs INTO g_oox[g_cnt].*
        IF STATUS THEN CALL cl_err('Foreach:',STATUS,1) EXIT FOREACH END IF
        SELECT pmc03 INTO g_oox[g_cnt].pmc03 FROM pmc_file WHERE pmc01 = g_oox[g_cnt].apa05   #No.FUN-A30028
       #zhouxm170802 add start
        if g_oox[g_cnt].oox08=0 and g_oox[g_cnt].oox11=0 then
           continue foreach
        end if  
       #zhouxm170802 add end 
        LET g_tot = g_tot + g_oox[g_cnt].oox10
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_oox.deleteElement(g_cnt)  #TQC-6B0094
    LET g_rec_b = g_cnt - 1
    DISPLAY BY NAME g_tot
END FUNCTION

FUNCTION q600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #NO.FUN-690009 VARCHAR(1)


   IF p_ud <> "G" THEN
      RETURN
   END IF

   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "

   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oox TO s_oox.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)

      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #No.FUN-680029 --begin
         IF g_aza.aza63 = 'Y' THEN
            CALL cl_set_act_visible("entry_sheet2",TRUE)
         ELSE
            CALL cl_set_act_visible("entry_sheet2",FALSE)
         END IF
         #No.FUN-680029 --end

      #BEFORE ROW
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

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
          CALL cl_show_fld_cont()                   #No.FUN-550037 hmf

      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY

     #No.FUN-D40107 ---Add--- Start
      ON ACTION UndoReveluation
         LET g_action_choice = "UndoReveluation"
         EXIT DISPLAY

      ON ACTION Reveluation
         LET g_action_choice = "Reveluation"
         EXIT DISPLAY
     #No.FUN-D40107 ---Add--- End
      
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

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY

      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121


      #FUN-4B0009
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
      #--
       #No.MOD-530853  --begin
      ON ACTION cancel
             LET INT_FLAG=FALSE 		#MOD-570244	mars
         LET g_action_choice="exit"
         EXIT DISPLAY
       #No.MOD-530853  --end
        ON ACTION controls                             #No.FUN-6A0092
         CALL cl_set_head_visible("","AUTO")           #No.FUN-6A0092
#No.FUN-A30028 --begin
      ON ACTION qry_apa
         LET g_action_choice = 'qry_apa'
         EXIT DISPLAY
#No.FUN-A30028 --end
     
     #No.FUN-D40107 ---Add--- Start
      ON ACTION carry_voucher
         LET g_action_choice = "carry_voucher"
         EXIT DISPLAY
         
      ON ACTION undo_carry_voucher
         LET g_action_choice = "undo_carry_voucher"
         EXIT DISPLAY
         
     #No.FUN-D40107 ---Add--- End

      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---


   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION


FUNCTION q600_v()
   DEFINE l_trno   LIKE npp_file.npp01
   DEFINE l_buf    LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(70)
   DEFINE l_n      LIKE type_file.num5     #NO.FUN-690009 SMALLINT
   DEFINE l_npp00  LIKE npp_file.npp00
   DEFINE l_npp011 LIKE npp_file.npp011

   IF cl_null(g_oox00) OR cl_null(g_oox01) OR cl_null(g_oox02) THEN
      RETURN
   END IF

   DELETE FROM sort_file;

   #單號為系統別+年度+月份
   LET l_trno = g_oox00,g_oox01 USING '&&&&',g_oox02 USING '&&'

   LET l_npp00  = 5
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

   #No.FUN-680029 --begin
   CALL q600_g_gl(l_npp00,l_npp011,l_trno,'0')
   IF g_aza.aza63 = 'Y' THEN
      CALL q600_g_gl(l_npp00,l_npp011,l_trno,'1')
   END IF
   #No.FUN-680029 --end

   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
END FUNCTION

#add 030226 NO.A048
FUNCTION q600_g_gl(l_npp00,l_npp011,l_trno,l_npptype)
   DEFINE l_trno   LIKE npp_file.npp01
   DEFINE l_npp    RECORD LIKE npp_file.*
   DEFINE l_npq    RECORD LIKE npq_file.*
   DEFINE l_npp00  LIKE npp_file.npp00
   DEFINE l_npp011 LIKE npp_file.npp011
   DEFINE l_npptype LIKE npp_file.npptype
   DEFINE l_oox05  LIKE oox_file.oox05
   DEFINE l_oox07  LIKE oox_file.oox07
   DEFINE l_aag06  LIKE aag_file.aag06     #TQC-C80023 add
   DEFINE l_aag42  LIKE aag_file.aag42     #TQC-C80023 add
   DEFINE l_aps42,l_aps43 LIKE aps_file.aps42
   DEFINE l_aag05  LIKE aag_file.aag05     #CHI-D50024
   DEFINE b_date,e_date   LIKE type_file.dat      #NO.FUN-690009 DATE
   DEFINE l_sql    LIKE type_file.chr1000  #NO.FUN-690009 VARCHAR(500)
   DEFINE l_i      LIKE type_file.num5     #NO.FUN-690009 SMALLINT
   DEFINE p_aps    RECORD LIKE aps_file.*
   DEFINE l_aap    DYNAMIC ARRAY OF RECORD
                   aps42 LIKE aps_file.aps42,
                   oox10 LIKE oox_file.oox10
                   END RECORD
   DEFINE l_sort   RECORD
                   oox03v LIKE oox_file.oox03v,
                   apa01 LIKE apa_file.apa01,
                   apa54 LIKE apa_file.apa54,
                   apa541 LIKE apa_file.apa541,     #No.FUN-680029
                   apa06 LIKE apa_file.apa06,
                   apa07 LIKE apa_file.apa07,
                   apa22 LIKE apa_file.apa22,
                   apa930 LIKE apa_file.apa930,     #CHI-D50024  
                   oox05 LIKE oox_file.oox05,
                   oox07 LIKE oox_file.oox07,
                   oox10 LIKE oox_file.oox10
                   END RECORD,
          l_sr2    RECORD
                   aps42 LIKE aps_file.aps42,
                   oox10 LIKE oox_file.oox10
                   END RECORD,
          l_sr     RECORD
                   apa54 LIKE apa_file.apa54,
                   apa541 LIKE apa_file.apa541,     #No.FUN-680029
                   oox05 LIKE oox_file.oox05,
                   oox07 LIKE oox_file.oox07,
                   npq06 LIKE npq_file.npq06,
                   npq07f LIKE npq_file.npq07f,
                   npq07 LIKE npq_file.npq07,
                   apa06 LIKE apa_file.apa06,
                   apa07 LIKE apa_file.apa07,
                   apa01 LIKE apa_file.apa01,
                   apa22 LIKE apa_file.apa22,      #CHI-D50024
                   apa930 LIKE apa_file.apa930     #CHI-D50024 
                   END RECORD
   DEFINE l_flag   LIKE type_file.chr1    #FUN-D40118 add

   DELETE FROM npp_file WHERE npp01 = l_trno  AND npp00 = l_npp00
                          AND nppsys= g_oox00 AND npp011= l_npp011  #異動序號
                          AND npptype = l_npptype     #No.FUN-680029
   DELETE FROM npq_file WHERE npq01 = l_trno  AND npq00 = l_npp00
                          AND npqsys= g_oox00 AND npq011= l_npp011  #異動序號
                          AND npqtype = l_npptype     #No.FUN-680029
   #FUN-B40056--add--str--
   DELETE FROM tic_file WHERE tic04 = l_trno
   #FUN-B40056--add--end--

   #No.FUN-680029 --begin
   IF g_aza.aza63 = 'Y' THEN
      IF l_npptype = '0' THEN
         CALL s_azmm01(g_oox01,g_oox02,g_apz.apz02p,g_apz.apz02b) RETURNING b_date,e_date
      ELSE
         CALL s_azmm01(g_oox01,g_oox02,g_apz.apz02p,g_apz.apz02c) RETURNING b_date,e_date
      END IF
   ELSE
      CALL s_azn01(g_oox01,g_oox02) RETURNING b_date,e_date
   END IF
   #No.FUN-680029 --end

   INITIALIZE l_npp.* TO NULL
   INITIALIZE l_npq.* TO NULL
   LET l_npp.nppsys= g_oox00
   LET l_npp.npp00 = l_npp00
   LET l_npp.npp01 = l_trno
   LET l_npp.npp011= l_npp011
   LET l_npp.npp02 = e_date
   LET l_npp.npp03 = NULL
   LET l_npp.npptype = l_npptype     #No.FUN-680029
   LET l_npp.npplegal = g_legal #FUN-980011 add
   INSERT INTO npp_file VALUES(l_npp.*)
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
      #No.FUN-660071  --Begin
      #CALL cl_err('ins npp',STATUS,1)
      CALL cl_err3("ins","npp_file",l_npp.npp01,l_npp.npp011,STATUS,"","ins npp",1) #No.FUN-660071
      LET g_success = 'N' RETURN
      #No.FUN-660071  --End
   END IF

   DECLARE q600_sortb_curs CURSOR FOR
    SELECT oox03v,apa01,apa54,apa541,apa06,apa07,apa22,apa930,oox05,oox07,oox10     #No.FUN-680029 #CHI-D50024 add apa930
      FROM oox_file,apa_file
     WHERE oox00=g_oox00 AND oox01=g_oox01 AND oox02=g_oox02
       AND apa01=oox03
   IF STATUS THEN
      CALL cl_err('q600_sortb_curs',STATUS,0) LET g_success='N' RETURN
   END IF

   FOREACH q600_sortb_curs INTO l_sort.*
     IF SQLCA.sqlcode THEN
        CALL cl_err(l_sort.apa01,SQLCA.sqlcode,0)
        LET g_success = 'N' EXIT FOREACH
     END IF
     IF g_apz.apz13 = 'Y' THEN   #按部門區分預設會計科目
        IF NOT cl_null(l_sort.apa22) THEN
           SELECT * INTO p_aps.* FROM aps_file WHERE aps01 = l_sort.apa22
           IF STATUS THEN
              #No.FUN-660071  --Begin
              #CALL cl_err('sel aps',STATUS,1)
              CALL cl_err3("sel","aps_file",l_sort.apa22,"",STATUS,"","sel aps",1) #No.FUN-660071
              LET g_success = 'N' RETURN#No.9510
              #No.FUN-660071  --End
           END IF
        ELSE
           INITIALIZE p_aps.* TO NULL
        END IF
     ELSE
 #        SELECT * INTO p_aps.* FROM aps_file WHERE aps01 = ''   #MOD-580075
         SELECT * INTO p_aps.* FROM aps_file WHERE aps01 = ' '   #MOD-580075
        IF STATUS THEN
           #No.FUN-660071  --Begin
           #CALL cl_err('sel aps',STATUS,1)
           CALL cl_err3("sel","aps_file"," ","",STATUS,"","sel aps",1) #No.FUN-660071
           LET g_success = 'N' RETURN   #No.9510
           #No.FUN-660071  --End
        END IF
     END IF
     #No.FUN-680029 --begin
     IF l_npptype = '0' THEN
        LET l_aps42 = p_aps.aps42
        LET l_aps43 = p_aps.aps43
     ELSE
        LET l_aps42 = p_aps.aps421
        LET l_aps43 = p_aps.aps431
     END IF
     #No.FUN-680029 --end
   #CHI-A30012 mark --start--
   #  IF l_sort.oox03v MATCHES '2*' THEN    #2*.待扺
   #     #-----MOD-830201---------
   #     #CASE
   #     #    WHEN l_sort.oox03v='21' LET l_sort.apa54=p_aps.aps41
   #     #    WHEN l_sort.oox03v='22' LET l_sort.apa54=p_aps.aps41
   #     #    WHEN l_sort.oox03v='24' LET l_sort.apa54=p_aps.aps12
   #     #    #No.FUN-680029 --begin
   #     #    WHEN l_sort.oox03v='25' IF l_npptype = '0' THEN
   #     #                               LET l_sort.apa54=p_aps.aps13
   #     #                            ELSE
   #     #                               LET l_sort.apa541=p_aps.aps131
   #     #                            END IF
   #     #    #No.FUN-680029 --end
   #     #END CASE
   #     IF g_apz.apz42 <> '1' THEN
   #        CASE
   #         WHEN l_sort.oox03v='21'
   #              IF l_npptype = '0' THEN
   #                 LET l_sort.apa54=p_aps.aps41
   #              ELSE
   #                 LET l_sort.apa541=p_aps.aps411
   #              END IF
   #         WHEN l_sort.oox03v='22'
   #              IF l_npptype = '0' THEN
   #                 LET l_sort.apa54=p_aps.aps41
   #              ELSE
   #                 LET l_sort.apa541=p_aps.aps411
   #              END IF
   #         WHEN l_sort.oox03v='24'
   #              IF l_npptype = '0' THEN
   #                 LET l_sort.apa54=p_aps.aps12
   #              ELSE
   #                 LET l_sort.apa541=p_aps.aps121
   #              END IF
   #         WHEN l_sort.oox03v='25'
   #              IF l_npptype = '0' THEN
   #                 LET l_sort.apa54=p_aps.aps13
   #              ELSE
   #                 LET l_sort.apa541=p_aps.aps131
   #              END IF
   #        END CASE
   #     END IF
   #     #-----END MOD-830201-----
   #  END IF
   #CHI-A30012 mark --end--
     IF l_sort.oox10 > 0 THEN
        LET l_aps42 = l_aps43
     END IF
     INSERT INTO sort_file VALUES(l_sort.oox03v,l_sort.apa01,
                 l_sort.apa54,l_sort.apa541,l_sort.apa06,l_sort.apa07,l_sort.apa22,l_sort.apa930,    #No.FUN-680029   #CHI-D50024 add apa930
                 l_sort.oox05,l_sort.oox07,l_sort.oox10,l_aps42)
     IF SQLCA.sqlcode THEN
        #CALL cl_err(l_sort.apa01,SQLCA.sqlcode,0) #No.FUN-660071
        CALL cl_err3("ins","sort_file","","",SQLCA.sqlcode,"","",0) #No.FUN-660071
        LET g_success = 'N' EXIT FOREACH
     END IF
   END FOREACH
  #月底重評價分錄底稿產生方式
   CASE g_apz.apz42            #明細
      WHEN '1'
        LET l_sql="SELECT apa54,apa541,oox05,oox07,'',0,SUM(oox10),apa06,apa07,apa01,apa22,apa930",    #CHI-D50024",
                  "  FROM sort_file ",
                  " GROUP BY apa54,apa541,oox05,oox07,apa06,apa07,apa01,apa22,apa930 ",      #No.FUN-680029        #CHI-D50024
                  " ORDER BY apa01 "
      WHEN '2'
        LET l_sql="SELECT apa54,apa541,oox05,oox07,'',0,SUM(oox10),'','','',apa22,apa930",             #CHI-D50024
                  "  FROM sort_file ",
                  "  GROUP BY apa54,apa541,oox05,oox07,apa22,apa930",                                  #CHI-D50024
                  "  ORDER BY apa54,apa541,oox05 "        #No.FUN-680029
      WHEN '3'
        LET l_sql = "SELECT apa54,apa541,oox05,oox07,'',0,SUM(oox10),apa06,apa07,'',apa22,apa930",     #CHI-D50024
                    "  FROM sort_file ",
                    " GROUP BY apa54,apa541,oox05,oox07,apa06,apa07,apa22,apa930",                     #CHI-D50024
                    " ORDER BY apa06,apa54,apa541,oox05"    #No.FUN-680029
   END CASE
   PREPARE q600_pre5 FROM l_sql
   IF STATUS THEN CALL cl_err('q600_pre5',STATUS,1) LET g_success = 'N' END IF
   DECLARE q600_npq1 CURSOR FOR q600_pre5

   LET l_npq.npqsys= g_oox00
   LET l_npq.npq00 = l_npp00
   LET l_npq.npq01 = l_trno
   LET l_npq.npq011= l_npp011
   LET l_npq.npq02 = 0
   LET l_npq.npq07f= 0
   LET l_npq.npq21 = 'MISC'
   LET l_npq.npq25 = 1
   LET l_npq.npqtype = l_npptype
   LET l_npq.npqlegal = g_legal #FUN-980011 add

   #No.FUN-740064 --begin
   CALL s_get_bookno(YEAR(l_npp.npp02)) RETURNING g_flag,g_bookno1,g_bookno2
   IF g_flag = '1' THEN
      CALL cl_err(YEAR(l_npp.npp02),'aoo-081',1)
      LET g_success = 'N'
   END IF
   IF l_npq.npqtype = '0' THEN
      LET g_bookno3 = g_bookno1
   ELSE
      LET g_bookno3 = g_bookno2
   END IF
   #No.FUN-740064 --end
   FOREACH q600_npq1 INTO l_sr.*
      IF STATUS THEN
         CALL cl_err('q600_curs',STATUS,1) LET g_success = 'N' EXIT FOREACH
      END IF
      LET l_npq.npq24 = l_sr.oox05     #幣別
      LET l_npq.npq04 = NULL  #FUN-D10065
     #LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<<.<<<<'      #MOD-CB0187 mark
     #LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<&.<<<<'      #MOD-CB0187 add  #FUN-D10065 mark
      IF g_apz.apz42 = '1' THEN
         #LET l_npq.npq04 = l_sr.apa01 CLIPPED,' ',  #摘要=異動單號+幣別+重估匯率 #FUN-D10065 mark
         #                  l_sr.oox05 CLIPPED,' ',                               #FUN-D10065 mark
         #                  l_sr.oox07 USING '<<<<.<<<<'    #MOD-CB0187 mark  FUN-D10065 mark
         #                 l_sr.oox07 USING '<<<&.<<<<'     #MOD-CB0187 add   #FUN-D10065 mark
         LET l_npq.npq23 = l_sr.apa01  #立沖單號
         LET l_npq.npq21 = l_sr.apa06  #廠商編號
         LET l_npq.npq22 = l_sr.apa07  #廠商簡稱
      END IF
      IF g_apz.apz42 = '3' THEN
      #  LET l_npq.npq04 = l_sr.apa06 CLIPPED,' ', #摘要=廠商編號+幣別+重估匯率  #FUN-D10065 mark
      #                    l_sr.oox05 CLIPPED,' ',                              #FUN-D10065 mark
      #                   #l_sr.oox07 USING '<<<<.<<<<'     #MOD-CB0187 mark#FUN-D10065 mark
      #                    l_sr.oox07 USING '<<<&.<<<<'     #MOD-CB0187 add#FUN-D10065 mark
         LET l_npq.npq21 = l_sr.apa06
         LET l_npq.npq22 = l_sr.apa07
      END IF
      IF cl_null(l_sr.npq07) THEN LET l_sr.npq07 = 0 END IF
      IF l_sr.npq07 > 0 THEN   #匯兌收益
         LET l_npq.npq02 = l_npq.npq02 + 1
         #No.FUN-680029 --begin
         IF l_npptype = '0' THEN
            LET l_npq.npq03 = l_sr.apa54
         ELSE
            LET l_npq.npq03 = l_sr.apa541
         END IF
         #No.FUN-680029 --end
         LET l_npq.npq06 = '1'
         LET l_npq.npq07 = l_sr.npq07
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
         IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF

         #NO.FUN-5C0015 ---start
#        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)    #No.FUN-740064  #No.TQC-760156 mark
         IF g_apz.apz42 = '1' THEN  #No.TQC-760156
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_sr.apa01,g_oox01,g_oox02,g_bookno3)  #No.TQC-760156
                 RETURNING l_npq.*
            #FUN-D10065--add--str--
            IF cl_null(l_npq.npq04) THEN
               LET l_npq.npq04=l_sr.apa01 CLIPPED,' ',  #摘要=異動單號+幣別+重估匯率
                               l_sr.oox05 CLIPPED,' ',
                               l_sr.oox07 USING '<<<&.<<<<'
            END IF
            #FUN-D10065--add--end
            CALL s_def_npq31_npq34(l_npq.*,g_bookno3)                      #FUN-AA0087
                 RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
         END IF  #No.TQC-760156
         #No.FUN-5C0015 ---end
         #FUN-D10065--add--str--
         IF g_apz.apz42 <> '1' THEN
            CALL s_def_npq3(g_bookno3,l_npq.npq03,g_prog,l_sr.apa01,g_oox01,g_oox02) RETURNING l_npq.npq04
            IF cl_null(l_npq.npq04) THEN
               IF g_apz.apz42 = '3' THEN
                  LET l_npq.npq04 = l_sr.apa06 CLIPPED,' ', #摘要=廠商編號+幣別+重估匯率
                                    l_sr.oox05 CLIPPED,' ',
                                    l_sr.oox07 USING '<<<&.<<<<'
               ELSE
                  LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<&.<<<<'
               END IF
            END IF
         END IF
         #FUN-D10065--add--end

         #TQC-C80023--add--str--
         SELECT aag06,aag42 INTO l_aag06,l_aag42 FROM aag_file
          WHERE aag01 = l_npq.npq03 AND aag00 = g_bookno3

         IF l_aag42 = 'Y' AND l_npq.npq06<>l_aag06 THEN
            LET l_npq.npq06 = l_aag06
            LET l_npq.npq07 = l_npq.npq07 * -1
            LET l_npq.npq07f = l_npq.npq07f * -1
         END IF
         #TQC-C80023--add--end--

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
         SELECT aag05 INTO l_aag05 FROM aag_file   
          WHERE aag01 = l_npq.npq03 AND aag00 = g_bookno3         

         LET l_npq.npq05 = ''
         IF l_aag05 = 'Y' THEN
            IF g_aaz.aaz90='N' THEN
               IF cl_null(l_npq.npq05) THEN
                  LET l_npq.npq05 = l_sort.apa22
               END IF
            ELSE
               LET l_npq.npq05 = l_sort.apa930 
            END IF
         ELSE
            LET l_npq.npq05 = ''
         END IF   
         #No.CHI-D50024  --end 
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            #CALL cl_err('ins npq #11',SQLCA.SQLCODE,1)  #No.FUN-660071
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq011,SQLCA.sqlcode,"","ins npq#11",1) #No.FUN-660071
            LET g_success = 'N' EXIT FOREACH
         END IF
      ELSE                #匯兌損失
         LET l_npq.npq02 = l_npq.npq02 + 1
         LET l_npq.npq03 = l_sr.apa54
         LET l_npq.npq06 = '2'
         LET l_npq.npq07 = l_sr.npq07 * -1
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
         IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF

         #NO.FUN-5C0015 ---start
#        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)    #No.FUN-740064  #No.TQC-760156
         IF g_apz.apz42 = '1' THEN  #No.TQC-760156
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_sr.apa01,g_oox01,g_oox02,g_bookno3)  #No.TQC-760156
                 RETURNING l_npq.*
            #FUN-D10065--add--str--
            IF cl_null(l_npq.npq04) THEN
               LET l_npq.npq04=l_sr.apa01 CLIPPED,' ',  #摘要=異動單號+幣別+重估匯率
                               l_sr.oox05 CLIPPED,' ',
                               l_sr.oox07 USING '<<<&.<<<<'
            END IF
            #FUN-D10065--add--end
            CALL s_def_npq31_npq34(l_npq.*,g_bookno3)                      #FUN-AA0087
                 RETURNING l_npq.npq31,l_npq.npq32,l_npq.npq33,l_npq.npq34 #FUN-AA0087
         END IF  #No.TQC-760156
         #No.FUN-5C0015 ---end
         #FUN-D10065--add--str--
         IF g_apz.apz42 <> '1' THEN
            CALL s_def_npq3(g_bookno3,l_npq.npq03,g_prog,l_sr.apa01,g_oox01,g_oox02) RETURNING l_npq.npq04
            IF cl_null(l_npq.npq04) THEN
               IF g_apz.apz42 = '3' THEN
                  LET l_npq.npq04 = l_sr.apa06 CLIPPED,' ', #摘要=廠商編號+幣別+重估匯率
                                    l_sr.oox05 CLIPPED,' ',
                                    l_sr.oox07 USING '<<<&.<<<<'
               ELSE
                  LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<&.<<<<'
               END IF
            END IF
         END IF
         #FUN-D10065--add--end

         #TQC-C80023--add--str--
         SELECT aag06,aag42 INTO l_aag06,l_aag42 FROM aag_file
          WHERE aag01 = l_npq.npq03 AND aag00 = g_bookno3

         IF l_aag42 = 'Y' AND l_npq.npq06<>l_aag06 THEN
            LET l_npq.npq06 = l_aag06
            LET l_npq.npq07 = l_npq.npq07 * -1
            LET l_npq.npq07f = l_npq.npq07f * -1
         END IF
         #TQC-C80023--add--end--

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
         SELECT aag05 INTO l_aag05 FROM aag_file   
          WHERE aag01 = l_npq.npq03 AND aag00 = g_bookno3         

         LET l_npq.npq05 = ''
         IF l_aag05 = 'Y' THEN
            IF g_aaz.aaz90='N' THEN
               IF cl_null(l_npq.npq05) THEN
                  LET l_npq.npq05 = l_sort.apa22
               END IF
            ELSE
               LET l_npq.npq05 = l_sort.apa930 
            END IF
         ELSE
            LET l_npq.npq05 = ''
         END IF   
         #No.CHI-D50024  --end 
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            #CALL cl_err('ins npq #22',SQLCA.SQLCODE,1) #No.FUN-660071
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq011,SQLCA.sqlcode,"","ins npq#22",1) #No.FUN-660071
            LET g_success = 'N' EXIT FOREACH
         END IF
      END IF
   END FOREACH

   DECLARE q600_oox05 CURSOR FOR
    SELECT UNIQUE oox05,oox07 FROM sort_file
   IF STATUS THEN
      CALL cl_err('q600_oox05',STATUS,0) LET g_success='N' RETURN
   END IF

   DECLARE q600_oox05_1 CURSOR WITH HOLD FOR
    SELECT aps42,SUM(oox10)
      FROM sort_file
     WHERE oox05 = l_oox05
       AND oox07 = l_oox07
     GROUP BY aps42
   IF STATUS THEN
      CALL cl_err('q600_oox05_1',STATUS,0) LET g_success='N' RETURN
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

   FOREACH q600_oox05 INTO l_oox05,l_oox07
      IF SQLCA.sqlcode THEN
         CALL cl_err(l_oox05,SQLCA.sqlcode,0)
         LET g_success = 'N' EXIT FOREACH
      END IF
      FOR l_i = 1 TO 300                   #單身 ARRAY 乾洗
          INITIALIZE l_aap[l_i].* TO NULL
      END FOR
      LET l_i = 1
      FOREACH q600_oox05_1 INTO l_aap[l_i].*
         IF SQLCA.sqlcode THEN
            CALL cl_err(l_aap[l_i].aps42,SQLCA.sqlcode,0)
            LET g_success = 'N' EXIT FOREACH
         END IF
         LET l_i = l_i + 1
      END FOREACH
      LET l_i = l_i - 1
      IF l_i = 2 AND ((l_aap[1].oox10 <= 0 AND l_aap[2].oox10 >= 0) #一正一負
         OR (l_aap[1].oox10 >= 0 AND l_aap[2].oox10 <= 0 )) THEN
         LET l_npq.npq21 = 'MISC'
         LET l_npq.npq22 = ''
        #LET l_npq.npq04 = l_oox05 CLIPPED,' ',l_oox07 USING '<<<<.<<<<'     #MOD-CB0187 mark
        #LET l_npq.npq04 = l_oox05 CLIPPED,' ',l_oox07 USING '<<<&.<<<<'     #MOD-CB0187 add #FUN-D10065 mark
         LET l_npq.npq23 = ''
         LET l_npq.npq24 = l_oox05
         LET l_npq.npq02 = l_npq.npq02 + 1
         IF (l_aap[1].oox10 + l_aap[2].oox10)>=0 THEN  #合并成一個科目
            IF l_aap[1].oox10 > 0 THEN              #收益
               LET l_npq.npq03 = l_aap[1].aps42
            ELSE
               LET l_npq.npq03 = l_aap[2].aps42
            END IF
            LET l_npq.npq06 = '2'
            LET l_npq.npq07 = l_aap[1].oox10 + l_aap[2].oox10 #總收益
         ELSE
            IF l_aap[1].oox10 < 0 THEN     #損失
               LET l_npq.npq03 = l_aap[1].aps42
            ELSE
               LET l_npq.npq03 = l_aap[2].aps42
            END IF
            LET l_npq.npq06 = '1'
            LET l_npq.npq07 = (l_aap[1].oox10 + l_aap[2].oox10) * -1
         END IF
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
         IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF

         #NO.FUN-5C0015 ---start
#        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)   #No.FUN-740064  #No.TQC-760156 mark
#        RETURNING l_npq.*          #No.TQC-760156 mark
         #No.FUN-5C0015 ---end
         #FUN-D10065--add--str--
         LET l_npq.npq04 = NULL
         CALL s_def_npq3(g_bookno3,l_npq.npq03,g_prog,l_npq.npq01,'','') RETURNING l_npq.npq04
         IF cl_null(l_npq.npq04) THEN
            LET l_npq.npq04 = l_oox05 CLIPPED,' ',l_oox07 USING '<<<&.<<<<'
         END IF
         #FUN-D10065--add--end

         #TQC-C80023--add--str--
         SELECT aag06,aag42 INTO l_aag06,l_aag42 FROM aag_file
          WHERE aag01 = l_npq.npq03 AND aag00 = g_bookno3

         IF l_aag42 = 'Y' AND l_npq.npq06<>l_aag06 THEN
            LET l_npq.npq06 = l_aag06
            LET l_npq.npq07 = l_npq.npq07 * -1
            LET l_npq.npq07f = l_npq.npq07f * -1
         END IF
         #TQC-C80023--add--end--

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
         SELECT aag05 INTO l_aag05 FROM aag_file   
          WHERE aag01 = l_npq.npq03 AND aag00 = g_bookno3         

         LET l_npq.npq05 = ''
         IF l_aag05 = 'Y' THEN
            IF g_aaz.aaz90='N' THEN
               IF cl_null(l_npq.npq05) THEN
                  LET l_npq.npq05 = l_sort.apa22
               END IF
            ELSE
               LET l_npq.npq05 = l_sort.apa930 
            END IF
         ELSE
            LET l_npq.npq05 = ''
         END IF   
         #No.CHI-D50024  --end
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
            #CALL cl_err('ins npq #12',SQLCA.SQLCODE,1)  #No.FUN-660071
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq011,SQLCA.sqlcode,"","ins npq#12",1) #No.FUN-660071
            LET g_success = 'N' EXIT FOREACH
         END IF
      ELSE  #不是合并到一個科目中去
         FOREACH q600_oox05_1 INTO l_sr2.*
            IF SQLCA.sqlcode THEN
               CALL cl_err(l_sr2.aps42,SQLCA.sqlcode,0)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
            IF cl_null(l_sr2.oox10) THEN LET l_sr2.oox10 = 0 END IF
            LET l_npq.npq21 = 'MISC'
            LET l_npq.npq22 = ''
           #LET l_npq.npq04 = l_oox05 CLIPPED,' ',l_oox07 USING '<<<<.<<<<'     #MOD-CB0187 mark
           #LET l_npq.npq04 = l_oox05 CLIPPED,' ',l_oox07 USING '<<<&.<<<<'     #MOD-CB0187 add   #FUN-D10065 mark
            LET l_npq.npq23 = ''
            LET l_npq.npq24 = l_oox05
            LET l_npq.npq03 = l_sr2.aps42
            IF l_sr2.oox10 > 0 THEN  #收益
               LET l_npq.npq02 = l_npq.npq02 + 1
               LET l_npq.npq06 = '2'
               LET l_npq.npq07 = l_sr2.oox10
               MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
               IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF

               #NO.FUN-5C0015 ---start
#              CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)   #No.FUN-740064 #No.TQC-760156 mark
#              RETURNING l_npq.*    #No.TQC-760156 mark
               #No.FUN-5C0015 ---end
               #FUN-D10065--add--str--
               LET l_npq.npq04 = NULL
               CALL s_def_npq3(g_bookno3,l_npq.npq03,g_prog,l_npq.npq01,'','') RETURNING l_npq.npq04
               IF cl_null(l_npq.npq04) THEN
                  LET l_npq.npq04 = l_oox05 CLIPPED,' ',l_oox07 USING '<<<&.<<<<'
               END IF
               #FUN-D10065--add--end

               #TQC-C80023--add--str--
               SELECT aag06,aag42 INTO l_aag06,l_aag42 FROM aag_file
                WHERE aag01 = l_npq.npq03 AND aag00 = g_bookno3

               IF l_aag42 = 'Y' AND l_npq.npq06<>l_aag06 THEN
                  LET l_npq.npq06 = l_aag06
                  LET l_npq.npq07 = l_npq.npq07 * -1
                  LET l_npq.npq07f = l_npq.npq07f * -1
               END IF
               #TQC-C80023--add--end--

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
               SELECT aag05 INTO l_aag05 FROM aag_file   
                WHERE aag01 = l_npq.npq03 AND aag00 = g_bookno3         
               
               LET l_npq.npq05 = ''
               IF l_aag05 = 'Y' THEN
                  IF g_aaz.aaz90='N' THEN
                     IF cl_null(l_npq.npq05) THEN
                        LET l_npq.npq05 = l_sort.apa22
                     END IF
                  ELSE
                     LET l_npq.npq05 = l_sort.apa930 
                  END IF
               ELSE
                  LET l_npq.npq05 = ''
               END IF   
               #No.CHI-D50024  --end
               INSERT INTO npq_file VALUES (l_npq.*)
               IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
                  #CALL cl_err('ins npq #12',SQLCA.SQLCODE,1)  #No.FUN-660071
                  CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq011,SQLCA.sqlcode,"","ins npq#12",1) #No.FUN-660071
                  LET g_success = 'N' EXIT FOREACH
               END IF
            ELSE   #損失
               LET l_npq.npq02 = l_npq.npq02 + 1
               LET l_npq.npq06 = '1'
               LET l_npq.npq07 = l_sr2.oox10 * -1
               MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
               IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF

               #NO.FUN-5C0015 ---start
#              CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',g_bookno3)  #No.fun-740064  #No.TQC-760156 mark
#              RETURNING l_npq.*    #No.TQC-760156 mark
               #No.FUN-5C0015 ---end
               #FUN-D10065--add--str--
               LET l_npq.npq04 = NULL
               CALL s_def_npq3(g_bookno3,l_npq.npq03,g_prog,l_npq.npq01,'','') RETURNING l_npq.npq04
               IF cl_null(l_npq.npq04) THEN
                  LET l_npq.npq04 = l_oox05 CLIPPED,' ',l_oox07 USING '<<<&.<<<<'
               END IF
               #FUN-D10065--add--end

               #TQC-C80023--add--str--
               SELECT aag06,aag42 INTO l_aag06,l_aag42 FROM aag_file
                WHERE aag01 = l_npq.npq03 AND aag00 = g_bookno3

               IF l_aag42 = 'Y' AND l_npq.npq06<>l_aag06 THEN
                  LET l_npq.npq06 = l_aag06
                  LET l_npq.npq07 = l_npq.npq07 * -1
                  LET l_npq.npq07f = l_npq.npq07f * -1
               END IF
               #TQC-C80023--add--end--

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
                  #CALL cl_err('ins npq #21',SQLCA.SQLCODE,1) #No.FUN-660071
                  CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq011,SQLCA.sqlcode,"","ins npq#21",1) #No.FUN-660071
                  LET g_success = 'N' EXIT FOREACH
               END IF
            END IF
         END FOREACH
      END IF
   END FOREACH
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021
   DELETE FROM sort_file     #No.FUN-680029 如不將分錄1所插入temp表的資料刪掉的話會影響分錄2的資料
END FUNCTION
#No.FUN-A30028 --begin
FUNCTION q600_apa_q()
DEFINE l_apa00    LIKE apa_file.apa00

    LET g_msg =''
    SELECT apa00 INTO l_apa00 FROM apa_file WHERE apa01 = g_oox[l_ac].oox03
    IF NOT sqlCA.sqlcode THEN
       IF l_apa00 ='23' THEN
          LET g_msg ='aapq230'," '",g_oox[l_ac].oox03 CLIPPED,"'"
          CALL cl_cmdrun(g_msg)
          RETURN
       END IF
       IF l_apa00 ='25' THEN
          LET g_msg ='aapq231'," '",g_oox[l_ac].oox03 CLIPPED,"'"
          CALL cl_cmdrun(g_msg)
          RETURN
       END IF
       IF l_apa00 ='24' THEN
          LET g_msg ='aapq240'," '",g_oox[l_ac].oox03 CLIPPED,"'"
          CALL cl_cmdrun(g_msg)
          RETURN
       END IF
       IF l_apa00 ='11' THEN
          LET g_msg ='aapt110'," '",g_oox[l_ac].oox03 CLIPPED,"'"
          CALL cl_cmdrun(g_msg)
          RETURN
       END IF
       IF l_apa00 ='12' THEN
          LET g_msg ='aapt120'," '",g_oox[l_ac].oox03 CLIPPED,"'"
          CALL cl_cmdrun(g_msg)
          RETURN
       END IF
       IF l_apa00 ='13' THEN
          LET g_msg ='aapt121'," '",g_oox[l_ac].oox03 CLIPPED,"'"
          CALL cl_cmdrun(g_msg)
          RETURN
       END IF
       IF l_apa00 ='15' THEN
          LET g_msg ='aapt150'," '",g_oox[l_ac].oox03 CLIPPED,"'"
          CALL cl_cmdrun(g_msg)
          RETURN
       END IF
       IF l_apa00 ='17' THEN
          LET g_msg ='aapt151'," '",g_oox[l_ac].oox03 CLIPPED,"'"
          CALL cl_cmdrun(g_msg)
          RETURN
       END IF
       IF l_apa00 ='16' THEN
          LET g_msg ='aapt160'," '",g_oox[l_ac].oox03 CLIPPED,"'"
          CALL cl_cmdrun(g_msg)
          RETURN
       END IF
       IF l_apa00 ='21' THEN
          LET g_msg ='aapt210'," '",g_oox[l_ac].oox03 CLIPPED,"'"
          CALL cl_cmdrun(g_msg)
          RETURN
       END IF
       IF l_apa00 ='22' THEN
          LET g_msg ='aapt220'," '",g_oox[l_ac].oox03 CLIPPED,"'"
          CALL cl_cmdrun(g_msg)
          RETURN
       END IF
       IF l_apa00 ='26' THEN
          LET g_msg ='aapt260'," '",g_oox[l_ac].oox03 CLIPPED,"'"
          CALL cl_cmdrun(g_msg)
          RETURN
       END IF
    END IF

END FUNCTION
#No.FUN-A30028 --end

#No.FUN-D40107 ---Add--- Start
FUNCTION q600_gapp600()
   DEFINE l_str      STRING
   LET l_str = "gapp600 '",g_oox01,"' '",g_oox02,"' 'N' "
   CALL cl_cmdrun(l_str)
END FUNCTION

FUNCTION q600_gapp601()
   DEFINE l_str      STRING
   LET l_str = "gapp601 '",g_oox01,"' '",g_oox02,"' 'N' "
   CALL cl_cmdrun(l_str)
END FUNCTION

FUNCTION q600_gxrp610()
   DEFINE l_str      STRING
   LET l_str = "gxrp610 '2' '' '' '' '' 'N' "
   CALL cl_cmdrun(l_str)
END FUNCTION

FUNCTION q600_gxrp620()
   DEFINE l_str      STRING
   DEFINE l_nppglno  LIKE npp_file.nppglno

   LET g_trno = g_oox00,g_oox01 USING '&&&&',g_oox02 USING '&&'
   SELECT nppglno INTO l_nppglno FROM npp_file WHERE npp01 = g_trno AND npp00 = 5
   LET l_str = "gxrp620 '' '' '",l_nppglno,"' 'N' "
   CALL cl_cmdrun(l_str)
END FUNCTION
#No.FUN-D40107 ---Add--- End
