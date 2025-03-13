# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#{
# Program name   : q_oeb10.4gl
# Program ver.   : 7.0
# Description    : 訂單資料查詢-過濾已開立出貨或出通訂單資料
# Date & Author  : 2009/04/10 by Dido copy from q_oeb.4gl
# Memo           : 
# Modify.........: No.MOD-5C0058 05/12/09 By Nicola 多單位資料也要新增至出貨單身中
# Modify.........: No.FUN-660161 06/07/07 By Rayven 增加匯出Excel功能
# Modify.........: No.FUN-660161 06/07/07 By Rayven 增加匯出Excel功能
# Modify.........: No.FUN-680006 06/08/02 By kim GP3.5 利潤中心
# Modify.........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-6B0044 06/11/13 By kim GP3.5 台虹保稅客製功能回收修改
# Modify.........; No.MOD-6C0010 06/12/04 by Yiting ogb1005需負予預設值
# Modify.........: No.FUN-670090 07/01/15 BY yiting cl_err->cl_err3
# Modify.........: No.CHI-710059 07/02/02 BY jamie ogb14應為ogb917*ogb13
# Modify.........: No.MOD-780285 07/08/31 BY claire 分批出貨時,未考慮多單位及計價單位的數量
# Modify.........: No.MOD-7B0195 07/11/22 BY claire 可出貨數量應改為(oeb12-oeb24+oeb25)>0 and oeb70='N'
# Modify.........: No.MOD-7B0266 07/11/30 BY claire 檢驗否值要傳回出貨單
# Modify.........: No.TQC-780032 08/01/14 BY jamie 開窗查詢,後方的欄位改為oeb12,oeb24,oeb25,(oeb12-oeb24+oeb25),oeb15
# Modify.........: No.FUN-880082 08/08/22 By tsai_yen 開窗全選功能
# Modify.........: No.MOD-8B0182 08/11/19 By Smapmin 訂單抓取條件由訂單單身數量決定即可
# Modify.........: No.MOD-8C0079 08/12/09 By Smapmin 原因碼未default
# Modify.........: No.MOD-8C0110 08/12/11 By Smapmin 由訂單整批產生單身時,未加入合理性控管
# Modify.........: No.MOD-8C0120 08/12/15 By Smapmin 原幣金額未依幣別取位
# Modify.........: No.MOD-940130 09/04/10 By Dido 過濾已開立出貨或出通訂單資料
# Modify.........: No.MOD-960281 09/06/25 By lilingyu 在維護單身的時候從訂單挑選,保存后再進行相同條件的挑選,原來的訂單量還是保持不變
# Modify.........: No.MOD-960353 09/07/16 By Smapmin 出貨數量帶到單身時有誤
# Modify.........: No.FUN-870007 09/08/13 By Zhangyajun 流通零售功能修改
# Modify.........: No.FUN-980012 09/08/24 By TSD.sar2436 GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.MOD-990181 09/09/29 By Smapmin 產生至出貨單單身時,若為ICD產業,也要產生ogbi_file的資料
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定 
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:MOD-A30126 10/03/22 By Smapmin 一併產生備註資料
# Modify.........: No:MOD-A40177 10/05/10 By Smapmin 修改WHERE 條件
# Modify.........: NO:MOD-AA0118 10/10/20 By Dido 尚可出貨量邏輯調整
# Modify.........: NO:MOD-A90122 10/09/20 By Smapmin  ON IDLE處理
# Modify.........: No.FUN-AB0061 10/11/17 By shenyang 出貨單加基礎單價字段ogb37
# Modify.........: No.FUN-AB0096 10/11/25 By vealxu 因新增ogb50的not null欄位,所導致其他作業無法insert into資料的問題修正
# Modify.........: No.FUN-AC0055 10/12/21 By wangxin oga55,ogb50欄位預設值修正
# Modify.........: NO:MOD-AC0261 10/12/24 By Smapmin 不同多角流程代碼的檢核,要將原先已存在單身的訂單考慮進去 
# Modify.........: NO:MOD-B60012 11/06/01 By zhangll CALL s_check_no增加第三個傳參,即就單據編號
# Modify.........: NO:MOD-B90198 11/09/26 By Vampire "從訂單挑選"功能,要過濾合約訂單 
# Modify.........: No:FUN-BB0083 11/12/21 By xujing 增加數量欄位小數取位
# Modify.........: No:TQC-C60093 12/06/12 By yangtt 在產品編號后添加品名和規格欄位 
# Modify.........: NO:MOD-C40078 12/06/27 By Vampire 調整axm-119判斷條件
# Modify.........: NO:MOD-C40132 12/06/27 By Vampire 多角出貨ms_argv0 MATCHES '[456]時,且參數設定一單到底時不控卡mfg0015
# Modify.........: No:FUN-C50097 12/06/13 By SunLM  對非空字段進行判斷ogb50,51,52             


DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         oea10    LIKE oea_file.oea10,      #str—add by huanglf 160712
         oea01    LIKE oea_file.oea01,
         oea02    LIKE oea_file.oea02,
         oeb03    LIKE oeb_file.oeb03,
         oeb04    LIKE oeb_file.oeb04,
         oeb06    LIKE oeb_file.oeb06,          #TQC-C60093 add
         ima021   LIKE ima_file.ima021,         #TQC-C60093 add
         oeb091   LIKE oeb_file.oeb091,
         oeb12    LIKE oeb_file.oeb12,   
         oeb24    LIKE oeb_file.oeb24,          #TQC-780032 add
         oeb25    LIKE oeb_file.oeb25,          #TQC-780032 add
         oeb12a   LIKE oeb_file.oeb12,          #TQC-780032 add
         oeb15    LIKE oeb_file.oeb15           #TQC-780032 add
END RECORD
#-----MOD-8C0110---------
DEFINE   ma_qry2  DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1, 
         oea10    LIKE oea_file.oea10,  #str—add by huanglf 160712  
         oea01    LIKE oea_file.oea01,
         oea02    LIKE oea_file.oea02,
         oeb03    LIKE oeb_file.oeb03,
         oeb04    LIKE oeb_file.oeb04,
         oeb06    LIKE oeb_file.oeb06,          #TQC-C60093 add
         ima021   LIKE ima_file.ima021,         #TQC-C60093 add
         oeb091   LIKE oeb_file.oeb091,
         oeb12    LIKE oeb_file.oeb12,   
         oeb24    LIKE oeb_file.oeb24,          #TQC-780032 add
         oeb25    LIKE oeb_file.oeb25,          #TQC-780032 add
         oeb12a   LIKE oeb_file.oeb12,          #TQC-780032 add
         oeb15    LIKE oeb_file.oeb15           #TQC-780032 add
END RECORD
DEFINE   ma_qry3  DYNAMIC ARRAY OF RECORD
         oea01    LIKE oea_file.oea01
         END RECORD
