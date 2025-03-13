# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#{
# Program name  : q_img4.4gl
# Program ver.  : 7.0
# Description   : 根據料號對倉庫/儲位/批號查詢,且順序依發料優先順序
# Input parameter: p_img01:料號
#                  p_img02:倉庫
#                  p_img03:存放位置
#                  p_img04:批號
#                  p_kind :倉儲類別  'S':一般倉庫檔 'W':在製品倉庫 'A':查全部
# Date & Author : 2003/10/16 by saki
# Memo          : 
# Modify        :
# Modify........: No.MOD-660044 06/06/20 By Pengu 重新查詢時應該顯示該料號所有的倉儲。
# Modify........: No.FUN-660161 06/07/07 By cl  增加匯出Excel功能
# Modify........: No.FUN-680131 06/08/31 By Carrier 欄位型態用LIKE定義
#}
# Modify.........: No.CHI-690081 06/10/31 By Judy hardcode程序退出將INT_FLAG置為0
# Modify.........: No.MOD-760098 06/06/22 By Carol 傳回值前變數去除clipped的處理
# Modify.........: No.FUN-840023 08/04/07 By saki 串查功能
# Modify.........: No.FUN-880082 08/09/01 By tsai_yen 開窗全選功能
# Modify.........: No.FUN-980030 09/08/14 By Hiko 加上資料權限控制
# Modify.........: No.CHI-960097 09/09/30 By chenmoyan 多單位時，可以查到庫存量及母單位數量及參考數量
# Modify.........: No.FUN-990069 09/10/09 By baofei 修改GP5.2的相關設定 
# Modify.........: No:CHI-9A0007 09/10/26 By Smapmin 使用多單位,但料件為單一單位時,畫面要呈現單一單位的畫面
# Modify.........: No:CHI-9C0048 09/12/23 By tsai_yen 陣列索引ARR_CURR()為0的判斷
# Modify.........: No:MOD-A70195 10/07/28 By Carrier ORDER BY 前加一空格
# Modify.........: No:FUN-B50087 11/05/18 By lixh1 增加顯示img18有效日期欄位
# Modify.........: No:MOD-C40065 12/04/09 By ck2yuan select 少了img23 導致img18日期顯示錯誤
# Modify.........: No:MOD-C90181 12/09/21 By zhangll 重新查詢功能應該支持
# Modify.........: No:TQC-D70053 13/07/23 By qirl 對axmt610的倉庫進行空管
#C2017030201chenyang  排除仓库编号ZTC
DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE   ma_qry   DYNAMIC ARRAY OF RECORD
         check    LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         img02    LIKE img_file.img02,
         img03    LIKE img_file.img03,
         img04    LIKE img_file.img04,
         img09    LIKE img_file.img09,
         img10    LIKE img_file.img10,
         img27    LIKE img_file.img27
#No.CHI-960097 --Begin
        ,img23      LIKE img_file.img23,
         img18      LIKE img_file.img18,     #FUN-B50087
         imgg10_1   LIKE imgg_file.imgg10,
         imgg10_2   LIKE imgg_file.imgg10,
         imgg10_3   LIKE imgg_file.imgg10,
         imgg10_4   LIKE imgg_file.imgg10,
         imgg10_5   LIKE imgg_file.imgg10,
         imgg10_6   LIKE imgg_file.imgg10,
         imgg10_7   LIKE imgg_file.imgg10,
         imgg10_8   LIKE imgg_file.imgg10,
         imgg10_9   LIKE imgg_file.imgg10,
         imgg10_10  LIKE imgg_file.imgg10
#No.CHI-960097 --End
END RECORD
DEFINE   ma_qry_tmp   DYNAMIC ARRAY OF RECORD
         check        LIKE type_file.chr1,  	#No.FUN-680131 VARCHAR(1)
         img02        LIKE img_file.img02,
         img03        LIKE img_file.img03,
         img04        LIKE img_file.img04,
         img09        LIKE img_file.img09,
         img10        LIKE img_file.img10,
         img27        LIKE img_file.img27
#No.CHI-960097 --Begin
        ,img23      LIKE img_file.img23,
         img18      LIKE img_file.img18,    #FUN-B50087
         imgg10_1   LIKE imgg_file.imgg10,
         imgg10_2   LIKE imgg_file.imgg10,
         imgg10_3   LIKE imgg_file.imgg10,
         imgg10_4   LIKE imgg_file.imgg10,
         imgg10_5   LIKE imgg_file.imgg10,
         imgg10_6   LIKE imgg_file.imgg10,
         imgg10_7   LIKE imgg_file.imgg10,
         imgg10_8   LIKE imgg_file.imgg10,
         imgg10_9   LIKE imgg_file.imgg10,
         imgg10_10  LIKE imgg_file.imgg10
