# Prog. Version..: '5.30.06-13.04.18(00007)'     #
#{
# Program name  : q_oga_oha.4gl
# Program ver.  : 7.0
# Description   : 訂單資料查詢
# Date & Author : 2009/10/19 By Carrier  #No.FUN-9A0027
# Memo          : 
#}
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:TQC-B40167 11/04/20 By yinhy l_sql,l_buf调整为STRING类型
# Modify.........: No:MOD-B60238 11/06/28 By wujie  排除有客户签收单的出货单
# Modify.........: No:MOD-B70264 11/07/29 By yinhy 增加oga09條件
# Modify.........: No:CHI-C10018 12/05/14 By Polly ooz65出貨應收包含銷退折讓的參數不受限大陸版
# Modify.........: No:MOD-CC0163 13/01/23 By Polly 出貨單開窗調整，因以單身角度來判斷是否有產生過應收
# Modify.........: No:MOD-D80020 13/08/06 By wangrr 30追單,MOD-CC0163判斷,若判斷有產生過,應CONTINUE FOREACH
DATABASE ds  #No.FUN-9A0027

GLOBALS "../../config/top.global"

DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	
         oga01    LIKE oga_file.oga01,                     
         oga02    LIKE oga_file.oga02,                     
         oga04    LIKE oga_file.oga04
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	
         oga01    LIKE oga_file.oga01,
         oga02    LIKE oga_file.oga02,
         oga04    LIKE oga_file.oga04
END RECORD

DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	
DEFINE   ms_cons_where    STRING                  #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10    #每頁顯現資料筆數.	
DEFINE   ms_default1      STRING     
DEFINE   ms_ret1          STRING    

FUNCTION q_oga_oha(pi_multi_sel,pi_need_cons,ps_default1)
   DEFINE   pi_multi_sel   LIKE type_file.num5,
            pi_need_cons   LIKE type_file.num5,
            ps_default1    STRING  
 
   LET ms_default1 = ps_default1
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_oga_oha" ATTRIBUTE(STYLE="create_qry") 

   CALL cl_ui_locale("q_oga_oha")

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

   CALL oga_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1 
   END IF
END FUNCTION

##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/09/22 by jack
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oga_qry_sel()
   DEFINE   ls_hide_act      STRING
   DEFINE   li_hide_page     LIKE type_file.num5,     #是否隱藏'上下頁'的按鈕.	
            li_reconstruct   LIKE type_file.num5,     #是否重新CONSTRUCT.預設為TRUE. 	
            li_continue      LIKE type_file.num5      #是否繼續.	
   DEFINE   li_start_index   LIKE type_file.num10, 	
            li_end_index     LIKE type_file.num10 	
   DEFINE   li_curr_page     LIKE type_file.num5  	
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
             CALL cl_opmsg('q')  
             CONSTRUCT ms_cons_where ON oga01, oga02, oga04
                                  FROM s_oga[1].oga01,s_oga[1].oga02,s_oga[1].oga04
                ON IDLE g_idle_seconds
                   CALL cl_on_idle()
                   CONTINUE CONSTRUCT
             
             END CONSTRUCT
             IF (INT_FLAG) THEN
                LET INT_FLAG = FALSE
                EXIT WHILE
             END IF
         END IF
     
         CALL oga_qry_prep_result_set() 
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
     
      CALL oga_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count

      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF

      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang

      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL oga_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL oga_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION

##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : 2003/09/22 by jack
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION oga_qry_prep_result_set()
   DEFINE   ls_sql      STRING,
            ls_where    STRING
  #DEFINE   l_sql,l_buf LIKE type_file.chr1000	  #No.TQC-B40167
   DEFINE   l_sql,l_buf STRING                    #No.TQC-B40167
   DEFINE   ls_where1   LIKE type_file.chr1000
   DEFINE   li_i        LIKE type_file.num10 	
   DEFINE   l_i         LIKE type_file.num5
   DEFINE   l_j         LIKE type_file.num5
   DEFINE   lr_qry      RECORD
            check       LIKE type_file.chr1,   	
            oga01       LIKE oga_file.oga01,
            oga02       LIKE oga_file.oga02,
            oga04       LIKE oga_file.oga04
            END RECORD
   DEFINE   l_cnt,l_cnt2 LIKE type_file.num5      #MOD-CC0163 add
   DEFINE   l_diff      LIKE type_file.chr1       #MOD-D80020  #判斷來源是oga或oha

   LET ls_sql = "SELECT 'N',oga01,oga02,oga04,'A'", #MOD-D80020 add 'A' 
                " FROM oga_file",
                " WHERE ",ms_cons_where,
               #"   AND  ogaconf = 'Y' and (oga10 is null or oga10=' ') ",           #MOD-CC0163 mark
                "   AND  ogaconf = 'Y' ",                                            #MOD-CC0163 add
               #"   AND (oga09 = '2' OR oga09 ='3' OR oga09 = '8') ",
                "    AND oga09 IN ('2','3','8','A','4','6') AND ogapost = 'Y' ",            #MOD-B70264
                "   AND (oga00 = '1' OR oga00 ='4' OR oga00 = '5' OR oga00 = '6') ",
                "   AND oga65 <> 'Y' "   #No.MOD-B60238

  #IF g_aza.aza26 = '2' AND g_ooz.ooz65 = 'Y' THEN     #CHI-C10018 mark
   IF g_ooz.ooz65 = 'Y' THEN                           #CHI-C10018 add
      LET l_j = ms_cons_where.getlength()                                                
      LET ls_where1 = ms_cons_where
      FOR l_i = 1 TO l_j - 4                                                    
          CASE ls_where1[l_i,l_i+4]                                                 
               WHEN 'oga01'  LET ls_where1[l_i,l_i+4] = 'oha01'
               WHEN 'oga02'  LET ls_where1[l_i,l_i+4] = 'oha02'
               WHEN 'oga04'  LET ls_where1[l_i,l_i+4] = 'oha04'
          END CASE                                                              
      END FOR           
      LET ls_sql = ls_sql CLIPPED," UNION ",                                     
             "SELECT 'N',oha01,oha02,oha04,'B' ",#MOD-D80020 add 'B'
             "  FROM oha_file,oay_file",
             " WHERE ",ls_where1 CLIPPED,                                          
            #"   AND ohaconf='Y' AND (oha10 is null or oha10 = ' ') ",         #MOD-CC0163 mark
             "   AND ohaconf='Y' ",                                            #MOD-CC0163 add
             "   AND oha01 like trim(oayslip)||'-%' AND oay11='Y'",            
             "   AND oha09 IN ('1','4','5') AND ohapost='Y'"                   
   END IF                 

   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED," ORDER BY oga01"

   DISPLAY "ls_sql=",ls_sql
   DECLARE lcurs_qry CURSOR FROM ls_sql
 
   FOR li_i = ma_qry.getLength() TO 1 STEP -1
      CALL ma_qry.deleteElement(li_i)
   END FOR
 
   LET li_i = 1
 
   FOREACH lcurs_qry INTO lr_qry.*
      IF (SQLCA.SQLCODE) THEN
         CALL cl_err(ls_sql, SQLCA.SQLCODE, 1)
         EXIT FOREACH
      END IF

     #-----------------------MOD-CC0163-------------(S)
   IF l_diff = 'A' THEN   #MOD-D80020
      LET l_cnt = 0
      LET l_cnt2 = 0
      SELECT COUNT(*) INTO l_cnt FROM ogb_file
       WHERE ogb01 = lr_qry.oga01
     #SELECT COUNT(*) INTO l_cnt2 FROM omb_file #MOD-D80020 mark
      SELECT COUNT(*) INTO l_cnt2 FROM omb_file,oma_file   #MOD-D80020
       WHERE omb31 = lr_qry.oga01
         AND oma01 = omb01 AND omavoid = 'N'               #MOD-D80020
      IF l_cnt = l_cnt2 THEN
         #EXIT FOREACH      #MOD-D80020 mark
          CONTINUE FOREACH  #MOD-D80020
      END IF
   END IF   #MOD-D80020
      #IF g_ooz.ooz65 = 'Y' THEN #MOD-D80020 mark
      IF l_diff = 'B' THEN       #MOD-D80020
         LET l_cnt = 0
         LET l_cnt2 = 0
         #SELECT COUNT(*) INTO l_cnt FROM ogb_file     #MOD-D80020 mark
         # WHERE ogb01 = lr_qry.oga01                  #MOD-D80020 mark
         SELECT COUNT(*) INTO l_cnt FROM ohb_file      #MOD-D80020
          WHERE ohb01 = lr_qry.oga01                   #MOD-D80020
         #SELECT COUNT(*) INTO l_cnt2 FROM ohb_file
         # WHERE ohb31 = lr_qry.oga01
         SELECT COUNT(*) INTO l_cnt2 FROM omb_file,oma_file #MOD-D80020
          WHERE omb31 = lr_qry.oga01                        #MOD-D80020
            AND oma01 = omb01 AND omavoid = 'N'             #MOD-D80020
         IF l_cnt = l_cnt2 THEN
            #EXIT FOREACH      #MOD-D80020 mark
            CONTINUE FOREACH   #MOD-D80020
         END IF
      END IF
     #-----------------------MOD-CC0163-------------(E)

      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF

      LET ma_qry[li_i].* = lr_qry.*
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION

