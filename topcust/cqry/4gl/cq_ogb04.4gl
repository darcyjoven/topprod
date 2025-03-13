# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
# Program name   : q_img6a.4gl
# Program ver.   : 1.0
# Program Author : jan
# Description    : DL_MF045 單身內新增多倉儲批挑選ACTION 可以依料件編號+倉庫+儲位+批號下查詢條件
# Input parameter: pi_multi_sel:是否需要複選資料(TRUE/FALSE)
#                  pi_need_cons:是否需要CONSTRUCT(TRUE/FALSE)
#                  ps_default1: 預設1
#                  ps_default2: 預設2
#                  ps_default3: 預設3
#                  p_sfp01: 發料單單號
#                  p_sfp06: 發料單型態
#                  p_sfs02: 發料單身項次
#                  p_sfs03: 發料單身工單單號
#                  p_sfs04: 發料單身下階料號
#                  p_sfs06: 發料單身發料單位
#                  p_sfs07: 發料單身倉庫
#                  p_sfs10: 發料單身作業編號
#                  p_sfs26: 發料單身替代碼
#                  p_sfa05: 發料單身應發量
#Modify...................: No.FUN-8A0140 By jan
#Modify...................: No.FUN-940008 By hongmei發料改善
#Modify...................: No.FUN-980012 09/08/18 By TSD.apple    GP5.2架構重整，修改 INSERT INTO 語法
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定
# Modify.........: No.MOD-9A0039 09/10/13 By Pengu 點選畫面上的x後沒有關閉，反而游標進入到單身
# Modify.........: No:MOD-9B0148 09/11/23 By Dido 給予 sfs10 預設值 
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:FUN-A60079 10/06/25 By jan s_shortqty加傳參數
# Modify.........: No:CHI-970038 10/12/10 By Summer 1.修改數量未跑ON ROW CHANGE段
#                                                   2.刪除tmp_file時會誤刪其它筆資料
#                                                   3.使用多單位時子單位數量放錯
# Modify.........: No:FUN-B70074 11/07/25 By lixh1 增加行業別TABLE(sfsi_file)的處理 
# Modify.........: No:FUN-BB0084 11/12/13 By lixh1 增加數量欄位小數取位
# Modify.........: No:FUN-C70014 12/07/09 By wangwei 新增RUN CARD發料作業
# Modify.........: No:MOD-D60001 13/06/27 By fengmy  增加傳值
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
DEFINE   ma_qry     DYNAMIC ARRAY OF RECORD   #單身陣列
         check      LIKE type_file.chr1,  	 #VARCHAR(1)
         img03      LIKE img_file.img03,
         img04      LIKE img_file.img04,
         img09      LIKE img_file.img09,
         img10      LIKE img_file.img10,
         new_ogb12  LIKE ogb_file.ogb12       #出貨數量
         ,img37     LIKE img_file.img37       #add by guanyao160907
END RECORD
#s_img1 (FORMONLY.check, img_file.img03, img_file.img04, img_file.img09, img_file.img10, FORMONLY.new_sfs05, FORMONLY.imgg09, FORMONLY.imgg10)
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD #單身暫存
         check      LIKE type_file.chr1,  	 #VARCHAR(1)
         img03      LIKE img_file.img03,
         img04      LIKE img_file.img04,
         img09      LIKE img_file.img09,
         img10      LIKE img_file.img10,
         new_ogb12  LIKE ogb_file.ogb12      #出貨數量
         ,img37     LIKE img_file.img37       #add by guanyao160907
END RECORD
DEFINE l_qry        RECORD
         img03      LIKE img_file.img03,
         img04      LIKE img_file.img04,
         img09      LIKE img_file.img09,
         img10      LIKE img_file.img10,
         new_ogb12  LIKE ogb_file.ogb12 
         ,img37     LIKE img_file.img37       #add by guanyao160907
                    END RECORD 
DEFINE   old_check        LIKE type_file.chr1
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE). SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).SMALLINT
DEFINE   mi_cons_index    LIKE type_file.chr1     #CONSTRUCT時回傳哪一個值       VARCHAR(1)
DEFINE   ms_cons_where    STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數 INTEGER
DEFINE   ms_ret1          STRING,
         ms_ret2          STRING,
         ms_ret3          STRING