#No.CHI-960097 --End
END RECORD
 
DEFINE   mi_multi_sel     LIKE type_file.num5     #是否需要複選資料(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_need_cons     LIKE type_file.num5     #是否需要CONSTRUCT(TRUE/FALSE).	#No.FUN-680131 SMALLINT
DEFINE   mi_cons_index    LIKE type_file.chr1     #CONSTRUCT時回傳哪一個值              #No.FUN-680131 VARCHAR(1)
DEFINE   ms_cons_where    STRING     #暫存CONSTRUCT區塊的WHERE條件.
DEFINE   mi_page_count    LIKE type_file.num10     #每頁顯現資料筆數.	#No.FUN-680131 INTEGER
DEFINE   ms_ret1          STRING, 
         ms_ret2          STRING,
         ms_ret3          STRING
DEFINE   ms_default1      STRING, 
         ms_default2      STRING,
         ms_default3      STRING
DEFINE   ms_img01         LIKE img_file.img01
DEFINE   ms_kind          LIKE img_file.img22    #倉儲類別   #No.FUN-680131 VARCHAR(1)
DEFINE   g_reconstruct    LIKE type_file.num5    #No.MOD-660044 add  #No.FUN-680131 SMALLINT
DEFINE   g_ima906         LIKE ima_file.ima906   #CHI-9A0007
 
FUNCTION q_img4(pi_multi_sel,pi_need_cons,p_img01,ps_default1,ps_default2,ps_default3,p_kind)
   DEFINE   pi_multi_sel   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            pi_need_cons   LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            ps_default1    STRING  , 
            ps_default2    STRING  ,
            ps_default3    STRING
   DEFINE   p_img01        LIKE img_file.img01
   DEFINE   p_kind         LIKE img_file.img22   #No.FUN-680131 VARCHAR(1)
  

   LET ms_default1 = ps_default1
   LET ms_default2 = ps_default2
   LET ms_default3 = ps_default3
   LET ms_img01 = p_img01
   LET ms_kind = p_kind

   #add by darcy 220323 s---
   IF g_prog ="aimt324" AND g_user = "24088" THEN
        LET ms_default1 = ''
        LET ms_default2 = ''
   END IF
   #add by darcy 220323 e---
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   OPEN WINDOW w_qry WITH FORM "qry/42f/q_img4" ATTRIBUTE(STYLE="create_qry")  #No.FUN-660161
 
   CALL cl_ui_locale("q_img4")
 
   LET mi_multi_sel = pi_multi_sel
   LET mi_need_cons = pi_need_cons
 
   # 2004/02/09 by saki : 不複選的狀態下要將CheckBox隱藏
   IF NOT (mi_multi_sel) THEN
      CALL cl_set_comp_visible("check",FALSE)
   END IF
 
   # 2003/09/16 by Hiko : 在複選狀態時,要將回傳欄位的字型顏色設為紅色,以作為標示.
   IF (mi_multi_sel) THEN
      CALL cl_set_comp_font_color("img02", "red")
   END IF

   SELECT ima906 INTO g_ima906 FROM ima_file WHERE ima01=ms_img01   #CHI-9A0007
 