##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : 2003/09/22 by jack
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION oga_qry_set_display_data(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_i             LIKE type_file.num10, 	
            li_j             LIKE type_file.num10 	
 

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
# Description  	: 採用INPUT ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2003/09/22 by jack
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION oga_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_continue      LIKE type_file.num5,  	
            li_reconstruct   LIKE type_file.num5  	
   DEFINE   li_i             LIKE type_file.num5        
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oga.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_oga.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_oga.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL oga_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_oga.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL oga_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL oga_qry_refresh()
     
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
            CALL oga_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL oga_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF

         LET li_continue = FALSE
     
         EXIT INPUT
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT

      
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      
   
      
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      

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
# Date & Author : 2003/09/22 by jack
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oga_qry_reset_multi_sel(pi_start_index, pi_end_index)
   DEFINE   pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_i             LIKE type_file.num10, 	
            li_j             LIKE type_file.num10 	
 
 
   FOR li_i = pi_start_index TO pi_end_index
      LET ma_qry[li_i].check = ma_qry_tmp[li_j+1].check
      LET li_j = li_j + 1
   END FOR
END FUNCTION

##################################################
# Description  	: 採用DISPLAY ARRAY的方式來顯現查詢過後的資料.
# Date & Author : 2003/09/22 by jack
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION oga_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	
            pi_end_index     LIKE type_file.num10 	
   DEFINE   li_continue      LIKE type_file.num5,  	
            li_reconstruct   LIKE type_file.num5  	
 
 
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
         CALL oga_qry_accept(pi_start_index+ARR_CURR()-1)
         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON ACTION cancel
         LET INT_FLAG = 0 
         IF (NOT mi_multi_sel) THEN
            LET ms_ret1 = ms_default1
         END IF

         LET li_continue = FALSE
      
         EXIT DISPLAY
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
      
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      

      
      ON ACTION qry_string
         CALL cl_qry_string("detail")
      

   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
 
   RETURN li_continue,li_reconstruct,pi_start_index
END FUNCTION

##################################################
# Description   : 重設查詢資料.
# Date & Author : 2003/09/22 by jack
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION oga_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	


   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION

##################################################
# Description  	: 選擇並確認資料.
# Date & Author : 2003/09/22 by jack
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION oga_qry_accept(pi_sel_index)
   DEFINE   pi_sel_index    LIKE type_file.num10 	
   DEFINE   lsb_multi_sel   base.StringBuffer,
            li_i            LIKE type_file.num10  	
 

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
