# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Prog. Version..: '5.30.06-13.03.12(00000)'     #
# Program name   : q_rvv4.4gl
# Program ver.   : 7.0
# Description    : 驗收后處理資料查詢
# Date & Author  : 2003/09/19 by Leagh
# Memo           : 
# Modify.........: No.FUN-660161 06/07/07 By Rayven 增加匯出Excel功能
# Modify.........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
# Modify.........: No.TQC-690079 06/09/27 By Tracy 增加可查出衝暫估的資料 
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.TQC-6C0126 06/12/20 By Smapmin 修改WHERE 條件
# Modify.........: No.TQC-760013 07/06/07 By Rayven 新增p_no3='2'的情況
# Modify.........: No.TQC-790140 07/09/26 By wujie  開窗數量沒有按照sma116的值區分，參考gapi140中TQC-6C0126的修改
# Modify.........: No.TQC-7B0164 07/12/03 By chenl  取絕對值，以保証減法后數量正確。
# Modify.........: No.TQC-810054 08/01/21 By chenl  根據rvv03，決定數量的正負。
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.MOD-860239 08/06/20 By chenl  修正倉退單余額計算時翻倍的問題。
# Modify.........: No.MOD-8C0248 08/12/25 By Sarah 判斷當查詢(ms_flag='0')時,組SQL時不過濾rvu00,否則會變成只抓出入庫單來開窗
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-980025 09/10/09 By dxfwo hardcode的部分修改
# Modify.........: No.FUN-9B0130 09/11/26 By lutingting 加傳參數營運中心 
# Modify.........: No.FUN-9C0041 09/12/15 By lutingting 跨庫要去實體DB抓取資料
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No.FUN-A20006 10/02/04 By lutingting 相关sql加上rvw99得判斷
# Modify.........: No:TQC-A40081 10/04/19 By xiaofeizhu ¦pªG°h³fÃ«¬¬°¡§3»ùÅ¡¨¡Arvv17µ¥¤_0¤]3¸Óã
# Modify.........: No.FUN-A50102 10/06/24 By lixia 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.MOD-C20235 12/02/29 By yinhy 不選資料退出時依然會把之前的資料帶出
# Modify.........: No.MOD-C60192 12/06/25 By Polly 1.調整效能，將PREPARE/DECLARE動作移到FOREACH前面處理
#                                                  2.5.3標準補加EXIT PROGRAM前加cl_used
# Modify.........: No.TQC-C70035 12/07/05 By lujh 在單身[入庫單號]開窗作業中，需過濾掉無需產生賬款資料的VMI倉的入庫單號和對應的項次資料，
#                                                 應只顯示對應VIM結算倉的入庫單號等資料。
# Modify.........: No.CHI-C80003 12/09/26 By wangwei 價格折讓類型的已衝過暫估資料不應被挑選
# Modify.........: No.MOD-CA0170 12/10/24 By yinhy 過濾掉多角入庫單


DATABASE ds
 
GLOBALS "../../config/top.global"
#查詢資料的暫存器.
DEFINE   ma_qry       DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         rvv09        LIKE rvv_file.rvv09,    #異動日期
         rvv01        LIKE rvv_file.rvv01,    #入庫/退貨單號
         rvv02        LIKE rvv_file.rvv02,    #項次
         rvv31        LIKE rvv_file.rvv31,    #料件編號 
         rvv031       LIKE rvv_file.rvv031,   #料名
         rvv17        LIKE rvv_file.rvv17,    #數量
         rvv36        LIKE rvv_file.rvv36,    #采購單號
         rvv37        LIKE rvv_file.rvv37,    #采購序號
         rvv04        LIKE rvv_file.rvv04,    #收貨單號
         rvv05        LIKE rvv_file.rvv05     #項次
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         rvv09        LIKE rvv_file.rvv09,
         rvv01        LIKE rvv_file.rvv01,
         rvv02        LIKE rvv_file.rvv02,
         rvv31        LIKE rvv_file.rvv31,
         rvv031       LIKE rvv_file.rvv031,
         rvv17        LIKE rvv_file.rvv17,
         rvv36        LIKE rvv_file.rvv36,
         rvv37        LIKE rvv_file.rvv37,
         rvv04        LIKE rvv_file.rvv04,
         rvv05        LIKE rvv_file.rvv05
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要復選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_ret1          STRING  ,  #回傳欄位的變數
         ms_ret2          LIKE rvv_file.rvv02,  #回傳欄位的變數  #No.FUN-680131 SMALLINT
         ms_vender        LIKE rvv_file.rvv06,  #廠商編號  #No.FUN-680131 VARCHAR(10)
         ms_default1      LIKE rvv_file.rvv01,             #No.FUN-680131 VARCHAR(16)
         ms_default2      LIKE rvv_file.rvv02,             #No.FUN-680131 SMALLINT
         ms_rvv03         LIKE rvv_file.rvv03,             #No.FUN-680131 VARCHAR(1)
         ms_flag          LIKE type_file.chr1,     #0:一般查詢 1:入庫單身檔	#No.FUN-680131 VARCHAR(1)
         ms_rvw01         LIKE rvw_file.rvw01