#No.CHI-960097 --Begin
   #IF g_sma.sma115 = 'Y' THEN   #CHI-9A0007
   IF g_sma.sma115 = 'Y' AND g_ima906 <> '1' THEN   #CHI-9A0007
      CALL cl_set_comp_visible("img09,img10,img27",FALSE)
   ELSE
      CALL cl_set_comp_visible("img23,imgg10_1,imgg10_2,imgg10_3,imgg10_4,
                                imgg10_5,imgg10_6,imgg10_7,imgg10_8,imgg10_9,
                                imgg10_10",FALSE)
   END IF
#No.CHI-960097 --End
   CALL img4_qry_sel()
 
   CLOSE WINDOW w_qry
 
   IF (mi_multi_sel) THEN
      RETURN ms_ret1 
   ELSE
      RETURN ms_ret1,ms_ret2,ms_ret3 
   END IF
END FUNCTION
 
##################################################
# Description  	: 畫面顯現與資料的選擇.
# Date & Author : 2003/10/16 by saki
# Parameter   	: none
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION img4_qry_sel()
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
 
      IF (li_reconstruct) THEN
         MESSAGE ""
         LET ms_cons_where = "1=1"

         #MOD-C90181 mod
         IF (mi_need_cons) THEN
            CONSTRUCT ms_cons_where ON img02,img03,img04,img09,img10,img27,img23,img18
                                  FROM s_img[1].img02,s_img[1].img03,
                                       s_img[1].img04,s_img[1].img09,
                                       s_img[1].img10,s_img[1].img27,
                                       s_img[1].img23,s_img[1].img18
               ON IDLE g_idle_seconds
                  CALL cl_on_idle()
                  CONTINUE CONSTRUCT

            END CONSTRUCT
            IF (INT_FLAG) THEN
               LET INT_FLAG = FALSE
               EXIT WHILE
            END IF
         END IF
         #MOD-C90181 mod--end
     
         CALL img4_qry_prep_result_set() 
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
     
      CALL img4_qry_set_display_data(li_start_index, li_end_index)
     
      LET li_curr_page = li_end_index / mi_page_count
 
      IF (li_end_index MOD mi_page_count) > 0 THEN
         LET li_curr_page = li_curr_page + 1
      END IF
 
      SELECT ze03 INTO li_count FROM ze_file WHERE ze01 = 'qry-001' AND ze02 = g_lang
      SELECT ze03 INTO li_page  FROM ze_file WHERE ze01 = 'qry-002' AND ze02 = g_lang
 
      MESSAGE li_count CLIPPED || " : " || ma_qry.getLength() || "  " || li_page CLIPPED || " : " || li_curr_page
     
      IF (mi_multi_sel) THEN
         CALL img4_qry_input_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      ELSE
         CALL img4_qry_display_array(ls_hide_act, li_start_index, li_end_index) RETURNING li_continue,li_reconstruct,li_start_index
      END IF
     
      IF (NOT li_continue) THEN
         EXIT WHILE
      END IF
   END WHILE
END FUNCTION
 
##################################################
# Description  	: 準備查詢畫面的資料集.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: none
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION img4_qry_prep_result_set()
   DEFINE l_filter_cond STRING #FUN-980030
   DEFINE   ls_sql     STRING
   DEFINE   ls_where   STRING
   DEFINE   li_i       LIKE type_file.num10 	#No.FUN-680131 INTEGER
#No.CHI-960097 --Begin
   DEFINE   l_imgg10   DYNAMIC ARRAY OF LIKE imgg_file.imgg09
   DEFINE   ls_sql1    LIKE type_file.chr100
   DEFINE   l_j        LIKE type_file.num5
   DEFINE   l_val      LIKE imgg_file.imgg10
   DEFINE   l_cnt      LIKE type_file.num5
   DEFINE   g_msg      LIKE gfe_file.gfe02
   DEFINE   l_msg      LIKE type_file.chr10
   DEFINE   l_chr      LIKE type_file.chr10
#No.CHI-960097 --End
   DEFINE   lr_qry     RECORD
            check      LIKE type_file.chr1,   	#No.FUN-680131 VARCHAR(1)
            img02      LIKE img_file.img02,
            img03      LIKE img_file.img03,
            img04      LIKE img_file.img04,
            img09      LIKE img_file.img09,
            img10      LIKE img_file.img10,
            img27      LIKE img_file.img27
#No.CHI-960097 --Begin
        ,img23      LIKE img_file.img23,
         img18      LIKE img_file.img18,   #FUN-B50087
         imgg10_1   LIKE imgg_file.imgg10,
         imgg10_2   LIKE imgg_file.imgg10,
         imgg10_3   LIKE imgg_file.imgg10,
         imgg10_4   LIKE imgg_file.imgg10,
         imgg10_5   LIKE imgg_file.imgg10,
         imgg10_6   LIKE imgg_file.imgg10,
         imgg10_7   LIKE imgg_file.imgg10,
         imgg10_8   LIKE imgg_file.imgg10,
         imgg10_9   LIKE imgg_file.imgg10,
         imgg10_10  LIKE imgg_file.imgg10
#No.CHI-960097 --End
   END RECORD
   #Begin:FUN-980030
   LET l_filter_cond = cl_get_extra_cond_for_qry('q_img4', 'img_file')
   IF NOT cl_null(l_filter_cond) THEN
      LET ms_cons_where = ms_cons_where,l_filter_cond
   END IF
   #End:FUN-980030
 
 
#No.CHI-960097 --Begin                                                                                                              
   #IF g_sma.sma115 = 'Y' THEN   #CHI-9A0007
   IF g_sma.sma115 = 'Y' AND g_ima906 <> '1' THEN   #CHI-9A0007
      DECLARE q_img4_imgg09 CURSOR FOR                                                                                              
       SELECT UNIQUE imgg09 FROM imgg_file                                                                                          
        WHERE imgg01 = ms_img01                                                                                                     
       LET li_i = 1                                                                                                                 
       FOREACH q_img4_imgg09 INTO l_imgg10[li_i]                                                                                    
           IF SQLCA.sqlcode THEN                                                                                                    
               CALL cl_err('Foreach:',SQLCA.sqlcode,1)                                                                              
               EXIT FOREACH                                                                                                         
           END IF                                                                                                                   
           LET li_i = li_i + 1                                                                                                      
           IF li_i > 10 THEN                                                                                                        
              EXIT FOREACH                                                                                                          
           END IF                                                                                                                   
      END FOREACH                                                                                                                   
      LET l_cnt = li_i - 1                                                                                                          
      FOR li_i = 1 TO 10                                                                                                            
          LET l_chr=li_i                                                                                                            
          LET l_msg="imgg10_",l_chr CLIPPED                                                                                         
          IF NOT cl_null(l_imgg10[li_i]) THEN                                                                                       
             SELECT gfe02 INTO g_msg FROM gfe_file WHERE gfe01=l_imgg10[li_i]                                                       
             IF STATUS THEN LET g_msg = l_imgg10[li_i] END IF
             CALL cl_set_comp_att_text(l_msg,g_msg CLIPPED)
          ELSE                                                                                                                      
             CALL cl_set_comp_visible(l_msg,FALSE)                                                                                  
          END IF                                                                                                                    
      END FOR                                                                                                                       
     #LET ls_sql = "SELECT UNIQUE 'N',img02,img03,img04,'','','',img23",        #FUN-B50087 
      LET ls_sql = "SELECT UNIQUE 'N',img02,img03,img04,'','','',img23,img18",  #FUN-B50087                                                    
                  "  FROM  img_file",                                                                                               
                  " WHERE ",ms_cons_where                                                                                           
      LET ls_sql1= " ORDER BY img02,img03"   #No.MOD-A70195                                                                                         
     
   ELSE
#No.CHI-960097 --End
 
   #  LET ls_sql = "SELECT 'N',img02,img03,img04,img09,img10,img27",         #FUN-B50087
   #  LET ls_sql = "SELECT 'N',img02,img03,img04,img09,img10,img27,img18",   #FUN-B50087  #MOD-C40065 mark
      LET ls_sql = "SELECT 'N',img02,img03,img04,img09,img10,img27,img23,img18",          #MOD-C40065 add
                   " FROM img_file",
                   " WHERE ",ms_cons_where
      LET ls_sql1= " ORDER BY img27,img02,img03"       #No.CHI-960097 #No.MOD-A70195
   END IF                    #No.CHI-960097 
#TQC-D70053--add--star---
     IF g_prog = 'axmt610' THEN
        LET ls_sql = ls_sql CLIPPED," AND img22 != 'I'"
     END IF
#TQC-D70053--add--end---
   
   IF NOT mi_multi_sel THEN
      LET ls_where = " AND img01 ='", ms_img01,"' "
 
      IF ms_kind !='A' THEN
         LET ls_where = ls_where CLIPPED, " AND img22 MATCHES '",ms_kind,"' "
      END IF
 
    #------------No.MOD-660044 modify
      IF g_reconstruct THEN
         IF ms_default1 IS NOT NULL AND ms_default1 <> ' ' THEN
            LET ls_where = ls_where CLIPPED," AND img02='",ms_default1,"' "
         END IF
         
         IF NOT cl_null(ms_default2) THEN
            LET ls_where = ls_where CLIPPED," AND img03='",ms_default2,"' "
         END IF
      END IF
    #------------No.MOD-660044 modify
 
   END IF
   LET ls_where = ls_where CLIPPED," AND img02<>'ZTC' "   #C2017030201chenyang  add
  # LET ls_where = ls_where CLIPPED," AND img10 > 0  "     #mod by huzhou 2017-08-07 自己过滤下条件

#No.CHI-960097 --Begin                                                                                                              
#  LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED, " ORDER BY img27,img02,img03"  
   LET ls_sql = ls_sql CLIPPED,ls_where CLIPPED,ls_sql1                                                                             
#No.CHI-960097 --End
 
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
 
      #FUN-4C0001 判斷是否已達選取上限  add by hongmf 20041201 
      IF li_i-1 >= g_aza.aza38 THEN
         CALL cl_err_msg(NULL,"lib-217",g_aza.aza38,10)
         EXIT FOREACH
      END IF
 
      LET ma_qry[li_i].* = lr_qry.*
#No.CHI-960097 --Begin                                                                                                              
      #IF g_sma.sma115 = 'Y' THEN   #CHI-9A0007
      IF g_sma.sma115 = 'Y' AND g_ima906 <> '1' THEN   #CHI-9A0007
#        LET ma_qry[l_i].img02 = lr_qry.img02                                                                                       
#        LET ma_qry[l_i].img03 = lr_qry.img03                                                                                       
#        LET ma_qry[l_i].img04 = lr_qry.img04                                                                                       
#        LET ma_qry[l_i].img23 = lr_qry.img23                                                                                       
         FOR l_j = 1 TO l_cnt                                                                                                       
            LET l_val=0                                                                                                             
            SELECT imgg10 INTO l_val FROM imgg_file                                                                                 
             WHERE imgg01 = ms_img01                                                                                                
               AND imgg02 = lr_qry.img02                                                                                            
               AND imgg03 = lr_qry.img03                                                                                            
               AND imgg04 = lr_qry.img04                                                                                            
               AND imgg09 = l_imgg10[l_j]                                                                                           
            IF cl_null(l_val) THEN LET l_val = 0 END IF                                                                             
            CASE l_j                                                                                                                
               WHEN '1'  LET ma_qry[li_i].imgg10_1=l_val                                                                            
               WHEN '2'  LET ma_qry[li_i].imgg10_2=l_val                                                                            
               WHEN '3'  LET ma_qry[li_i].imgg10_3=l_val                                                                            
               WHEN '4'  LET ma_qry[li_i].imgg10_4=l_val                                                                            
               WHEN '5'  LET ma_qry[li_i].imgg10_5=l_val                                                                            
               WHEN '6'  LET ma_qry[li_i].imgg10_6=l_val                                                                            
               WHEN '7'  LET ma_qry[li_i].imgg10_7=l_val
               WHEN '8'  LET ma_qry[li_i].imgg10_8=l_val                                                                            
               WHEN '9'  LET ma_qry[li_i].imgg10_9=l_val                                                                            
               WHEN '10' LET ma_qry[li_i].imgg10_10=l_val                                                                           
            END CASE                                                                                                                
         END FOR                                                                                                                    
      END IF                                                                                                                        
#No.CHI-960097 --End 
      LET li_i = li_i + 1
   END FOREACH
END FUNCTION
 
##################################################
# Description  	: 設定查詢畫面的顯現資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return        : void
# Memo        	:
# Modify        :
##################################################
FUNCTION img4_qry_set_display_data(pi_start_index, pi_end_index)
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: ps_hide_act      STRING    所要隱藏的Action Button
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION img4_qry_input_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
   DEFINE   li_i             LIKE type_file.num5        #No.FUN-880082
 
 
   #INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_img.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE)            #FUN-880082 mark
   INPUT ARRAY ma_qry_tmp WITHOUT DEFAULTS FROM s_img.* ATTRIBUTE(INSERT ROW=FALSE, DELETE ROW=FALSE,APPEND ROW=FALSE, UNBUFFERED) #FUN-880082
      BEFORE INPUT
         CALL cl_set_act_visible("prevpage,nextpage,reconstruct",TRUE)
         IF (ps_hide_act IS NOT NULL) THEN   
            CALL cl_set_act_visible(ps_hide_act, FALSE)
         END IF
      ON ACTION prevpage
         CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL img4_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index - mi_page_count) >= 1) THEN
            LET pi_start_index = pi_start_index - mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION nextpage
         CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
         CALL img4_qry_reset_multi_sel(pi_start_index, pi_end_index)
     
         IF ((pi_start_index + mi_page_count) <= ma_qry.getLength()) THEN
            LET pi_start_index = pi_start_index + mi_page_count
         END IF
     
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION refresh
         CALL img4_qry_refresh()
     
         LET pi_start_index = 1
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION reconstruct
         LET li_reconstruct = TRUE
         LET li_continue = TRUE
     
         EXIT INPUT
      ON ACTION accept
         IF ARR_CURR()>0 THEN        #CHI-9C0048
            CALL GET_FLDBUF(s_img.check) RETURNING ma_qry_tmp[ARR_CURR()].check
            CALL img4_qry_reset_multi_sel(pi_start_index, pi_end_index)
            CALL img4_qry_accept(pi_start_index+ARR_CURR()-1)
         ELSE                        #CHI-9C0048
            LET ms_ret1 = NULL       #CHI-9C0048
            LET ms_ret2 = NULL       #CHI-9C0048
            LET ms_ret3 = NULL       #CHI-9C0048
         END IF                      #CHI-9C0048
         LET li_continue = FALSE
     
         EXIT INPUT
      ON ACTION cancel
         LET INT_FLAG = 0 #No.CHI-690081
         IF NOT mi_multi_sel THEN
            LET ms_ret1 = ms_default1
            LET ms_ret2 = ms_default2
            LET ms_ret3 = ms_default3
         END IF
 
         LET li_continue = FALSE
     
         EXIT INPUT
 
      #No.FUN-660161--begin
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161--end
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
   
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION img4_qry_reset_multi_sel(pi_start_index, pi_end_index)
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
#               : pi_start_index   LIKE type_file.num10    所要顯現的查詢資料起始位置	#No.FUN-680131 INTEGER
#               : pi_end_index     LIKE type_file.num10    所要顯現的查詢資料結束位置	#No.FUN-680131 INTEGER
# Return   	: SMALLINT   是否繼續
#               : SMALLINT   是否重新查詢
#               : INTEGER    改變後的起始位置
# Memo        	:
# Modify   	:
##################################################
FUNCTION img4_qry_display_array(ps_hide_act, pi_start_index, pi_end_index)
   DEFINE   ps_hide_act      STRING,
            pi_start_index   LIKE type_file.num10, 	#No.FUN-680131 INTEGER
            pi_end_index     LIKE type_file.num10 	#No.FUN-680131 INTEGER
   DEFINE   li_continue      LIKE type_file.num5,  	#No.FUN-680131 SMALLINT
            li_reconstruct   LIKE type_file.num5  	#No.FUN-680131 SMALLINT
 
 
   DISPLAY ARRAY ma_qry_tmp TO s_img.*
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
         CALL img4_qry_accept(pi_start_index+ARR_CURR()-1)
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
 
      #No.FUN-660161--begin
      ON ACTION exporttoexcel
         CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(ma_qry),'','')
      #No.FUN-660161--end
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY
   
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
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter     : none
# Return        : void
# Memo          :
# Modify        :
##################################################
FUNCTION img4_qry_refresh()
   DEFINE   li_i   LIKE type_file.num10 	#No.FUN-680131 INTEGER
 
 
   FOR li_i = 1 TO ma_qry.getLength()
      LET ma_qry[li_i].check = 'N'
   END FOR
