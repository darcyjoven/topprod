# Prog. Version..: '5.30.06-13.03.12(00009)'     #
# Program name   : q_oea4.sql
# Program ver.   : 7.0
# Description    : 訂單資料查詢
# Date & Author  : 2004/03/30 by saki
# Memo           : 
# Modify.........: No.FUN-660161 06/07/07 By Rayven 增加匯出Excel功能
# Modify.........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.MOD-860228 08/06/19 By claire 調整語法
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.MOD-960250 09/06/22 By mike 1.將"訂單產品"名稱改為"料號(數量)",且定義為STRING. 
#                                                 2.將原先呈現在這二個欄位的資料都放到"料號(數量)"欄位.
#                                                 3.將"品名規格"欄位拿掉.
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定 
# Modify.........: No:MOD-970045 09/11/03 By Pengu 訂單轉工單時，排除oea61>(oea62+oea63)的限制，且加上oeb70='N'的條件
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:MOD-A70171 10/07/23 By Sarah 開窗帶出訂之訂單資料應與asfp304單身產出訂單資料一致
# Modify.........: No:MOD-A80023 10/08/04 By Dido 訂單確認碼不需區分是否複選項目 
# Modify.........: No:TQC-D50003 13/05/02 By zhangweib 顯示品名、規格
# Modify.........: No:160504 16/05/04 By guanyao 合约订单开窗可以查到，存在合约订单的一般订单开窗查不到
# Modify.........: No:160613 16/06/13 By guanyao 订单转工单只考虑合约订单
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         oga01  LIKE oga_file.oga01,
         oga02  LIKE oga_file.oga02,
         oga04  LIKE oga_file.oga04,
         occ02  LIKE occ_file.occ02
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         oga01  LIKE oga_file.oga01,
         oga02  LIKE oga_file.oga02,
         oga04  LIKE oga_file.oga04,
         occ02  LIKE occ_file.occ02
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_default1      STRING,
         ms_cus_no        LIKE oea_file.oea03   #帳款編號  #No.FUN-680131 VARCHAR(20)
DEFINE   ms_ret1          STRING
 
