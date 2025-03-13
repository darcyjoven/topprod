# Prog. Version..: '5.30.07-13.06.13(00010)'     #
#
# Pattern name...: gxrq600.4gl
# Descriptions...: 應收帳款月底重評價異動記錄查詢
# Date & Author..: 02/03/04 By Danny
# Modify.........: No.FUN-4B0017 04/11/02 By ching add '轉Excel檔' action
# Modify ........: No.FUN-4C0014 04/12/01 By ching 單價,金額改成 DEC(20,6)
# Modify.........: No.MOD-530853 05/04/04 By Anney 作業窗口不能用X關閉
# Modify.........: FUN-5C0015 05/12/20 BY GILL (1)多Update 異動碼5~10, 關係人
#                  (2)若該科目有設彈性異動碼(agli120),則default帶出
#                     彈性異動碼的設定值(call s_def_npq: 抓取異動碼default值)
# Modify.........: No.FUN-660146 06/06/22 By Carrier cl_err --> cl_err3
# Modify.........: No.FUN-660152 06/06/27 By rainy CREATE TEMP TABLE 單號改char(16)
# Modify.........: No.FUN-670047 06/08/15 By day 多帳套修改
# Modify.........: No.FUN-680145 06/09/18 By Dxfwo  欄位類型定義-改為LIKE
# Modify.........: No.FUN-6A0099 06/10/26 By king l_time轉g_time
# Modify.........: No.FUN-6A0092 06/11/17 By Jackho 新增動態切換單頭隱藏的功能
# Modify.........: No.TQC-6B0105 07/03/08 By carrier 連續兩次查詢,第二次查不到資料,做修改等操作會將當前筆停在上次查詢到的資料上
# Modify.........: No.FUN-740009 07/04/03 By Judy 會計科目加帳套
# Modify.........: No.FUN-750051 07/05/22 By johnray 連續二次查詢key值時,若第二次查詢不到key值時,會顯示錯誤key值
# Modify.........: No.TQC-760156 07/07/02 By Rayven 修改s_def_npq傳的參數
# Modify.........: No.TQC-770014 07/07/02 By judy 匯出EXCEL的值多一空白行
# Modify.........: No.FUN-7B0089 07/11/15 By Carrier 單身加入多帳期項次oox041 
# Modify.........: No.FUN-850030 08/07/24 By dxfwo   加入傳入參數功能
# Modify.........: No.FUN-980011 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No:MOD-9C0039 09/12/07 By Smapmin 修改2*的帳款,oma18的抓取方式
# Modify.........: No:FUN-A30028 10/03/30 By wujie   增加来源单据串查
#                                                    单头增加细项选择项，不选细项则按客户汇总
#                                                    单身增加客户及客户名称栏位
# Modify.........: No:FUN-B40056 11/05/12 By lixia 刪除資料時一併刪除tic_file的資料
# Modify.........: No:TQC-B70021 11/07/19 By wujie 抛转tic_file资料
# Modify.........: No:CHI-C80005 12/08/03 By yinhy 生成分錄時，應按照aag42按餘額方向生成
# Modify.........: No:MOD-CB0159 12/11/16 By yinhy 查詢時默認axrs010中的ooz05,ooz06
# Modify.........: No:MOD-CB0187 12/11/21 By Polly 調整npq04欄位格式
# Modify.........: No.FUN-D10065 13/01/15 By wangrr 所有npq04的给值统一放在s_def_npq3（s_def_npq,s_def_npq5等）的后面
#                                                 判断若npq04 为空.则依原给值方式给值
# Modify.........: No:FUN-D40118 13/05/21 By lujh 若科目npq03有做核算控管aag44=Y,但agli122作業沒有維護，則科目給空
# Modify.........: No:FUN-D40107 13/05/23 By zhangweib 新增狀態頁簽、畫面上的按鈕增加順序為:重評價產生,重評價還原,分錄底稿產生,分錄底稿,拋轉憑證,拋轉憑證還原
# Modify.........: No.FUN-D40121 13/06/27 By zhangweib 修改背景作業邏輯
# Modify.........: No:FUN-D70002 13/08/27 By yangtt 新增時給原幣未沖金額(oox11)賦值
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
              #add 030226 NO.A048
              oox03v   LIKE oox_file.oox03v,
              oox03    LIKE oox_file.oox03,
              oox04    LIKE oox_file.oox04,
              oox041   LIKE oox_file.oox041,  #No.FUN-7B0089
              oma03    LIKE oma_file.oma03,   #No.FUN-A30028
              oma032   LIKE oma_file.oma032,  #No.FUN-A30028
              oox05    LIKE oox_file.oox05,
              oox06    LIKE oox_file.oox06,
              oox07    LIKE oox_file.oox07,
              oox11    LIKE oox_file.oox11,   #No.FUN-D70002   Add
              oox08    LIKE oox_file.oox08,
              oox09    LIKE oox_file.oox09,
              oox10    LIKE oox_file.oox10
              END RECORD,
    g_argv1          STRING,   #No.FUN-850030 
     g_wc,g_wc2,g_sql string,  #WHERE CONDITION  #No.FUN-580092 HCN
    g_rec_b          LIKE type_file.num10,   #NO.FUN-680145 INTEGER    #單身筆數
    g_trno           LIKE type_file.chr20,       #NO.FUN-680145 VARCHAR(20)
    g_npq03  ARRAY[100] OF LIKE npq_file.npq03,  #NO.FUN-680145 VARCHAR(20)
    g_j              LIKE type_file.num5,        #NO.FUN-680145 SMALLINT
    g_tot            LIKE oox_file.oox10         #NO.FUN-680145 DEC(20,6)  #FUN-4C0014
 
DEFINE   g_chr           LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
DEFINE   g_cnt           LIKE type_file.num10    #NO.FUN-680145 INTEGER   
DEFINE   g_msg           LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(72)
DEFINE   g_row_count     LIKE type_file.num10    #NO.FUN-680145 INTEGER
DEFINE   g_curs_index    LIKE type_file.num10    #NO.FUN-680145 INTEGER
DEFINE   g_jump          LIKE type_file.num10    #NO.FUN-680145 INTEGER
DEFINE   mi_no_ask       LIKE type_file.num5     #NO.FUN-680145 SMALLINT
DEFINE   g_detail        LIKE type_file.chr1     #NO.FUN-A30028
DEFINE   g_aag44         LIKE aag_file.aag44     #FUN-D40118 add