#-----END MOD-8C0110-----
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         oea10        LIKE oea_file.oea10,       #str—add by huanglf 160712
         oea01        LIKE oea_file.oea01,
         oea02        LIKE oea_file.oea02,
         oeb03        LIKE oeb_file.oeb03,
         oeb04        LIKE oeb_file.oeb04,
         oeb06        LIKE oeb_file.oeb06,          #TQC-C60093 add
         ima021       LIKE ima_file.ima021,         #TQC-C60093 add
         oeb091       LIKE oeb_file.oeb091,
         oeb12        LIKE oeb_file.oeb12, 
         oeb24        LIKE oeb_file.oeb24,          #TQC-780032 add
         oeb25        LIKE oeb_file.oeb25,          #TQC-780032 add
         oeb12a       LIKE oeb_file.oeb12,          #TQC-780032 add
         oeb15        LIKE oeb_file.oeb15           #TQC-780032 add
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_cus           LIKE oea_file.oea03,
         ms_oga01         LIKE oga_file.oga01,
         ms_oga213        LIKE oga_file.oga213,
         ms_oga211        LIKE oga_file.oga211,
         ms_oga24         LIKE oga_file.oga24,
         ms_oga04         LIKE oga_file.oga04,
         ms_oga21         LIKE oga_file.oga21,
         ms_oga23         LIKE oga_file.oga23,
         ms_oga25         LIKE oga_file.oga25,
         ms_ogb03         LIKE ogb_file.ogb03,
         ms_oga16         LIKE oga_file.oga16,   #MOD-8C0110
         ms_oga08         LIKE oga_file.oga08,   #MOD-8C0110
         ms_oga32         LIKE oga_file.oga32,   #MOD-8C0110
         ms_argv0         LIKE type_file.chr1    #MOD-8C0110