DEFINE   ms_plant         LIKE type_file.chr10   #FUN-9B0130
DEFINE   ms_dbs           LIKE type_file.chr21   #FUN-9B0130

#FUNCTION q_rvv4(pi_multi_sel,pi_need_cons,p_vender,p_no1,p_no2,p_no3,p_no4,p_no5)   #FUN-9B0130
FUNCTION q_rvv4(pi_multi_sel,pi_need_cons,p_vender,p_no1,p_no2,p_no3,p_no4,p_no5,p_plant)   #FUN-9B0130
   DEFINE  pi_multi_sel  LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
           pi_need_cons  LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
           p_vender      LIKE rvv_file.rvv06,             #No.FUN-680131 VARCHAR(10)
           p_no1	 LIKE rvv_file.rvv01,             #No.FUN-680131 VARCHAR(16)
           p_no2	 LIKE rvv_file.rvv02,             #No.FUN-680131 SMALLINT
           p_no3         LIKE rvv_file.rvv03,             #No.FUN-680131 VARCHAR(1)
           p_no4         LIKE rvv_file.rvv03,             #No.FUN-680131 VARCHAR(1)
           p_no5         LIKE rvv_file.rvv01              #No.FUN-680131 VARCHAR(16)
   DEFINE  p_plant       LIKE type_file.chr10             #No.FUN-9B0130 

   #FUN-9B0130--add--str--
   #IF cl_null(p_plant) THEN   #FUN-A50102
   #   LET ms_dbs = NULL
   #ELSE
      LET g_plant_new = p_plant
     #FUN-9C0041--mod--str-
     #CALL s_getdbs()
     #LET ms_dbs = g_dbs_new
   #   CALL s_gettrandbs()
   #   LET ms_dbs = g_dbs_tra
     #FUN-9C0041--mod--end
   #END IF
   #FUN-9B0130--add--end

   LET ms_vender        = p_vender
   LET ms_default1      = p_no1
   LET ms_default2      = p_no2
   LET ms_rvv03         = p_no3
   LET ms_flag          = p_no4
   LET ms_rvw01         = p_no5
   LET ms_plant         = p_plant     #FUN-9B0130
   LET ms_ret1          = NULL        #MOD-C20235
   LET ms_ret2          = NULL        #MOD-C20235
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_rvv4" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_rvv4")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不復選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 在復選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("rvv1", "red")
   END IF
 
   CALL rvv4_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 #復選資料只能回傳一個欄位的組合字串.
   ELSE
      RETURN ms_ret1,ms_ret2 #回傳值(也許有多個).
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvv4_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 #每頁顯現最大資料筆數.
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON rvv09,rvv01,rvv02,rvv31,rvv031,rvv17,rvv36,rvv37,rvv04,rvv05
             FROM s_rvv[1].rvv09,s_rvv[1].rvv01,s_rvv[1].rvv02,s_rvv[1].rvv31,
                  s_rvv[1].rvv031,s_rvv[1].rvv17,s_rvv[1].rvv36,s_rvv[1].rvv37,
                  s_rvv[1].rvv04,s_rvv[1].rvv05
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            
            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               LET ms_ret1 = NULL   #MOD-C20235
               EXIT WHILE
            END IF
         END IF
     
         CALL rvv4_qry_prep_result_set() 
         # 2003/07/14 by Hiko : 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 2003/07/14 by Hiko : 如果所設定的'每頁顯現資料筆數'超過/等于所有資料,則要隱藏'上下頁'的按鈕.
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
     
      CALL rvv4_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL rvv4_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL rvv4_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 准備查詢畫面的資料集.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION rvv4_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql   STRING,
            ls_where STRING
   DEFINE   li_i     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry   RECORD
            check    LIKE type_file.chr1,   #如果不需要復選資料,則不要設定此欄位(per亦需將check移除). 	#No.FUN-680131 VARCHAR(1)
         rvv09        LIKE rvv_file.rvv09,
         rvv01        LIKE rvv_file.rvv01,
         rvv02        LIKE rvv_file.rvv02,
         rvv31        LIKE rvv_file.rvv31,
         rvv031        LIKE rvv_file.rvv031,
         rvv17        LIKE rvv_file.rvv17,
         rvv36        LIKE rvv_file.rvv36,
         rvv37        LIKE rvv_file.rvv37,
         rvv04        LIKE rvv_file.rvv04,
         rvv05        LIKE rvv_file.rvv05
   END RECORD
    DEFINE  l_rvv17    LIKE rvv_file.rvv17    #No.MOD-540169
   DEFINE  l_sql      LIKE type_file.chr1000	#No.FUN-680131 VARCHAR(300)
   DEFINE  l_cnt      LIKE type_file.num5    	#No.FUN-680131 SMALLINT
   DEFINE  l_apb09    LIKE apb_file.apb09     #No.TQC-690079         
   DEFINE  l_rvv03    LIKE rvv_file.rvv03     #No.TQC-810054 
   DEFINE  l_rvu116   LIKE rvu_file.rvu116    #TQC-A40081
   DEFINE  l_rvw10    LIKE rvw_file.rvw10     #yinhy130917
 
 