MAIN
        DEFINE  # l_time LIKE type_file.chr8	     #No.FUN-6A0099
          p_row,p_col    LIKE type_file.num5,    #NO.FUN-680145 SMALLINT
	  l_sl 		 LIKE type_file.num10    #NO.FUN-680145 INTEGER
 
   OPTIONS                                #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
  
   WHENEVER ERROR CALL cl_err_msg_log
  
   IF (NOT cl_setup("GXR")) THEN
      EXIT PROGRAM
   END IF
 
   LET g_argv1  = ARG_VAL(1)  #No.FUN-850030 
 
    #add 030226 NO.A048
    DROP TABLE sort_file;             
    CREATE TEMP TABLE sort_file(
     oma00   LIKE oma_file.oma00,
     oma01   LIKE oma_file.oma01,
     oma13   LIKE oma_file.oma13,
     oma18   LIKE oma_file.oma18,
     oma03   LIKE oma_file.oma03,
     oma032  LIKE oma_file.oma032,
     oma34   LIKE oma_file.oma34,
     oox03v  LIKE oox_file.oox03v,
     oox05   LIKE oox_file.oox05,
     oox07   LIKE oox_file.oox07,
     oox10   LIKE oox_file.oox10,
     oma181  LIKE oma_file.oma18,
     oma15   LIKE oma_file.oma15,  #CHI-D50024
     oma930  LIKE oma_file.oma930) #CHI-D50024  
    IF STATUS THEN CALL cl_err('cre tmp',STATUS,0) EXIT PROGRAM END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time

    OPEN WINDOW q600_w WITH FORM "gxr/42f/gxrq600" 
          ATTRIBUTE (STYLE = g_win_style CLIPPED) #No.FUN-580092 HCN
    CALL cl_ui_init()
 
    IF NOT cl_null(g_argv1) THEN                                                                                                   
       CALL q600_q()                                                                                                               
    END IF                                                                                                                         
    CALL q600_menu()                                                                                                               
    CLOSE WINDOW q600_w

    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    #No.FUN-6A0099
END MAIN
 
#QBE 查詢資料
FUNCTION q600_cs()
   CLEAR FORM #清除畫面
   CALL g_oox.clear()
   CALL cl_opmsg('q')
   #modify 030226 NO.A048
   CALL cl_set_head_visible("","YES")       #No.FUN-6A0092
#No.FUN-A30028 --begin
   LET g_detail = 'Y'
   IF cl_null (g_argv1) THEN   #No.FUN-D40121   Add
   INPUT BY NAME g_detail WITHOUT DEFAULTS  
     ON ACTION locale
        CALL cl_dynamic_locale()
        CALL cl_show_fld_cont()   #FUN-550037(smin)

      AFTER FIELD g_detail 
         IF cl_null(g_detail) OR g_detail NOT MATCHES '[YN]' THEN
            NEXT FIELD g_detail
         END IF  
         CALL cl_set_comp_visible("oox03,oox04,oox041,oma03,oma032,oox11",TRUE)   #No.FUN-D70002   Add
         CALL cl_set_act_visible("qry_oma", TRUE)
         IF g_detail ='N' THEN
            CALL cl_set_comp_visible("oox03,oox04,oox041,oox11", FALSE)   #No.FUN-D70002   Add
            CALL cl_set_act_visible("qry_oma", FALSE)
        #ELSE             #FUN-D90016 mark
        #   CALL cl_set_comp_visible("oma03,oma032", FALSE)  #FUN-D90016 mark
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
   #No.FUN-D40121 ---Mark--- Start
   ELSE
      DISPLAY BY NAME g_detail
      IF g_detail ='N' THEN
         CALL cl_set_comp_visible("oox03,oox04,oox041", FALSE)
         CALL cl_set_act_visible("qry_oma", FALSE)
     #ELSE     #FUN-D90016 mark
     #   CALL cl_set_comp_visible("oma03,oma032", FALSE)  #FUN-D90016 mark
      END IF
   END IF
  #No.FUN-D40121 ---Mark--- End

   INITIALIZE g_oox00 TO NULL    #No.FUN-750051
   INITIALIZE g_oox01 TO NULL    #No.FUN-750051
   INITIALIZE g_oox02 TO NULL    #No.FUN-750051
   #No.FUN-850030  --Begin                                                                                                          
   IF NOT cl_null(g_argv1) THEN                                                                                                     
      LET g_wc = g_argv1                                                                                                            
   ELSE  
   CONSTRUCT g_wc ON oox01,oox02,oox03v,oox03,oox04,oox041,oox05,oox06,  #No.FUN-7B0089
                     oox07,oox11,oox08,oox09,oox10  #No.FUN-D70002   Add oox11
                FROM oox01,oox02,s_oox[1].oox03v,
                     s_oox[1].oox03,s_oox[1].oox04,s_oox[1].oox041,      #No.FUN-7B0089
                     s_oox[1].oox05,s_oox[1].oox06,s_oox[1].oox07,
                     s_oox[1].oox11,   #No.FUN-D70002   Add
                     s_oox[1].oox08,s_oox[1].oox09,s_oox[1].oox10
 
              #No.FUN-580031 --start--     HCN
              BEFORE CONSTRUCT
                 DISPLAY g_ooz.ooz05 TO oox01  #MOD-CB0159
                 DISPLAY g_ooz.ooz06 TO oox02  #MOD-CB0159
                 CALL cl_qbe_init()
              #No.FUN-580031 --end--       HCN

      #FUN-D90016-----add---str--
      ON ACTION CONTROLP
         CASE
            WHEN INFIELD(oox03)  #genero要改查單據單(未改)
               IF g_oox[1].oox03v='10' THEN
                  CALL q_oma(TRUE,TRUE,g_oox[1].oox03,'','10')
                  RETURNING g_qryparam.multiret
               ELSE
                  CALL q_oma(TRUE,TRUE,g_oox[1].oox03,'','')
                  RETURNING g_qryparam.multiret
               END IF
               DISPLAY g_qryparam.multiret TO oox03
         END CASE
      #FUN-D90016-----add---end--
 
       ON ACTION locale
          CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()   #FUN-550037(smin)
 
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
             "   AND oox00 = 'AR' ",
             " ORDER BY 1,2,3 "
   PREPARE q600_prepare FROM g_sql
   IF STATUS THEN CALL cl_err('q600_pre',STATUS,1) END IF
   DECLARE q600_cs SCROLL CURSOR WITH HOLD FOR q600_prepare
 
   DROP TABLE count_tmp
   LET g_sql="SELECT oox00,oox01,oox02  ",
             "  FROM oox_file             ",
             " WHERE ", g_wc CLIPPED,
             "   AND oox00 = 'AR' ", 
             " GROUP BY oox00,oox01,oox02 ",
             " INTO TEMP count_tmp"
   PREPARE q600_cnt_tmp  FROM g_sql
   EXECUTE q600_cnt_tmp
   DECLARE q600_count CURSOR FOR SELECT COUNT(*) FROM count_tmp
 
 