DEFINE   ms_default1      STRING,
         ms_default2      STRING,
         ms_default3      STRING
DEFINE   g_reconstruct    LIKE type_file.num5     #SMALLINT
DEFINE   g_tot_ogb12      LIKE ogb_file.ogb12     #挑選發料數量總和
DEFINE   g_cnt            LIKE type_file.num5   #FUN-940008 SMALLINT
DEFINE   g_first          LIKE type_file.num5   #FUN-940008 SMALLINT
DEFINE   g_check          LIKE type_file.chr1   #FUN-940008 varchar2(1) 
DEFINE   g_sum_tot        LIKE sfs_file.sfs05
DEFINE   g_wc             STRING
DEFINE   g_ogb01        LIKE ogb_file.ogb01
DEFINE   g_ogb03        LIKE ogb_file.ogb03
DEFINE   g_ogb04        LIKE ogb_file.ogb04
DEFINE   g_ogb06        LIKE ogb_file.ogb06
DEFINE   g_ima021       LIKE ima_file.ima021
DEFINE   g_ogb12        LIKE ogb_file.ogb12
DEFINE   g_ogb09        LIKE ogb_file.ogb09
 
FUNCTION cq_ogb04(pi_multi_sel, pi_need_cons, ps_default1, ps_default2, ps_default3,
                   p_ogb01,     #出货单号
                   p_ogb03,     #出货单项次
                   p_ogb04,     #料号
                   p_ogb06,     #品名
                   p_ima021,    #规格
                   p_ogb12,     #出货数量
                   p_ogb09      #仓库
                   )
 
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING,
            ps_default2    STRING,
            ps_default3    STRING
   DEFINE   p_ogb01        LIKE ogb_file.ogb01
   DEFINE   p_ogb03        LIKE ogb_file.ogb03
   DEFINE   p_ogb04        LIKE ogb_file.ogb04
   DEFINE   p_ogb06        LIKE ogb_file.ogb06
   DEFINE   p_ima021       LIKE ima_file.ima021
   DEFINE   p_ogb12        LIKE ogb_file.ogb12
   DEFINE   p_ogb09        LIKE ogb_file.ogb09
   DEFINE   l_fac          LIKE ima_file.ima55_fac, #發料單位/庫存單位換算率
            l_flag         LIKE type_file.num5,     #FUN-940008 SMALLINT
            l_msg          STRING,
            l_cnt          LIKE type_file.num5,     #FUN-940008 SMALLINT
            ls_token       STRING
   DEFINE   lst_token      base.StringTokenizer,
            l_t1           LIKE apy_file.apyslip,
            l_n            LIKE type_file.num5   #檢查重複用     #No.FUN-680126 SMALLINT
   DEFINE   l_ogb          RECORD LIKE ogb_file.*
   DEFINE   l_ogb1         RECORD LIKE ogb_file.*
   DEFINE   g_oga          RECORD LIKE oga_file.*
   DEFINE   l_ogb09        LIKE ogb_file.ogb09
   DEFINE   l_i            LIKE type_file.num5
   DEFINE   l_sql          STRING 
 
   LET mi_multi_sel = pi_multi_sel          #是否需要複選資料(TRUE/FALSE)
   LET mi_need_cons = pi_need_cons          #是否需要CONSTRUCT(TRUE/FALSE)
   LET ms_default1 = ps_default1
   LET ms_default2 = ps_default2
   LET ms_default3 = ps_default3
 
   LET g_ogb01=p_ogb01
   LET g_ogb03=p_ogb03
   LET g_ogb04=p_ogb04
   LET g_ogb06=p_ogb06
   LET g_ima021=p_ima021
   LET g_ogb12=p_ogb12
   LET g_ogb09=p_ogb09
   LET g_tot_ogb12 = 0
 
   WHENEVER ERROR CALL cl_err_msg_log

   DROP TABLE tmp_file;
   CREATE TEMP TABLE tmp_file(
      img03      LIKE img_file.img03,
      img04      LIKE img_file.img04,
      img09      LIKE img_file.img09,
      img10      LIKE img_file.img10,
      new_ogb12  LIKE img_file.img10,
      img37     LIKE img_file.img37)

   DELETE FROM tmp_file WHERE 1=1
 
   #開啟畫面檔
   OPEN WINDOW w_qry WITH FORM "cqry/42f/cq_ogb04" ATTRIBUTE(STYLE="create_qry")
   CALL cl_ui_locale("cq_ogb04")

   CALL cl_set_comp_required("ogb09",TRUE)  #add by guanyao160829
   #將傳入參數顯示畫面上
   CALL ogb04_qry_show()
 
   # 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check1",FALSE)
   END IF
   
   INPUT l_ogb09 WITHOUT DEFAULTS FROM ogb09
      BEFORE INPUT
         CALL ogb04_qry_show()
         IF NOT cl_null(g_ogb09) THEN
            LET l_ogb09 = g_ogb09
         END IF
 
      AFTER FIELD ogb09 #檢查倉庫
         IF NOT cl_null(l_ogb09) THEN
            SELECT imd02 FROM imd_file
             WHERE imd01=l_ogb09                #MOD-D60001
               AND imdacti = 'Y' #MOD-4B0169
            IF STATUS THEN
               CALL cl_err3("sel","imd_file",l_ogb09,"",STATUS,"","sel imd",1)  #MOD-D60001
               NEXT FIELD ogb09
            END IF
         END IF
         LET g_ogb09 = l_ogb09
         DISPLAY g_ogb09 TO ogb09
 
     #---------------No.MOD-9A0039 add
      AFTER INPUT 
         IF INT_FLAG THEN
            EXIT INPUT
         END IF
     #---------------No.MOD-9A0039 end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   END INPUT
 
  #---------------No.MOD-9A0039 add
   IF INT_FLAG THEN
      LET INT_FLAG = FALSE
      CLOSE WINDOW w_qry
      RETURN
   END IF
   
   CALL ogb04_qry_sel()  #畫面顯現與資料的選擇

   BEGIN WORK 
   LET g_success='Y'
   
   SELECT * INTO g_oga.* FROM oga_file WHERE oga01=g_ogb01
   SELECT * INTO l_ogb1.* FROM ogb_file WHERE ogb01=g_ogb01 AND ogb03=g_ogb03

   LET l_n=0
   SELECT COUNT(*) INTO l_n FROM tmp_file
   #FOR l_i=1 TO ma_qry.getLength()
   #   IF ma_qry[l_i].check='Y' THEN 
   #      LET l_n=l_n+1
   #   END IF 
   #END FOR 

   IF l_n>0 THEN  
      DELETE FROM ogb_file WHERE ogb01=g_ogb01 AND ogb03=g_ogb03
      IF SQLCA.sqlcode THEN
         LET g_success='N'
      END IF

      #UPDATE ogb_file SET ogb03=ogb03+l_n-1 WHERE ogb01=g_ogb01 AND ogb03>l_ogb.ogb03  #mark by guanyao160902
      UPDATE ogb_file SET ogb03=ogb03+l_n-1 WHERE ogb01=g_ogb01 AND ogb03>g_ogb03       #add by guanyao160902
      IF SQLCA.sqlcode THEN
         LET g_success='N'
      END IF
   END IF
  
         
   LET l_cnt=0
   INITIALIZE l_qry.* TO NULL 
   LET l_sql=" select * from tmp_file "
   PREPARE l_pre11 FROM l_sql
   DECLARE l_cur11 CURSOR WITH HOLD FOR l_pre11
   FOREACH l_cur11 INTO l_qry.*
   
         LET l_cnt=l_cnt+1

         LET l_ogb.*=l_ogb1.*
         LET l_ogb.ogb03=g_ogb03+l_cnt-1
         LET l_ogb.ogb09=g_ogb09
         LET l_ogb.ogb091=l_qry.img03
         LET l_ogb.ogb092=l_qry.img04
         LET l_ogb.ogb12=l_qry.new_ogb12
         LET l_ogb.ogb917=l_qry.new_ogb12
         LET l_ogb.ogb16=l_ogb.ogb12*l_ogb.ogb15_fac
         LET l_ogb.ogb18=l_ogb.ogb12
         LET l_ogb.ogb912=l_ogb.ogb12*l_ogb.ogb911
         SELECT azi04 INTO t_azi04 FROM azi_file WHERE azi01=g_oga.oga23
         IF g_oga.oga213 = 'N' THEN
            LET l_ogb.ogb14 =l_ogb.ogb917*l_ogb.ogb13   
            LET l_ogb.ogb14t=l_ogb.ogb14*(1+g_oga.oga211/100)
         ELSE
            LET l_ogb.ogb14t=l_ogb.ogb917*l_ogb.ogb13  
            LET l_ogb.ogb14 =l_ogb.ogb14t/(1+g_oga.oga211/100)
         END IF
         CALL cl_digcut(l_ogb.ogb14,t_azi04) RETURNING l_ogb.ogb14 
         CALL cl_digcut(l_ogb.ogb14t,t_azi04)RETURNING l_ogb.ogb14t 

         INSERT INTO ogb_file VALUES (l_ogb.*)
         IF SQLCA.sqlcode THEN
            LET g_success='N'
         END IF
   END FOREACH  

   

   IF g_success='Y' THEN 
      MESSAGE "UPDATE OK"
      COMMIT WORK
   ELSE 
      ROLLBACK WORK 
   END IF 
 
   CLOSE WINDOW w_qry
   RETURN
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author   : 2003/10/16 by saki
# Parameter       : none
# Return   	      : void
# Memo            :
# Modify          :
##################################################
FUNCTION ogb04_qry_sel()
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
   LET g_reconstruct = TRUE     #No.MOD-660044 add
 
   WHILE TRUE
      CLEAR FORM
 
      LET INT_FLAG = FALSE
      LET ls_hide_act = ""
 
      CALL ogb04_qry_show()
 
      IF (li_reconstruct) THEN  #是否重查
         MESSAGE ""
 
         IF g_first >= 0 THEN
            CONSTRUCT ms_cons_where ON img03,img04,img09,img10
                 FROM s_img1[1].img03,s_img1[1].img04,s_img1[1].img09,s_img1[1].img10
                 
            BEFORE CONSTRUCT
               CALL ogb04_qry_show()
 
            END CONSTRUCT
         END IF
         LET g_first = 1
         CALL ogb04_qry_prep_result_set()  #準備查詢畫面的資料集.
         # 2003/07/14 by Hiko : 如果沒有設定'每頁顯現資料筆數',則預設為所有資料一起顯現.
         IF (mi_page_count = 0) THEN
            LET mi_page_count = ma_qry.getLength()
         END IF
         # 2003/07/14 by Hiko : 如果所設定的'每頁顯現資料筆數'超過/等於所有資料,則要隱藏'上下頁'的按鈕.
         IF (mi_page_count >= ma_qry.getLength()) THEN
            LET ls_hide_act = "prevpage,nextpage"
         END IF
 
         IF (NOT mi_need_cons) THEN  #是否需要CONSTRUCT(TRUE/FALSE)
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
 
      CALL ogb04_qry_set_display_data(li_start_index, li_end_index) #設定查詢畫面的顯現資料.
 
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang  #總筆數
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang  #頁次
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
 
      IF (mi_multi_sel) THEN  #是否需要複選資料
         #採用INPUT ARRAY的方式來顯現查詢過後的資料.
         CALL ogb04_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE    
         #採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
         CALL ogb04_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
 
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description   : 準備查詢畫面的資料集.
# Date & Author : {格式為:2008/10/10 by TPS.m121752332}
# Parameter     : none
# Return        : void
# Memo        	 :
# Modify        :
##################################################
FUNCTION ogb04_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING
   DEFINE   ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	    #No.FUN-680131 INTEGER
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   	 #No.FUN-680131 VARCHAR(1)
            img03      LIKE img_file.img03,      #儲位
            img04      LIKE img_file.img04,      #批號
            img09      LIKE img_file.img09,      #單位庫存
            img10      LIKE img_file.img10,      #
            ogb12      LIKE ogb_file.ogb12      #出貨數量
            ,img37     LIKE img_file.img37      #add by guanyao160907
                     END RECORD
   DEFINE   l_fac      LIKE ima_file.ima31_fac,
            l_flag     LIKE type_file.num5       #FUN-940008 SMALLINT
   DEFINE l_ogb12      LIKE ogb_file.ogb12       #add by guanyao160903
   DEFINE l_ogb12_1    LIKE ogb_file.ogb12       #add by guanyao160903
 
   IF cl_null(ms_cons_where) THEN LET ms_cons_where = ' AND 1=1 ' END IF
 
   LET ms_cons_where = ms_cons_where," AND img01 = '",g_ogb04,"'"
   IF NOT cl_null(g_ogb09) THEN
      LET ms_cons_where = ms_cons_where," AND img02 = '",g_ogb09,"'"
   END IF
   DISPLAY "ms_cons_where=",ms_cons_where
 
   #Begin:FUN-980030
   #LET l_filter_cond = cl_get_extra_cond_for_qry('cq_ogb04', 'img_file')
   #IF NOT cl_null(l_filter_cond) THEN
   #   LET ms_cons_where = ms_cons_where,l_filter_cond
   #END IF
   #End:FUN-980030
   LET ls_sql = "SELECT 'N', img03,img04, ",
                "       img09,img10,img10,img37 ",   #add img37 by guanyao160907
                " FROM img_file ",
                " WHERE ",
                " img10 > 0",
                "  AND ",ms_cons_where
 
   LET ls_sql = ls_sql CLIPPED, " ORDER BY img37,img03"  #add by guanyao160907
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

      #str----add by guanyao160907
      LET l_ogb12 = ''
      LET l_ogb12_1 = ''
      SELECT SUM(ogb12) INTO l_ogb12 FROM ogb_file,oga_file
       WHERE ogb04 = g_ogb04
         AND ogb09 = g_ogb09
         AND ogb091 = lr_qry.img03
         AND ogb092 = lr_qry.img04
         AND ogb01 = oga01 
         AND ogapost <>'Y' 
         AND ogaconf <>'X'
         AND oga09 = '2'
      SELECT ogb12 INTO l_ogb12_1 FROM ogb_file 
       WHERE ogb01 = g_ogb01
         AND ogb03 = g_ogb03
         AND ogb091 = lr_qry.img03
         AND ogb092 = lr_qry.img04
      IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF  
      IF cl_null(l_ogb12_1) THEN LET l_ogb12_1 = 0 END IF  
      LET l_ogb12 = l_ogb12-l_ogb12_1
      LET lr_qry.img10= lr_qry.img10- l_ogb12
      LET lr_qry.ogb12= lr_qry.img10
      IF lr_qry.img10<=0 THEN
         CONTINUE FOREACH 
      END IF 
      #end----add by guanyao160907
      #str----add by guanyao160903
      #SELECT SUM(ogb12) INTO l_ogb12 FROM ogb_file 
      # WHERE ogb01 = g_ogb01 
      #   AND ogb09 = g_ogb09 
      #   AND ogb091 = lr_qry.img03
      #   AND ogb092 = lr_qry.img04
      #   AND ogb03 <>g_ogb03
      #IF cl_null(l_ogb12) THEN LET l_ogb12 = 0 END IF  
      #LET lr_qry.img10= lr_qry.img10- l_ogb12
      #LET lr_qry.ogb12= lr_qry.img10
      #end----add by guanyao160903
 
      IF li_i-1 >= g_aza.aza38 THEN  #如果大於最大顯示列
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
      LET ma_qry[li_i].* = lr_qry.*  #將撈出資料丟至單身
      LET li_i = li_i + 1
   END FOREACH
   CALL ma_qry.deleteElement(li_i)