DEFINE   mr_oeb           RECORD LIKE oeb_file.*
DEFINE   mr_ogb           RECORD LIKE ogb_file.*
DEFINE   g_cnt            LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
FUNCTION q_oeb10(pi_multi_sel,pi_need_cons,ps_cus,ps_oga01,ps_oga213,ps_oga211,
               #ps_oga24,ps_oga04,ps_oga21,ps_oga23,ps_oga25)      #MOD-8C0110
               ps_oga24,ps_oga04,ps_oga21,ps_oga23,ps_oga25,ps_argv0)      #MOD-8C0110
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   ps_cus          LIKE oea_file.oea03,
            ps_oga01        LIKE oga_file.oga01,
            ps_oga213       LIKE oga_file.oga213,
            ps_oga211       LIKE oga_file.oga211,
            ps_oga24        LIKE oga_file.oga24,
            ps_oga04        LIKE oga_file.oga04,
            ps_oga21        LIKE oga_file.oga21,
            ps_oga23        LIKE oga_file.oga23,
            ps_oga25        LIKE oga_file.oga25,
            ps_argv0        LIKE type_file.chr1   #MOD-8C0110
 
 
   WHENEVER ERROR CONTINUE
 
   LET ms_cus    = ps_cus  
   LET ms_oga01  = ps_oga01
   LET ms_oga213 = ps_oga213
   LET ms_oga211 = ps_oga211
   LET ms_oga24  = ps_oga24
   LET ms_oga04  = ps_oga04
   LET ms_oga21  = ps_oga21
   LET ms_oga23  = ps_oga23
   LET ms_oga25  = ps_oga25
   LET ms_argv0  = ps_argv0   #MOD-8C0110
   SELECT oga16,oga08,oga32 INTO ms_oga16,ms_oga08,ms_oga32 FROM oga_file   #MOD-8C0110
    WHERE oga01 = ms_oga01   #MOD-8C0110
 
   OPEN WINDOW w_qry WITH FORM "cqry/42f/q_oeb" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_oeb")
 
   LET mi_multi_sel = TRUE
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   CALL oeb_qry_sel_oeb10()
 
   CLOSE WINDOW w_qry
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2004/02/27 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oeb_qry_sel_oeb10()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
  #MOD-780285-begin-add
   DEFINE l_ogb912a  LIKE ogb_file.ogb912,
          l_ogb915a  LIKE ogb_file.ogb915,
          l_ogb917a  LIKE ogb_file.ogb917
  #MOD-780285-end-add
 
 
   LET mi_page_count = 100 
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      DISPLAY ms_cus TO oea03 
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      LET ms_cons_where=" 1=1"
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
            CONSTRUCT BY NAME ms_cons_where ON oea10,oea01,oea02,oeb03,oeb04,oeb06,ima021,oeb091,oeb12,  #TQC-C60093 add oeb06,ima021
                                               oeb24,oeb25,oeb12a,oeb15   #TQC-780032 add #str—add by huanglf 160712
     
            #-----MOD-A90122---------
            ON ACTION controlg      
               CALL cl_cmdask()     

            ON IDLE g_idle_seconds
               CALL cl_on_idle()
               CONTINUE CONSTRUCT
 
            ON ACTION about         
               CALL cl_about()      
 
            ON ACTION help          
               CALL cl_show_help()  

            END CONSTRUCT
            #-----END MOD-A90122-----
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL oeb_qry_prep_result_set_oeb10() 
         # 2003/07/14 by Hiko : 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 2003/07/14 by Hiko : 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
         IF (mi_page_count >= ma_qry.getLength()) THEN
            LET ls_hide_act = "prevpage,nextpage"
         END IF
     
         IF (NOT mi_need_cons) THEN
            IF (ls_hide_act IS NULL) THEN
               LET ls_hide_act = "reconstruct"
            ELSE
               LET ls_hide_act = "prevpage,nextpage,reconstruct"
            END IF 
         END IF
     
         LET li_start_index = 1
     
         LET li_reconstruct = FALSE
      END IF
     
      LET li_end_index = li_start_index + mi_page_count - 1
     
      IF (li_end_index > ma_qry.getLength()) THEN
         LET li_end_index = ma_qry.getLength()
      END IF
     
      CALL oeb_qry_set_display_data_oeb10(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      # 2004/02/25 by saki : 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL oeb_qry_input_array_oeb10(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL oeb_qry_display_array_oeb10(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2004/02/27 by saki
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION oeb_qry_prep_result_set_oeb10()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
            oea10      LIKE oea_file.oea10,     #str—add by huanglf 160712
            oea01      LIKE oea_file.oea01,
            oea02      LIKE oea_file.oea02,
            oeb03      LIKE oeb_file.oeb03,
            oeb04      LIKE oeb_file.oeb04,
            oeb06      LIKE oeb_file.oeb06,          #TQC-C60093 add
            ima021     LIKE ima_file.ima021,         #TQC-C60093 add
            oeb091     LIKE oeb_file.oeb091,
            oeb12      LIKE oeb_file.oeb12,
            oeb24      LIKE oeb_file.oeb24,          #TQC-780032 add
            oeb25      LIKE oeb_file.oeb25,          #TQC-780032 add
            oeb12a     LIKE oeb_file.oeb12,          #TQC-780032 add
            oeb15      LIKE oeb_file.oeb15           #TQC-780032 add
   END RECORD
   DEFINE   l_oeb12    LIKE oeb_file.oeb12 	
   DEFINE   l_ogb12    LIKE ogb_file.ogb12           #MOD-940130
 
 
   IF cl_null(ms_oga16) THEN   #MOD-8C0110
     #LET ls_sql = "SELECT 'N',oea01,oea02,oeb03,oeb04,oeb091,(oeb12-oeb24+oeb25),oeb24,oeb15",              #TQC-780032 mark #MOD-780285 modify -oeb24  #MOD-7B0195 +oeb25
 
      #Begin:FUN-980030
      LET l_filter_cond = cl_get_extra_cond_for_qry('q_oeb10', 'oea_file')
      IF NOT cl_null(l_filter_cond) THEN
         LET ms_cons_where = ms_cons_where,l_filter_cond
      END IF
      #End:FUN-980030
      LET ls_sql = "SELECT 'N',oea10,oea01,oea02,oeb03,oeb04,oeb06,ima021,oeb091,oeb12,oeb24,oeb25,(oeb12-oeb24+oeb25),oeb15",  #TQC-780032 mod  #MOD-780285 modify -oeb24  #MOD-7B0195 +oeb25   #TQC-C60093 add oeb06,ima021
                   " FROM oea_file,oeb_file,ima_file",    #TQC-C60093 add ima_file
                   " WHERE oea01 = oeb01",
                   "   AND oeb04 = ima01",       #TQC-C60093
                   "   AND oea03 = '",ms_cus CLIPPED,"'",
                   "   AND oeaconf = 'Y' ",
                   "   AND oea04   = '",ms_oga04,"' ", #帳款客戶
                   "   AND oea21   = '",ms_oga21,"' ", #稅別 
                   "   AND oea23   = '",ms_oga23,"' ", #幣別 
                   "   AND oea25   = '",ms_oga25,"' ", #銷售分類 
                   #"   AND oea61>(oea62+oea63)",   #MOD-8B0182
                   "   AND ",ms_cons_where CLIPPED,
                   "   AND oeb70 = 'N' ",          #MOD-7B0195 
                   "   AND oeb12-oeb24+oeb25 > 0", #MOD-7B0195
                   "   AND oea08 = '",ms_oga08,"' ",   #MOD-8C0110
                   "   AND oea00 != '0' ",   #MOD-B90198 add
                   " ORDER BY oea01,oeb03 "
   #-----MOD-8C0110---------
   ELSE
      LET ls_sql = "SELECT 'N',oea10,oea01,oea02,oeb03,oeb04,oeb06,ima021,oeb091,oeb12,oeb24,oeb25,(oeb12-oeb24+oeb25),oeb15",  #TQC-780032 mod  #MOD-780285 modify -oeb24  #MOD-7B0195 +oeb25   #TQC-C60093 add oeb06,ima021,
                   " FROM oea_file,oeb_file,ima_file",    #TQC-C60093 add ima_file
                   " WHERE oea01 = oeb01",
                   "   AND oeb04 = ima01",       #TQC-C60093
                   "   AND oeaconf = 'Y' ",
                   "   AND oea01 = '",ms_oga16,"' ",
                   "   AND ",ms_cons_where CLIPPED,
                   "   AND oeb70 = 'N' ",          
                   "   AND oeb12-oeb24+oeb25 > 0", 
                   "   AND oea08 = '",ms_oga08,"' ",  
                   "   AND oea00 != '0' ",   #MOD-B90198 add
                   " ORDER BY oea01,oeb03 "
   END IF
   #-----END MOD-8C0110-----
 
#FUN-990069---begin 
   IF (NOT mi_multi_sel ) THEN
      CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql
   END IF     
#FUN-990069---end  
              
   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
      
      #-MOD-940130-add
      SELECT SUM(ogb12) INTO l_ogb12
       FROM oga_file,ogb_file
      WHERE oga01 = ogb01
        AND oga09 = ms_argv0
        AND ogb31 = lr_qry.oea01
        AND ogb32 = lr_qry.oeb03
        AND ogaconf <> 'X'   #MOD-A40177
      IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF
 
      IF lr_qry.oeb12 <= l_ogb12 THEN
         CONTINUE FOREACH
      END IF
      #-MOD-940130-end
 
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
#MOD-960281 --begin--
     LET lr_qry.oeb24 = l_ogb12
    #LET lr_qry.oeb12a = lr_qry.oeb12a - l_ogb12                     #MOD-AA0118 mark
     LET lr_qry.oeb12a = lr_qry.oeb12 - lr_qry.oeb24 + lr_qry.oeb25  #MOD-AA0118
#MOD-960281 --end--
 
      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2004/02/27 by saki
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION oeb_qry_set_display_data_oeb10(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   CALL ma_qry_tmp.clear()
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
 
##################################################
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2004/02/27 by saki
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION oeb_qry_input_array_oeb10(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oeb.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oeb.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_oeb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL oeb_qry_reset_multi_sel_oeb10(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_oeb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL oeb_qry_reset_multi_sel_oeb10(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL oeb_qry_refresh_oeb10()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_oeb.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL oeb_qry_reset_multi_sel_oeb10(pi_start_index, pi_end_index)
            IF cl_sure(0,0) THEN
               CALL oeb_qry_accept_oeb10(pi_start_index+ARR_CURR()-1)
            ELSE
               CLOSE WINDOW w_qry 
            END IF
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         LET li_continue = FALSE
     
         EXIT INPUT
 
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--

      #-----MOD-A90122---------
      ON ACTION controlg      
         CALL cl_cmdask()     

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
      #-----END MOD-A90122-----
 
      ### FUN-880082 START ###
      ON ACTION selectall
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "Y"
         END FOR
 
      ON ACTION select_none
         FOR li_i = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[li_i].check = "N"
         END FOR
      ### FUN-880082 END ###
 
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : 2004/02/27 by saki
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oeb_qry_reset_multi_sel_oeb10(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION
 
##################################################
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2004/02/27 by saki
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION oeb_qry_display_array_oeb10(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_oeb.*
      BEFORE DISPLAY
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
      
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION nextpage
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
      
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION refresh
         LET pi_start_index = 1
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
      
         EXIT DISPLAY
      ON ACTION accept
         CALL oeb_qry_accept_oeb10(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         LET li_continue = FALSE
      
         EXIT DISPLAY
 
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--

      #-----MOD-A90122---------
      ON ACTION controlg      
         CALL cl_cmdask()     

      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY 
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help          
         CALL cl_show_help()  
      #-----END MOD-A90122-----
 
   END DISPLAY
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2004/02/27 by saki
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION oeb_qry_refresh_oeb10()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2004/02/27 by saki
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oeb_qry_accept_oeb10(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_i2,li_i3     LIKE type_file.num10,       #MOD-8C0110
            #-----MOD-990181---------
            l_ogbi          RECORD LIKE ogbi_file.*,   
            l_oebi          RECORD LIKE oebi_file.*,
            l_imaicd04      LIKE imaicd_file.imaicd04,
            l_cnt           LIKE type_file.num5,
            l_flag          LIKE type_file.chr1   
            #-----END MOD-990181----- 
 
   LET g_success='Y'
   BEGIN WORK
      SELECT MAX(ogb03)+1 INTO ms_ogb03 FROM ogb_file WHERE ogb01 = ms_oga01 
      #@@@ 95/07/05 by danny
      IF cl_null(ms_ogb03) THEN LET ms_ogb03=1 END IF
      #@@@
      #-----MOD-8C0110---------
      LET li_i2 = 1
      LET li_i3 = 1
      CALL ma_qry2.clear()
      CALL ma_qry3.clear()
      FOR li_i = 1 TO ma_qry.getLength()   
          IF (ma_qry[li_i].check = 'Y') THEN
              LET ma_qry2[li_i2].* = ma_qry[li_i].*
              IF li_i2 > 1 THEN
                 IF ma_qry2[li_i2].oea01 <> ma_qry2[li_i2-1].oea01 THEN
                    LET ma_qry3[li_i3].oea01 = ma_qry[li_i].oea01
                    LET li_i3 = li_i3 + 1
                 END IF
              ELSE
                 LET ma_qry3[li_i3].oea01 = ma_qry[li_i].oea01
                 LET li_i3 = li_i3 + 1
              END IF
              LET li_i2 = li_i2 + 1
          END IF
      END FOR
      CALL ma_qry2.deleteElement(li_i2)
      CALL ma_qry3.deleteElement(li_i3)
      CALL s_showmsg_init() 
      CALL q_oeb_chk_oeb10()
      IF g_success = 'Y' THEN 
      #-----END MOD-8C0110-----
         FOR li_i = 1 TO ma_qry.getLength()   
            IF (ma_qry[li_i].check = 'Y') THEN
               SELECT * INTO mr_oeb.* FROM oeb_file
               WHERE oeb01=ma_qry[li_i].oea01 AND oeb03=ma_qry[li_i].oeb03
               INITIALIZE mr_ogb.* TO NULL
               LET mr_ogb.ogb01 = ms_oga01
               LET mr_ogb.ogb03 = ms_ogb03
               LET mr_ogb.ogb1005 = '1'    #NO.MOD-6C0010
               CALL oeb_qry_detail_oeb10()
               LET mr_ogb.ogb44='1' #No.FUN-870007
               LET mr_ogb.ogb47=0   #No.FUN-870007
               LET mr_ogb.ogbplant = g_plant #FUN-980012 add
               LET mr_ogb.ogblegal = g_legal #FUN-980012 add
#FUN-AB0061 -----------add start----------------                          
               IF cl_null(mr_ogb.ogb37) OR mr_ogb.ogb37=0 THEN           
                   LET mr_ogb.ogb37=mr_ogb.ogb13                         
               END IF                                                                             
#FUN-AB0061 -----------add end----------------  
#FUN-AC0055 mark ---------------------begin-----------------------
##FUN-AB0096 ------------add start----------------
#               IF cl_null(mr_ogb.ogb50) THEN
#                 LET  mr_ogb.ogb50 = '1'
#               END IF
##FUN-AB0096 --------------add end----------------------           
#FUN-AC0055 mark ----------------------end------------------------  
#FUN-C50097 ------------add start----------------
               IF cl_null(mr_ogb.ogb50) THEN
                 LET  mr_ogb.ogb50 = '0'
               END IF
               IF cl_null(mr_ogb.ogb51) THEN
                 LET  mr_ogb.ogb51 = '0'
               END IF
               IF cl_null(mr_ogb.ogb52) THEN
                 LET  mr_ogb.ogb52 = '0'
               END IF    
               IF cl_null(mr_ogb.ogb53) THEN
                 LET  mr_ogb.ogb53 = '0'
               END IF
               IF cl_null(mr_ogb.ogb54) THEN
                 LET  mr_ogb.ogb54 = '0'
               END IF
               IF cl_null(mr_ogb.ogb55) THEN
                 LET  mr_ogb.ogb55 = '0'
               END IF
#FUN-C50097 --------------add end----------------
               LET mr_ogb.ogbud02=ma_qry[li_i].oea10
               INSERT INTO ogb_file VALUES(mr_ogb.*)
               IF STATUS THEN 
                  CALL cl_err3("ins","ogb_file","","",STATUS,"","",0)   #No.FUN-670090
                  #CALL cl_err('ins ogb',STATUS,1) LET g_success='N'
                  EXIT FOR
               #-----MOD-990181---------
               ELSE
                  IF s_industry('icd') THEN
                     INITIALIZE l_ogbi.* TO NULL
                     SELECT * INTO l_oebi.* FROM oebi_file
                       WHERE oebi01 = ma_qry[li_i].oea01
                         AND oebi03 = ma_qry[li_i].oeb03
                     IF l_oebi.oebiicd04 = 'Y' THEN
                        LET l_ogbi.ogbiicd02 = 0 
                     ELSE
                        IF cl_null(l_oebi.oebiicd03) THEN
                           LET l_ogbi.ogbiicd02 = 0
                        ELSE
                           LET l_ogbi.ogbiicd02 = mr_ogb.ogb12 * (l_oebi.oebiicd03/100)
                           CALL cl_digcut(l_ogbi.ogbiicd02,0) RETURNING l_ogbi.ogbiicd02
                        END IF
                     END IF 
                     LET l_ogbi.ogbiicd03 = '0'
                     LET l_ogbi.ogbiicd04 = NULL
                     LET l_imaicd04 = NULL
                     SELECT imaicd04 INTO l_imaicd04
                       FROM imaicd_file
                      WHERE imaicd00 = mr_ogb.ogb04
                     LET l_cnt = 0
                     SELECT COUNT(*) INTO l_cnt
                       FROM jce_file
                      WHERE jce02 = mr_ogb.ogb09
                        AND jceacti = 'Y'
                     IF l_imaicd04 MATCHES '[1234]' AND l_cnt > 0 THEN
                        LET l_ogbi.ogbiicd01 = 'Y'
                     ELSE
                        LET l_ogbi.ogbiicd01 = 'N'
                     END IF
                     LET l_ogbi.ogbi01 = mr_ogb.ogb01
                     LET l_ogbi.ogbi03 = mr_ogb.ogb03
                     LET l_flag = s_ins_ogbi(l_ogbi.*,'')
                  END IF
               #-----END MOD-990181-----
               END IF
               #-----MOD-A30126---------
               DROP TABLE x
               SELECT * FROM oao_file 
                WHERE oao01=mr_ogb.ogb31
                  AND oao03=mr_ogb.ogb32
                 INTO TEMP x
                 UPDATE x SET oao01 = mr_ogb.ogb01,
                              oao03 = mr_ogb.ogb03
               INSERT INTO oao_file SELECT * FROM x
               IF STATUS THEN 
                  CALL cl_err3("ins","oao_file","","",STATUS,"","",0)  
                  EXIT FOR
               END IF
               #-----END MOD-A30126-----
               LET ms_ogb03 = ms_ogb03 + 1
            END IF    
         END FOR
      END IF   #MOD-8C0110
      CALL s_showmsg()   #MOD-8C0110
      IF g_success='Y' THEN
         COMMIT WORK 
      ELSE
         ROLLBACK WORK
      END IF
      MESSAGE ''
END FUNCTION
 
FUNCTION oeb_qry_detail_oeb10()
   DEFINE l_ogb15  LIKE ogb_file.ogb15
   DEFINE l_ima35  LIKE ima_file.ima35 #No.MOD-5C0058
   DEFINE l_ima36  LIKE ima_file.ima36 #No.MOD-5C0058
  #MOD-780285-begin-add
   DEFINE l_ogb912a  LIKE ogb_file.ogb912,
          l_ogb915a  LIKE ogb_file.ogb915,
          l_ogb917a  LIKE ogb_file.ogb917
  #MOD-780285-end-add
DEFINE   l_ogb12    LIKE ogb_file.ogb12 #MOD-940130
 
   LET mr_ogb.ogb31     = mr_oeb.oeb01
   LET mr_ogb.ogb32     = mr_oeb.oeb03
   LET mr_ogb.ogb04     = mr_oeb.oeb04
   LET mr_ogb.ogb05     = mr_oeb.oeb05
   LET mr_ogb.ogb05_fac = mr_oeb.oeb05_fac
   LET mr_ogb.ogb06     = mr_oeb.oeb06
   LET mr_ogb.ogb07     = mr_oeb.oeb07
   LET mr_ogb.ogb09     = mr_oeb.oeb09
   LET mr_ogb.ogb091    = mr_oeb.oeb091
   LET mr_ogb.ogb1001   = mr_oeb.oeb1001    #MOD-8C0079
   #-----No.MOD-5C0058-----
   SELECT ima35,ima36 INTO l_ima35,l_ima36
     FROM ima_file
    WHERE ima01 = mr_oeb.oeb04
 
   IF cl_null(mr_ogb.ogb09) THEN
      LET mr_ogb.ogb09 = l_ima35
   END IF
 
   IF cl_null(mr_ogb.ogb091) THEN 
      LET mr_ogb.ogb091 = l_ima36
   END IF
   LET mr_ogb.ogb19     = mr_oeb.oeb906   #MOD-7B0266
   #-----No.MOD-5C0058 END-----
   LET mr_ogb.ogb092    = mr_oeb.oeb092
   LET mr_ogb.ogb11     = mr_oeb.oeb11
 
   #-MOD-940130-add
   SELECT SUM(ogb12) INTO l_ogb12
    FROM oga_file,ogb_file
    WHERE oga01 = ogb01
      AND oga09 = ms_argv0
      AND ogb31 = mr_ogb.ogb31
      AND ogb32 = mr_ogb.ogb32
      AND ogapost = 'N'   #MOD-960353
   IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF
   #-MOD-940130-end
 
  #LET mr_ogb.ogb12     = mr_oeb.oeb12 - mr_oeb.oeb24 + mr_oeb.oeb25            #MOD-940130 mark 
   LET mr_ogb.ogb12     = mr_oeb.oeb12 - mr_oeb.oeb24 + mr_oeb.oeb25 - l_ogb12  #MOD-940130 add
   LET mr_ogb.ogb12     = s_digqty(mr_ogb.ogb12,mr_ogb.ogb05) #FUN-BB0083 add
   LET mr_ogb.ogb13     = mr_oeb.oeb13
   LET mr_ogb.ogb917    = mr_oeb.oeb917  #CHI-710059 #將程式段移至此
 
  #MOD-780285-begin-add
   LET mr_ogb.ogb910 = mr_oeb.oeb910
   LET mr_ogb.ogb911 = mr_oeb.oeb911
   LET mr_ogb.ogb912 = mr_oeb.oeb912
   LET mr_ogb.ogb913 = mr_oeb.oeb913
   LET mr_ogb.ogb914 = mr_oeb.oeb914
   LET mr_ogb.ogb915 = mr_oeb.oeb915
   LET mr_ogb.ogb916 = mr_oeb.oeb916
 
   #開窗查詢出的未出貨數量, 公式計算為(訂單數量-已過帳出貨單數量)
   #與實際出貨單單身確認公式不同, 故在此的推算方式以本程式的規格為主
   SELECT SUM(ogb912),SUM(ogb915),SUM(ogb917)
     INTO l_ogb912a,l_ogb915a,l_ogb917a
     FROM ogb_file,oga_file
    WHERE ogb01 = oga01 AND oga09 IN ('2','4','6') 
      AND ogb31 = mr_ogb.ogb31
      AND ogb32 = mr_ogb.ogb32
      AND ogb04 = mr_ogb.ogb04
      AND ogaconf = 'Y'   
   IF cl_null(l_ogb912a) THEN LET l_ogb912a= 0 END IF
   IF cl_null(l_ogb915a) THEN LET l_ogb915a= 0 END IF
   IF cl_null(l_ogb917a) THEN LET l_ogb917a= 0 END IF
   LET mr_ogb.ogb912= mr_ogb.ogb912-l_ogb912a
   LET mr_ogb.ogb912= s_digqty(mr_ogb.ogb912,mr_ogb.ogb910) #FUN-BB0083 add
   LET mr_ogb.ogb915= mr_ogb.ogb915-l_ogb915a
   LET mr_ogb.ogb915= s_digqty(mr_ogb.ogb915,mr_ogb.ogb913) #FUN-BB0083 add
   IF g_sma.sma115='Y' THEN
   LET mr_ogb.ogb917= mr_ogb.ogb917-l_ogb917a
   LET mr_ogb.ogb917= s_digqty(mr_ogb.ogb917,mr_ogb.ogb916) #FUN-BB0083 add
   END IF 
 
   CALL oeb_set_ogb917_oeb10()   
  #MOD-780285-end-add
 
 
   IF ms_oga213 = 'N' THEN
     #LET mr_ogb.ogb14  = mr_ogb.ogb12  * mr_ogb.ogb13     #CHI-710059 mod
      LET mr_ogb.ogb14  = mr_ogb.ogb917 * mr_ogb.ogb13     #CHI-710059 mod
      LET mr_ogb.ogb14t = mr_ogb.ogb14  * (1 + ms_oga211/100)
   ELSE
     #LET mr_ogb.ogb14t = mr_ogb.ogb12  * mr_ogb.ogb13     #CHI-710059 mod
      LET mr_ogb.ogb14t = mr_ogb.ogb917 * mr_ogb.ogb13     #CHI-710059 mod
      LET mr_ogb.ogb14  = mr_ogb.ogb14t / (1 + ms_oga211/100)
   END IF
   #-----MOD-8C0120--------- 
   #CALL cl_digcut(mr_ogb.ogb14,g_azi04) RETURNING mr_ogb.ogb14
   #CALL cl_digcut(mr_ogb.ogb14t,g_azi04)RETURNING mr_ogb.ogb14t
 
   SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01 = ms_oga23
   CALL cl_digcut(mr_ogb.ogb14,t_azi04) RETURNING mr_ogb.ogb14
   CALL cl_digcut(mr_ogb.ogb14t,t_azi04)RETURNING mr_ogb.ogb14t
   #-----END MOD-8C0120-----
 
   IF mr_ogb.ogb09  IS NULL THEN LET mr_ogb.ogb09  = ' ' END IF
   IF mr_ogb.ogb091 IS NULL THEN LET mr_ogb.ogb091 = ' ' END IF
   IF mr_ogb.ogb092 IS NULL THEN LET mr_ogb.ogb092 = ' ' END IF
 
   SELECT img09 INTO l_ogb15 FROM img_file
    WHERE img01 = mr_ogb.ogb04 AND img02 = mr_ogb.ogb09
      AND img03 = mr_ogb.ogb091 AND img04 = mr_ogb.ogb092
 
   IF cl_null(mr_ogb.ogb15) THEN LET mr_ogb.ogb15 = l_ogb15 END IF
 
   IF STATUS=0 THEN
      IF mr_ogb.ogb05 = mr_ogb.ogb15 THEN 
         LET mr_ogb.ogb15_fac =1 
      ELSE 
         #檢查該發料單位與主檔之單位是否可以轉換
         CALL s_umfchk(mr_ogb.ogb04,mr_ogb.ogb05,mr_ogb.ogb15)
                   RETURNING g_cnt,mr_ogb.ogb15_fac
         IF g_cnt = 1 THEN 
            CALL cl_err('','mfg3075',1)
         END IF
      END IF
   END IF
 
   IF cl_null(mr_ogb.ogb15) THEN LET mr_ogb.ogb15  = mr_ogb.ogb05 END IF
   IF cl_null(mr_ogb.ogb15_fac) THEN LET mr_ogb.ogb15_fac = 1 END IF
   LET mr_ogb.ogb16 = mr_ogb.ogb12 * mr_ogb.ogb15_fac
   LET mr_ogb.ogb16 = s_digqty(mr_ogb.ogb16,mr_ogb.ogb15) #FUN-BB0083 add
   LET mr_ogb.ogb17 = 'N'
   LET mr_ogb.ogb18 = mr_ogb.ogb12
   LET mr_ogb.ogb60 = 0
   LET mr_ogb.ogb63 = 0
   LET mr_ogb.ogb64 = 0
   MESSAGE mr_ogb.ogb03,' ',mr_ogb.ogb04,' ',mr_ogb.ogb12
 
  #MOD-780285-begin-mark
  # #-----No.MOD-5C0058-----
  # LET mr_ogb.ogb910 = mr_oeb.oeb910
  # LET mr_ogb.ogb911 = mr_oeb.oeb911
  # LET mr_ogb.ogb912 = mr_oeb.oeb912
  # LET mr_ogb.ogb913 = mr_oeb.oeb913
  # LET mr_ogb.ogb914 = mr_oeb.oeb914
  # LET mr_ogb.ogb915 = mr_oeb.oeb915
  # LET mr_ogb.ogb916 = mr_oeb.oeb916
  #MOD-780285-end-mark
  #LET mr_ogb.ogb917 = mr_oeb.oeb917 #CHI-710059 mark
   #-----No.MOD-5C0058 END-----
   LET mr_ogb.ogb930 = mr_oeb.oeb930 #FUN-680006
   LET mr_ogb.ogb1014='N' #FUN-6B0044
END FUNCTION
 
#MOD-780285-begin-add
FUNCTION oeb_set_ogb917_oeb10()
  DEFINE    l_item   LIKE img_file.img01,     #料號
            l_ima25  LIKE ima_file.ima25,     #ima單位
            l_ima31  LIKE ima_file.ima31,     #ima單位
            l_ima906 LIKE ima_file.ima906,
            l_fac2   LIKE img_file.img21,     #第二轉換率
            l_qty2   LIKE img_file.img10,     #第二數量
            l_fac1   LIKE img_file.img21,     #第一轉換率
            l_qty1   LIKE img_file.img10,     #第一數量
            l_tot    LIKE img_file.img10,     #計價數量
            l_factor LIKE img_file.img21
 
    SELECT ima25,ima31,ima906 INTO l_ima25,l_ima31,l_ima906
      FROM ima_file WHERE ima01=mr_ogb.ogb04
    IF SQLCA.sqlcode = 100 THEN
       IF mr_ogb.ogb04 MATCHES 'MISC*' THEN
          SELECT ima25,ima31,ima906 INTO l_ima25,l_ima31,l_ima906
            FROM ima_file WHERE ima01='MISC'
       END IF
    END IF
    IF cl_null(l_ima31) THEN LET l_ima31=l_ima25 END IF
 
    LET l_fac2=mr_ogb.ogb914
    LET l_qty2=mr_ogb.ogb915
    IF g_sma.sma115 = 'Y' THEN
       LET l_fac1=mr_ogb.ogb911
       LET l_qty1=mr_ogb.ogb912
    ELSE
       LET l_fac1=1
       LET l_qty1=mr_ogb.ogb12
       CALL s_umfchk(mr_ogb.ogb04,mr_ogb.ogb05,l_ima31)
             RETURNING g_cnt,l_fac1
       IF g_cnt = 1 THEN
          LET l_fac1 = 1
       END IF
    END IF
    IF cl_null(l_fac1) THEN LET l_fac1=1 END IF
    IF cl_null(l_qty1) THEN LET l_qty1=0 END IF
    IF cl_null(l_fac2) THEN LET l_fac2=1 END IF
    IF cl_null(l_qty2) THEN LET l_qty2=0 END IF
 
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
    CALL s_umfchk(mr_ogb.ogb04,l_ima31,mr_ogb.ogb916)
          RETURNING g_cnt,l_factor
    IF g_cnt = 1 THEN
       LET l_factor = 1
    END IF
    LET l_tot = l_tot * l_factor
 
    LET mr_ogb.ogb917 = l_tot
    LET mr_ogb.ogb917= s_digqty(mr_ogb.ogb917,mr_ogb.ogb916) #FUN-BB0083 add
END FUNCTION
#MOD-780285-end-add
 
#-----MOD-8C0110---------
FUNCTION q_oeb_chk_oeb10()
   DEFINE l_chr1,l_chr2 LIKE type_file.chr1,
          l_rec_b       LIKE type_file.num10,
          l_i           LIKE type_file.num10,
          l_oea         RECORD LIKE oea_file.*,
          l_i2          LIKE type_file.num10,
          l_oga         RECORD LIKE oga_file.*,
          l_cnt         LIKE type_file.num5,
          l_t1          LIKE oay_file.oayslip,
          l_oay22_oea   LIKE oay_file.oay22,
          l_oay22_oga   LIKE oay_file.oay22,
          l_oea18       LIKE oea_file.oea18,
          l_oea23       LIKE oea_file.oea23,
          l_oea24       LIKE oea_file.oea24,
          l_oea904      LIKE oea_file.oea904,
          l_oea161      LIKE oea_file.oea161,
          l_oea163      LIKE oea_file.oea163,
          l_oeb         RECORD LIKE oeb_file.*,
          li_result     LIKE type_file.num5, 
          l_poz         RECORD LIKE poz_file.*,
          l_oea99       LIKE oea_file.oea99,  
          l_flow        LIKE oea_file.oea904,
          l_oea904_2    LIKE oea_file.oea904   #MOD-AC0261
   DEFINE l_oax06       LIKE oax_file.oax06    #MOD-C40132 add
 
   LET l_chr1 = 'N'
   LET l_chr2 = 'N'
   LET l_rec_b = ma_qry3.getLength()
   FOR l_i = 1 TO l_rec_b
       SELECT * INTO l_oea.* FROM oea_file 
        WHERE oea01 = ma_qry3[l_i].oea01
       IF l_chr1 = 'N' THEN 
          FOR l_i2 = 1 TO l_rec_b
              SELECT oea18,oea23,oea24 INTO l_oea18,l_oea23,l_oea24 
                FROM oea_file
               WHERE oea01 = ma_qry3[l_i2].oea01
              IF l_oea.oea18 <> l_oea18 OR 
                 (l_oea.oea18 = 'Y' AND 
                  (l_oea.oea23 <> l_oea23 OR l_oea.oea24 <> l_oea24)) THEN
                 CALL s_errmsg('','','','axm-608',1)
                 LET g_success = 'N'
                 LET l_chr1 = 'Y' 
                 EXIT FOR
              END IF 
          END FOR 
       END IF
       IF l_chr2 = 'N' THEN 
          FOR l_i2 = 1 TO l_rec_b
              SELECT oea904 INTO l_oea904 
                FROM oea_file
               WHERE oea01 = ma_qry3[l_i2].oea01
               IF l_oea.oea904 <> l_oea904 THEN
                  CALL s_errmsg('','','','axm-501',1)
                  LET g_success = 'N'
                  LET l_chr2 = 'Y'
                  EXIT FOR
               END IF
               #-----MOD-AC0261---------
               SELECT oea904 INTO l_oea904_2 FROM oea_file
                 WHERE oea01 IN 
                       (SELECT MIN(ogb31) FROM ogb_file where ogb01=ms_oga01 )
               IF l_oea904_2 <> l_oea904 THEN
                  CALL s_errmsg('','','','axm-501',1)
                  LET g_success = 'N'
                  LET l_chr2 = 'Y'
                  EXIT FOR
               END IF 
               #-----END MOD-AC0261-----
          END FOR 
       END IF
       IF l_chr1 = 'Y' AND l_chr2 = 'Y' THEN 
          EXIT FOR
       END IF
   END FOR
 
   IF l_rec_b > 1 THEN 
      FOR l_i = 1 TO l_rec_b
           LET l_oea161=0
           LET l_oea163=0
           SELECT oea161,oea163 INTO l_oea161,l_oea163 FROM oea_file
            WHERE oea01 = ma_qry3[l_i].oea01
           IF l_oea161 > 0 OR l_oea163 > 0 THEN
              CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','axm-076',1)
              LET g_success = 'N'
           END IF
      END FOR
   END IF
 
   SELECT * INTO l_oga.* FROM oga_file WHERE oga01 = ms_oga01
   FOR l_i = 1 TO l_rec_b
       CASE l_oga.oga00 
        WHEN '1' 
             #CALL s_check_no("axm",ma_qry3[l_i].oea01,"","30","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oea01,ma_qry3[l_i].oea01,"30","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oea01
        WHEN '2'
             #CALL s_check_no("axm",ma_qry3[l_i].oea01,"","32","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oea01,ma_qry3[l_i].oea01,"32","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oea01
        WHEN '3'
             #CALL s_check_no("axm",ma_qry3[l_i].oea01,"","33","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oea01,ma_qry3[l_i].oea01,"33","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oea01
        WHEN '4'
             #CALL s_check_no("axm",ma_qry3[l_i].oea01,"","34","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oea01,ma_qry3[l_i].oea01,"34","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oea01
        WHEN '5'
             #CALL s_check_no("axm",ma_qry3[l_i].oea01,"","35","ogb_file","ogb31","")
              CALL s_check_no("axm",ma_qry3[l_i].oea01,ma_qry3[l_i].oea01,"35","ogb_file","ogb31","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oea01
        WHEN '6' 
             #CALL s_check_no("axm",ma_qry3[l_i].oea01,"","30","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oea01,ma_qry3[l_i].oea01,"30","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oea01
        WHEN '7'
             #CALL s_check_no("axm",ma_qry3[l_i].oea01,"","33","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oea01,ma_qry3[l_i].oea01,"33","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oea01
        WHEN 'A'
             #CALL s_check_no("axm",ma_qry3[l_i].oea01,"","22","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oea01,ma_qry3[l_i].oea01,"22","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oea01
        WHEN 'B'
             #CALL s_check_no("axm",ma_qry3[l_i].oea01,"","22","","","")
              CALL s_check_no("axm",ma_qry3[l_i].oea01,ma_qry3[l_i].oea01,"22","","","") #MOD-B60012 mod
                RETURNING li_result,ma_qry3[l_i].oea01
       END CASE 
       #IF NOT li_result THEN #MOD-C40132 mark
       SELECT oax06 INTO l_oax06 FROM oax_file            #MOD-C40132 add
       IF NOT li_result AND NOT (ms_argv0 MATCHES '[456]' AND l_oax06 = 'Y') THEN #MOD-C40132 add
          CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','mfg0015',1)
          LET g_success='N'
       END IF
 
 
       SELECT * INTO l_oea.* FROM oea_file where oea01 = ma_qry3[l_i].oea01
       IF l_oga.oga044 <> l_oea.oea044 THEN
          CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','axm-916',1)
          LET g_success = 'N'
       END IF
       
       LET l_cnt = 0 
       SELECT COUNT(*) INTO l_cnt FROM oep_file 
          WHERE oep01 = ma_qry3[l_i].oea01
            AND oepconf = 'N' 
       IF l_cnt > 0  THEN
          CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','axm-118',1)
          LET g_success = 'N'
       END IF
       LET l_cnt = 0 
       SELECT COUNT(*) INTO l_cnt FROM oep_file 
          WHERE oep01 = ma_qry3[l_i].oea01 
            AND oep09 <> '2' 
            AND oepconf = 'Y' #MOD-C40078 add
       IF l_cnt > 0  THEN
          CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','axm-119',1)
          LET g_success = 'N'
       END IF
       
       IF g_sma.sma120 = 'Y' AND g_sma.sma907 = 'Y' THEN
          LET l_t1 = ma_qry3[l_i].oea01[1,g_doc_len]
          SELECT oay22 INTO l_oay22_oea FROM oay_file WHERE oayslip =l_t1
          LET l_t1 = ms_oga01[1,g_doc_len]
          SELECT oay22 INTO l_oay22_oga FROM oay_file WHERE oayslip =l_t1
          IF l_oay22_oga != l_oay22_oea THEN
              CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','atm-521',1)
              LET g_success = 'N'
          END IF
       END IF
       
       IF ma_qry3[l_i].oea01[1,4] !='MISC' THEN
          IF NOT cl_null(l_oea.oeahold) THEN
             CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','axm-151',1)
             LET g_success = 'N'
          END IF
          IF l_oea.oea32 != ms_oga32 THEN	#收款條件不符
             CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','axm-143',1)
             LET g_success = 'N'
          END IF
          IF cl_null(l_oga.oga909) OR l_oga.oga909 = 'N' THEN
             IF l_oea.oea901 = 'Y' THEN
                CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','tri-015',1)
                LET g_success = 'N'
             END IF
          END IF
          IF l_oga.oga909 = 'Y' THEN
             #是否為三角貿易訂單
             IF cl_null(l_oea.oea901) OR l_oea.oea901='N' THEN
                CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','tri-014',1)
                LET g_success = 'N'
             END IF
             #是否三角貿易已拋轉各廠
             IF l_oea.oea905 = 'N'  OR l_oea.oea905 IS NULL THEN
                CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','axm-307',1)
                LET g_success = 'N'
             END IF
             #檢查流程代碼
             CALL q_oeb_chkpoz_oeb10(l_oga.*,ma_qry3[l_i].oea01) 
               RETURNING li_result,l_poz.*,l_oea99,l_flow 
             IF NOT li_result THEN 
                LET g_success='N'
             END IF 
       
             IF ms_argv0 MATCHES '[456]' THEN #多角出貨    
                IF l_poz.poz011 = '1' THEN  #正拋方式
                   #檢查是否為起始訂單
                   IF l_oea.oea906 = 'N' OR cl_null(l_oea.oea906) THEN
                      CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','axm-409',1)
                      LET g_success = 'N'
                   END IF
                END IF
                IF l_poz.poz011 = '2' THEN  #反拋方式
                   IF NOT q_oeb_last_oeb10(l_flow,ma_qry3[l_i].oea01) THEN
                      LET g_success = 'N'
                   END IF
                END IF
                #判斷銷售段 OR 代採段之訂單
                IF ms_argv0 = '4' THEN       #銷售段
                   IF l_oea.oea11 ='6' THEN
                      CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','axm-022',1)
                      LET g_success = 'N'
                   END IF
                   IF l_poz.poz00 ='2' THEN
                      CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','tri-008',1)
                      LET g_success = 'N'
                   END IF
                END IF
                IF ms_argv0 = '6' THEN       #代採段
                   IF l_oea.oea11 <> '6' THEN
                      CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','axm-023',1)
                      LET g_success = 'N'
                   END IF
                   IF l_poz.poz011 <> '2' THEN 
                      CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','axm-027',1)
                      LET g_success = 'N'
                   END IF
                   IF l_poz.poz00 ='1' THEN
                      CALL s_errmsg('oea01',ma_qry3[l_i].oea01,'','tri-008',1)
                      LET g_success = 'N'
                   END IF
                END IF
             END IF
          END IF
       END IF
   END FOR
 
   FOR l_i = 1 TO ma_qry2.getLength()
       SELECT * INTO l_oea.* FROM oea_file WHERE oea01 = ma_qry2[l_i].oea01
       SELECT * INTO l_oeb.* FROM oeb_file 
         WHERE oeb01=ma_qry2[l_i].oea01 AND oeb03=ma_qry2[l_i].oeb03
 
       IF ma_qry2[l_i].oea01[1,4] !='MISC' THEN
          IF ms_argv0 MATCHES '[246]' AND NOT cl_null(l_oga.oga011) THEN 
             LET l_cnt = 0 
             SELECT COUNT(*) INTO l_cnt FROM oga_file,ogb_file
              WHERE oga01=l_oga.oga011 
                AND oga01=ogb01 AND (oga09 = '1' OR oga09 = '5')  
                AND ogb31=ma_qry2[l_i].oea01 AND ogb32=ma_qry2[l_i].oeb03
             IF l_cnt=0 THEN 	
                LET g_showmsg = ma_qry2[l_i].oea01,"/",ma_qry2[l_i].oeb03
                CALL s_errmsg('oea01,oeb03',g_showmsg,'','axm-224',1)
                LET g_success = 'N'
             END IF
          END IF
       
          IF ms_argv0 MATCHES '[246]' AND l_oeb.oeb1003='1' THEN
             IF ((l_oeb.oeb12*((100+l_oea.oea09)/100))-
                 l_oeb.oeb24+l_oeb.oeb25) <= 0 THEN 
                LET g_showmsg = ma_qry2[l_i].oea01,"/",ma_qry2[l_i].oeb03
                CALL s_errmsg('oea01,oeb03',g_showmsg,'','axm-148',1)
                LET g_success = 'N'
             END IF
          END IF
          IF l_oeb.oeb70 = 'Y' THEN
             LET g_showmsg = ma_qry2[l_i].oea01,"/",ma_qry2[l_i].oeb03
             CALL s_errmsg('oea01,oeb03',g_showmsg,'','axm-150',1)
             LET g_success = 'N'
          END IF
       END IF
   END FOR
END FUNCTION
 
FUNCTION q_oeb_chkpoz_oeb10(l_oga,p_ogb31)
DEFINE l_oga    RECORD LIKE oga_file.*
DEFINE p_ogb31  LIKE ogb_file.ogb31  
DEFINE l_argv0  LIKE ogb_file.ogb09
DEFINE l_oea01  LIKE oea_file.oea01
DEFINE l_oea99  LIKE oea_file.oea99  
DEFINE l_oea904 LIKE oea_file.oea904 
DEFINE l_poz    RECORD LIKE poz_file.* 
 
 
   LET l_argv0=l_oga.oga09  
   IF cl_null(l_oga.oga16) THEN    
      LET l_oea01 = p_ogb31
      SELECT oea99 INTO l_oea99 FROM oea_file  
       WHERE oea01 = p_ogb31
   ELSE
      SELECT oea01,oea99 INTO l_oea01,l_oea99  
        FROM oea_file
       WHERE oea01 = l_oga.oga16
         AND oeaconf = 'Y' 
   END IF
   SELECT oea904 INTO l_oea904 FROM oea_file WHERE oea99 = l_oea99
   SELECT * INTO l_poz.* FROM poz_file WHERE poz01 = l_oea904
   IF STATUS THEN
      CALL s_errmsg('poz01',l_oea904,'','axm-318',1)
      RETURN FALSE,l_poz.*,l_oea99,l_oea904
   END IF
   IF l_argv0 = '4' AND l_poz.poz00='2' THEN
      CALL s_errmsg('oea904',l_oea904,'','tri-008',1)
      RETURN FALSE,l_poz.*,l_oea99,l_oea904
   END IF
   IF l_argv0 = '6' AND l_poz.poz00='1' THEN
      CALL s_errmsg('oea904',l_oea904,'','tri-008',1)
      RETURN FALSE,l_poz.*,l_oea99,l_oea904
   END IF
   RETURN TRUE,l_poz.*,l_oea99,l_oea904  
END FUNCTION
 
FUNCTION q_oeb_last_oeb10(l_flow,l_oea01)
   DEFINE l_flow        LIKE oea_file.oea904
   DEFINE l_oea01       LIKE oea_file.oea01
   DEFINE l_last        LIKE poy_file.poy02
   DEFINE l_last_plant  LIKE poy_file.poy04
   DEFINE l_poz18       LIKE poz_file.poz18   
   DEFINE l_poz19       LIKE poz_file.poz19   
   DEFINE l_break       LIKE poy_file.poy02   
   DEFINE l_now         LIKE poy_file.poy02   
 
 
   SELECT MAX(poy02) INTO l_last FROM poy_file
    WHERE poy01 = l_flow
      AND poy02 != 99         
 
   IF STATUS THEN
      RETURN TRUE 
   END IF
 
   SELECT poy04 INTO l_last_plant FROM poy_file
    WHERE poy01 = l_flow AND poy02 = l_last
 
   IF cl_null(l_last_plant) THEN
      CALL s_errmsg('oea01',l_oea01,'','axm-318',1)
      RETURN FALSE
   END IF
 
   SELECT poz18,poz19 INTO l_poz18,l_poz19 FROM poz_file
    WHERE poz01 = l_flow
   IF l_poz19 = "Y" THEN
      SELECT poy02 INTO l_break FROM poy_file
       WHERE poy04 = l_poz18
 
      SELECT poy02 INTO l_now FROM poy_file
       WHERE poy04 = g_plant
 
      IF l_last_plant != l_now THEN
         IF l_now > l_break THEN
            CALL s_errmsg('oea01',l_oea01,'','axm-410',1)
            RETURN FALSE
         END IF
      END IF
   ELSE
      IF l_last_plant != g_plant THEN
         CALL s_errmsg('oea01',l_oea01,'','axm-410',1)
         RETURN FALSE
      END IF
   END IF
 
   RETURN TRUE 
END FUNCTION
#-----END MOD-8C0110-----