END FUNCTION
 
FUNCTION q600_menu()
DEFINE l_ac    LIKE type_file.num5         #No.FUN-A30028
 
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
 
         #FUN-4B0017
         WHEN "exporttoexcel"
             IF cl_chk_act_auth() THEN
                CALL cl_export_to_excel
                (ui.Interface.getRootNode(),base.TypeInfo.create(g_oox),'','')
             END IF
         #--

        #No.FUN-D40107 ---Add--- Start
         WHEN "Reveluation"
            IF cl_chk_act_auth() THEN
               CALL q600_gxrp601()
            END IF
         WHEN "UndoReveluation"
            IF cl_chk_act_auth() THEN
               CALL q600_gxrp600()
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
         WHEN "entry_sheet1"  #No.FUN-670047
            IF cl_chk_act_auth() THEN 
               LET g_trno = g_oox00,g_oox01 USING '&&&&',g_oox02 USING '&&'
#              CALL s_fsgl(g_oox00,4,g_trno,0,g_ooz.ooz02b,1,'N')  #No.FUN-670047
               CALL s_fsgl(g_oox00,4,g_trno,0,g_ooz.ooz02b,1,'N','0',g_ooz.ooz02p)  #No.FUN-670047
            END IF
         #No.FUN-670047--begin
         #@WHEN "分錄底稿二" 
         WHEN "entry_sheet2"
            IF cl_chk_act_auth() THEN 
               LET g_trno = g_oox00,g_oox01 USING '&&&&',g_oox02 USING '&&'
               CALL s_fsgl(g_oox00,4,g_trno,0,g_ooz.ooz02c,1,'N','1',g_ooz.ooz02p)  
            END IF
         #No.FUN-670047--end
        #No.FUN-A30028 --begin
         WHEN "qry_oma"
            IF cl_chk_act_auth() THEN 
               LET l_ac = ARR_CURR()
               IF NOT cl_null(l_ac) AND l_ac <> 0 THEN
                  LET g_msg = "axrt300 '",g_oox[l_ac].oox03,"'"
                  CALL cl_cmdrun(g_msg)
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
       CALL q600_fetch('F')                  # 讀出TEMP第一筆並顯示
       OPEN q600_count
       FETCH q600_count INTO g_row_count
       DISPLAY g_row_count TO FORMONLY.cnt  
    END IF
    MESSAGE ''
END FUNCTION
 
FUNCTION q600_fetch(p_flag)
DEFINE
    p_flag          LIKE type_file.chr1,    #NO.FUN-680145 VARCHAR(1)       #處理方式
    l_abso          LIKE type_file.num10    #NO.FUN-680145 INTEGER       #絕對的筆數
 
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
   DISPLAY g_oox01,g_oox02 TO oox01,oox02   # 顯示單頭值
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
    DEFINE l_sql     LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(1000)
 
    #modify 030226 NO.A048
#   LET l_sql = "SELECT oox03v,oox03,oox04,oox041,oox05,oox06,oox07,oox08,oox09,oox10",  #No.FUN-7B0089
   #LET l_sql = "SELECT oox03v,oox03,oox04,oox041,'','',oox05,oox06,oox07,oox11,oox08,oox09,oox10",  #No.FUN-7B0089   #No.FUN-A30028  #No.FUN-D70002   Add #FUN-D90016 mark
    LET l_sql = "SELECT oox03v,oox03,oox04,oox041,oma03,oma032,oox05,oox06,oox07,oox11,oox08,oox09,oox10",  #No.FUN-7B0089   #No.FUN-A30028   #No.FUN-D70002#FUN-D90016
                "  FROM oox_file,oma_file ",   #FUN-D90016 add oma_file
                " WHERE oox00 = '",g_oox00,"'",
                "   AND oox01 = ",g_oox01, 
                "   AND oox02 = ",g_oox02,
                "   AND oma01 = oox03",      #FUN-D90016 add
                "   AND ",g_wc CLIPPED,     #bugno:5907
                " ORDER BY oox03v,oox03,oox04,oox041 "  #No.FUN-7B0089
#No.FUN-A30028 --begin
    IF g_detail ='N' THEN 
       LET l_sql = "SELECT oox03v,'','','',oma03,oma032,oox05,oox06,oox07,0,SUM(oox08),SUM(oox09),SUM(oox10)",  #No.FUN-D70002   Add 0
                   "  FROM oox_file,oma_file ",
                   " WHERE oox00 = '",g_oox00,"'",
                   "   AND oox01 = ",g_oox01, 
                   "   AND oox02 = ",g_oox02,
                   "   AND oma01 = oox03",
                   "   AND ",g_wc CLIPPED, 
                   " GROUP BY oox03V,'','','',oma03,oma032,oox05,oox06,oox07",
                   " ORDER BY oox03V,oma03,oma032,oox05,oox06,oox07"
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
        LET g_tot = g_tot + g_oox[g_cnt].oox10
        LET g_cnt = g_cnt + 1
      # genero shell add g_max_rec check START
      IF g_cnt > g_max_rec THEN
         CALL cl_err( '', 9035, 0 )
	 EXIT FOREACH
      END IF
      # genero shell add g_max_rec check END
    END FOREACH
    CALL g_oox.deleteElement(g_cnt)   #TQC-770014
    LET g_rec_b = g_cnt - 1
    DISPLAY BY NAME g_tot
END FUNCTION
 
FUNCTION q600_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1     #NO.FUN-680145 VARCHAR(1)
 
 
   IF p_ud <> "G" THEN
      RETURN
   END IF
 
   CALL SET_COUNT(g_rec_b)
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_oox TO s_oox.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
 
      BEFORE DISPLAY
         CALL cl_navigator_setting( g_curs_index, g_row_count )
         #No.FUN-670047--begin
         IF g_aza.aza63 = 'Y' THEN
            CALL cl_set_act_visible("entry_sheet2", TRUE)  
         ELSE
            CALL cl_set_act_visible("entry_sheet2", FALSE)  
         END IF
         #No.FUN-670047--end  
 
      #BEFORE ROW
      #   LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()                   #No.FUN-550037 hmf
      #   LET l_sl = SCR_LINE()
 
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

     #No.FUN-D40107 ---Add--- Start
      ON ACTION UndoReveluation
         LET g_action_choice = "UndoReveluation"
         EXIT DISPLAY

      ON ACTION Reveluation
         LET g_action_choice = "Reveluation"
         EXIT DISPLAY
     #No.FUN-D40107 ---Add--- End
     
      ON ACTION gen_entry #會計分錄產生
         LET g_action_choice="gen_entry"
         EXIT DISPLAY
     
      ON ACTION entry_sheet1 #分錄底稿       #No.FUN-670047
         LET g_action_choice="entry_sheet1"  #No.FUN-670047  
         EXIT DISPLAY
 
      #No.FUN-670047--begin
      ON ACTION entry_sheet2 #分錄底稿2
         LET g_action_choice="entry_sheet2"   
         EXIT DISPLAY
      #No.FUN-670047--end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      ON ACTION about         #MOD-4C0121
         CALL cl_about()      #MOD-4C0121
 
 
      #FUN-4B0017
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
 
      # No.FUN-530067 --start--
      AFTER DISPLAY
         CONTINUE DISPLAY
      # No.FUN-530067 ---end---