#   LET ls_sql=" SELECT 'N',rvv09,rvv01,rvv02,rvv31,rvv031,rvv17-rvv23,rvv36,rvv37,rvv04,rvv05",   #No.MOD-540169 #No.TQC-690079 mark
    #No.TQC-760013 --start--
#No.TQC-790140 --begin
    IF g_sma.sma116 MATCHES '[13]'  THEN
       IF ms_rvv03 = '2' THEN
 
          LET ls_sql=" SELECT 'N',rvv09,rvv01,rvv02,rvv31,rvv031,rvv87,rvv36,rvv37,rvv04,rvv05,rvv03",   #No.MOD-540169 #No.TQC-690079 #No.TQC-810054 
                    #"   FROM rvv_file,rvu_file",   #FUN-9B0130
                    #"   FROM ",ms_dbs CLIPPED,"rvv_file,",ms_dbs CLIPPED,"rvu_file ",   #FUN-9B0130
                    "   FROM ",cl_get_target_table(g_plant_new,'rvv_file'),",", #FUN-A50102
                               cl_get_target_table(g_plant_new,'rvu_file'),     #FUN-A50102
                    "  WHERE ",ms_cons_where CLIPPED,
                    "    AND rvu01 = rvv01 ",
                   #"    AND rvu00 <> '2' ",   #MOD-8C0248 mark
                    "    AND rvuconf <> 'X' ",
                    "    AND rvu08 NOT IN ('TAP','TRI') "   #MOD-CA0170
         #str MOD-8C0248 add
          IF ms_flag != '0' THEN
             LET ls_sql=ls_sql CLIPPED,"    AND rvu00 <> '2' "
          END IF
         #end MOD-8C0248 add
       ELSE
       #No.TQC-760013 --end--
          LET ls_sql=" SELECT 'N',rvv09,rvv01,rvv02,rvv31,rvv031,rvv87,rvv36,rvv37,rvv04,rvv05,rvv03",   #No.MOD-540169 #No.TQC-690079 #No.TQC-810054 
                    #"   FROM rvv_file,rvu_file",    #FUN-9B0130
                    #"   FROM ",ms_dbs CLIPPED,"rvv_file,",ms_dbs CLIPPED,"rvu_file ",   #FUN-9B0130
                    "   FROM ",cl_get_target_table(g_plant_new,'rvv_file'),",", #FUN-A50102
                               cl_get_target_table(g_plant_new,'rvu_file'),     #FUN-A50102
                    "  WHERE ",ms_cons_where CLIPPED,
                    "    AND rvu01 = rvv01 ",
                   #"    AND rvu00 = '",ms_rvv03,"' ",    #只抓入庫單資料   #MOD-8C0248 mark 
                    "    AND rvuconf <> 'X' ",
                    "    AND rvv89 != 'Y' ",       #TQC-C70035   add  
                    "    AND rvu08 NOT IN ('TAP','TRI') "   #MOD-CA0170
         #str MOD-8C0248 add
          IF ms_flag != '0' THEN
             LET ls_sql=ls_sql CLIPPED,"    AND rvu00 = '",ms_rvv03,"' "
          END IF
         #end MOD-8C0248 add
       END IF  #No.TQC-760013
    ELSE
       IF ms_rvv03 = '2' THEN
          LET ls_sql=" SELECT 'N',rvv09,rvv01,rvv02,rvv31,rvv031,rvv17,rvv36,rvv37,rvv04,rvv05,rvv03",   #No.MOD-540169 #No.TQC-690079 #No.TQC-810054 
                    #"   FROM rvv_file,rvu_file",    #FUN-9B0130
                    #"   FROM ",ms_dbs CLIPPED,"rvv_file,",ms_dbs CLIPPED,"rvu_file ",   #FUN-9B0130
                    "   FROM ",cl_get_target_table(g_plant_new,'rvv_file'),",", #FUN-A50102
                               cl_get_target_table(g_plant_new,'rvu_file'),     #FUN-A50102
                    "  WHERE ",ms_cons_where CLIPPED,
                    "    AND rvu01 = rvv01 ",
                   #"    AND rvu00 <> '2' ",   #MOD-8C0248 mark
                    "    AND rvuconf <> 'X' ",
                    "    AND rvu08 NOT IN ('TAP','TRI') "   #MOD-CA0170
         #str MOD-8C0248 add
          IF ms_flag != '0' THEN
             LET ls_sql=ls_sql CLIPPED,"    AND rvu00 <> '2' "
          END IF
         #end MOD-8C0248 add
       ELSE
       #No.TQC-760013 --end--
          LET ls_sql=" SELECT 'N',rvv09,rvv01,rvv02,rvv31,rvv031,rvv17,rvv36,rvv37,rvv04,rvv05,rvv03",   #No.MOD-540169 #No.TQC-690079 #No.TQC-810054 
                    #"   FROM rvv_file,rvu_file",   #FUN-9B0130
                    #"   FROM ",ms_dbs CLIPPED,"rvv_file,",ms_dbs CLIPPED,"rvu_file ",   #FUN-9B0130
                    "   FROM ",cl_get_target_table(g_plant_new,'rvv_file'),",", #FUN-A50102
                               cl_get_target_table(g_plant_new,'rvu_file'),     #FUN-A50102
                    "  WHERE ",ms_cons_where CLIPPED,
                    "    AND rvu01 = rvv01 ",
                   #"    AND rvu00 = '",ms_rvv03,"' ",    #只抓入庫單資料   #MOD-8C0248 mark 
                    "    AND rvuconf <> 'X' ",
                    "    AND rvv89 != 'Y' ",       #TQC-C70035   add 
                    "    AND rvu08 NOT IN ('TAP','TRI') "   #MOD-CA0170
         #str MOD-8C0248 add
          IF ms_flag != '0' THEN
             LET ls_sql=ls_sql CLIPPED,"    AND rvu00 = '",ms_rvv03,"' "
          END IF
         #end MOD-8C0248 add
       END IF  #No.TQC-760013
   END IF