END FUNCTION
 
##################################################
# Description   : 設定查詢畫面的顯現資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	 : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo          : 將單身陣列丟到單身暫存並設定暫存區筆數
# Modify        :
##################################################
FUNCTION ogb04_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	   #No.FUN-680131 INTEGER
   DEFINE   li_i             LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            li_j             LIKE type_file.num10 	   #No.FUN-680131 INTEGER
 
   CALL ma_qry_tmp.clear()
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry_tmp[li_j+1].* = ma_qry[li_i].*
      LET li_j = li_j + 1
   END FOR
 
   CALL SET_COUNT(ma_qry_tmp.getLength())
END FUNCTION
 
##################################################
# Description   : 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter     : ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	    : li_continue      LIKE type_file.num5     是否繼續
#               : li_reconstruct   LIKE type_file.num5     是否重新查詢
#               : pi_start_index   LIKE type_file.num10    改變後的起始位置
# Memo        	 :
# Modify        :
##################################################
FUNCTION ogb04_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   i,l_cnt          LIKE type_file.num5   #FUN-940008 SMALLINT              #i:指標位置 l_cnt:筆數
   DEFINE   ps_hide_act      STRING,               #所要隱藏的Action Button
            pi_start_index   LIKE type_file.num10, #No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  #No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   l_n              LIKE type_file.num5   #檢查重複用         #No.FUN-680126 SMALLINT
   DEFINE l_ogb12            LIKE ogb_file.ogb12    #add by guanyao160829
 
   #顯示單頭資料
   CALL ogb04_qry_show()
 
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_img1.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED)
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN  #隱藏ps_hide_act傳入值
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
 
      BEFORE ROW
         LET i=ARR_CURR()
         LET old_check = ma_qry_tmp[i].check
         
      ON ROW CHANGE
         LET g_tot_ogb12=0
         FOR g_cnt = 1 TO ma_qry_tmp.getLength()
            IF ma_qry_tmp[g_cnt].check = 'Y' THEN
               LET g_tot_ogb12=g_tot_ogb12+ma_qry_tmp[g_cnt].new_ogb12
            END IF
            IF cl_null(ma_qry_tmp[g_cnt].check) AND cl_null(ma_qry_tmp[g_cnt].img03) AND cl_null(ma_qry_tmp[g_cnt].img04)
              AND cl_null(ma_qry_tmp[g_cnt].img09) AND cl_null(ma_qry_tmp[g_cnt].img10) AND cl_null(ma_qry_tmp[g_cnt].new_ogb12) THEN 

              CALL ma_qry_tmp.deleteElement(g_cnt)
            END IF 
         END FOR
         
         IF g_tot_ogb12 IS NULL THEN LET g_tot_ogb12 = 0 END IF
         DISPLAY g_tot_ogb12 TO FORMONLY.tot_ogb12
 
      ON CHANGE check1
         LET g_tot_ogb12=0
         FOR g_cnt = 1 TO ma_qry_tmp.getLength()
            IF ma_qry_tmp[g_cnt].check = 'Y' THEN
               LET g_tot_ogb12=g_tot_ogb12+ma_qry_tmp[g_cnt].new_ogb12
            END IF
            IF cl_null(ma_qry_tmp[g_cnt].check) AND cl_null(ma_qry_tmp[g_cnt].img03) AND cl_null(ma_qry_tmp[g_cnt].img04)
              AND cl_null(ma_qry_tmp[g_cnt].img09) AND cl_null(ma_qry_tmp[g_cnt].img10) AND cl_null(ma_qry_tmp[g_cnt].new_ogb12) THEN 

              CALL ma_qry_tmp.deleteElement(g_cnt)
            END IF 
         END FOR

         IF g_tot_ogb12 IS NULL THEN LET g_tot_ogb12 = 0 END IF
         DISPLAY g_tot_ogb12 TO FORMONLY.tot_ogb12

      AFTER ROW 
         DELETE FROM tmp_file
         FOR g_cnt = 1 TO ma_qry_tmp.getLength()
            IF ma_qry_tmp[g_cnt].check = 'Y' THEN
               INSERT INTO tmp_file VALUES (ma_qry_tmp[g_cnt].img03,ma_qry_tmp[g_cnt].img04,ma_qry_tmp[g_cnt].img09,ma_qry_tmp[g_cnt].img10,ma_qry_tmp[g_cnt].new_ogb12,ma_qry_tmp[g_cnt].img37) #add img37 by guanyao160907
            END IF 
         END FOR 
         
      AFTER FIELD new_ogb12
         IF ma_qry_tmp[i].new_ogb12>ma_qry_tmp[i].img10 THEN 
            CALL cl_err('','cqry-02',1)
            NEXT FIELD new_ogb12
         END IF 
      
      ON ACTION prevpage #上一頁
         CALL GET_FLDBUF(s_img1.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ogb04_qry_reset_multi_sel(pi_start_index, pi_end_index) #重設查詢資料關於'check'欄位的值.
 
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
 
         LET li_continue = TRUE
         EXIT INPUT
 
      ON ACTION nextpage #下一頁
         CALL GET_FLDBUF(s_img1.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL ogb04_qry_reset_multi_sel(pi_start_index, pi_end_index) #重設查詢資料關於'check'欄位的值.
 
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
 
         LET li_continue = TRUE
         EXIT INPUT
 
      ON ACTION refresh #重新整理
         CALL ogb04_qry_refresh() #取消單身所有選擇動作
         LET pi_start_index = 1   #顯現第一筆查詢資料位置
 
         LET li_continue = TRUE   #繼續執行
         EXIT INPUT
 
      ON ACTION reconstruct #重新查詢
         LET g_tot_ogb12 = 0   #另挑選發料初始為0
         DISPLAY g_tot_ogb12 TO FORMONLY.tot_ogb12
 
         LET li_reconstruct = TRUE #重新查詢
         LET li_continue = TRUE    #繼續執行
         EXIT INPUT
 
      ON ACTION selectall #勾選全部
         LET g_tot_ogb12 = 0
         FOR g_cnt = 1 TO ma_qry_tmp.getLength()
            #逐筆打勾
            LET ma_qry_tmp[g_cnt].check = 'Y'
            DISPLAY BY NAME ma_qry_tmp[g_cnt].CHECK
            LET g_tot_ogb12 = g_tot_ogb12+ma_qry_tmp[g_cnt].new_ogb12
         END FOR
         
         #計算temp內

         IF g_tot_ogb12 IS NULL THEN LET g_tot_ogb12 = 0 END IF
         DISPLAY g_tot_ogb12 TO FORMONLY.tot_ogb12
 
   #     DISPLAY ARRAY ma_qry_tmp TO s_img1.*
   #        BEFORE DISPLAY
   #        EXIT DISPLAY
   #     END DISPLAY
 
 
      ON ACTION select_none #取消勾選

         FOR g_cnt = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[g_cnt].check = 'N'
             DISPLAY BY NAME ma_qry_tmp[g_cnt].check
 
         END FOR
         LET g_tot_ogb12 = 0
         DISPLAY g_tot_ogb12 TO FORMONLY.tot_ogb12
 
  #      DISPLAY ARRAY ma_qry_tmp TO s_img1.*
  #         BEFORE DISPLAY
  #         EXIT DISPLAY
  #      END DISPLAY

      #str-----add by guanyao160829
      ON ACTION sure 
         LET g_tot_ogb12 = 0
         CALL ogb04_qry_refresh()
         LET pi_start_index = 1 
         FOR g_cnt = 1 TO ma_qry_tmp.getLength()
            IF g_ogb12 -g_tot_ogb12 > ma_qry_tmp[g_cnt].img10 THEN 
               LET g_tot_ogb12 = g_tot_ogb12+ma_qry_tmp[g_cnt].img10
               LET ma_qry_tmp[g_cnt].check = 'Y'
            ELSE 
               LET ma_qry_tmp[g_cnt].new_ogb12 =g_ogb12-g_tot_ogb12 
               LET g_tot_ogb12 = g_tot_ogb12+ma_qry_tmp[g_cnt].new_ogb12  #add by guanyao160901
               LET ma_qry_tmp[g_cnt].check = 'Y'
               EXIT FOR
            END IF 
         END FOR 
         DISPLAY g_tot_ogb12 TO FORMONLY.tot_ogb12
      #end-----add by guanyao160829
 
      AFTER INPUT  #確定
        #-----------------No:CHI-970038 add
         LET g_tot_ogb12 = 0
         DELETE FROM tmp_file
         FOR g_cnt = 1 TO ma_qry_tmp.getLength() 
            IF ma_qry_tmp[g_cnt].check = 'Y' THEN 
               LET g_tot_ogb12=g_tot_ogb12+ma_qry_tmp[g_cnt].new_ogb12
               INSERT INTO tmp_file VALUES (ma_qry_tmp[g_cnt].img03,ma_qry_tmp[g_cnt].img04,ma_qry_tmp[g_cnt].img09,ma_qry_tmp[g_cnt].img10,ma_qry_tmp[g_cnt].new_ogb12,ma_qry_tmp[g_cnt].img37) #add img37 by guanyao160907
            END IF 
         END FOR 
        #-----------------No:CHI-970038 end

        IF g_tot_ogb12<>g_ogb12 THEN 
           CALL cl_err('','cqry-01',1)
           DELETE FROM tmp_file
           CONTINUE INPUT  
        END IF 

         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_img1.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL ogb04_qry_reset_multi_sel(pi_start_index, pi_end_index)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
            LET ms_ret2 = NULL       #CHI-9C0048
            LET ms_ret3 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE  #離開程式
         EXIT INPUT
 
      ON ACTION cancel #放棄
         LET INT_FLAG = 0 #No.CHI-690081
         FOR g_cnt = 1 TO ma_qry_tmp.getLength()
             LET ma_qry_tmp[g_cnt].check = 'N'
             DISPLAY BY NAME ma_qry_tmp[g_cnt].check
         END FOR
         LET g_tot_ogb12=0
         LET li_continue = FALSE #離開程式
         EXIT INPUT
 
      ON ACTION exporttoexcel #匯出excel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON IDLE g_idle_seconds #閒置設定
         CALL cl_on_idle()
         CONTINUE INPUT
 
   END INPUT
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description  	: 重設查詢資料關於'check'欄位的值.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	. pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb04_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               . pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               . pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION ogb04_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_img1.*
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
         LET g_reconstruct = FALSE     #No.MOD-660044 add
 
         EXIT DISPLAY
      ON ACTION accept
         #CALL ogb04_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
 
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF NOT mi_multi_sel THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
            LET ms_ret3 = ms_default3
         END IF
 
         LET li_continue = FALSE
 
         EXIT DISPLAY
 
      ON ACTION exporttoexcel  #No.FUN-660161
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION
 
##################################################
# Description   : 重設查詢資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION ogb04_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'        #取消所有單身勾選
   END FOR
END FUNCTION
 
##################################################
# Description   : 選擇並確認資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter     : pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return        : void
# Memo          : 若需要回傳資料才需使用
# Modify        : TPS.m121752332 該程式只有建立發料單身作業不需回傳處理
##################################################
FUNCTION ogb04_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  	#No.FUN-680131 INTEGER
 
 
   # 2004/06/03 by saki : GDC 1.3版本後，若沒有資料，ARR_CURR()會是0
   IF pi_sel_index = 0 THEN
      RETURN
   END IF
 
   IF (mi_multi_sel) THEN  #是否需要複選資料
      LET lsb_multi_sel = base.StringBuffer.create()
 
      FOR li_i = 1 TO ma_qry.getLength()
         IF (ma_qry[li_i].check = 'Y') THEN #將單身勾選資料
            IF (lsb_multi_sel.getLength() = 0) THEN
               #CALL lsb_multi_sel.append(ma_qry[li_i].img02 CLIPPED)
            ELSE
               #CALL lsb_multi_sel.append("|" || ma_qry[li_i].img02 CLIPPED)
            END IF
         END IF
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值.
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
      # LET ms_ret1 = ma_qry[pi_sel_index].img02
      # LET ms_ret2 = ma_qry[pi_sel_index].img03
      # LET ms_ret3 = ma_qry[pi_sel_index].img04
   END IF
END FUNCTION
 
FUNCTION ogb04_qry_show()
   DISPLAY g_ogb01 TO FORMONLY.ogb01
   DISPLAY g_ogb03 TO FORMONLY.ogb03
   DISPLAY g_ogb04 TO FORMONLY.ogb04
   DISPLAY g_ogb06 TO FORMONLY.ogb06
   DISPLAY g_ima021 TO FORMONLY.ima021
   DISPLAY g_ogb12  TO FORMONLY.ogb12
   DISPLAY g_ogb09  TO ogb09
   DISPLAY g_tot_ogb12 TO FORMONLY.tot_ogb12
END FUNCTION 
#FUN-8A0140