#No.FUN-A30028 --begin
      ON ACTION qry_oma
         LET g_action_choice = 'qry_oma'
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
   
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
 
#modify 030226 NO.A048
FUNCTION q600_v()
   DEFINE l_trno   LIKE npp_file.npp01
   DEFINE l_buf    LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(70)
   DEFINE l_n      LIKE type_file.num5     #NO.FUN-680145 SMALLINT
   DEFINE l_npp00  LIKE npp_file.npp00
   DEFINE l_npp011 LIKE npp_file.npp00
 
   IF cl_null(g_oox00) OR cl_null(g_oox01) OR cl_null(g_oox02) THEN 
      RETURN 
   END IF
 
   DELETE FROM sort_file
 
   #單號為系統別+年度+月份
   LET l_trno = g_oox00,g_oox01 USING '&&&&',g_oox02 USING '&&'
 
   LET l_npp00 = 4
   LET l_npp011= 1
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
      IF NOT s_ask_entry(l_trno) THEN RETURN END IF #Genero
   END IF
 
   LET g_success = 'Y'
   BEGIN WORK
 
   #No.FUN-670047--begin
#  CALL q600_g_gl(l_npp00,l_npp011,l_trno)     
 
   CALL q600_g_gl(l_npp00,l_npp011,l_trno,'0')   #產生第一分錄
   DELETE FROM sort_file
   IF g_aza.aza63 = 'Y' AND g_success='Y' THEN   #使用多帳套功能)
    CALL q600_g_gl(l_npp00,l_npp011,l_trno,'1') #產生第二分錄
   END IF
   #No.FUN-670047--end
 
   IF g_success = 'Y' THEN 
      COMMIT WORK 
   ELSE 
      ROLLBACK WORK
   END IF
END FUNCTION
   
#add 030226 NO.A048
#FUNCTION q600_g_gl(l_npp00,l_npp011,l_trno)            #No.FUN-670047
FUNCTION q600_g_gl(l_npp00,l_npp011,l_trno,l_npptype)   #No.FUN-670047
   DEFINE l_trno   LIKE npp_file.npp01
   DEFINE l_npp00  LIKE npp_file.npp00
   DEFINE l_npp011 LIKE npp_file.npp011
   DEFINE l_npp    RECORD LIKE npp_file.*
   DEFINE l_npq    RECORD LIKE npq_file.*
   DEFINE l_ool    RECORD LIKE ool_file.*
   DEFINE p_ool    RECORD LIKE ool_file.*
   DEFINE b_date,e_date  LIKE type_file.dat      #NO.FUN-680145 DATE
   DEFINE l_sql    LIKE type_file.chr1000  #NO.FUN-680145 VARCHAR(600) 
   DEFINE l_sort   RECORD
                   oma00   LIKE oma_file.oma00,
                   oma01   LIKE oma_file.oma01,
                   oma13   LIKE oma_file.oma13,
                   oma18   LIKE oma_file.oma18,
                   oma03   LIKE oma_file.oma03,
                   oma032  LIKE oma_file.oma032,
                   oma34   LIKE oma_file.oma34,
                   oox03v  LIKE oox_file.oox03v,
                   oox05   LIKE oox_file.oox05,
                   oox07   LIKE oox_file.oox07,
                   oox10   LIKE oox_file.oox10, 
                   oma181  LIKE oma_file.oma181,  #No.FUN-670047
                   oma15   LIKE oma_file.oma15,   #CHI-D50024
                   oma930  LIKE oma_file.oma930   #CHI-D50024  
                   END RECORD,
          l_sr     RECORD
                   oma18   LIKE oma_file.oma18,
                   oox05   LIKE oox_file.oox05,
                   oox07   LIKE oox_file.oox07,
                   npq06   LIKE npq_file.npq06,
                   npq07f  LIKE npq_file.npq07f,
                   npq07   LIKE npq_file.npq07,
                   oma03   LIKE oma_file.oma03,
                   oma01   LIKE oma_file.oma01,
                   oma032  LIKE oma_file.oma032,
                   oma181  LIKE oma_file.oma181,  #No.FUN-670047
                   oma15   LIKE oma_file.oma15,   #CHI-D50024
                   oma930  LIKE oma_file.oma930   #CHI-D5002
                   END RECORD,
          l_sr2    RECORD
                   oox05   LIKE oox_file.oox05,
                   oox07   LIKE oox_file.oox07,
                   oox10   LIKE oox_file.oox10
                   END RECORD
   DEFINE l_npptype LIKE npp_file.npptype  #No.FUN-670047
   DEFINE l_flag    LIKE type_file.chr1,    #FUN-740009
          l_bookno1 LIKE aza_file.aza81,    #FUN-740009
          l_bookno2 LIKE aza_file.aza82,    #FUN-740009
          l_bookno3 LIKE aag_file.aag00     #FUN-740009
   DEFINE l_aag06   LIKE aag_file.aag06     #CHI-C80005
   DEFINE l_aag42   LIKE aag_file.aag42     #CHI-C80005
   DEFINE l_aag05   LIKE aag_file.aag05     #CHI-D50024 
 
 
   SELECT * INTO l_ool.* FROM ool_file WHERE ool01 = g_ooz.ooz08
   IF STATUS THEN 
#     CALL cl_err('sel ool',STATUS,1)   #No.FUN-660146
      CALL cl_err3("sel","ool_file",g_ooz.ooz08,"",STATUS,"","sel ool",1)   #No.FUN-660146
      LET g_success = 'N' RETURN  
   END IF
 
   #No.FUN-670047-begin