#No.TQC-790140 --end
   IF NOT mi_multi_sel OR ms_flag = '1' THEN
      #No.TQC-760013 --start--
      IF ms_rvv03 = '2' THEN
         LET ls_where = "    AND rvv03 <> '2' ",
                        "    AND rvv06 ='", ms_vender,"'",
                        "     AND rvuconf='Y' "
      ELSE
      #No.TQC-760013 --end--
         LET ls_where = "    AND rvv03 ='",ms_rvv03,"' ",
                        "    AND rvv06 ='", ms_vender,"'",
#                       "    AND rvv17 > rvv23 ",   #No.TQC-690079 mark
#                       "    AND rvv01||rvv02 NOT IN ",
#                       " (SELECT UNIQUE rvw08||rvw09 FROM rvw_file ",
#                       "   WHERE rvw08 IS NOT NULL AND rvw09 IS NOT NULL  )   ",
#                       "     AND rvv04||rvv05 NOT IN ",
#                       " (SELECT UNIQUE rvw08||rvw09 FROM rvw_file ",
#                       "   WHERE rvw08 IS NOT NULL AND rvw09 IS NOT NULL  )   ",
                        "     AND rvuconf='Y' "
      END IF  #No.TQC-760013
   END IF
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_rvv4', 'rvv_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY rvv01,rvv02"
 
  ##NO.FUN-980025 GP5.2 add--begin						
  # IF (NOT mi_multi_sel ) THEN	 #FUN-A50102					
  #      #FUN-9B0130--add--str--
  #      IF NOT cl_null(ms_plant) THEN
  #         CALL cl_parse_qry_sql( ls_sql, ms_plant ) RETURNING ls_sql
  #      ELSE
  #      #FUN-9B0130--add--end
  #         CALL cl_parse_qry_sql( ls_sql, g_plant ) RETURNING ls_sql						
  #      END IF      #FUN-9B0130 add
  # END IF						
  ##NO.FUN-980025 GP5.2 add--end
   DISPLAY "ls_sql=",ls_sql
   CALL cl_replace_sqldb(ls_sql) RETURNING ls_sql  #FUN-A50102 
   CALL cl_parse_qry_sql(ls_sql,g_plant_new) RETURNING ls_sql #FUN-A50102
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
  #-----------------------------MOD-C60192------------------------------(S)
   LET l_sql = " SELECT ABS(SUM(apb09)) ",
               "   FROM apb_file,apa_file ",
               "  WHERE apb01 = apa01 ",
               "    AND apb21 = ? ",
               "    AND apb22 = ? ",
               "    AND apa08 <> 'UNAP' "
   PREPARE q_rvv4_pb0 FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            
      EXIT PROGRAM 
   END IF
   DECLARE rvv_curs0 CURSOR FOR q_rvv4_pb0

   LET l_sql = " SELECT ABS(SUM(rvw10)) ",
               "   FROM rvw_file ",
               "  WHERE rvw01 NOT IN ",
               "(SELECT DISTINCT apk03 ",
               "   FROM apk_file,apa_file,apb_file ",
               "  WHERE apk01 = apa01 ",
               "    AND apa01 = apb01 ",
               "    AND apa08 <> 'UNAP' ",                        #排除衝暫估資料
               "    AND apb21 = ? ",
               "    AND apb22 = ? ",
               "    AND rvw08 = ? ",
               "    AND rvw99 = '",ms_plant,"' ",
               "    AND rvw09 = ? "
   PREPARE q_rvv4_pb1 FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            
      EXIT PROGRAM 
   END IF
   DECLARE rvv_curs1 CURSOR FOR q_rvv4_pb1
  #-----------------------------MOD-C60192------------------------------(E)
  
  #NO.yinhy130917  --Begin  #已经开立发票但没有抛砖账款的
  LET l_sql = " SELECT ABS(SUM(rvw10))",
              "   FROM rvw_file ",
              "  WHERE rvw01 <> '",ms_rvw01,"'",
              "    AND rvw08 = ? ",
              "    AND rvw09 = ? ",
              "    AND rvw18 IS NULL "
   PREPARE q_rvw10_pb1 FROM l_sql
   IF STATUS THEN 
      CALL cl_err('prepare:',STATUS,1) 
      CALL cl_used(g_prog,g_time,2) RETURNING g_time            
      EXIT PROGRAM 
   END IF
   DECLARE rvw10_curs1 CURSOR FOR q_rvw10_pb1
   #NO.yinhy130917  --End
 
   FOREACH lcurs_qry INTO lr_qry.*,l_rvv03
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
       #No.MOD-540169 --start--
      IF NOT mi_multi_sel OR ms_flag = '1' THEN
       #-----------------------------MOD-C60192------------------------------mark
       ##No.TQC-690079  --start--                                                                                                           
       # LET l_sql = " SELECT ABS(SUM(apb09)) ", #No.MOD-860239 add abs()
       #             "   FROM apb_file,apa_file ",                                                                                  
       #             "  WHERE apb01 = apa01 ",                                                                                      
       #             "    AND apb21 = '",lr_qry.rvv01,"' ",                                                                         
       #             #"    AND apb22 = ",lr_qry.rvv02,") ",     #TQC-6C0126                                                                       
       #             "    AND apb22 = ",lr_qry.rvv02,     #TQC-6C0126                                                                       
       #             "    AND apa08 <> 'UNAP' "                                                                                     
       # PREPARE q_rvv4_pb0 FROM l_sql                                                                                              
       # IF STATUS THEN
       #    CALL cl_err('prepare:',STATUS,1)
       #    RETURN
       # END IF                                                        
       # DECLARE rvv_curs0 CURSOR FOR q_rvv4_pb0                                                                                    
       # OPEN rvv_curs0                                                                                                             
         OPEN rvv_curs0 USING lr_qry.rvv01,lr_qry.rvv02                #MOD-C60192 add
       #-----------------------------MOD-C60192------------------------------mark
         FETCH rvv_curs0 INTO l_apb09                                                                                               
         IF cl_null(l_apb09) THEN LET l_apb09 = 0 END IF                                                                            
        #No.TQC-690079  --end--            
        #-----------------------------MOD-C60192------------------------------mark
        #LET l_sql = " SELECT ABS(SUM(rvw10)) ",      #No.TQC-7B0164 modify 
        #            "   FROM rvw_file ",
        #            "  WHERE rvw01 NOT IN ",
        #            "(SELECT DISTINCT apk03 ",
        #            "   FROM apk_file,apa_file,apb_file ",
        #            "  WHERE apk01 = apa01 ",
        #            "    AND apa01 = apb01 ",
        #            "    AND apa08 <> 'UNAP' ",     #排除衝暫估資料
        #            "    AND apb21 = '",lr_qry.rvv01,"' ",
        #            "    AND apb22 = ",lr_qry.rvv02,") ",
        #            "    AND rvw08 = '",lr_qry.rvv01,"' ",
        #            "    AND rvw99 = '",ms_plant,"' ",                 #FUN-A20006
        #            "    AND rvw09 = ",lr_qry.rvv02," "
        #PREPARE q_rvv4_pb1 FROM l_sql                                                                                                   
        #IF STATUS THEN CALL
        #   cl_err('prepare:',STATUS,1)
        #   RETURN
        #END IF                                                           
        #DECLARE rvv_curs1 CURSOR FOR q_rvv4_pb1                                                                                         
        #OPEN rvv_curs1                                                                                                                
         OPEN rvv_curs1 USING lr_qry.rvv01,lr_qry.rvv02,lr_qry.rvv01,lr_qry.rvv02      #MOD-C60192 add
        #-----------------------------MOD-C60192------------------------------mark
         FETCH rvv_curs1 INTO l_rvv17
         IF cl_null(l_rvv17) THEN LET l_rvv17 = 0 END IF
         
         #No.yinhy130917  --Begin
         OPEN rvw10_curs1 USING lr_qry.rvv01,lr_qry.rvv02 
         FETCH rvw10_curs1 INTO l_rvw10
         IF cl_null(l_rvw10) THEN LET l_rvw10 = 0 END IF
         #No.yinhy130917  --End
         
        #LET lr_qry.rvv17 = lr_qry.rvv17 - l_rvv17              #No.TQC-690079 mark
         #LET lr_qry.rvv17 = lr_qry.rvv17 - l_rvv17 - l_apb09    #No.TQC-690079         #yinhy130917 mark
         LET lr_qry.rvv17 = lr_qry.rvv17 - l_rvv17 - l_apb09 - l_rvw10                  #yinhy130917
         CLOSE rvv_curs0                                                                #MOD-C60192 add
         CLOSE rvv_curs1  
         CLOSE rvw10_curs1        #yinhy130917

         #TQC-A40081--Add--Begin--#
         SELECT rvu116 INTO l_rvu116
           FROM rvu_file
          WHERE rvu01 = lr_qry.rvv01
         IF l_rvu116 = '3' THEN 
           IF lr_qry.rvv17 < 0 THEN
               CONTINUE FOREACH
           END IF
           #CHI-C80003  --Begin
           SELECT COUNT(*) INTO l_cnt FROM apb_file,apa_file
            WHERE apb21 = lr_qry.rvv01
              AND apb22 = lr_qry.rvv02
              AND apb37 = ms_plant
              AND apa00 <> '26'
              AND apa01 = apb01
           IF l_cnt > 0 THEN
              CONTINUE FOREACH
           END IF
           #CHI-C80003  --End
         ELSE
           IF lr_qry.rvv17 <= 0 THEN
               CONTINUE FOREACH
           END IF
         END IF           	                    
         #TQC-A40081--Add--End--#
         
         #TQC-A40081--Mark--Begin--# 
       #  IF lr_qry.rvv17 <= 0 THEN
       #     CONTINUE FOREACH
       #  END IF
         #TQC-A40081--Mark--End--#

         SELECT COUNT(*) INTO l_cnt FROM rvw_file
          WHERE rvw01 = ms_rvw01
            AND rvw08 = lr_qry.rvv01
            AND rvw09 = lr_qry.rvv02 
         IF l_cnt > 0 THEN
            CONTINUE FOREACH
         END IF
         
      END IF
       #No.MOD-540169 --end--
      LET ma_qry[li_i].* = lr_qry.*
     #No.TQC-810054--begin--
      IF l_rvv03 <> '1' THEN 
         LET ma_qry[li_i].rvv17 = ma_qry[li_i].rvv17 * -1
      END IF
     #No.TQC-810054---end---
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION rvv4_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = ma_qry_tmp.getLength() TO 1 STEP -1
      CALL ma_qry_tmp.deleteElement(li_i)
   END FOR
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
 