END FUNCTION
 
##################################################
# Description  	: 選擇並確認資料.
# Date & Author : {%格式為:xxxx/xx/xx by xxx}
# Parameter   	: pi_sel_index   LIKE type_file.num10    所選擇的資料索引	#No.FUN-680131 INTEGER
# Return   	: void
# Memo        	:
# Modify   	:
##################################################
FUNCTION img4_qry_accept(pi_sel_index)
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
               CALL lsb_multi_sel.append(ma_qry[li_i].img02 CLIPPED)
            ELSE
               CALL lsb_multi_sel.append("|" || ma_qry[li_i].img02 CLIPPED)
            END IF
         END IF    
      END FOR
      # 2003/09/16 by Hiko : 複選狀態只會有一組字串回傳值. 
      LET ms_ret1 = lsb_multi_sel.toString()
   ELSE
#MOD-760098-modify
#     LET ms_ret1 = ma_qry[pi_sel_index].img02 CLIPPED
#     LET ms_ret2 = ma_qry[pi_sel_index].img03 CLIPPED
#     LET ms_ret3 = ma_qry[pi_sel_index].img04 CLIPPED
      LET ms_ret1 = ma_qry[pi_sel_index].img02
      LET ms_ret2 = ma_qry[pi_sel_index].img03
      LET ms_ret3 = ma_qry[pi_sel_index].img04
#MOD-760098-modify-end
   END IF
END FUNCTION