#  CALL s_azn01(g_oox01,g_oox02) RETURNING b_date,e_date   
 
   IF g_aza.aza63 = 'Y' THEN
      IF l_npptype = '0' THEN
         CALL s_azmm01(g_oox01,g_oox02,g_ooz.ooz02p,g_ooz.ooz02b) 
             RETURNING b_date,e_date  
      ELSE
         CALL s_azmm01(g_oox01,g_oox02,g_ooz.ooz02p,g_ooz.ooz02c) 
             RETURNING b_date,e_date  
      END IF
   ELSE
      CALL s_azn01(g_oox01,g_oox02) RETURNING b_date,e_date   
   END IF
   #No.FUN-670047-end
 
   DELETE FROM npp_file WHERE npp01 = l_trno  AND npp00 = l_npp00
                          AND nppsys= g_oox00 AND npp011= l_npp011
                          AND npptype = l_npptype  #No.FUN-670047
   DELETE FROM npq_file WHERE npq01 = l_trno  AND npq00 = l_npp00
                          AND npqsys= g_oox00 AND npq011= l_npp011
                          AND npqtype = l_npptype  #No.FUN-670047
   DELETE FROM tic_file WHERE tic04 = l_trno    #FUN-B40056 

   INITIALIZE l_npp.* TO NULL
   INITIALIZE l_npq.* TO NULL
   LET l_npp.npptype = l_npptype  #No.FUN-670047
   LET l_npp.npplegal = g_legal   #FUN-980011 add
   LET l_npp.nppsys = g_oox00
   LET l_npp.npp00 = l_npp00
   LET l_npp.npp01 = l_trno
   LET l_npp.npp011= l_npp011
   LET l_npp.npp02 = e_date
   LET l_npp.npp03 = NULL
   INSERT INTO npp_file VALUES(l_npp.*)
   IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#     CALL cl_err('ins npp',STATUS,1)   #No.FUN-660146
      CALL cl_err3("ins","npp_file",l_npp.npp01,l_npp.npp011,STATUS,"","ins npp",1)   #No.FUN-660146
      LET g_success = 'N' RETURN 
   END IF
 
   #有關注釋請看gapq600
   DECLARE q600_sortc_curs CURSOR FOR
    SELECT oox05,oox07,SUM(oox10)             
      FROM sort_file               
     GROUP BY oox05,oox07
   IF STATUS THEN 
      CALL cl_err('q600_sortc_curs',STATUS,0) LET g_success='N' RETURN  
   END IF
 
   DECLARE q600_sortb_curs CURSOR FOR
    SELECT oma00,oma01,oma13,oma18,oma03,oma032,oma34,oox03v,oox05,oox07,oox10,oma181,oma15,oma930 #No.FUN-670047  #CHI-D50024
      FROM oox_file,oma_file
     WHERE oox00=g_oox00 AND oox01=g_oox01 AND oox02=g_oox02
       AND oma01=oox03 
   IF STATUS THEN 
      CALL cl_err('q600_sortb_curs',STATUS,0) LET g_success='N' RETURN  
   END IF
 
   FOREACH q600_sortb_curs INTO l_sort.*
     IF SQLCA.sqlcode THEN
        CALL cl_err(l_sort.oma01,SQLCA.sqlcode,0) 
        LET g_success='N' EXIT FOREACH
     END IF
     IF l_sort.oma00 MATCHES '2*' THEN
        #IF NOT cl_null(l_sort.oma13) THEN   #MOD-9C0039
        IF NOT cl_null(l_sort.oma13) AND g_ooz.ooz15 <> '1' THEN   #MOD-9C0039
           SELECT * INTO p_ool.* FROM ool_file WHERE ool01 = l_sort.oma13
           IF STATUS THEN 
#             CALL cl_err('sel ool',STATUS,1)   #No.FUN-660146
              CALL cl_err3("sel","ool_file",l_sort.oma13,"",STATUS,"","sel ool",1)   #No.FUN-660146
              LET g_success='N' RETURN  
           END IF
               #No.FUN-670047--begin
#              WHEN l_sort.oma00='22' LET l_sort.oma18=p_ool.ool25
#              WHEN l_sort.oma00='23' LET l_sort.oma18=p_ool.ool21
#              WHEN l_sort.oma00='24' LET l_sort.oma18=p_ool.ool23
#              WHEN l_sort.oma00='25' LET l_sort.oma18=p_ool.ool51
#              WHEN l_sort.oma00='21' 
#                   IF l_sort.oma34='5' THEN 
#                      LET l_sort.oma18=p_ool.ool47
#                   ELSE
#                      LET l_sort.oma18=p_ool.ool42
#                   END IF
               IF l_npptype = '0' THEN
                  CASE 
                    WHEN l_sort.oma00='22' LET l_sort.oma18=p_ool.ool25
                    WHEN l_sort.oma00='23' LET l_sort.oma18=p_ool.ool21
                    WHEN l_sort.oma00='24' LET l_sort.oma18=p_ool.ool23
                    WHEN l_sort.oma00='25' LET l_sort.oma18=p_ool.ool51
                    WHEN l_sort.oma00='21' 
                         IF l_sort.oma34='5' THEN 
                            LET l_sort.oma18=p_ool.ool47
                         ELSE
                            LET l_sort.oma18=p_ool.ool42
                         END IF
                  END CASE
               ELSE
                  CASE 
                    WHEN l_sort.oma00='22' LET l_sort.oma181=p_ool.ool251
                    WHEN l_sort.oma00='23' LET l_sort.oma181=p_ool.ool211
                    WHEN l_sort.oma00='24' LET l_sort.oma181=p_ool.ool231
                    WHEN l_sort.oma00='25' LET l_sort.oma181=p_ool.ool511
                    WHEN l_sort.oma00='21' 
                         IF l_sort.oma34='5' THEN 
                            LET l_sort.oma181=p_ool.ool471
                         ELSE
                            LET l_sort.oma181=p_ool.ool421
                         END IF
                  END CASE
               END IF
               #No.FUN-670047--end
        END IF
     END IF
     INSERT INTO sort_file VALUES(l_sort.oma00,l_sort.oma01,l_sort.oma13,
                                  l_sort.oma18,l_sort.oma03,l_sort.oma032,
                                  l_sort.oma34,l_sort.oox03v,l_sort.oox05,
                                  l_sort.oox07,l_sort.oox10,l_sort.oma181,l_sort.oma15,l_sort.oma930)  #No.FUN-670047 #CHI-D50024
     IF SQLCA.sqlcode THEN 