##################################################
# Description  	: 采用INPUT ARRAY的方式來顯現查詢過后的資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變后的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvv4_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_rvv.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE,UNBUFFERED)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_rvv.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL rvv4_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_rvv.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL rvv4_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL rvv4_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_rvv.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL rvv4_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL rvv4_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
            LET ms_ret2 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
         END IF
 
         LET li_continue = FALSE
     
         EXIT INPUT
         
      ### FUN-88008 mark START ###
#      ON ACTION select_all
#         FOR li_i = 1 TO ma_qry_tmp.getLength()
#            LET ma_qry_tmp[li_i].check = "Y"
#         END FOR 
 
#      ON ACTION un_select_all
#         FOR li_i = 1 TO ma_qry_tmp.getLength()
#            LET ma_qry_tmp[li_i].check = "N" 
#         END FOR 
#   #     CONTINUE INPUT
 
#      ON IDLE g_idle_seconds
#         CALL cl_on_idle()
#         CONTINUE INPUT
      ### FUN-88008 mark END ###
 
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
   
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--
 
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description  	: 重設查詢資料關于'check'欄位的值.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvv4_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Description  	: 采用DISPLAY ARRAY的方式來顯現查詢過后的資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變后的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvv4_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_rvv.*
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
         CALL rvv4_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
         END IF
 
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--
   
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION rvv4_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇并確認資料.
# Date & Author : 2003/09/18 by Leagh
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION rvv4_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  	#No.FUN-680131 INTEGER
 
 
   # 2004/06/03 by saki : GDC 1.3版本后，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].rvv01 CLIPPED)
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].rvv02 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].rvv01 CLIPPED)
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].rvv02 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 復選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].rvv01 CLIPPED
      LET ms_ret2 = ma_qry[pi_sel_index].rvv02 CLIPPED
   END IF
END FUNCTION