FUNCTION cq_oga_1(pi_multi_sel,pi_need_cons,ps_default1,ps_cus_no)  #modify by guanyao160504
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  , 
            ps_cus_no      LIKE oea_file.oea03   #帳款編號  #No.FUN-680131 VARCHAR(20)
 
 
   WHENEVER ERROR CONTINUE
 
   LET ms_default1 = ps_default1 
   LET ms_cus_no = ps_cus_no
 
   OPEN WINDOW w_qry WITH FORM "cqry/42f/cq_oga_1" ATTRIBUTE(STYLE="create_qry") #No.FUN-660161
 
   CALL cl_ui_locale("cq_oga_1")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("oga01", "red")
   END IF
 
   CALL c_oga_1_qry_sel()  #modify by guanyao160504
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1 
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2004/03/30 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION c_oga_1_qry_sel() #modify by guanyao160504
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	#No.FUN-680131 SMALLINT
            li_continue      LIKE type_file.num5      #是否繼續.	#No.FUN-680131 SMALLINT
   DEFINE   li_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_curr_page     LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_count         LIKE ze_file.ze03,
            li_page          LIKE ze_file.ze03
 
 
   LET mi_page_count = 100 
   LET li_reconstruct = TRUE
 
   WHILE TRUE
      CLEAR FORM
     
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      IF (li_reconstruct) THEN
         MESSAGE ""
     
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON  oga01
                FROM s_oga[1].oga01   #add by huanglf161101
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT
            END CONSTRUCT
     
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
     
         CALL c_oga_1_qry_prep_result_set()  #modify by guanyao160504
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
     
      CALL c_oga_1_qry_set_display_data(li_start_index, li_end_index)  #modify by guanyao160504
     
      LET li_curr_page = li_end_index / mi_page_count
     
      # 2004/02/25 by saki : 若最後一頁不到整除的數目, 避免頁次不會再往上加
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN
         CALL c_oga_1_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index  #modify by guanyao160504
      ELSE
         CALL c_oga_1_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index #modify by guanyao160504
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2004/03/30 by saki
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION c_oga_1_qry_prep_result_set()  #modify by guanyao160504
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING,
            ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lr_qry     RECORD
            check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
            oga01  LIKE oga_file.oga01,
            oga02  LIKE oga_file.oga02,
            oga04  LIKE oga_file.oga04,
            occ02  LIKE occ_file.occ02   
                        END RECORD
   DEFINE   l_oeb03    LIKE oeb_file.oeb03,
            l_oeb04    LIKE oeb_file.oeb04,
            l_oeb12    LIKE oeb_file.oeb12,
            l_sfb08    LIKE sfb_file.sfb08,
            l_tot      LIKE oeb_file.oeb12,
            l_cnt      LIKE type_file.num5,
            l_buf      STRING   #MOD-860228 modify LIKE type_file.chr1000	#No.FUN-680131 VARCHAR(1000)
 DEFINE     l_ogb12    LIKE ogb_file.ogb12,
            ll_ohb12   LIKE ohb_file.ohb12,
            ll_ogb12   LIKE ogb_file.ogb12,
            l_ogb03    LIKE ogb_file.ogb03
 
  #LET ls_sql = "SELECT 'N',oea01,oea00,oea02,oea032,oea14,'',''", #MOD-960250
 
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_oea4', 'oea_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
  { LET ls_sql = "SELECT distinct 'N',oga01", #MOD-960250 
                " FROM (select a.oga01, a.ogb31, a.ogb32, a.ogb12 , b.ogb12" ,  
                " FROM (select oga01, ogb31, ogb32, sum(ogb12) ogb12
                        from ogb_file, oga_file
                        where oga01 = ogb01
                              and ogaconf <> 'X'
                              and oga09 = '1'
                        group by oga01, ogb31, ogb32) a
                        left join (select oga011, ogb31, ogb32, nvl(sum(ogb12),0) ogb12
                                   from ogb_file, oga_file
                                   where oga01 = ogb01
                                         and ogapost = 'Y'
                                         and oga09 = '2'
                                   group by oga011, ogb31, ogb32 ) b on b.oga011 = a.oga01
                                                    #      and b.oga011 = a.oga01
                                                          and b.ogbud10 = a.ogb03
                                                          and a.ogb12>b.ogb12)", }
       LET ls_sql="  SELECT DISTINCT 'N',oga01,ogb03,ogb12 FROM oga_file,ogb_file ",
                " WHERE oga01 = ogb01 and ogaconf <> 'X' and oga09 = '1' AND ",ms_cons_where CLIPPED,
                " ORDER BY oga01,ogb03 "
  
 
   DISPLAY "ls_sql=",ls_sql
   PREPARE lcurs_pre1 FROM  ls_sql
   DECLARE lcurs_qry CURSOR FOR lcurs_pre1 
   CALL ma_qry.clear()
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.check,lr_qry.oga01,l_ogb03,l_ogb12

      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF
     SELECT oga02,oga04,occ02 INTO lr_qry.oga02,lr_qry.oga04,lr_qry.occ02
     FROM oga_file,occ_file
     WHERE ogaconf = 'Y'  AND oga04 = occ_file.occ01  AND oga01=lr_qry.oga01
       #tianry add 161109
   #   SELECT COUNT(*) INTO l_cnt FROM ogb_file WHERE ogb01=lr_qry.oga01   #判断所有出通单是否已经完全转出货
   #   AND ogb01||ogb31||ogb32 NOT IN (select ogb01||ogb31||ogb32 FROM ogb_file,oga_file WHERE  ogaconf='Y' 
   #   AND oga01=ogb01 AND oga09='2' )
   #   IF l_cnt=0 THEN 
   #      CONTINUE FOREACH 
   #   END IF 
       #抓取出货数量
      SELECT SUM(ogb12) INTO ll_ogb12 FROM ogb_file,oga_file WHERE  ogbud10=l_ogb03
      AND oga09='2' AND ogaconf!='X'  AND oga01=ogb01 AND oga011=lr_qry.oga01
      IF cl_null(ll_ogb12) THEN LET ll_ogb12=0 END IF
      #抓取销退数量 
      SELECT SUM(ohb12) INTO ll_ohb12 FROM ohb_file,oha_file WHERE oha01=ohb01 AND ohaconf!='X'  AND ohb31=lr_qry.oga01
      AND ohb32=l_ogb03 
      IF cl_null(ll_ohb12) THEN LET ll_ohb12=0 END IF 
      IF l_ogb12-ll_ogb12+ll_ohb12 <0 OR l_ogb12-ll_ogb12+ll_ohb12=0  THEN 
         CONTINUE FOREACH 
      END IF 


      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
   #   IF li_i>1 THEN
   #      IF 
   #   END IF
 
      LET ma_qry[li_i].* = lr_qry.*
      IF li_i>1 THEN
         IF ma_qry[li_i].oga01=ma_qry[li_i-1].oga01 THEN
          #  LET li_i=li_i-1
            CONTINUE FOREACH 
         END IF 
      END IF
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2004/03/30 by saki
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
################################################## 
FUNCTION c_oga_1_qry_set_display_data(pi_start_index, pi_end_index)   #modify by guanyao160504
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
# Date & Author : 2004/03/30 by saki
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION c_oga_1_qry_input_array(ps_hide_act, pi_start_index, pi_end_index) #modify by guanyao160504
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oga.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oga.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_oga.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL c_oga_1_qry_reset_multi_sel(pi_start_index, pi_end_index) #modify by guanyao160504
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_oga.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL c_oga_1_qry_reset_multi_sel(pi_start_index, pi_end_index)  #modify by guanyao160504
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL c_oga_1_qry_refresh()  #modify by guanyao160504
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_oga.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL c_oga_1_qry_reset_multi_sel(pi_start_index, pi_end_index)  #modify by guanyao160504
            CALL c_oga_1_qry_accept(pi_start_index+ARR_CURR()-1)   #modify by guanyao160504
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF
 
         LET li_continue = FALSE
     
         EXIT INPUT
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      #No.FUN-660161 --begin--
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161 --end--
 
      #No.FUN-840023 --start--
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      #No.FUN-840023 ---end---
 
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
# Date & Author : 2004/03/30 by saki
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
################################################## 
FUNCTION c_oga_1_qry_reset_multi_sel(pi_start_index, pi_end_index)   #modify by guanyao160504
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
# Date & Author : 2004/03/30 by saki
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION c_oga_1_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)  #modify by guanyao160504
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_oga.*
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
         CALL c_oga_1_qry_accept(pi_start_index+ARR_CURR()-1)  #modify by guanyao160504
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
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
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : 2004/03/30 by saki
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION c_oga_1_qry_refresh()  #modify by guanyao160504
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2004/03/30 by saki
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION c_oga_1_qry_accept(pi_sel_index)  #modify by guanyao160504
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  	#No.FUN-680131 INTEGER
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN
            IF (lsb_multi_sel.getLength() = 0) THEN
               CALL lsb_multi_sel.append(ma_qry[li_i].oga01 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].oga01 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      LET ms_ret1 = ma_qry[pi_sel_index].oga01 CLIPPED
   END IF
END FUNCTION