#       CALL cl_err('ins tmp',SQLCA.sqlcode,0)   #No.FUN-660146
        CALL cl_err3("ins","sort_file","","",SQLCA.sqlcode,"","ins tmp",0)   #No.FUN-660146
        LET g_success='N' EXIT FOREACH 
     END IF
   END FOREACH
   CASE g_ooz.ooz15 
      WHEN '1'
        LET l_sql="SELECT oma18,oox05,oox07,'',0,SUM(oox10),oma03,",
                  "       oma01,oma032,oma181,oma15,oma930", #No.FUN-670047 #CHI-D50024
                  "  FROM sort_file ",
                  " GROUP BY oma18,oox05,oox07,oma03,oma01,oma032,oma181,oma15,oma930 ", #No.FUN-670047 #CHI-D50024
                  " ORDER BY oma01,oox05,oma18,oma181,oma15,oma930"         #No.FUN-670047  #CHI-D50024
      WHEN '2'
        LET l_sql="SELECT oma18,oox05,oox07,'',0,SUM(oox10),'','','',oma181,oma15,oma930", #No.FUN-670047  #CHI-D50024
                  "  FROM sort_file ",
                  "  GROUP BY oma18,oox05,oox07,oma181,oma15,oma930 ", #No.FUN-670047  #CHI-D50024
                  "  ORDER BY oma18,oox05,oma181,oma15,oma930"         #No.FUN-670047  #CHI-D50024
      WHEN '3'
        LET l_sql="SELECT oma18,oox05,oox07,'',0,SUM(oox10),oma03,'',oma032,oma181,oma15,oma930",  #No.FUN-670047  #CHI-D50024
                  "  FROM sort_file ",
                  " GROUP BY oma18,oox05,oox07,oma03,oma032,oma181,oma15,oma930 ",  #No.FUN-670047  #CHI-D50024
                  " ORDER BY oma03,oma18,oox05,oma181,oma15,oma930"                 #No.FUN-670047  #CHI-D50024
   END CASE       
   PREPARE q600_pre5 FROM l_sql
   IF STATUS THEN 
      CALL cl_err('q600_pre5',STATUS,0) LET g_success='N' RETURN 
   END IF 
   DECLARE q600_npq1 CURSOR FOR q600_pre5
 
   LET l_npq.npqtype = l_npptype  #No.FUN-670047
   LET l_npq.npqlegal = g_legal   #FUN-980011 add
   LET l_npq.npqsys = g_oox00
   LET l_npq.npq00 = l_npp00
   LET l_npq.npq01 = l_trno
   LET l_npq.npq011= l_npp011
   LET l_npq.npq02 = 0
   LET l_npq.npq07f= 0
   LET l_npq.npq21 = 'MISC'
   LET l_npq.npq25 = 1
#FUN-740009.....begin
   CALL s_get_bookno(YEAR(e_date)) RETURNING l_flag,l_bookno1,l_bookno2   
   IF l_flag = '1' THEN
      CALL cl_err(YEAR(e_date),'aoo-081',1)
      LET g_success = 'N'                                                    
   END IF
   IF l_npq.npqtype = '0' THEN
      LET l_bookno3 = l_bookno1
   ELSE
      LET l_bookno3 = l_bookno2
   END IF
#FUN-740009.....end
   FOREACH q600_npq1 INTO l_sr.*
      IF STATUS THEN 
         CALL cl_err('q600_curs',STATUS,0) LET g_success='N' EXIT FOREACH
      END IF
      LET l_npq.npq24 = l_sr.oox05
     #LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<<.<<<<'    #MOD-CB0187 mark
     #LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<&.<<<<'    #MOD-CB0187 add  #FUN-D10065 mark
      IF g_ooz.ooz15 = '1' THEN
      #  LET l_npq.npq04 = l_sr.oma01 CLIPPED,' ',                             #FUN-D10065 mark
      #                    l_sr.oox05 CLIPPED,' ',                              #FUN-D10065 mark
      #                   #l_sr.oox07 USING '<<<<.<<<<'   #MOD-CB0187 mark  #FUN-D10065 mark
      #                    l_sr.oox07 USING '<<<&.<<<<'   #MOD-CB0187 add   #FUN-D10065 mark
         LET l_npq.npq23 = l_sr.oma01
         LET l_npq.npq21 = l_sr.oma03
         LET l_npq.npq22 = l_sr.oma032
      END IF
      IF g_ooz.ooz15 = '3' THEN
      #  LET l_npq.npq04 = l_sr.oma032 CLIPPED,' ',                          #FUN-D10065 mark
      #                    l_sr.oox05 CLIPPED,' ',                           #FUN-D10065 mark
      #                   #l_sr.oox07 USING '<<<<.<<<<'   #MOD-CB0187 mark   #FUN-D10065 mark
      #                    l_sr.oox07 USING '<<<&.<<<<'   #MOD-CB0187 add     #FUN-D10065 mark
         LET l_npq.npq21 = l_sr.oma03
         LET l_npq.npq22 = l_sr.oma032
      END IF
      IF cl_null(l_sr.npq07) THEN LET l_sr.npq07 = 0 END IF
      IF l_sr.npq07 > 0 THEN   #匯兌收益
         LET l_npq.npq02 = l_npq.npq02 + 1
         #No.FUN-670047--begin
#        LET l_npq.npq03 = l_sr.oma18 
 
         IF l_npptype = '1' THEN
            LET l_npq.npq03 = l_sr.oma181 
         ELSE
            LET l_npq.npq03 = l_sr.oma18 
         END IF
         #No.FUN-670047--end  
         LET l_npq.npq06 = '1'
         LET l_npq.npq07 = l_sr.npq07
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
         IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
    
         #NO.FUN-5C0015 ---start
#        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')  #FUN-740009
#        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)  #FUN-740009  #No.TQC-760156 mark
         IF g_ooz.ooz15 = '1' THEN  #No.TQC-760156
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_sr.oma01,g_oox01,g_oox02,l_bookno3)   #No.TQC-760156
                 RETURNING l_npq.*
            #FUN-D10065--add--str--
            IF cl_null(l_npq.npq04) THEN
               LET l_npq.npq04 = l_sr.oma01 CLIPPED,' ',
                                 l_sr.oox05 CLIPPED,' ',
                                 l_sr.oox07 USING '<<<&.<<<<'
            END IF
            #FUN-D10065--add--end
         END IF  #No.TQC-760156
         #No.FUN-5C0015 ---end
         #FUN-D10065--add--str--
         IF g_ooz.ooz15 <> '1' THEN
            CALL s_def_npq3(l_bookno3,l_npq.npq03,g_prog,l_sr.oma01,g_oox01,g_oox02) RETURNING l_npq.npq04
            IF cl_null(l_npq.npq04) THEN
               IF g_ooz.ooz15 = '3' THEN
                  LET l_npq.npq04 = l_sr.oma032 CLIPPED,' ',
                                    l_sr.oox05 CLIPPED,' ',
                                    l_sr.oox07 USING '<<<&.<<<<'
               ELSE
                  LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<&.<<<<'
               END IF
            END IF
         END IF
         #FUN-D10065--add--end
         #No.CHI-C80005  --End
         SELECT aag06,aag42 INTO l_aag06,l_aag42 FROM aag_file
          WHERE aag01 = l_npq.npq03 AND aag00 = l_bookno3

         IF l_aag42 = 'Y' AND l_npq.npq06<>l_aag06 THEN
            LET l_npq.npq06 = l_aag06
            LET l_npq.npq07 = l_npq.npq07 * -1
            LET l_npq.npq07f = l_npq.npq07f * -1
         END IF
         #No.CHI-C80005  --End 
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = l_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,l_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         #No.CHI-D50024  --Begin         
         SELECT aag05 INTO l_aag05 FROM aag_file   
          WHERE aag01 = l_npq.npq03 AND aag00 = l_bookno3
         
         LET l_npq.npq05 = ''
         IF l_aag05 = 'Y' THEN
            IF g_aaz.aaz90='N' THEN
               IF cl_null(l_npq.npq05) THEN
                  LET l_npq.npq05 = l_sort.oma15
               END IF
            ELSE
               LET l_npq.npq05 = l_sort.oma930 
            END IF
         ELSE
            LET l_npq.npq05 = ''
         END IF   
         #No.CHI-D50024  --end  
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('ins npq #11',SQLCA.SQLCODE,0)    #No.FUN-660146
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq #11",0)   #No.FUN-660146
            LET g_success='N' EXIT FOREACH
         END IF
      ELSE                #匯兌損失
         LET l_npq.npq07 = l_sr.npq07 * (-1)
         LET l_npq.npq02 = l_npq.npq02 + 1
         #No.FUN-670047--begin
#        LET l_npq.npq03 = l_sr.oma18 
         IF l_npptype = '1' THEN
            LET l_npq.npq03 = l_sr.oma181 
         ELSE
            LET l_npq.npq03 = l_sr.oma18 
         END IF
         #No.FUN-670047--end  
         LET l_npq.npq06 = '2'
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
         IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
    
         #NO.FUN-5C0015 ---start
#        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')  #FUN-740009
#        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)  #FUN-740009  #No.TQC-760156 mark
         IF g_ooz.ooz15 = '1' THEN  #No.TQC-760156
            CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_sr.oma01,g_oox01,g_oox02,l_bookno3)   #No.TQC-760156
                 RETURNING l_npq.*
            #FUN-D10065--add--str--
            IF cl_null(l_npq.npq04) THEN
               LET l_npq.npq04 = l_sr.oma01 CLIPPED,' ',
                                 l_sr.oox05 CLIPPED,' ',
                                 l_sr.oox07 USING '<<<&.<<<<'
            END IF
            #FUN-D10065--add--end
         END IF  #No.TQC-760156
         #No.FUN-5C0015 ---end
         IF g_ooz.ooz15 <> '1' THEN
            CALL s_def_npq3(l_bookno3,l_npq.npq03,g_prog,l_sr.oma01,g_oox01,g_oox02) RETURNING l_npq.npq04
            IF cl_null(l_npq.npq04) THEN
               IF g_ooz.ooz15 = '3' THEN
                  LET l_npq.npq04 = l_sr.oma032 CLIPPED,' ',
                                    l_sr.oox05 CLIPPED,' ',
                                    l_sr.oox07 USING '<<<&.<<<<'
               ELSE
                  LET l_npq.npq04 = l_sr.oox05 CLIPPED,' ',l_sr.oox07 USING '<<<&.<<<<'
               END IF
            END IF
         END IF
         #FUN-D10065--add--end


         #No.CHI-C80005  --End
         SELECT aag06,aag42 INTO l_aag06,l_aag42 FROM aag_file
          WHERE aag01 = l_npq.npq03 AND aag00 = l_bookno3

         IF l_aag42 = 'Y' AND l_npq.npq06<>l_aag06 THEN 
            LET l_npq.npq06 = l_aag06
            LET l_npq.npq07 = l_npq.npq07 * -1 
            LET l_npq.npq07f = l_npq.npq07f * -1 
         END IF
         #No.CHI-C80005  --End 
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = l_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,l_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         #No.CHI-D50024  --Begin         
         SELECT aag05 INTO l_aag05 FROM aag_file   
          WHERE aag01 = l_npq.npq03 AND aag00 = l_bookno3
         
         LET l_npq.npq05 = ''
         IF l_aag05 = 'Y' THEN
            IF g_aaz.aaz90='N' THEN
               IF cl_null(l_npq.npq05) THEN
                  LET l_npq.npq05 = l_sort.oma15
               END IF
            ELSE
               LET l_npq.npq05 = l_sort.oma930 
            END IF
         ELSE
            LET l_npq.npq05 = ''
         END IF   
         #No.CHI-D50024  --end 
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('ins npq #22',SQLCA.SQLCODE,0)   #No.FUN-660146
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq #22",0)   #No.FUN-660146
            LET g_success='N' EXIT FOREACH
         END IF
      END IF
   END FOREACH
 
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
        LET g_success='N' EXIT FOREACH
     END IF
     IF cl_null(l_sr2.oox10) THEN LET l_sr2.oox10 = 0 END IF
     LET l_npq.npq21 = 'MISC'                                                   
     LET l_npq.npq22 = ''                                                   
    #LET l_npq.npq04 = l_sr2.oox05 CLIPPED,' ',l_sr2.oox07 USING '<<<<.<<<<'   #MOD-CB0187 mark
    #LET l_npq.npq04 = l_sr2.oox05 CLIPPED,' ',l_sr2.oox07 USING '<<<&.<<<<'   #MOD-CB0187 add    #FUN-D10065 mark
     LET l_npq.npq23 = ''                                                   
     LET l_npq.npq24 = l_sr2.oox05
     IF l_sr2.oox10 > 0 THEN
        LET l_npq.npq02 = l_npq.npq02 + 1
        LET l_npq.npq06 = '2'
        #No.FUN-670047--begin
#       LET l_npq.npq03 = l_ool.ool53
        IF l_npptype = '0' THEN
           LET l_npq.npq03 = l_ool.ool53
        ELSE
           LET l_npq.npq03 = l_ool.ool531
        END IF
        #No.FUN-670047--end  
        LET l_npq.npq07 = l_sr2.oox10
        MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
        IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
    
        #NO.FUN-5C0015 ---start
#       CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')   #FUN-740009
#       CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)  #FUN-740009 #No.TQC-760156 mark
#       RETURNING l_npq.*    #No.TQC-760156 mark
        #FUN-D10065--add--str--
        LET l_npq.npq04 = NULL
        CALL s_def_npq3(l_bookno3,l_npq.npq03,g_prog,l_npq.npq01,'','') RETURNING l_npq.npq04
        IF cl_null(l_npq.npq04) THEN
           LET l_npq.npq04 = l_sr2.oox05 CLIPPED,' ',l_sr2.oox07 USING '<<<&.<<<<'
        END IF
        #FUN-D10065--add--end

        #No.FUN-5C0015 ---end
         #No.CHI-C80005  --End
         SELECT aag06,aag42 INTO l_aag06,l_aag42 FROM aag_file
          WHERE aag01 = l_npq.npq03 AND aag00 = l_bookno3

         IF l_aag42 = 'Y' AND l_npq.npq06<>l_aag06 THEN
            LET l_npq.npq06 = l_aag06
            LET l_npq.npq07 = l_npq.npq07 * -1
            LET l_npq.npq07f = l_npq.npq07f * -1
         END IF
         #No.CHI-C80005  --End 
        #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = l_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,l_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         #No.CHI-D50024  --Begin         
         SELECT aag05 INTO l_aag05 FROM aag_file   
          WHERE aag01 = l_npq.npq03 AND aag00 = l_bookno3
         
         LET l_npq.npq05 = ''
         IF l_aag05 = 'Y' THEN
            IF g_aaz.aaz90='N' THEN
               IF cl_null(l_npq.npq05) THEN
                  LET l_npq.npq05 = l_sort.oma15
               END IF
            ELSE
               LET l_npq.npq05 = l_sort.oma930 
            END IF
         ELSE
            LET l_npq.npq05 = ''
         END IF   
         #No.CHI-D50024  --end 
        INSERT INTO npq_file VALUES (l_npq.*)
        IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#          CALL cl_err('ins npq #12',SQLCA.SQLCODE,0)    #No.FUN-660146
           CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq #12",0)   #No.FUN-660146
           LET g_success='N' EXIT FOREACH
        END IF
     ELSE
         LET l_npq.npq02 = l_npq.npq02 + 1
         #No.FUN-670047--begin
#        LET l_npq.npq03 = l_ool.ool52
         IF l_npptype = '0' THEN
            LET l_npq.npq03 = l_ool.ool52
         ELSE
            LET l_npq.npq03 = l_ool.ool521
         END IF
         #No.FUN-670047--end  
         LET l_npq.npq06 = '1'
         LET l_npq.npq07 = l_sr2.oox10 * -1
         MESSAGE '>',l_npq.npq02,' ',l_npq.npq03
         IF cl_null(l_npq.npq03) THEN LET l_npq.npq03='-' END IF
    
         #NO.FUN-5C0015 ---start
#        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','')   #FUN-740009
#        CALL s_def_npq(l_npq.npq03,g_prog,l_npq.*,l_npq.npq01,'','',l_bookno3)   #FUN-740009 #No.TQC-760156 mark
#        RETURNING l_npq.*    #No.TQC-760156 mark
         #No.FUN-5C0015 ---end
         #No.CHI-C80005  --End
         SELECT aag06,aag42 INTO l_aag06,l_aag42 FROM aag_file
          WHERE aag01 = l_npq.npq03 AND aag00 = l_bookno3

         IF l_aag42 = 'Y' AND l_npq.npq06<>l_aag06 THEN
            LET l_npq.npq06 = l_aag06
            LET l_npq.npq07 = l_npq.npq07 * -1
            LET l_npq.npq07f = l_npq.npq07f * -1
         END IF
         #No.CHI-C80005  --End 
         #FUN-D40118--add--str--
         SELECT aag44 INTO g_aag44 FROM aag_file
          WHERE aag00 = l_bookno3
            AND aag01 = l_npq.npq03
         IF g_aza.aza26 = '2' AND g_aag44 = 'Y' THEN
            CALL s_chk_ahk(l_npq.npq03,l_bookno3) RETURNING l_flag
            IF l_flag = 'N'   THEN
               LET l_npq.npq03 = ''
            END IF
         END IF
         #FUN-D40118--add--end--
         #No.CHI-D50024  --Begin         
         SELECT aag05 INTO l_aag05 FROM aag_file   
          WHERE aag01 = l_npq.npq03 AND aag00 = l_bookno3
         
         LET l_npq.npq05 = ''
         IF l_aag05 = 'Y' THEN
            IF g_aaz.aaz90='N' THEN
               IF cl_null(l_npq.npq05) THEN
                  LET l_npq.npq05 = l_sort.oma15
               END IF
            ELSE
               LET l_npq.npq05 = l_sort.oma930 
            END IF
         ELSE
            LET l_npq.npq05 = ''
         END IF   
         #No.CHI-D50024  --end 
         INSERT INTO npq_file VALUES (l_npq.*)
         IF STATUS OR SQLCA.SQLERRD[3]=0 THEN
#           CALL cl_err('ins npq #21',SQLCA.SQLCODE,0)   #No.FUN-660146
            CALL cl_err3("ins","npq_file",l_npq.npq01,l_npq.npq02,SQLCA.sqlcode,"","ins npq #21",0)   #No.FUN-660146
            LET g_success='N' EXIT FOREACH
         END IF
     END IF
   END FOREACH
   CALL s_flows('3','',l_npq.npq01,l_npp.npp02,'N',l_npq.npqtype,TRUE)   #No.TQC-B70021  
END FUNCTION

#No.FUN-D40107 ---Add--- Start
FUNCTION q600_gxrp600()
   DEFINE l_str      STRING
   LET l_str = "gxrp600 '",g_oox01,"' '",g_oox02,"' 'N' "
   CALL cl_cmdrun(l_str)
END FUNCTION

FUNCTION q600_gxrp601()
   DEFINE l_str      STRING
   LET l_str = "gxrp601 '",g_oox01,"' '",g_oox02,"' 'N' "
   CALL cl_cmdrun(l_str)
END FUNCTION

FUNCTION q600_gxrp610()
   DEFINE l_str      STRING
   LET l_str = "gxrp610 '1' '' '' '' '' 'N' "
   CALL cl_cmdrun(l_str)
END FUNCTION

FUNCTION q600_gxrp620()
   DEFINE l_str      STRING
   DEFINE l_nppglno  LIKE npp_file.nppglno
   LET g_trno = g_oox00,g_oox01 USING '&&&&',g_oox02 USING '&&'
   SELECT nppglno INTO l_nppglno FROM npp_file WHERE npp01 = g_trno AND npp00 = 4
   LET l_str = "gxrp620 '' '' '",l_nppglno,"' 'N' "
   CALL cl_cmdrun(l_str)
END FUNCTION
#No.FUN-D40107 ---Add--- End
