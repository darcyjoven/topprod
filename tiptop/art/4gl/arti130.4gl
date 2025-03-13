# Prog. Version..: '5.30.06-13.03.12(00010)'     #
#
#Pattern name..:"arti130.4gl"
#Descriptions..:采購合同維護作業
#Date & Author..:FUN-870007 08/07/10 By Zhangyajun
# Modify.........: No.FUN-980030 09/08/31 By Hiko 加上GP5.2的相關設定
# Modify.........: No.FUN-960130 09/11/16 By bnlent 合同变更后审核判断移去低版本合同资料
# Modify.........: No.TQC-A10128 10/01/18 By Cockroach 添加g_data_plant管控 
# Modify.........: No.FUN-9B0098 10/02/24 by tommas delete cl_doc
# Modify.........: No.TQC-A30028 10/03/12 By Cockroach add orig/oriu
# Modify.........: No.TQC-A30102 10/05/31 By Cockroach 開啟畫面時候cn2應為空
# Modify.........: No.FUN-A50102 10/07/14 By vealxu 跨庫寫法統一改為用cl_get_target_table()來實現
# Modify.........: No.FUN-A70130 10/08/06 By shaoyong AXM/ATM/ARM/ART/ALM單別調整,統一整合到oay_file,ART單據調整回歸 ART模組
# Modify.........: No.FUN-A70130 10/08/11 By huangtao 修改q_oay*()的參數
# Modify.........: No.FUN-AB0096 10/11/24 By huangtao  rtq06抓取資料改成抓oba_file
# Modify.........: No.TQC-AB0216 10/11/29 By shenyang GP5.2 SOP流程修改
# Modify.........: No.TQC-AC0005 10/12/01 By Carrier 品牌开窗时仅开tqa03='2'的资料
# Modify.........: No.TQC-AC0095 10/12/09 BY shenyang 修改營運中心查詢範圍
# Modify.........: No.MOD-B10196 11/01/25 By huangtao 採購合約進行合約變更時,單身頁籤未顯示己存在資料
# Modify.........: No:FUN-B40041 11/04/26 By shiwuying 合同编号开窗修改
# Modify.........: No:TQC-B50138 11/05/24 By lixia 單身經營品類/經營品牌的控管
# Modify.........: No:FUN-B50171 11/05/31 By shiwuying 週期行不固定費用和返利費用隱藏週期方式1:期初
# Modify.........: No.FUN-B50064 11/06/02 By xianghui BUG修改，刪除時提取資料報400錯誤
# Modify.........: No.FUN-B50026 11/07/05 By zhangll 單號控管改善
# Modify.........: No.FUN-B80123 11/08/19 By yangxf 查詢、錄入改成DIALOG形式
# Modify.........: No.FUN-B90092 11/09/21 By pauline 單身新增開窗時可以多選
# Modify.........: No.FUN-B90094 11/09/22 By pauline 調整合約控卡
# Modify.........: No.TQC-B90176 11/09/26 By pauline　AFTER FIELD控卡錯誤
# Modify.........: No.FUN-BC0010 12/01/16 By pauline 確認營運心時增加項次條件
# Modify.........: No.TQC-C20433 12/02/24 By fanbj 開啟rto06欄位
# Modify.........: No.TQC-C20489 12/02/24 By baogc CTRL+O問題修改
# Modify.........: No.CHI-C30107 12/06/12 By yuhuabao  整批修改將確認的詢問窗口放到chk段的前面
# Modify.........: No.FUN-C90046 12/09/11 By xumeimei 隐藏rto13,rto14栏位
# Modify.........: No.TQC-C60107 12/06/18 By SunLM 新增加營運中心時,自動將採購協議拋轉到新增的營運中心去(與artt131的t131_transfer功能一致)
# Modify.........: No.CHI-C80041 13/02/06 By bart 排除作廢


DATABASE ds
 
GLOBALS "../../config/top.global"
 
DEFINE  g_rto    RECORD LIKE rto_file.*,   #采購合同資料單頭檔
        g_rto_t  RECORD LIKE rto_file.*,
        g_rto_o  RECORD LIKE rto_file.*,
        g_rtp   DYNAMIC ARRAY OF RECORD    #合同生效機構單身檔
                rtp04   LIKE rtp_file.rtp04,
                rtp05   LIKE rtp_file.rtp05,
                rtp05_desc   LIKE azp_file.azp02
                        END RECORD,
        g_rtp_t RECORD
                rtp04   LIKE rtp_file.rtp04,
                rtp05   LIKE rtp_file.rtp05,
                rtp05_desc   LIKE azp_file.azp02
                        END RECORD,
        g_rtp_o RECORD
                rtp04   LIKE rtp_file.rtp04,
                rtp05   LIKE rtp_file.rtp05,
                rtp05_desc   LIKE azp_file.azp02
                        END RECORD,
        g_rtq   DYNAMIC ARRAY OF RECORD    #合同經營類單身檔
                rtq04   LIKE rtq_file.rtq04,
                rtq06   LIKE rtq_file.rtq06,
                rtq06_desc   LIKE tqa_file.tqa02
                        END RECORD,
        g_rtq_t RECORD 
                rtq04   LIKE rtq_file.rtq04,
                rtq06   LIKE rtq_file.rtq06,
                rtq06_desc   LIKE tqa_file.tqa02
                        END RECORD,
        g_rtq_o RECORD 
                rtq04   LIKE rtq_file.rtq04,
                rtq06   LIKE rtq_file.rtq06,
                rtq06_desc   LIKE tqa_file.tqa02
                        END RECORD,
        g_rtq1   DYNAMIC ARRAY OF RECORD 
                rtq04   LIKE rtq_file.rtq04,
                rtq06   LIKE rtq_file.rtq06,
                rtq06_desc   LIKE tqa_file.tqa02
                        END RECORD,
        g_rtq1_t RECORD 
                rtq04   LIKE rtq_file.rtq04,
                rtq06   LIKE rtq_file.rtq06,
                rtq06_desc   LIKE tqa_file.tqa02
                        END RECORD,
        g_rtq1_o RECORD 
                rtq04   LIKE rtq_file.rtq04,
                rtq06   LIKE rtq_file.rtq06,
                rtq06_desc   LIKE tqa_file.tqa02
                        END RECORD,
        g_rtr   DYNAMIC ARRAY OF RECORD       #合同費用單身檔
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc LIKE oaj_file.oaj02,
                rtr07   LIKE rtr_file.rtr07,
                rtr08   LIKE rtr_file.rtr08,
                rtr09   LIKE rtr_file.rtr09,
                rtr10   LIKE rtr_file.rtr10,
                rtr11   LIKE rtr_file.rtr11,
                rtr12   LIKE rtr_file.rtr12,  
                rtr13   LIKE rtr_file.rtr13,
                rtr14   LIKE rtr_file.rtr14,
                rtr15   LIKE rtr_file.rtr15,
                rtr16   LIKE rtr_file.rtr16,
                rtr17   LIKE rtr_file.rtr17,
                rtr18   LIKE rtr_file.rtr18,
                rtr19   LIKE rtr_file.rtr19
                        END RECORD,
        g_rtr1  DYNAMIC ARRAY OF RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc LIKE oaj_file.oaj02,
                rtr07   LIKE rtr_file.rtr07,
                rtr10   LIKE rtr_file.rtr10
                        END RECORD,
        g_rtr1_t RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc LIKE oaj_file.oaj02,
                rtr07   LIKE rtr_file.rtr07,
                rtr10   LIKE rtr_file.rtr10
                        END RECORD,
        g_rtr1_o RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc LIKE oaj_file.oaj02,
                rtr07   LIKE rtr_file.rtr07,
                rtr10   LIKE rtr_file.rtr10
                        END RECORD,
        g_rtr2  DYNAMIC ARRAY OF RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc   LIKE oaj_file.oaj02,
                rtr08   LIKE rtr_file.rtr08,
                rtr09   LIKE rtr_file.rtr09,
                rtr10   LIKE rtr_file.rtr10               
                        END RECORD,
        g_rtr2_t        RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc   LIKE oaj_file.oaj02,
                rtr08   LIKE rtr_file.rtr08,
                rtr09   LIKE rtr_file.rtr09,
                rtr10   LIKE rtr_file.rtr10              
                        END RECORD,  
       g_rtr2_o        RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc   LIKE oaj_file.oaj02,
                rtr08   LIKE rtr_file.rtr08,
                rtr09   LIKE rtr_file.rtr09,
                rtr10   LIKE rtr_file.rtr10              
                        END RECORD,
       g_rtr3   DYNAMIC ARRAY OF RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc   LIKE oaj_file.oaj02,
                rtr08   LIKE rtr_file.rtr08,
                rtr09   LIKE rtr_file.rtr09,
                rtr11   LIKE rtr_file.rtr11,
                rtr12   LIKE rtr_file.rtr12,  
                rtr14   LIKE rtr_file.rtr14,
                rtr15   LIKE rtr_file.rtr15
                        END RECORD, 
        g_rtr3_t        RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc   LIKE oaj_file.oaj02,
                rtr08   LIKE rtr_file.rtr08,
                rtr09   LIKE rtr_file.rtr09,
                rtr11   LIKE rtr_file.rtr11,
                rtr12   LIKE rtr_file.rtr12,  
                rtr14   LIKE rtr_file.rtr14,
                rtr15   LIKE rtr_file.rtr15
                        END RECORD,
        g_rtr3_o        RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc   LIKE oaj_file.oaj02,
                rtr08   LIKE rtr_file.rtr08,
                rtr09   LIKE rtr_file.rtr09,
                rtr11   LIKE rtr_file.rtr11,
                rtr12   LIKE rtr_file.rtr12,  
                rtr14   LIKE rtr_file.rtr14,
                rtr15   LIKE rtr_file.rtr15
                        END RECORD,
        g_rtr4  DYNAMIC ARRAY OF RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc   LIKE oaj_file.oaj02,
                rtr08   LIKE rtr_file.rtr08,
                rtr09   LIKE rtr_file.rtr09,
                rtr11   LIKE rtr_file.rtr11,
                rtr12   LIKE rtr_file.rtr12,  
                rtr13   LIKE rtr_file.rtr13
                        END RECORD,
        g_rtr4_t        RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc   LIKE oaj_file.oaj02,
                rtr08   LIKE rtr_file.rtr08,
                rtr09   LIKE rtr_file.rtr09,
                rtr11   LIKE rtr_file.rtr11,
                rtr12   LIKE rtr_file.rtr12,  
                rtr13   LIKE rtr_file.rtr13
                        END RECORD,
        g_rtr4_o        RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc   LIKE oaj_file.oaj02,
                rtr08   LIKE rtr_file.rtr08,
                rtr09   LIKE rtr_file.rtr09,
                rtr11   LIKE rtr_file.rtr11,
                rtr12   LIKE rtr_file.rtr12,  
                rtr13   LIKE rtr_file.rtr13
                        END RECORD,                
        g_rtr5  DYNAMIC ARRAY OF RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc LIKE oaj_file.oaj02,
                rtr07   LIKE rtr_file.rtr07,
                rtr10   LIKE rtr_file.rtr10
                        END RECORD,
        g_rtr5_t        RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc LIKE oaj_file.oaj02,
                rtr07   LIKE rtr_file.rtr07,
                rtr10   LIKE rtr_file.rtr10
                        END RECORD,
        g_rtr5_o        RECORD
                rtr05   LIKE rtr_file.rtr05,
                rtr06   LIKE rtr_file.rtr06,
                rtr06_desc LIKE oaj_file.oaj02,
                rtr07   LIKE rtr_file.rtr07,
                rtr10   LIKE rtr_file.rtr10
                        END RECORD,
        g_rtr6   DYNAMIC ARRAY OF RECORD
                rtr05   LIKE rtr_file.rtr05,                                           
                rtr18   LIKE rtr_file.rtr18,
                rtr19   LIKE rtr_file.rtr19,
                rtr19_desc LIKE azp_file.azp02,
                rtr10   LIKE rtr_file.rtr10
                        END RECORD,
        g_rtr6_t        RECORD
                rtr05   LIKE rtr_file.rtr05,                                           
                rtr18   LIKE rtr_file.rtr18,
                rtr19   LIKE rtr_file.rtr19,
                rtr19_desc LIKE azp_file.azp02,
                rtr10   LIKE rtr_file.rtr10
                        END RECORD,
        g_rtr6_o        RECORD
                rtr05   LIKE rtr_file.rtr05,                                           
                rtr18   LIKE rtr_file.rtr18,
                rtr19   LIKE rtr_file.rtr19,
                rtr19_desc LIKE azp_file.azp02,
                rtr10   LIKE rtr_file.rtr10
                        END RECORD,
        g_rtr7    RECORD
                rtr06   LIKE rtr_file.rtr06,
                rtr08   LIKE rtr_file.rtr08,
                rtr16   LIKE rtr_file.rtr16,
                rtr17   LIKE rtr_file.rtr17
                  END RECORD,
        g_rtr7_t  RECORD
                rtr06   LIKE rtr_file.rtr06,
                rtr08   LIKE rtr_file.rtr08,
                rtr16   LIKE rtr_file.rtr16,
                rtr17   LIKE rtr_file.rtr17
                  END RECORD,
        g_rtr7_o  RECORD
                rtr06   LIKE rtr_file.rtr06,
                rtr08   LIKE rtr_file.rtr08,
                rtr16   LIKE rtr_file.rtr16,
                rtr17   LIKE rtr_file.rtr17
                  END RECORD
DEFINE  g_sql1  STRING,
        g_sql2  STRING,
        g_sql3  STRING,
        g_sql   STRING,
        g_wc1   STRING,
        g_wc2   STRING,
        g_wc3   STRING,
        g_wc4   STRING,
        g_wc5   STRING,
        g_wc6   STRING,
        g_wc7   STRING,
        g_wc8   STRING,
        g_wc9   STRING,
        g_wc    STRING,
        g_rec_b1 LIKE type_file.num5,
        g_rec_b2 LIKE type_file.num5,
        g_rec_b3 LIKE type_file.num5,
        g_rec_b4 LIKE type_file.num5,
        g_rec_b5 LIKE type_file.num5,
        g_rec_b6 LIKE type_file.num5,
        g_rec_b7 LIKE type_file.num5,
        g_rec_b8 LIKE type_file.num5,
        g_rec_b9 LIKE type_file.num5,     
        l_ac     LIKE type_file.num5
DEFINE  p_row,p_col     LIKE type_file.num5
DEFINE  g_forupd_sql    STRING
DEFINE  g_before_input_done     LIKE type_file.num5
DEFINE  g_chr           LIKE type_file.chr1
DEFINE  g_cnt           LIKE type_file.num10
DEFINE  g_msg           LIKE ze_file.ze03
DEFINE  g_row_count     LIKE type_file.num10
DEFINE  g_curs_index    LIKE type_file.num10
DEFINE  g_jump          LIKE type_file.num10
DEFINE  mi_no_ask       LIKE type_file.num5
DEFINE  l_table         STRING
DEFINE  g_str           STRING
DEFINE  l_allow_insert  LIKE type_file.num5,
        l_allow_delete  LIKE type_file.num5,
        g_change        LIKE type_file.chr1,  #判斷復制還是合同變更
        g_action_flag   STRING                #單身頁簽切換
DEFINE  g_t1            LIKE oay_file.oayslip #自動編號
DEFINE  g_pmc17         LIKE pmc_file.pmc17
DEFINE  g_intflag       LIKE type_file.num5
DEFINE  g_page          LIKE type_file.chr10  #FUN-B90092 add
DEFINE  g_flag1         LIKE type_file.chr1   #FUN-B90094 add 
DEFINE  g_exit_flag     LIKE type_file.chr1   #FUN-B80123 Add By shi

MAIN
 DEFINE cb ui.ComboBox  #FUN-B50171

   OPTIONS                            
      INPUT NO WRAP
      DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("ART")) THEN
      EXIT PROGRAM
   END IF
 
    CALL  cl_used(g_prog,g_time,1) RETURNING g_time   
          
    LET g_forupd_sql="SELECT * FROM rto_file WHERE rto01=? AND rto02=?",
                     "   AND rto03=? AND rtoplant=? FOR UPDATE"
    LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
    DECLARE i130_cl    CURSOR FROM g_forupd_sql
    
    LET p_row = 4 LET p_col = 10
    OPEN WINDOW i130_w AT p_row,p_col WITH FORM "art/42f/arti130"
          ATTRIBUTE (STYLE = g_win_style CLIPPED) 
    #FUN-C90046--------add----str
    CALL cl_set_comp_visible("rto13",FALSE)
    CALL cl_set_comp_visible("rto14",FALSE)
    CALL cl_set_comp_visible("dummy03",FALSE)
    CALL cl_set_comp_visible("dummy05",FALSE)
    #FUN-C90046--------add----end
    CALL cl_ui_init()
   ##FUN-B50171 Begin---
    LET cb = ui.ComboBox.forname("rtr09_2")
    CALL cb.removeitem("1")
    LET cb = ui.ComboBox.forname("rtr09_3")
    CALL cb.removeitem("1")
   #FUN-B50171 End-----
    
    LET g_change='N'
    CALL i130_menu()
    CLOSE WINDOW i130_w                   
    CALL  cl_used(g_prog,g_time,2) RETURNING g_time    
END MAIN
 
FUNCTION i130_bp1(p_ud) #頁簽一
DEFINE   p_ud   LIKE type_file.chr1          
       
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rtp TO s_b1.* ATTRIBUTE(COUNT=g_rec_b1,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
         
      ON ACTION fixup2 
         LET g_action_flag="fixup2"
         EXIT DISPLAY
 
      ON ACTION fixup3 
         LET g_action_flag="fixup3"
         EXIT DISPLAY
 
      ON ACTION fixup4 
         LET g_action_flag="fixup4"
         EXIT DISPLAY
 
      ON ACTION fixup5 
         LET g_action_flag="fixup5"
         EXIT DISPLAY
 
      ON ACTION fixup6 
         LET g_action_flag="fixup6"
         EXIT DISPLAY
 
      ON ACTION fixup7 
         LET g_action_flag="fixup7"
         EXIT DISPLAY
 
      ON ACTION fixup8 
         LET g_action_flag="fixup8"
         EXIT DISPLAY
 
      ON ACTION fixup9 
         LET g_action_flag="fixup9"
         EXIT DISPLAY
     
     ON ACTION confirm  #審核
        LET g_action_choice="confirm"
        EXIT DISPLAY
             
     ON ACTION void  #廢止
         LET g_action_choice="void"
         EXIT DISPLAY   
    
     
         
      ON ACTION chgcontract #合同變更
         LET g_action_choice="chgcontract"
         EXIT DISPLAY
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i130_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i130_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i130_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i130_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL i130_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
        LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
    ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DISPLAY
 
    ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
    ON ACTION cancel
      LET INT_FLAG=FALSE 		
      LET g_action_choice="exit"
      EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i130_bp2(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
       
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rtq TO s_b2.* ATTRIBUTE(COUNT=g_rec_b2,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      
      ON ACTION fixup1 
         LET g_action_flag="fixup1"
         EXIT DISPLAY        
 
      ON ACTION fixup3 
         LET g_action_flag="fixup3"
         EXIT DISPLAY
 
      ON ACTION fixup4 
         LET g_action_flag="fixup4"
         EXIT DISPLAY
 
      ON ACTION fixup5 
         LET g_action_flag="fixup5"
         EXIT DISPLAY
 
      ON ACTION fixup6 
         LET g_action_flag="fixup6"
         EXIT DISPLAY
 
      ON ACTION fixup7 
         LET g_action_flag="fixup7"
         EXIT DISPLAY
 
      ON ACTION fixup8 
         LET g_action_flag="fixup8"
         EXIT DISPLAY
 
      ON ACTION fixup9 
         LET g_action_flag="fixup9"
         EXIT DISPLAY
     
     ON ACTION confirm
        LET g_action_choice="confirm"
        EXIT DISPLAY
        
     ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY   
         EXIT DISPLAY
         
      ON ACTION chgcontract
         LET g_action_choice="chgcontract"
         EXIT DISPLAY
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i130_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i130_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i130_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i130_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL i130_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
        LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
    ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DISPLAY
 
    ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
    ON ACTION cancel
      LET INT_FLAG=FALSE 		
      LET g_action_choice="exit"
      EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i130_bp3(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
       
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rtq1 TO s_b3.* ATTRIBUTE(COUNT=g_rec_b3,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      
      ON ACTION fixup1 
         LET g_action_flag="fixup1"
         EXIT DISPLAY
         
      ON ACTION fixup2 
         LET g_action_flag="fixup2"
         EXIT DISPLAY
 
      ON ACTION fixup4 
         LET g_action_flag="fixup4"
         EXIT DISPLAY
 
      ON ACTION fixup5 
         LET g_action_flag="fixup5"
         EXIT DISPLAY
 
      ON ACTION fixup6 
         LET g_action_flag="fixup6"
         EXIT DISPLAY
 
      ON ACTION fixup7 
         LET g_action_flag="fixup7"
         EXIT DISPLAY
 
      ON ACTION fixup8 
         LET g_action_flag="fixup8"
         EXIT DISPLAY
 
      ON ACTION fixup9 
         LET g_action_flag="fixup9"
         EXIT DISPLAY
     
     ON ACTION confirm
        LET g_action_choice="confirm"
        EXIT DISPLAY
            
     ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY   
 

      ON ACTION chgcontract
         LET g_action_choice="chgcontract"
         EXIT DISPLAY
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i130_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i130_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i130_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i130_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL i130_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
        LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
    ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DISPLAY
 
    ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
    ON ACTION cancel
      LET INT_FLAG=FALSE 		
      LET g_action_choice="exit"
      EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i130_bp4(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
       
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rtr1 TO s_b4.* ATTRIBUTE(COUNT=g_rec_b4,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      
      ON ACTION fixup1 
         LET g_action_flag="fixup1"
         EXIT DISPLAY
         
      ON ACTION fixup2 
         LET g_action_flag="fixup2"
         EXIT DISPLAY
 
      ON ACTION fixup3 
         LET g_action_flag="fixup3"
         EXIT DISPLAY
         
      ON ACTION fixup5 
         LET g_action_flag="fixup5"
         EXIT DISPLAY
 
      ON ACTION fixup6 
         LET g_action_flag="fixup6"
         EXIT DISPLAY
 
      ON ACTION fixup7 
         LET g_action_flag="fixup7"
         EXIT DISPLAY
 
      ON ACTION fixup8 
         LET g_action_flag="fixup8"
         EXIT DISPLAY
 
      ON ACTION fixup9 
         LET g_action_flag="fixup9"
         EXIT DISPLAY
     
     ON ACTION confirm
        LET g_action_choice="confirm"
        EXIT DISPLAY
           
     ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY   
         
      ON ACTION chgcontract
         LET g_action_choice="chgcontract"
         EXIT DISPLAY
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i130_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i130_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i130_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i130_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL i130_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
        LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
    ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DISPLAY
 
    ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
    ON ACTION cancel
      LET INT_FLAG=FALSE 		
      LET g_action_choice="exit"
      EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO") 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i130_bp5(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
       
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rtr2 TO s_b5.* ATTRIBUTE(COUNT=g_rec_b5,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      
      ON ACTION fixup1 
         LET g_action_flag="fixup1"
         EXIT DISPLAY
         
      ON ACTION fixup2 
         LET g_action_flag="fixup2"
         EXIT DISPLAY
 
      ON ACTION fixup3 
         LET g_action_flag="fixup3"
         EXIT DISPLAY
 
      ON ACTION fixup4 
         LET g_action_flag="fixup4"
         EXIT DISPLAY
 
      ON ACTION fixup6 
         LET g_action_flag="fixup6"
         EXIT DISPLAY
 
      ON ACTION fixup7 
         LET g_action_flag="fixup7"
         EXIT DISPLAY
 
      ON ACTION fixup8 
         LET g_action_flag="fixup8"
         EXIT DISPLAY
 
      ON ACTION fixup9 
         LET g_action_flag="fixup9"
         EXIT DISPLAY
     
     ON ACTION confirm
        LET g_action_choice="confirm"
        EXIT DISPLAY
        
     ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY   

         
      ON ACTION chgcontract
         LET g_action_choice="chgcontract"
         EXIT DISPLAY
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i130_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i130_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i130_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i130_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL i130_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
        LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
    ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DISPLAY
 
    ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
    ON ACTION cancel
      LET INT_FLAG=FALSE 		
      LET g_action_choice="exit"
      EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO") 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i130_bp6(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
       
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rtr3 TO s_b6.* ATTRIBUTE(COUNT=g_rec_b6,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      
      ON ACTION fixup1 
         LET g_action_flag="fixup1"
         EXIT DISPLAY
         
      ON ACTION fixup2 
         LET g_action_flag="fixup2"
         EXIT DISPLAY
 
      ON ACTION fixup3 
         LET g_action_flag="fixup3"
         EXIT DISPLAY
 
      ON ACTION fixup4 
         LET g_action_flag="fixup4"
         EXIT DISPLAY
 
      ON ACTION fixup5 
         LET g_action_flag="fixup5"
         EXIT DISPLAY
 
      ON ACTION fixup7 
         LET g_action_flag="fixup7"
         EXIT DISPLAY
 
      ON ACTION fixup8 
         LET g_action_flag="fixup8"
         EXIT DISPLAY
 
      ON ACTION fixup9 
         LET g_action_flag="fixup9"
         EXIT DISPLAY
     
     ON ACTION confirm
        LET g_action_choice="confirm"
        EXIT DISPLAY
        
     ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY   
         
      ON ACTION chgcontract
         LET g_action_choice="chgcontract"
         EXIT DISPLAY
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i130_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i130_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i130_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i130_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL i130_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
        LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
    ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DISPLAY
 
    ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
    ON ACTION cancel
      LET INT_FLAG=FALSE 		
      LET g_action_choice="exit"
      EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i130_bp7(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
       
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rtr4 TO s_b7.* ATTRIBUTE(COUNT=g_rec_b7,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      
      ON ACTION fixup1 
         LET g_action_flag="fixup1"
         EXIT DISPLAY
         
      ON ACTION fixup2 
         LET g_action_flag="fixup2"
         EXIT DISPLAY
 
      ON ACTION fixup3 
         LET g_action_flag="fixup3"
         EXIT DISPLAY
 
      ON ACTION fixup4 
         LET g_action_flag="fixup4"
         EXIT DISPLAY
 
      ON ACTION fixup5 
         LET g_action_flag="fixup5"
         EXIT DISPLAY
 
      ON ACTION fixup6 
         LET g_action_flag="fixup6"
         EXIT DISPLAY
         
      ON ACTION fixup8 
         LET g_action_flag="fixup8"
         EXIT DISPLAY
 
      ON ACTION fixup9 
         LET g_action_flag="fixup9"
         EXIT DISPLAY
     
     ON ACTION confirm
        LET g_action_choice="confirm"
        EXIT DISPLAY
        
     ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY   
         
      ON ACTION chgcontract
         LET g_action_choice="chgcontract"
         EXIT DISPLAY
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i130_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i130_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i130_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i130_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL i130_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
        LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
    ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DISPLAY
 
    ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
    ON ACTION cancel
      LET INT_FLAG=FALSE 		
      LET g_action_choice="exit"
      EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO") 
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY 
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i130_bp8(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
       
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rtr5 TO s_b8.* ATTRIBUTE(COUNT=g_rec_b8,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      
      ON ACTION fixup1 
         LET g_action_flag="fixup1"
         EXIT DISPLAY
         
      ON ACTION fixup2 
         LET g_action_flag="fixup2"
         EXIT DISPLAY
 
      ON ACTION fixup3 
         LET g_action_flag="fixup3"
         EXIT DISPLAY
 
      ON ACTION fixup4 
         LET g_action_flag="fixup4"
         EXIT DISPLAY
 
      ON ACTION fixup5 
         LET g_action_flag="fixup5"
         EXIT DISPLAY
 
      ON ACTION fixup6 
         LET g_action_flag="fixup6"
         EXIT DISPLAY
 
      ON ACTION fixup7 
         LET g_action_flag="fixup7"
         EXIT DISPLAY
         
      ON ACTION fixup9 
         LET g_action_flag="fixup9"
         EXIT DISPLAY
     
     ON ACTION confirm
        LET g_action_choice="confirm"
        EXIT DISPLAY
        
     ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY   
         
      ON ACTION chgcontract
         LET g_action_choice="chgcontract"
         EXIT DISPLAY
         
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i130_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i130_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i130_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i130_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL i130_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
        LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
    ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DISPLAY
 
    ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
    ON ACTION cancel
      LET INT_FLAG=FALSE 		
      LET g_action_choice="exit"
      EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY  
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
 
FUNCTION i130_bp9(p_ud)
DEFINE   p_ud   LIKE type_file.chr1          
       
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = ''
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   
   DISPLAY ARRAY g_rtr6 TO s_b9.* ATTRIBUTE(COUNT=g_rec_b9,UNBUFFERED)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)
        
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()                   
      
      ON ACTION fixup1 
         LET g_action_flag="fixup1"
         EXIT DISPLAY
         
      ON ACTION fixup2 
         LET g_action_flag="fixup2"
         EXIT DISPLAY
 
      ON ACTION fixup3 
         LET g_action_flag="fixup3"
         EXIT DISPLAY
 
      ON ACTION fixup4 
         LET g_action_flag="fixup4"
         EXIT DISPLAY
 
      ON ACTION fixup5 
         LET g_action_flag="fixup5"
         EXIT DISPLAY
 
      ON ACTION fixup6 
         LET g_action_flag="fixup6"
         EXIT DISPLAY
 
      ON ACTION fixup7 
         LET g_action_flag="fixup7"
         EXIT DISPLAY
 
      ON ACTION fixup8 
         LET g_action_flag="fixup8"
         EXIT DISPLAY
 
     ON ACTION confirm
        LET g_action_choice="confirm"
        EXIT DISPLAY
        
     ON ACTION void
         LET g_action_choice="void"
         EXIT DISPLAY   
         

      ON ACTION chgcontract
         LET g_action_choice="chgcontract"
         EXIT DISPLAY
         
      ON ACTION bmodify
         LET g_action_choice = "bmodify"
         EXIT DISPLAY
            
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY
      ON ACTION insert
         LET g_action_choice="insert"
         EXIT DISPLAY
      ON ACTION delete
         LET g_action_choice="delete"
         EXIT DISPLAY
      ON ACTION modify
         LET g_action_choice="modify"
         EXIT DISPLAY
      ON ACTION first
         CALL i130_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i130_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DISPLAY 
      ON ACTION jump
         CALL i130_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i130_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DISPLAY 
         END IF
      ON ACTION last
         CALL i130_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DISPLAY 
      ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DISPLAY   
      ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DISPLAY
      ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DISPLAY
      ON ACTION output
        LET g_action_choice="output"
         EXIT DISPLAY
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY
 
      ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()                  
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY
 
    ON ACTION controlg
      LET g_action_choice="controlg"
      EXIT DISPLAY
 
    ON ACTION accept
      LET g_action_choice="detail"
      LET l_ac = ARR_CURR()
      EXIT DISPLAY
 
    ON ACTION cancel
      LET INT_FLAG=FALSE 		
      LET g_action_choice="exit"
      EXIT DISPLAY
 
     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DISPLAY
 
      ON ACTION about         
         CALL cl_about()      
            
#      ON ACTION exporttoexcel
#         LET g_action_choice = 'exporttoexcel'
#         EXIT DISPLAY
      ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
      ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DISPLAY
      AFTER DISPLAY
         CONTINUE DISPLAY
 
  END DISPLAY
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

FUNCTION i130_bp(p_ud)
DEFINE   p_ud   LIKE type_file.chr1
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
   LET g_action_choice = ''
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DIALOG ATTRIBUTES(UNBUFFERED)
   DISPLAY ARRAY g_rtp TO s_b1.* ATTRIBUTE(COUNT=g_rec_b1)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
   END DISPLAY 
   DISPLAY ARRAY g_rtq TO s_b2.* ATTRIBUTE(COUNT=g_rec_b2)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
         
   END DISPLAY 
   DISPLAY ARRAY g_rtq1 TO s_b3.* ATTRIBUTE(COUNT=g_rec_b3)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
   END DISPLAY 
   DISPLAY ARRAY g_rtr1 TO s_b4.* ATTRIBUTE(COUNT=g_rec_b4)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()   
   END DISPLAY 
   DISPLAY ARRAY g_rtr2 TO s_b5.* ATTRIBUTE(COUNT=g_rec_b5)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
   END DISPLAY 
   DISPLAY ARRAY g_rtr3 TO s_b6.* ATTRIBUTE(COUNT=g_rec_b6)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
   END DISPLAY
   DISPLAY ARRAY g_rtr4 TO s_b7.* ATTRIBUTE(COUNT=g_rec_b7)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
   END DISPLAY 
   DISPLAY ARRAY g_rtr5 TO s_b8.* ATTRIBUTE(COUNT=g_rec_b8)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
   END DISPLAY 
   DISPLAY ARRAY g_rtr6 TO s_b9.* ATTRIBUTE(COUNT=g_rec_b9)
      BEFORE DISPLAY
        CALL cl_navigator_setting(g_curs_index,g_row_count)

      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()
   END DISPLAY       
   
     ON ACTION confirm  #審核
        LET g_action_choice="confirm"
        EXIT DIALOG

     ON ACTION void  #廢止
         LET g_action_choice="void"
         EXIT DIALOG


     ON ACTION chgcontract #合同變更
         LET g_action_choice="chgcontract"
         EXIT DIALOG

     ON ACTION query
         LET g_action_choice="query"
         EXIT DIALOG
     ON ACTION insert
         LET g_action_choice="insert"
         EXIT DIALOG
     ON ACTION delete
         LET g_action_choice="delete"
         EXIT DIALOG
     ON ACTION modify
         LET g_action_choice="modify"
         EXIT DIALOG
     ON ACTION first
         CALL i130_fetch('F')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
     ON ACTION previous
         IF g_curs_index>1 THEN
          CALL i130_fetch('P')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
         END IF
         ACCEPT DIALOG
     ON ACTION jump
         CALL i130_fetch('/')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
     ON ACTION next
         IF g_curs_index<g_row_count THEN
          CALL i130_fetch('N')
          CALL cl_navigator_setting(g_curs_index,g_row_count)
          CALL fgl_set_arr_curr(1)
          ACCEPT DIALOG
         END IF
     ON ACTION last
         CALL i130_fetch('L')
         CALL cl_navigator_setting(g_curs_index,g_row_count)
         CALL fgl_set_arr_curr(1)
         ACCEPT DIALOG
     ON ACTION invalid
         LET g_action_choice="invalid"
         EXIT DIALOG
     ON ACTION reproduce
         LET g_action_choice="reproduce"
         EXIT DIALOG
     ON ACTION detail
         LET g_action_choice="detail"
         LET l_ac = 1
         EXIT DIALOG
     ON ACTION output
        LET g_action_choice="output"
         EXIT DIALOG
     ON ACTION help
         LET g_action_choice="help"
         EXIT DIALOG

     ON ACTION locale
         CALL cl_dynamic_locale()
          CALL cl_show_fld_cont()

     ON ACTION exit
         LET g_action_choice="exit"
         EXIT DIALOG

     ON ACTION controlg
        LET g_action_choice="controlg"
        EXIT DIALOG

     ON ACTION ACCEPT
        LET g_action_choice="detail"
        LET l_ac = ARR_CURR()
        EXIT DIALOG

     ON ACTION CANCEL
        LET INT_FLAG=FALSE
        LET g_action_choice="exit"
        EXIT DIALOG

     ON IDLE g_idle_seconds
        CALL cl_on_idle()
        CONTINUE DIALOG

     ON ACTION about
         CALL cl_about()

     ON ACTION controls
           CALL cl_set_head_visible("","AUTO")
     ON ACTION related_document
         LET g_action_choice="related_document"
         EXIT DIALOG 

  END DIALOG 
  CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION 
 
FUNCTION i130_menu()
 
   WHILE TRUE
      IF g_action_choice = "exit"  THEN
         EXIT WHILE
      END IF
      CALL i130_b1_fill(g_wc1)
      CALL i130_b2_fill(g_wc2)
      CALL i130_b3_fill(g_wc3)
      CALL i130_b4_fill(g_wc4,'1')
      CALL i130_b4_fill(g_wc5,'2') 
      CALL i130_b4_fill(g_wc6,'3')
      CALL i130_b4_fill(g_wc7,'4')
      CALL i130_b4_fill(g_wc8,'5')
      CALL i130_b9_show()
      CALL i130_bp("G")
#FUN-B80123-------------STA-------------
#      LET g_action_choice=''
#      CASE
#         WHEN (g_action_flag IS NULL) OR (g_action_flag = "fixup1")
#              CALL i130_b1_fill(g_wc1)
#              CALL i130_bp1("G")
#         WHEN (g_action_flag = "fixup2")
#              CALL i130_b2_fill(g_wc2)
#              CALL i130_bp2("G")
#         WHEN (g_action_flag = "fixup3")
#              CALL i130_b3_fill(g_wc3)
#              CALL i130_bp3("G")
#         WHEN (g_action_flag = "fixup4")
#              CALL i130_b4_fill(g_wc4,'1')
#              CALL i130_bp4("G")
#         WHEN (g_action_flag = "fixup5")
#              CALL i130_b4_fill(g_wc5,'2')
#              CALL i130_bp5("G")
#         WHEN (g_action_flag = "fixup6")
#              CALL i130_b4_fill(g_wc6,'3')
#              CALL i130_bp6("G")
#         WHEN (g_action_flag = "fixup7")
#              CALL i130_b4_fill(g_wc7,'4')
#              CALL i130_bp7("G")
#         WHEN (g_action_flag = "fixup8")
#              CALL i130_b4_fill(g_wc8,'5')
#              CALL i130_bp8("G")
#         WHEN (g_action_flag = "fixup9")
#              CALL i130_b9_show()
#              CALL i130_bp9("G")
#        END CASE
#FUN-B80123-------------END-------------
      CASE g_action_choice
         WHEN "confirm"   #審核
            IF cl_chk_act_auth() THEN
                  CALL i130_y()
            END IF 
 
         WHEN "void"      #廢止
            IF cl_chk_act_auth() THEN
                  CALL i130_v()
            END IF 
    

         WHEN "chgcontract" #合同變更
            IF cl_chk_act_auth() THEN
                  LET g_change = 'Y'               
                  CALL i130_copy()
            END IF
         WHEN "bmodify"     #保底費用展開
            IF cl_chk_act_auth() THEN
                  CALL i130_b9_check()
            END IF
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL i130_q()
            END IF
         WHEN "insert"
            IF cl_chk_act_auth() THEN
               CALL i130_a()
            END IF
         WHEN "delete"
            IF cl_chk_act_auth() THEN
                  CALL i130_r()
            END IF
         WHEN "modify"
            IF cl_chk_act_auth() THEN
                  CALL i130_u()
            END IF
         WHEN "invalid"
            IF cl_chk_act_auth() THEN
                  CALL i130_x()
            END IF
         WHEN "reproduce"
            IF cl_chk_act_auth() THEN
                  CALL i130_copy()
            END IF
         WHEN "detail"
            IF cl_chk_act_auth() THEN
               CALL i130_b_all()                   #FUN-B80123 
#FUN-B80123-------------STA-------------
#               CASE
#                 WHEN (g_action_flag IS NULL) OR (g_action_flag = "fixup1")
#                       CALL i130_b('1')
#                 WHEN (g_action_flag = "fixup2")
#                       CALL i130_b('2')
#                 WHEN (g_action_flag = "fixup3")
#                       CALL i130_b('3')
#                 WHEN (g_action_flag = "fixup4")
#                       CALL i130_b('4')
#                 WHEN (g_action_flag = "fixup5")
#                       CALL i130_b('5')
#                 WHEN (g_action_flag = "fixup6")
#                       CALL i130_b('6')
#                 WHEN (g_action_flag = "fixup7")
#                       CALL i130_b('7')
#                 WHEN (g_action_flag = "fixup8")
#                       CALL i130_b('8')
#                 WHEN (g_action_flag = "fixup9")
#                       CALL i130_b('9')
#               END CASE
#FUN-B80123-------------END-------------
               CALL i130_delall()
            ELSE
               LET g_action_choice = NULL
            END IF
#         WHEN "output"
#            IF cl_chk_act_auth() THEN
#               CALL i130_out()
#            END IF
         WHEN "help"
            CALL cl_show_help()
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
         WHEN "related_document"   
           IF cl_chk_act_auth() THEN
              IF NOT cl_null(g_rto.rto01) THEN
                 LET g_doc.column1 = "rto01"
                 LET g_doc.column2 = "rto02"
                 LET g_doc.column3 = "rto03"
                 LET g_doc.value1 = g_rto.rto01
                 LET g_doc.value2 = g_rto.rto02
                 LET g_doc.value3 = g_rto.rto03
                 CALL cl_doc()
              END IF
           END IF                
      END CASE
   END WHILE
END FUNCTION
#FUN-B80123-----------STA-----------
FUNCTION i130_b_all() 
DEFINE  l_ac_t  LIKE type_file.num5,
        l_n     LIKE type_file.num5,
        l_cnt   LIKE type_file.num5,
        l_lock_sw       LIKE type_file.chr1,
        p_cmd   LIKE type_file.chr1
#FUN-B90092 add START---------------------------
DEFINE tok         base.StringTokenizer
DEFINE l_plant     LIKE azp_file.azp01
DEFINE l_flag      LIKE type_file.chr1
DEFINE l_i         LIKE type_file.num5
DEFINE l_ima131    LIKE ima_file.ima131 
DEFINE l_rtq06_1   LIKE rtq_file.rtq06 
DEFINE l_rtr06     LIKE rtr_file.rtr06
DEFINE l_rtr06_1   LIKE rtr_file.rtr06
DEFINE l_rtr06_2   LIKE rtr_file.rtr06 
DEFINE l_rtr06_3   LIKE rtr_file.rtr06
DEFINE l_rtr06_4   LIKE rtr_file.rtr06
#FUN-B90092 add END-----------------------------
        LET g_action_choice=""
        IF s_shut(0) THEN
           RETURN
        END IF

        IF cl_null(g_rto.rto01) THEN
           RETURN
        END IF

        SELECT * INTO g_rto.* FROM rto_file
         WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
           AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant

        IF g_rto.rtoacti='N' THEN
           CALL cl_err(g_rto.rto01,'mfg1000',0)
           RETURN
        END IF

       IF g_rto.rtoconf <>'N' THEN
          CALL cl_err('',9022,0)
          RETURN
       END IF




       LET g_sql2 =  " FROM rtr_file",
                     " WHERE rtr01=? AND rtr02=? ",
                     "   AND rtr03=? AND rtrplant=?",
                     "   AND rtr05=?"


       LET g_forupd_sql="SELECT  rtp04,rtp05,''",
                        " FROM rtp_file",
                        " WHERE rtp01=? AND rtp02=? ",
                        "   AND rtp03=? AND rtpplant=?",
                        "   AND rtp04=? FOR UPDATE "
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE i130_bcl1 CURSOR FROM g_forupd_sql
       LET g_forupd_sql="SELECT  rtq04,rtq06,''",
                        " FROM rtq_file",
                        " WHERE rtq01=? AND rtq02=? ",
                        "   AND rtq03=? AND rtqplant=?",
                        "   AND rtq04=? AND rtq05='1' FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE i130_bcl2 CURSOR FROM g_forupd_sql                        

       LET g_forupd_sql="SELECT  rtq04,rtq06,''",
                        " FROM rtq_file",
                        " WHERE rtq01=? AND rtq02=? ",
                        "   AND rtq03=? AND rtqplant=?",
                        " AND rtq04=? AND rtq05='2' FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE i130_bcl3 CURSOR FROM g_forupd_sql
       
       LET g_forupd_sql="SELECT  rtr05,rtr06,'',rtr07,rtr10",g_sql2 CLIPPED,
                        " AND rtr04='1' FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE i130_bcl4 CURSOR FROM g_forupd_sql
       
       LET g_forupd_sql="SELECT  rtr05,rtr06,'',rtr08,rtr09,rtr10",g_sql2 CLIPPED,
                        " AND rtr04='2' FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE i130_bcl5 CURSOR FROM g_forupd_sql
       LET g_forupd_sql="SELECT  rtr05,rtr06,'',rtr08,rtr09,rtr11,rtr12,rtr14,rtr15",g_sql2 CLIPPED,
                        " AND rtr04='3' FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE i130_bcl6 CURSOR FROM g_forupd_sql
       LET g_forupd_sql="SELECT  rtr05,rtr06,'',rtr08,rtr09,rtr11,rtr12,rtr13",g_sql2 CLIPPED,
                        " AND rtr04='4' FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE i130_bcl7 CURSOR FROM g_forupd_sql
       LET g_forupd_sql="SELECT  rtr05,rtr06,'',rtr07,rtr10",g_sql2 CLIPPED,
                        " AND rtr04='5' FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE i130_bcl8 CURSOR FROM g_forupd_sql                              
       LET g_forupd_sql="SELECT  rtr05,rtr18,rtr19,'',rtr10",g_sql2 CLIPPED,
                        " AND rtr04='6' FOR UPDATE"
       LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
       DECLARE i130_bcl9 CURSOR FROM g_forupd_sql        
       LET l_ac_t = 0
       LET l_allow_insert=cl_detail_input_auth("insert")
       LET l_allow_delete=cl_detail_input_auth("delete")
       DIALOG ATTRIBUTES(UNBUFFERED)
       INPUT ARRAY g_rtp FROM s_b1.*
             ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,
                       INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                       APPEND ROW= l_allow_insert)
       BEFORE INPUT
        IF g_rec_b1 !=0 THEN
           CALL fgl_set_arr_curr(l_ac)
        END IF
       BEFORE ROW

        LET p_cmd =''
        LET l_ac =ARR_CURR()
        LET l_lock_sw ='N'
        LET l_n =ARR_COUNT()

                BEGIN WORK
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF

                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err("",SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK
                        RETURN
                END IF
                IF g_rec_b1 >=l_ac THEN
                        LET p_cmd ='u'
                        LET g_rtp_t.*=g_rtp[l_ac].*
                        LET g_rtp_o.*=g_rtp[l_ac].*
                        OPEN i130_bcl1 USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtp_t.rtp04
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl1:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl1 INTO g_rtp[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtp05('d')
                        END IF
                 END IF

       BEFORE INSERT
               #CALL i130_b1_fill(" 1=1")   #TQC-B90176 add #TQC-C20489 Mark
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtp[l_ac].* TO NULL
                LET g_rtp_t.*=g_rtp[l_ac].*
                LET g_rtp_o.*=g_rtp[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtp04
#FUN-B90092 mark START
      # AFTER INSERT
      #          IF INT_FLAG THEN
      #                  CALL cl_err('',9001,0)
      #                  LET INT_FLAG=0
      #                  CANCEL INSERT
      #          END IF
      #          IF NOT cl_null(g_rtp[l_ac].rtp05) THEN
      #          INSERT INTO rtp_file(rtp01,rtp02,rtp03,rtp04,rtp05,rtpplant,rtplegal)
      #               VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,
      #                      g_rtp[l_ac].rtp04,g_rtp[l_ac].rtp05,
      #                      g_rto.rtoplant,g_rto.rtolegal)
      #          IF SQLCA.sqlcode THEN
      #          CALL cl_err3("ins","rtp_file",'','',SQLCA.sqlcode,"","",1)
      #                  CANCEL INSERT
      #          ELSE
      #                  MESSAGE 'INSERT Ok'
      #                  COMMIT WORK
      #                  LET g_rec_b1=g_rec_b1+1
      #                  DISPLAY g_rec_b1 TO FORMONLY.cn2
      #          END IF
      #          END IF
#FUN-B90092 mark END
#TQC-B90176 add START
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtp[l_ac].rtp05) THEN
                   CALL i130_rtp05('a') 
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtp[l_ac].rtp05,g_errno,0)
                      NEXT FIELD rtp05
                   ELSE
                      IF g_page = 's_b1' THEN
                         LET g_page = NULL 
                      ELSE
                         INSERT INTO rtp_file(rtp01,rtp02,rtp03,rtp04,rtp05,rtpplant,rtplegal)
                              VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,
                                     g_rtp[l_ac].rtp04,g_rtp[l_ac].rtp05,
                                     g_rto.rtoplant,g_rto.rtolegal)
                         LET g_rec_b1=g_rec_b1+1 
                      END IF
                   END IF
                   IF SQLCA.sqlcode THEN
                      LET g_rec_b1=g_rec_b1-1
                      CALL cl_err3("ins","rtp_file",'','',SQLCA.sqlcode,"","",1)
                           CANCEL INSERT
                   ELSE
                           MESSAGE 'INSERT Ok'
                           COMMIT WORK
                           DISPLAY g_rec_b1 TO FORMONLY.cn2
                   END IF
                ELSE
                END IF
#TQC-B90176 START END
      BEFORE FIELD rtp04
        IF cl_null(g_rtp[l_ac].rtp04) OR g_rtp[l_ac].rtp04=0 THEN
            SELECT MAX(rtp04)+1 INTO g_rtp[l_ac].rtp04 FROM rtp_file
                WHERE rtp01=g_rto.rto01 AND rtp02 = g_rto.rto02
                  AND rtp03=g_rto.rto03 AND rtpplant = g_rto.rtoplant
                IF cl_null(g_rtp[l_ac].rtp04) THEN
                        LET g_rtp[l_ac].rtp04=1
                END IF
         END IF
      AFTER FIELD rtp04
        IF NOT cl_null(g_rtp[l_ac].rtp04) THEN
           IF g_rtp[l_ac].rtp04<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtp[l_ac].rtp04=g_rtp_t.rtp04
              NEXT FIELD rtp04
           END IF
           IF p_cmd='a' OR  
              (p_cmd='u' AND g_rtp[l_ac].rtp04!=g_rtp_t.rtp04) THEN 
              SELECT COUNT(*) INTO l_cnt FROM rtp_file
                WHERE rtp01= g_rto.rto01 AND rtp02=g_rto.rto02
                  AND rtp03= g_rto.rto03 AND rtpplant=g_rto.rtoplant
                  AND rtp04= g_rtp[l_ac].rtp04
              IF l_cnt>0 THEN
                  CALL cl_err('',-239,0)
                  LET g_rtp[l_ac].rtp04=g_rtp_t.rtp04
                  NEXT FIELD rtp04
              END IF
             #TQC-C20489 Add Begin ---
              IF NOT cl_null(g_rtp[l_ac].rtp05) THEN
                 LET l_cnt = 0
                 SELECT COUNT(*) INTO l_cnt FROM rtp_file
                   WHERE rtp01= g_rto.rto01 AND rtp02=g_rto.rto02
                     AND rtp03= g_rto.rto03 AND rtpplant=g_rto.rtoplant
                     AND rtp05 = g_rtp[l_ac].rtp05
                     AND rtp04 <> g_rtp[l_ac].rtp04
                 IF l_cnt >0 THEN
                    CALL cl_err('',-239,0)
                    NEXT FIELD rtp05
                 END IF
              END IF
             #TQC-C20489 Add End -----
           END IF
        END IF
       AFTER FIELD rtp05
          IF NOT cl_null(g_rtp[l_ac].rtp05) THEN                                                         
     #        IF (p_cmd='a' AND cl_null(g_page))  OR (p_cmd='u' AND                    #FUN-B90092 add  #TQC-B90176 mark 
     #           g_rtp[l_ac].rtp05!=g_rtp_o.rtp05 )  THEN                              #FUN-B90092 add  #TQC-B90176 mark
         #    IF p_cmd='a'   OR (p_cmd='u' AND                                         #FUN-B90092 mark                                  
         #       g_rtp[l_ac].rtp05!=g_rtp_o.rtp05 OR cl_null(g_rtp_o.rtp05))  THEN   #FUN-B90092 mark
             IF p_cmd='a'   OR (p_cmd='u' AND                                        #TQC-B90176 add 
                g_rtp[l_ac].rtp05!=g_rtp_o.rtp05 OR cl_null(g_rtp_o.rtp05))  THEN    #TQC-B90176 add  
                #TQC-B90176 add----------------------
                      SELECT COUNT(*) INTO l_cnt FROM rtp_file
                        WHERE rtp01= g_rto.rto01 AND rtp02=g_rto.rto02
                          AND rtp03= g_rto.rto03 AND rtpplant=g_rto.rtoplant
                          AND rtp05 = g_rtp[l_ac].rtp05 
                          AND rtp04 <> g_rtp[l_ac].rtp04
                 IF l_cnt >0 THEN
                    CALL cl_err('',-239,0)
                    LET g_rtp[l_ac].rtp05=g_rtp_t.rtp05                    
                    NEXT FIELD rtp05 
                 END IF  
                #TQC-B90176 add--------------------
                   CALL i130_rtp05('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtp[l_ac].rtp05,g_errno,0)
                      NEXT FIELD rtp05
                   ELSE
                      CALL i130_chkrtp05() 
                      IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_rtp[l_ac].rtp05,g_errno,0)
                        NEXT FIELD rtp05
                      ELSE
                        LET g_rtp_o.rtp05=g_rtp[l_ac].rtp05
                      END IF
                   END IF
            END IF
         ELSE
           LET g_rtp_o.rtp05=''
           LET g_rtp[l_ac].rtp05_desc=''
           DISPLAY BY NAME g_rtp[l_ac].rtp05_desc
         END IF

       BEFORE DELETE
           IF g_rtp_t.rtp04 > 0 AND (NOT cl_null(g_rtp_t.rtp04)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtp_file
               WHERE rtp01 = g_rto.rto01 AND rtp02 = g_rto.rto02
                 AND rtp03 = g_rto.rto03 AND rtpplant = g_rto.rtoplant
                 AND rtp04 = g_rtp_t.rtp04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtp_file","","",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
              DISPLAY g_rec_b1 TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtp[l_ac].* = g_rtp_t.*
              CLOSE i130_bcl1
              ROLLBACK WORK
              EXIT DIALOG  
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtp[l_ac].* = g_rtp_t.*
           ELSE
            IF cl_null(g_rtp[l_ac].rtp05) THEN
               DELETE FROM rtp_file
               WHERE rtp01 = g_rto.rto01 AND rtp02 = g_rto.rto02
                 AND rtp03 = g_rto.rto03 AND rtpplant=g_rto.rtoplant
                 AND rtp04 = g_rtp_t.rtp04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtp_file","","",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'DELETE Ok'
                 COMMIT WORK
                 CALL g_rtp.deleteelement(l_ac)
                 LET g_rec_b1=g_rec_b1-1
                 DISPLAY g_rec_b1 TO FORMONLY.cn2
              END IF
            ELSE
              UPDATE rtp_file SET rtp04=g_rtp[l_ac].rtp04,
                                  rtp05=g_rtp[l_ac].rtp05
                 WHERE rtp01=g_rto.rto01 AND rtp02=g_rto.rto02
                   AND rtp03=g_rto.rto03 AND rtpplant=g_rto.rtoplant
                   AND rtp04=g_rtp_t.rtp04
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtp_file","","",SQLCA.sqlcode,"","",1)
                 LET g_rtp[l_ac].* = g_rtp_t.*
              ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,
                                      rtodate = g_rto.rtodate
                   WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
                     AND rto03 = g_rto.rto03 AND rtoplant=g_rto.rtoplant

                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
           END IF

        AFTER ROW
           CALL i130_b1_fill(" 1=1")   #TQC-B90176 add
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtp[l_ac].rtp05) THEN
              CALL g_rtp.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtp[l_ac].* = g_rtp_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl1
              ROLLBACK WORK
              CONTINUE DIALOG 
           END IF
           CLOSE i130_bcl1
           COMMIT WORK

        ON ACTION CONTROLO
           IF INFIELD(rtp04) AND l_ac > 1 THEN
              LET g_rtp[l_ac].* = g_rtp[l_ac-1].*
              LET g_rtp[l_ac].rtp04 = g_rec_b1 + 1
              NEXT FIELD rtp04
           END IF
        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp
          CASE
            WHEN INFIELD(rtp05)
#FUN-B90092 mark START------------------------------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_azp"
#               LET g_qryparam.default1 = g_rtp[l_ac].rtp05
#               LET g_qryparam.where = "azp01 IN ",g_auth     #TQC-AC0095
#               CALL cl_create_qry() RETURNING g_rtp[l_ac].rtp05
#               DISPLAY BY NAME g_rtp[l_ac].rtp05
#               CALL i130_rtp05('d')
#               NEXT FIELD rtp05
#FUN-B90092 mark END--------------------------------------
#FUN-B90092 add START-------------------------------------
               CALL cl_init_qry_var()
              # LET l_ac = l_ac    #TQC-B90176 mark
               SELECT MAX(rtp04) INTO l_i FROM rtp_file WHERE rtp01 = g_rto.rto01 AND  rtp02 = g_rto.rto02    #TQC-B90176 add
               IF cl_null(l_i) THEN              #TQC-B90176 add
                  LET l_i = 0                    #TQC-B90176 add
               END IF                             #TQC-B90176 add 
               LET l_i = l_i + 1
               LET g_qryparam.form ="q_azp"
               LET g_qryparam.default1 = g_rtp[l_ac].rtp05
               LET g_qryparam.where = "azp01 IN ",g_auth
               IF NOT cl_null(g_rtp[l_ac].rtp05) THEN
                  LET g_qryparam.default1 = g_rtp[l_ac].rtp05
                  CALL cl_create_qry() RETURNING g_rtp[l_ac].rtp05
                  DISPLAY g_rtp[l_ac].rtp05 TO rtp05
               ELSE
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_plant = tok.nextToken()
                       IF cl_null(l_plant) THEN
                          CONTINUE WHILE
                       END IF
                IF p_cmd='a' OR
                   (p_cmd='u' AND g_rtp[l_ac].rtp04!=g_rtp_t.rtp04) THEN
                      SELECT COUNT(*) INTO l_cnt FROM rtp_file
                        WHERE rtp01= g_rto.rto01 AND rtp02=g_rto.rto02
                          AND rtp03= g_rto.rto03 AND rtpplant=g_rto.rtoplant
                          AND rtp05 = l_plant
                       IF l_cnt>0 THEN
                          #CALL cl_err('',-239,0)  #FUN-BC0010 mark
                          #LET g_rtp[l_ac].rtp04=g_rtp_t.rtp04  #FUN-BC0010 mark
                          #NEXT FIELD rtp04  #FUN-BC0010 mark
                           CONTINUE WHILE   #FUN-BC0010 add
                       END IF
                 END IF
                       INSERT INTO rtp_file(rtp01,rtp02,rtp03,rtp04,rtp05,rtpplant,rtplegal)
                          VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,
                     #            l_ac,l_plant ,
                                 l_i,l_plant , 
                                 g_rto.rtoplant,g_rto.rtolegal)
                    #   LET l_ac = l_ac+1
                       LET l_i = l_i+1
                    END WHILE
                   LET l_flag = 'Y'
                   LET g_page = 's_b1'
                   CALL i130_b1_fill(" 1=1")
                   LET g_rtp_t.*=g_rtp[l_ac].*    #TQC-B90176 add
                   LET g_rtp_o.*=g_rtp[l_ac].*    #TQC-B90176 add
               END IF
#FUN-B90092 add END-----------------------------------
            OTHERWISE EXIT CASE
          END CASE
     END INPUT 
        INPUT ARRAY g_rtq FROM s_b2.*
                ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b2 !=0 THEN
                        CALL fgl_set_arr_curr(l_ac)
                END IF
            #  CALL g_rtq.clear()  #FUN-B90092 add
        BEFORE ROW
DISPLAY "BEFORE ROW ", ARR_COUNT()
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()

                BEGIN WORK
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF
                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err("",SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK
                        RETURN
                END IF
                IF g_rec_b2 >=l_ac THEN
                        LET p_cmd ='u'
                        LET g_rtq_t.*=g_rtq[l_ac].*
                        LET g_rtq_o.*=g_rtq[l_ac].*

                        OPEN i130_bcl2 USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtq_t.rtq04
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl2:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl2 INTO g_rtq[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtq06('d')
                        END IF
                 END IF

       BEFORE INSERT
                CALL i130_b2_fill(" 1=1")   #TQC-B90176 add
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtq[l_ac].* TO NULL
                LET g_rtq_t.*=g_rtq[l_ac].*
                LET g_rtq_o.*=g_rtq[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtq04
#FUN-B90092 mark START
    #   AFTER INSERT
    #            IF INT_FLAG THEN
    #                    CALL cl_err('',9001,0)
    #                    LET INT_FLAG=0
    #                    CANCEL INSERT
    #            END IF
    #            IF NOT cl_null(g_rtq[l_ac].rtq06) THEN
    #            INSERT INTO rtq_file(rtq01,rtq02,rtq03,rtq04,rtq05,rtq06,rtqplant,rtqlegal)
    #                 VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rtq[l_ac].rtq04,
    #                        '1',g_rtq[l_ac].rtq06,g_rto.rtoplant,g_rto.rtolegal)
    #            IF SQLCA.sqlcode THEN
    #            CALL cl_err3("ins","rtq_file",'','',SQLCA.sqlcode,"","",1)
    #                    CANCEL INSERT
    #            ELSE
    #                    MESSAGE 'INSERT Ok'
    #                    COMMIT WORK
    #                    LET g_rec_b2=g_rec_b2+1
    #                    DISPLAY g_rec_b2 TO FORMONLY.cn2
    #            END IF
    #            END IF
#FUN-B90092 mark END
#TQC-B90176 add START
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
               #CALL i130_b2_fill(" 1=1")   #TQC-B90176 add  #FUN-BC0010 mark
                IF NOT cl_null(g_rtq[l_ac].rtq06) THEN
                   SELECT COUNT(*) INTO l_cnt FROM rtq_file
                      WHERE rtq01= g_rto.rto01 AND rtq02=g_rto.rto02
                        AND rtq03= g_rto.rto03 AND rtqplant=g_rto.rtoplant
                        AND rtq06= g_rtq[l_ac].rtq06 
                        AND rtq04 <> g_rtq[l_ac].rtq04 AND rtq05='1'
                   IF l_cnt>0 THEN
                      CALL cl_err('',-239,0)
                      LET g_rtq[l_ac].rtq04=g_rtq_t.rtq04
                      NEXT FIELD rtq04
                   ELSE
                      IF g_page = 's_b2' THEN 
                         LET g_page = NULL
                      ELSE 
                         INSERT INTO rtq_file(rtq01,rtq02,rtq03,rtq04,rtq05,rtq06,rtqplant,rtqlegal)
                              VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rtq[l_ac].rtq04,
                                     '1',g_rtq[l_ac].rtq06,g_rto.rtoplant,g_rto.rtolegal)
                         LET g_rec_b2=g_rec_b2+1
                      END IF
                   END IF
                IF SQLCA.sqlcode THEN
                   LET g_rec_b2=g_rec_b2-1
                   CALL cl_err3("ins","rtq_file",'','',SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        DISPLAY g_rec_b2 TO FORMONLY.cn2
                         
                END IF
                END IF
#TQC-B90176 add  END
      BEFORE FIELD rtq04
        IF cl_null(g_rtq[l_ac].rtq04) OR g_rtq[l_ac].rtq04=0 THEN
            SELECT MAX(rtq04)+1 INTO g_rtq[l_ac].rtq04 FROM rtq_file
             WHERE rtq01=g_rto.rto01 AND rtq02 = g_rto.rto02
               AND rtq03=g_rto.rto03 AND rtqplant=g_rto.rtoplant
               AND rtq05='1'
            IF cl_null(g_rtq[l_ac].rtq04) THEN
               LET g_rtq[l_ac].rtq04=1
            END IF
         END IF

      AFTER FIELD rtq04
 #       IF NOT cl_null(g_rtq[l_ac].rtq04) THEN    #FUN-B90092 mark
#        IF NOT cl_null(g_rtq[l_ac].rtq04) AND cl_null(g_page)THEN  #FUN-B90092 add  #TQC-B90176 mark
        IF NOT cl_null(g_rtq[l_ac].rtq04) THEN       #TQC-B90176 add
           IF g_rtq[l_ac].rtq04<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtq[l_ac].rtq04=g_rtq_t.rtq04
              NEXT FIELD rtq04
           END IF
                IF p_cmd='a' OR
                   (p_cmd='u' AND g_rtq[l_ac].rtq04!=g_rtq_t.rtq04) THEN
                      SELECT COUNT(*) INTO l_cnt FROM rtq_file
                        WHERE rtq01= g_rto.rto01 AND rtq02=g_rto.rto02
                          AND rtq03= g_rto.rto03 AND rtqplant=g_rto.rtoplant
                          AND rtq04= g_rtq[l_ac].rtq04 AND rtq05='1'
                       IF l_cnt>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtq[l_ac].rtq04=g_rtq_t.rtq04
                           NEXT FIELD rtq04
                       END IF
                 END IF
         END IF

       AFTER FIELD rtq06
          LET l_ac = ARR_CURR()   #TQC-B90176 add
  #        IF NOT cl_null(g_rtq[l_ac].rtq06) THEN         #FUN-B90092 mark
#          IF NOT cl_null(g_rtq[l_ac].rtq04) AND cl_null(g_page)THEN  #FUN-B90092 add  #TQC-B90176 mark
          IF NOT cl_null(g_rtq[l_ac].rtq06) THEN   #TQC-B90176 add
                IF p_cmd='a' OR (p_cmd='u' AND
                   g_rtq[l_ac].rtq06!=g_rtq_o.rtq06 OR cl_null(g_rtq_o.rtq06)) THEN
                   SELECT COUNT(*) INTO l_cnt FROM rtq_file
                        WHERE rtq01= g_rto.rto01 AND rtq02=g_rto.rto02
                          AND rtq03= g_rto.rto03 AND rtqplant=g_rto.rtoplant
                          AND rtq06= g_rtq[l_ac].rtq06 AND rtq05='1'
                          AND rtq04 <>  g_rtq[l_ac].rtq04             #TQC-B90176 add
                   IF l_cnt>0 THEN
                           CALL cl_err('','art-194',0)
                           LET g_rtq[l_ac].rtq06=g_rtq_t.rtq06
                           NEXT FIELD rtq06
                   ELSE
                   CALL i130_rtq06('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtq[l_ac].rtq06,g_errno,0)
                      LET g_rtq[l_ac].rtq06 = g_rtq_t.rtq06
                      DISPLAY BY NAME g_rtq[l_ac].rtq06
                      NEXT FIELD rtq06
                   ELSE
                      LET g_rtq_o.rtq06=g_rtq[l_ac].rtq06
                   END IF
                   END IF
                 END IF
                #CALL i130_b2_fill(" 1=1")        #TQC-B90176 add  #FUN-BC0010 mark
           ELSE
             LET g_rtq_o.rtq06=''
             LET g_rtq[l_ac].rtq06_desc=''
             DISPLAY BY NAME g_rtq[l_ac].rtq06_desc
           END IF
       BEFORE DELETE
           IF g_rtq_t.rtq04 > 0 AND (NOT cl_null(g_rtq_t.rtq04)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtq_file
               WHERE rtq01 = g_rto.rto01 AND rtq02 = g_rto.rto02
                 AND rtq03 = g_rto.rto03 AND rtqplant = g_rto.rtoplant
                 AND rtq05 = '1' AND rtq04 = g_rtq_t.rtq04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtq_file","","",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtq[l_ac].* = g_rtq_t.*
              CLOSE i130_bcl2
              ROLLBACK WORK
              EXIT DIALOG  
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtq[l_ac].* = g_rtq_t.*
           ELSE
             IF cl_null(g_rtq[l_ac].rtq06) THEN
              DELETE FROM rtq_file
               WHERE rtq01 = g_rto.rto01 AND rtq02 = g_rto.rto02
                 AND rtq03 = g_rto.rto03 AND rtqplant = g_rto.rtoplant
                 AND rtq05 = '1' AND rtq04 = g_rtq_t.rtq04
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtq_file","","",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
              ELSE
                 MESSAGE "DELETE O.K"
                 COMMIT WORK
                 CALL g_rtq.deleteelement(l_ac)
                 LET g_rec_b2=g_rec_b2-1
                 DISPLAY g_rec_b2 TO FORMONLY.cn2
              END IF
             ELSE
              UPDATE rtq_file SET rtq04=g_rtq[l_ac].rtq04,
                                  rtq06=g_rtq[l_ac].rtq06
                 WHERE rtq01=g_rto.rto01 AND rtq02=g_rto.rto02
                   AND rtq03=g_rto.rto03 AND rtqplant=g_rto.rtoplant
                   AND rtq04=g_rtq_t.rtq04 AND rtq05 = '1'
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtq_file","","",SQLCA.sqlcode,"","",1)
                 LET g_rtq[l_ac].* = g_rtq_t.*
              ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,
                                      rtodate = g_rto.rtodate
                      WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
                        AND rto03 = g_rto.rto03 AND rtoplant=g_rto.rtoplant

                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
             END IF
           END IF

        AFTER ROW
          #CALL i130_b2_fill(" 1=1") #TQC-B90176 add  #FUN-BC0010 mark
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtq[l_ac].rtq06) THEN
              CALL g_rtq.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtq[l_ac].* = g_rtq_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl2
              ROLLBACK WORK
              CONTINUE DIALOG 
           END IF
           CLOSE i130_bcl2
           COMMIT WORK

        ON ACTION CONTROLO
           IF INFIELD(rtq04) AND l_ac > 1 THEN
              LET g_rtq[l_ac].* = g_rtq[l_ac-1].*
              LET g_rtq[l_ac].rtq04 = g_rec_b1 + 1
              NEXT FIELD rtq04
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp
          CASE
            WHEN INFIELD(rtq06)
#FUN-B90092 mark START------------------------------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_oba_11"                      
#               LET g_qryparam.default1 = g_rtq[l_ac].rtq06
#               CALL cl_create_qry() RETURNING g_rtq[l_ac].rtq06
#               DISPLAY BY NAME g_rtq[l_ac].rtq06
#               CALL i130_rtq06('d')
#               NEXT FIELD rtq06
#FUN-B90092 mark END--------------------------------------
#FUN-B90092 add START-------------------------------------
               CALL cl_init_qry_var()
              #SELECT MAX(rtq04) INTO l_ac FROM rtq_file WHERE rtq01 = g_rto.rto01 AND rtq05 = '1'  #FUN-BC0010 mark
               SELECT MAX(rtq04) INTO l_i  FROM rtq_file WHERE rtq01 = g_rto.rto01 AND rtq05 = '1'  #FUN-BC0010 add
                                                           AND rtq02 = g_rto.rto02    #TQC-B90176 add
              #IF cl_null(l_ac) THEN   #FUN-BC0010 mark
              #   LET l_ac = 0  #FUN-BC0010 mark
              #END IF           #FUN-BC0010 mark
              #LET l_ac = l_ac + 1  #FUN-BC0010 mark
              #LET l_ac = l_ac  #FUN-BC0010 mark
              #FUN-BC0010 add START
               IF cl_null(l_i) THEN
                  LET l_i = 0
               END IF
               LET l_i = l_i + 1
              #FUN-BC0010 add END
               LET g_qryparam.form ="q_oba_11"
               LET g_qryparam.default1 = g_rtq[l_ac].rtq06
               IF NOT cl_null(g_rtq[l_ac].rtq06) THEN
                  LET g_qryparam.default1 = g_rtq[l_ac].rtq06
                  CALL cl_create_qry() RETURNING g_rtq[l_ac].rtq06
                  DISPLAY g_rtq[l_ac].rtq06 TO rtq06
               ELSE
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_ima131 = tok.nextToken()
                       IF cl_null(l_ima131) THEN
                          CONTINUE WHILE
                       END IF
                IF p_cmd='a' OR
                   (p_cmd='u' AND g_rtq[l_ac].rtq04!=g_rtq_t.rtq04) THEN
                      SELECT COUNT(*) INTO l_cnt FROM rtq_file
                        WHERE rtq01= g_rto.rto01 AND rtq02=g_rto.rto02
                          AND rtq03= g_rto.rto03 AND rtqplant=g_rto.rtoplant
                          AND rtq05='1' AND rtq06 = l_ima131
                       IF l_cnt>0 THEN
                          #CALL cl_err('',-239,0)  #FUN-BC0010 mark
                          #LET g_rtq[l_ac].rtq04=g_rtq_t.rtq04  #FUN-BC0010 mark
                          #NEXT FIELD rtq04  #FUN-BC0010 mark
                           CONTINUE WHILE   #FUN-BC0010 add
                       END IF
                 END IF
                       INSERT INTO rtq_file(rtq01,rtq02,rtq03,rtq04,rtq05,rtq06,rtqplant,rtqlegal)
                            VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,
                                  #l_ac,'1', l_ima131 ,  #FUN-BC0010 mark
                                   l_i, '1', l_ima131 ,   #FUN-BC0010 add
                                   g_rto.rtoplant,g_rto.rtolegal)
                      #LET l_ac = l_ac+1
                       LET l_i = l_i + 1
                    END WHILE
                   LET l_flag = 'Y'
                   LET g_page = 's_b2'
                        COMMIT WORK
                  #      LET g_rec_b2=g_rec_b2+1
                  #      DISPLAY g_rec_b2 TO FORMONLY.cn2
                  #LET l_ac = ARR_CURR()  #FUN-BC0010 mark
                   CALL i130_b2_fill(" 1=1")
                   LET g_rtq_t.*=g_rtq[l_ac].*    #TQC-B90176 add
                   LET g_rtq_o.*=g_rtq[l_ac].*    #TQC-B90176 add
               END IF
#FUN-B90092 add END---------------------------------------
            OTHERWISE EXIT CASE
          END CASE   
        END INPUT 
        INPUT ARRAY g_rtq1 FROM s_b3.*
                ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b3 !=0 THEN
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()

                BEGIN WORK
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF

                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err("",SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK
                        RETURN
                END IF
                IF g_rec_b3>=l_ac THEN
                        LET p_cmd ='u'
                        LET g_rtq1_t.*=g_rtq1[l_ac].*
                        LET g_rtq1_o.*=g_rtq1[l_ac].*
                        OPEN i130_bcl3 USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtq1_t.rtq04
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl3:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl3 INTO g_rtq1[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtq06_1('d')
                        END IF
                 END IF

       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtq1[l_ac].* TO NULL
                LET g_rtq1_t.*=g_rtq1[l_ac].*
                LET g_rtq1_o.*=g_rtq1[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtq04_1

#FUN-B90092 mark START
    #   AFTER INSERT
    #            IF INT_FLAG THEN
    #                    CALL cl_err('',9001,0)
    #                    LET INT_FLAG=0
    #                    CANCEL INSERT
    #            END IF
    #            IF NOT cl_null(g_rtq1[l_ac].rtq06) THEN
    #             INSERT INTO rtq_file(rtq01,rtq02,rtq03,rtq04,rtq05,rtq06,rtqplant,rtqlegal)
    #                 VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,
    #                        g_rtq1[l_ac].rtq04,'2',g_rtq1[l_ac].rtq06,
    #                        g_rto.rtoplant,g_rto.rtolegal)
    #             IF SQLCA.sqlcode THEN
    #               CALL cl_err3("ins","rtq_file",'','',SQLCA.sqlcode,"","",1)
    #               CANCEL INSERT
    #             ELSE
    #                    MESSAGE 'INSERT Ok'
    #                    COMMIT WORK
    #                    LET g_rec_b3=g_rec_b3+1
    #                    DISPLAY g_rec_b3 TO FORMONLY.cn2
    #             END IF
    #            END IF
#FUN-B90092 mark END  
#TQC-B90176 add START
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtq1[l_ac].rtq06) THEN
                   SELECT COUNT(*) INTO l_cnt FROM rtq_file
                      WHERE rtq01= g_rto.rto01 AND rtq02=g_rto.rto02
                        AND rtq03= g_rto.rto03 AND rtqplant=g_rto.rtoplant
                        AND rtq04= g_rtq[l_ac].rtq04 AND rtq05='2'
                    IF g_page = 's_b3' THEN 
                       LET g_page = NULL
                    ELSE
                    IF l_cnt>0 THEN
                       CALL cl_err('',-239,0)
                       LET g_rtq1[l_ac].rtq04=g_rtq1_t.rtq04
                       NEXT FIELD rtq04_1
                    ELSE 
                      INSERT INTO rtq_file(rtq01,rtq02,rtq03,rtq04,rtq05,rtq06,rtqplant,rtqlegal)
                         VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,
                                g_rtq1[l_ac].rtq04,'2',g_rtq1[l_ac].rtq06,
                                g_rto.rtoplant,g_rto.rtolegal)
                      LET g_rec_b3=g_rec_b3+1
                    END IF
                    END IF
                 IF SQLCA.sqlcode THEN
                   LET g_rec_b3=g_rec_b3-1
                   CALL cl_err3("ins","rtq_file",'','',SQLCA.sqlcode,"","",1)
                   CANCEL INSERT
                 ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        DISPLAY g_rec_b3 TO FORMONLY.cn2
                 END IF
                END IF
#TQC-B90176 add END 
     BEFORE FIELD rtq04_1
        IF cl_null(g_rtq1[l_ac].rtq04) OR g_rtq1[l_ac].rtq04=0 THEN
            SELECT max(rtq04)+1 INTO g_rtq1[l_ac].rtq04 FROM rtq_file
             WHERE rtq01=g_rto.rto01 AND rtq02 = g_rto.rto02
               AND rtq03=g_rto.rto03 AND rtqplant=g_rto.rtoplant
               AND rtq05 = '2'
            IF cl_null(g_rtq1[l_ac].rtq04) THEN
               LET g_rtq1[l_ac].rtq04=1
            END IF
         END IF

      AFTER FIELD rtq04_1
        IF NOT cl_null(g_rtq1[l_ac].rtq04) THEN
           IF g_rtq1[l_ac].rtq04<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtq1[l_ac].rtq04=g_rtq1_t.rtq04
              NEXT FIELD rtq04_1
           END IF
   #             IF p_cmd='a' OR    #FUN-B90092 mark 
   #                (p_cmd='u' AND g_rtq1[l_ac].rtq04!=g_rtq1_t.rtq04) THEN    #FUN-B90092 mark 
 #               IF (p_cmd='a' AND cl_null(g_page)) OR (p_cmd='u' AND        #FUN-B90092 add #TQC-B90176 mark
 #                  g_rtq1[l_ac].rtq06!=g_rtq1_o.rtq06 ) THEN                #FUN-B90092 add #TQC-B90176 mark
                IF p_cmd='a' OR                                              #TQC-B90176 add
                   (p_cmd='u' AND g_rtq1[l_ac].rtq04!=g_rtq1_t.rtq04) THEN   #TQC-B90176 add
                      SELECT COUNT(*) INTO l_cnt FROM rtq_file
                        WHERE rtq01= g_rto.rto01 AND rtq02=g_rto.rto02
                          AND rtq03= g_rto.rto03 AND rtqplant=g_rto.rtoplant
                          AND rtq04= g_rtq1[l_ac].rtq04 AND rtq05 = '2'
                       IF l_cnt>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtq1[l_ac].rtq04=g_rtq1_t.rtq04
                           NEXT FIELD rtq04_1
                       END IF
                 END IF
         END IF

       AFTER FIELD rtq06_1
          IF NOT cl_null(g_rtq1[l_ac].rtq06) THEN
    #            IF p_cmd='a' OR (p_cmd='u' AND     #FUN-B90092 mark 
    #               g_rtq1[l_ac].rtq06!=g_rtq1_o.rtq06 OR cl_null(g_rtq1_o.rtq06)) THEN   #FUN-B90092 mark 
#                IF (p_cmd='a' AND cl_null(g_page)) OR (p_cmd='u' AND                      #FUN-B90092 add   #TQC-B90176 mark
#                   g_rtq1[l_ac].rtq06!=g_rtq1_o.rtq06 ) THEN                              #FUN-B90092 add   #TQC-B90176 mark
                IF p_cmd='a'  OR (p_cmd='u' AND                      #TQC-B90176 add
                   g_rtq1[l_ac].rtq06!=g_rtq1_o.rtq06 ) THEN                              #TQC-B90176 add  
                   SELECT COUNT(*) INTO l_cnt FROM rtq_file
                        WHERE rtq01= g_rto.rto01 AND rtq02=g_rto.rto02
                          AND rtq03= g_rto.rto03 AND rtqplant=g_rto.rtoplant
                          AND rtq06= g_rtq1[l_ac].rtq06 AND rtq05 = '2'
                          AND rtq04 <> g_rtq1[l_ac].rtq04              #TQC-B90176 add
                   IF l_cnt>0 THEN
                           CALL cl_err('','art-194',0)
                           LET g_rtq1[l_ac].rtq06=g_rtq1_t.rtq06
                           NEXT FIELD rtq06_1
                   ELSE
                   CALL i130_rtq06_1('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtq1[l_ac].rtq06,g_errno,0)
                      LET g_rtq1[l_ac].rtq06 = g_rtq1_t.rtq06
                      DISPLAY BY NAME g_rtq1[l_ac].rtq06
                      NEXT FIELD rtq06_1
                   ELSE
                      LET g_rtq1_t.rtq06=g_rtq1[l_ac].rtq06
                   END IF
                   END IF
                 END IF
           ELSE
             LET g_rtq1_o.rtq06 = ''
             LET g_rtq1[l_ac].rtq06_desc=''
             DISPLAY BY NAME g_rtq1[l_ac].rtq06_desc
           END IF

       BEFORE DELETE
           IF g_rtq1_t.rtq04 > 0 AND (NOT cl_null(g_rtq1_t.rtq04)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtq_file
               WHERE rtq01 = g_rto.rto01 AND rtq02 = g_rto.rto02
                 AND rtq03 = g_rto.rto03 AND rtqplant = g_rto.rtoplant
                 AND rtq04 = g_rtq1_t.rtq04 AND rtq05 = '2'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtq_file","","",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b3=g_rec_b3-1
              DISPLAY g_rec_b3 TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtq1[l_ac].* = g_rtq1_t.*
              CLOSE i130_bcl3
              ROLLBACK WORK
              EXIT DIALOG  
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtq1[l_ac].* = g_rtq1_t.*
           ELSE
             IF cl_null(g_rtq1[l_ac].rtq06) THEN
                DELETE FROM rtq_file
                 WHERE rtq01 = g_rto.rto01 AND rtq02 = g_rto.rto02
                   AND rtq03 = g_rto.rto03 AND rtqplant = g_rto.rtoplant
                   AND rtq04 = g_rtq1_t.rtq04 AND rtq05 = '2'
                IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtq_file","","",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                ELSE
                  MESSAGE "DELETE O.K"
                  COMMIT WORK
                  CALL g_rtq.deleteelement(l_ac)
                  LET g_rec_b3=g_rec_b3-1
                  DISPLAY g_rec_b3 TO FORMONLY.cn2
                END IF
             ELSE
              UPDATE rtq_file SET rtq04=g_rtq1[l_ac].rtq04,
                                  rtq06=g_rtq1[l_ac].rtq06
                 WHERE rtq01=g_rto.rto01 AND rtq02=g_rto.rto02
                   AND rtq03=g_rto.rto03 AND rtqplant=g_rto.rtoplant
                   AND rtq04=g_rtq1_t.rtq04 AND rtq05 = '2'
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtq_file","","",SQLCA.sqlcode,"","",1)
                 LET g_rtq1[l_ac].* = g_rtq1_t.*
              ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,
                                      rtodate = g_rto.rtodate
                      WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
                        AND rto03 = g_rto.rto03 AND rtoplant=g_rto.rtoplant

                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
             END IF
           END IF

        AFTER ROW
           CALL i130_b3_fill(" 1=1")  #TQC-B90176 add
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtq1[l_ac].rtq06) THEN
              CALL g_rtq1.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtq1[l_ac].* = g_rtq1_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl3
              ROLLBACK WORK
              CONTINUE DIALOG 
           END IF
           CLOSE i130_bcl3
           COMMIT WORK

        ON ACTION CONTROLO
           IF INFIELD(rtq04) AND l_ac > 1 THEN
              LET g_rtq1[l_ac].* = g_rtq1[l_ac-1].*
              LET g_rtq1[l_ac].rtq04 = g_rec_b3 + 1
              NEXT FIELD rtq04
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp
          CASE
            WHEN INFIELD(rtq06_1)
#FUN-B90092 mark START------------------------------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_tqa05"
#               LET g_qryparam.arg1 = '2'
#               LET g_qryparam.default1 = g_rtq1[l_ac].rtq06
#               CALL cl_create_qry() RETURNING g_rtq1[l_ac].rtq06
#               DISPLAY g_rtq1[l_ac].rtq06 TO rtq06_1
#               CALL i130_rtq06_1('d')
#               NEXT FIELD rtq06_1
#FUN-B90092 mark END--------------------------------------
#FUN-B90092 add START-------------------------------
               CALL cl_init_qry_var()
               SELECT MAX(rtq04) INTO l_i FROM rtq_file WHERE rtq01 = g_rto.rto01 AND rtq05 = '2'
                                                          AND rtq02 = g_rto.rto02    #TQC-B90176 add       
               IF cl_null(l_i) THEN
                  LET l_i = 0
               END IF
               LET l_i = l_i + 1
               LET g_qryparam.form ="q_tqa05"
               LET g_qryparam.arg1 = '2'
               LET g_qryparam.default1 = g_rtq1[l_ac].rtq06
               IF NOT cl_null(g_rtq1[l_ac].rtq06) THEN
                  LET g_qryparam.default1 = g_rtq1[l_ac].rtq06
                  CALL cl_create_qry() RETURNING g_rtq1[l_ac].rtq06
                  DISPLAY g_rtq1[l_ac].rtq06 TO rtq06_1
               ELSE
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_rtq06_1 = tok.nextToken()
                       IF cl_null(l_rtq06_1) THEN
                          CONTINUE WHILE
                       END IF
                       SELECT COUNT(*) INTO l_cnt FROM rtq_file
                              WHERE rtq01= g_rto.rto01 AND rtq02=g_rto.rto02
                                    AND rtq03= g_rto.rto03 AND rtqplant=g_rto.rtoplant
                                    AND rtq06= l_rtq06_1 AND rtq05 = '2'
                       IF l_cnt>0 THEN
                          #CALL cl_err('','art-194',0)  #FUN-BC0010 mark
                          #LET g_rtq1[l_ac].rtq06=g_rtq1_t.rtq06  #FUN-BC0010 mark
                          #NEXT FIELD rtq06_1  #FUN-BC0010 mark
                           CONTINUE WHILE       #FUN-BC0010 add  
                       ELSE
                           INSERT INTO rtq_file(rtq01,rtq02,rtq03,rtq04,rtq05,rtq06,rtqplant,rtqlegal)
                               VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,
                                   l_i,'2', l_rtq06_1,
                                   g_rto.rtoplant,g_rto.rtolegal)
                           LET l_i = l_i+1
                       END IF 
                    END WHILE
                   LET l_flag = 'Y'
                   LET g_page = 's_b3'
                        COMMIT WORK
                  #      LET g_rec_b3=g_rec_b3+1
                  #      DISPLAY g_rec_b3 TO FORMONLY.cn2
                   CALL i130_b3_fill(" 1=1")
                   LET g_rtq1_t.*=g_rtq1[l_ac].*    #TQC-B90176 add
                   LET g_rtq1_o.*=g_rtq1[l_ac].*    #TQC-B90176 add
               END IF
#FUN-B90092 add END---------------------------------
            OTHERWISE EXIT CASE
          END CASE
      END INPUT         
        INPUT ARRAY g_rtr1 FROM s_b4.*
                ATTRIBUTE(COUNT=g_rec_b4,MAXCOUNT=g_max_rec,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b4 <> 0 THEN
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()

                BEGIN WORK
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF

                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK
                        RETURN
                END IF
                IF g_rec_b4 >=l_ac THEN
                        LET p_cmd ='u'
                        LET g_rtr1_t.*=g_rtr1[l_ac].*
                        LET g_rtr1_o.*=g_rtr1[l_ac].*
                        OPEN i130_bcl4 USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtr1_t.rtr05
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl4:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl4 INTO g_rtr1[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtr06('d','1')
                        END IF
                 END IF

       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtr1[l_ac].* TO NULL
                LET g_rtr1_t.*=g_rtr1[l_ac].*
                LET g_rtr1_o.*=g_rtr1[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtr05

#FUN-B90092 mark START
#       AFTER INSERT
#                IF INT_FLAG THEN
#                        CALL cl_err('',9001,0)
#                        LET INT_FLAG=0
#                        CANCEL INSERT
#                END IF
#                IF NOT cl_null(g_rtr1[l_ac].rtr06) THEN
#                INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,rtr06,rtr07,rtr10,rtrplant,rtrlegal)
#                     VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'1',
#                            g_rtr1[l_ac].rtr05,g_rtr1[l_ac].rtr06,g_rtr1[l_ac].rtr07,
#                            g_rtr1[l_ac].rtr10,g_rto.rtoplant,g_rto.rtolegal)
#                IF SQLCA.sqlcode THEN
#                CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
#                        CANCEL INSERT
#                ELSE
#                        MESSAGE 'INSERT Ok'
#                        COMMIT WORK
#                        LET g_rec_b4=g_rec_b4+1
#                        DISPLAY g_rec_b4 TO FORMONLY.cn2
#                END IF
#                END IF
#FUN-B90092 mark END 
#TQC-B90176 add START
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtr1[l_ac].rtr06) THEN
                   IF g_page = 's_b4' THEN
                      LET g_page = NULL
                   ELSE
                      INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,rtr06,rtr07,rtr10,rtrplant,rtrlegal)
                           VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'1',
                                  g_rtr1[l_ac].rtr05,g_rtr1[l_ac].rtr06,g_rtr1[l_ac].rtr07,
                                  g_rtr1[l_ac].rtr10,g_rto.rtoplant,g_rto.rtolegal)
                      LET g_rec_b4=g_rec_b4+1
                   END IF
                END IF
                IF SQLCA.sqlcode THEN
                   LET g_rec_b4=g_rec_b4-1  
                   CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
                     CANCEL INSERT
                ELSE
                   UPDATE rtr_file SET rtr05=g_rtr1[l_ac].rtr05,
                                       rtr06=g_rtr1[l_ac].rtr06,
                                       rtr07=g_rtr1[l_ac].rtr07,
                                       rtr10=g_rtr1[l_ac].rtr10
                        WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                          AND rtr03=g_rto.rto03 AND rtrplant = g_rto.rtoplant
                          AND rtr04= '1' AND rtr05 = g_rtr1_t.rtr05
                     MESSAGE 'INSERT Ok'
                     COMMIT WORK
                     DISPLAY g_rec_b4 TO FORMONLY.cn2
                END IF
#TQC-B90176 add END

      BEFORE FIELD rtr05
        IF cl_null(g_rtr1[l_ac].rtr05) OR g_rtr1[l_ac].rtr05=0 THEN
            SELECT MAX(rtr05)+1 INTO g_rtr1[l_ac].rtr05 FROM rtr_file
             WHERE rtr01=g_rto.rto01 AND rtr02 = g_rto.rto02
               AND rtr03=g_rto.rto03 AND rtrplant = g_rto.rtoplant
               AND rtr04 = '1'
            IF cl_null(g_rtr1[l_ac].rtr05) THEN
               LET g_rtr1[l_ac].rtr05=1
            END IF
         END IF

      AFTER FIELD rtr05
        IF NOT cl_null(g_rtr1[l_ac].rtr05) THEN
           IF g_rtr1[l_ac].rtr05<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtr1[l_ac].rtr05=g_rtr1_t.rtr05
              NEXT FIELD rtr05
           END IF
                IF p_cmd='a' OR
                   (p_cmd='u' AND g_rtr1[l_ac].rtr05 <> g_rtr1_t.rtr05) THEN
                      SELECT COUNT(*) INTO l_n FROM rtr_file
                        WHERE rtr01= g_rto.rto01 AND rtr02=g_rto.rto02
                          AND rtr03= g_rto.rto03 AND rtrplant=g_rto.rtoplant
                          AND rtr04 = '1' AND rtr05= g_rtr1[l_ac].rtr05
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtr1[l_ac].rtr05=g_rtr1_t.rtr05
                           NEXT FIELD rtr05
                       END IF
                 END IF
         END IF

       AFTER FIELD rtr06
          IF NOT cl_null(g_rtr1[l_ac].rtr06) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr1[l_ac].rtr06!=g_rtr1_o.rtr06 OR cl_null(g_rtr1_o.rtr06)) THEN
                   CALL i130_rtr06('a','1')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtr1[l_ac].rtr06,g_errno,0)
                      LET g_rtr1[l_ac].rtr06 = g_rtr1_t.rtr06
                      DISPLAY BY NAME g_rtr1[l_ac].rtr06
                      NEXT FIELD rtr06
                   ELSE
                      LET g_rtr1_t.rtr06=g_rtr1[l_ac].rtr06
                      LET g_rtr1_t.rtr10=g_rtr1[l_ac].rtr10   #TQC-B90176 add
                   END IF
                 END IF
           ELSE
             LET g_rtr1_o.rtr06=''
             LET g_rtr1[l_ac].rtr06_desc=''
             DISPLAY BY NAME g_rtr1[l_ac].rtr06_desc
           END IF

       AFTER FIELD rtr07
          IF NOT cl_null(g_rtr1[l_ac].rtr07) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr1[l_ac].rtr07!=g_rtr1_t.rtr07 OR cl_null(g_rtr1_t.rtr07)) THEN
                   IF g_rtr1[l_ac].rtr07 < g_rto.rto08 OR
                      g_rtr1[l_ac].rtr07 > g_rto.rto09 THEN
                      CALL cl_err(g_rtr1[l_ac].rtr07,'art-425',0)
                      LET g_rtr1[l_ac].rtr07 = g_rtr1_t.rtr07
                      DISPLAY BY NAME g_rtr1[l_ac].rtr07
                      NEXT FIELD rtr07
                   END IF
                 END IF
          END IF

       AFTER FIELD rtr10
          IF NOT cl_null(g_rtr1[l_ac].rtr10) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr1[l_ac].rtr10!=g_rtr1_t.rtr10 OR cl_null(g_rtr1_t.rtr10)) THEN
                   IF g_rtr1[l_ac].rtr10 < 0 THEN
                      CALL cl_err(g_rtr1[l_ac].rtr10,'alm-342',0)
                      LET g_rtr1[l_ac].rtr10 = g_rtr1_t.rtr10
                      DISPLAY BY NAME g_rtr1[l_ac].rtr10
                      NEXT FIELD rtr10
                   END IF
                 END IF
          END IF

       BEFORE DELETE
           IF g_rtr1_t.rtr05 > 0 AND (NOT cl_null(g_rtr1_t.rtr05)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtr_file
               WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                 AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                 AND rtr04 = '1' AND rtr05 = g_rtr1_t.rtr05
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b4=g_rec_b4-1
              DISPLAY g_rec_b4 TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtr1[l_ac].* = g_rtr1_t.*
              CLOSE i130_bcl4
              ROLLBACK WORK
              EXIT DIALOG  
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtr1[l_ac].* = g_rtr1_t.*
           ELSE
              IF cl_null(g_rtr1[l_ac].rtr06) THEN
                DELETE FROM rtr_file
                 WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                   AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                   AND rtr04 = '1' AND rtr05 = g_rtr1_t.rtr05
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                ELSE
                  MESSAGE "DELETE O.K"
                  COMMIT WORK
                  CALL g_rtr1.deleteelement(l_ac)
                  LET g_rec_b4=g_rec_b4-1
                  DISPLAY g_rec_b4 TO FORMONLY.cn2
                END IF
              ELSE
              UPDATE rtr_file SET rtr05=g_rtr1[l_ac].rtr05,
                                  rtr06=g_rtr1[l_ac].rtr06,
                                  rtr07=g_rtr1[l_ac].rtr07,
                                  rtr10=g_rtr1[l_ac].rtr10
                 WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                   AND rtr03=g_rto.rto03 AND rtrplant = g_rto.rtoplant
                   AND rtr04= '1' AND rtr05 = g_rtr1_t.rtr05
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1)
                 LET g_rtr1[l_ac].* = g_rtr1_t.*
              ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,rtodate = g_rto.rtodate
                   WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
                     AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant

                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
              END IF
           END IF

        AFTER ROW
           CALL i130_b4_fill(" 1=1",'1')  #TQC-B90176 add
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtr1[l_ac].rtr06) THEN
              CALL g_rtr1.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtr1[l_ac].* = g_rtr1_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl4
              ROLLBACK WORK
              CONTINUE DIALOG 
           END IF
           CLOSE i130_bcl4
           COMMIT WORK

      ON ACTION CONTROLO
           IF INFIELD(rtr05) AND l_ac > 1 THEN
              LET g_rtr1[l_ac].* = g_rtr1[l_ac-1].*
              LET g_rtr1[l_ac].rtr05 = g_rec_b4 + 1
              NEXT FIELD rtq04
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp
          CASE
            WHEN INFIELD(rtr06)
#FUN-B90092 mark START------------------------------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_oaj3"
#               LET g_qryparam.default1 = g_rtr1[l_ac].rtr06
#               CALL cl_create_qry() RETURNING g_rtr1[l_ac].rtr06
#               DISPLAY g_rtr1[l_ac].rtr06 TO rtr06
#               CALL i130_rtr06('d','1')
#               NEXT FIELD rtr06
#FUN-B90092 mark END--------------------------------------
#FUN-B90092 add START-------------------------------
               CALL cl_init_qry_var()
               SELECT MAX(rtr05) INTO l_i FROM rtr_file WHERE rtr01 = g_rto.rto01 AND rtr04 = '1'
                                                          AND rtr02 = g_rto.rto02    #TQC-B90176 add                                       
               IF cl_null(l_i) THEN
                  LET l_i = 0
               END IF
               LET l_i = l_i + 1
               LET g_qryparam.form ="q_oaj3"
               LET g_qryparam.default1 = g_rtr1[l_ac].rtr06
               IF NOT cl_null(g_rtr1[l_ac].rtr06) THEN
                  LET g_qryparam.default1 = g_rtr1[l_ac].rtr06
                  CALL cl_create_qry() RETURNING g_rtr1[l_ac].rtr06
                  DISPLAY g_rtr1[l_ac].rtr06 TO rtr06
               ELSE
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_rtr06 = tok.nextToken()
                       IF cl_null(l_rtr06) THEN
                          CONTINUE WHILE
                       ELSE
                       END IF
                       INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,rtr06,rtrplant,rtrlegal)
                            VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'1',
                                   l_i,l_rtr06 ,
                                   g_rto.rtoplant,g_rto.rtolegal)
                       LET l_i = l_i+1
                    END WHILE

                IF g_rec_b4 >=l_ac THEN
                        LET p_cmd ='u'
                        LET g_rtr1_t.*=g_rtr1[l_ac].*
                        LET g_rtr1_o.*=g_rtr1[l_ac].*
                        OPEN i130_bcl4 USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtr1_t.rtr05
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl4:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl4 INTO g_rtr1[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtr06('d','1')
                        END IF
                 END IF
                   LET l_flag = 'Y'
                   LET g_rtr1_t.*=g_rtr1[l_ac].*   #TQC-B90176 add
                   LET g_rtr1_o.*=g_rtr1[l_ac].*   #TQC-B90176 add
                   LET g_page = 's_b4' #TQC-B90176 add
                   CALL i130_b4_fill(" 1=1",'1')
               END IF
#FUN-B90092 add END---------------------------------
            OTHERWISE EXIT CASE
          END CASE
        END INPUT         
        INPUT ARRAY g_rtr2 FROM s_b5.*
                ATTRIBUTE(COUNT=g_rec_b5,MAXCOUNT=g_max_rec,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b5 !=0 THEN
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()

                BEGIN WORK
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF

                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK
                        RETURN
                END IF
                IF g_rec_b5 >= l_ac THEN
                        LET p_cmd ='u'
                        LET g_rtr2_t.*=g_rtr2[l_ac].*
                        LET g_rtr2_o.*=g_rtr2[l_ac].*
                        OPEN i130_bcl5 USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtr2_t.rtr05
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl5:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl5 INTO g_rtr2[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtr06('d','2')
                        END IF
                 END IF

       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtr2[l_ac].* TO NULL
                LET g_rtr2_t.*=g_rtr2[l_ac].*
                LET g_rtr2_o.*=g_rtr2[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtr05_1
#FUN-B90092 mark START
#       AFTER INSERT
#                IF INT_FLAG THEN
#                        CALL cl_err('',9001,0)
#                        LET INT_FLAG=0
#                        CANCEL INSERT
#                END IF
#                IF NOT cl_null(g_rtr2[l_ac].rtr06) THEN
#                INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,
#                                     rtr06,rtr08,rtr09,rtr10,rtrplant,rtrlegal)
#                     VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'2',
#                            g_rtr2[l_ac].rtr05,g_rtr2[l_ac].rtr06,g_rtr2[l_ac].rtr08,
#                            g_rtr2[l_ac].rtr09,g_rtr2[l_ac].rtr10,g_rto.rtoplant,g_rto.rtolegal)
#                IF SQLCA.sqlcode THEN
#                CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
#                        CANCEL INSERT
#                ELSE
#                        MESSAGE 'INSERT Ok'
#                        COMMIT WORK
#                        LET g_rec_b5=g_rec_b5+1
#                        DISPLAY g_rec_b5 TO FORMONLY.cn2
#                END IF
#                END IF
#FUN-B90092 mark END 
#TQC-B90176 add START
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtr2[l_ac].rtr06) THEN
                   IF g_page = 's_b5' THEN
                      LET g_page = NULL
                   ELSE
                      INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,
                                           rtr06,rtr08,rtr09,rtr10,rtrplant,rtrlegal)
                           VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'2',
                                  g_rtr2[l_ac].rtr05,g_rtr2[l_ac].rtr06,g_rtr2[l_ac].rtr08,
                                  g_rtr2[l_ac].rtr09,g_rtr2[l_ac].rtr10,g_rto.rtoplant,g_rto.rtolegal)
                      LET g_rec_b5=g_rec_b5+1 
                    END IF
                IF SQLCA.sqlcode THEN
                   LET g_rec_b5=g_rec_b5-1  
                   CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                  UPDATE rtr_file SET rtr05 = g_rtr2[l_ac].rtr05,
                                      rtr06 = g_rtr2[l_ac].rtr06,
                                      rtr08 = g_rtr2[l_ac].rtr08,
                                      rtr09 = g_rtr2[l_ac].rtr09,
                                      rtr10 = g_rtr2[l_ac].rtr10
                         WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                           AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                           AND rtr04 = '2' AND rtr05=g_rtr2_t.rtr05
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        DISPLAY g_rec_b5 TO FORMONLY.cn2
                END IF
                END IF
#TQC-B90176 add END
      BEFORE FIELD rtr05_1
        IF cl_null(g_rtr2[l_ac].rtr05) OR g_rtr2[l_ac].rtr05=0 THEN
            SELECT MAX(rtr05)+1 INTO g_rtr2[l_ac].rtr05 FROM rtr_file
             WHERE rtr01=g_rto.rto01 AND rtr02 = g_rto.rto02
               AND rtr03=g_rto.rto03 AND rtrplant = g_rto.rtoplant
               AND rtr04 = '2'
            IF cl_null(g_rtr2[l_ac].rtr05) THEN
               LET g_rtr2[l_ac].rtr05=1
            END IF
         END IF

      AFTER FIELD rtr05_1
        IF NOT cl_null(g_rtr2[l_ac].rtr05) THEN
           IF g_rtr1[l_ac].rtr05<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtr1[l_ac].rtr05=g_rtr1_t.rtr05
              NEXT FIELD rtr05_1
           END IF
                IF p_cmd='a' OR
                   (p_cmd='u' AND g_rtr2[l_ac].rtr05 <> g_rtr2_t.rtr05) THEN
                      SELECT COUNT(*) INTO l_n FROM rtr_file
                        WHERE rtr01= g_rto.rto01 AND rtr02=g_rto.rto02
                          AND rtr03= g_rto.rto03 AND rtrplant=g_rto.rtoplant
                          AND rtr05= g_rtr2[l_ac].rtr05 AND rtr04 = '2'
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtr2[l_ac].rtr05=g_rtr2_t.rtr05
                           NEXT FIELD rtr05_1
                       END IF
                 END IF
         END IF

       AFTER FIELD rtr06_1
          IF NOT cl_null(g_rtr2[l_ac].rtr06) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr2[l_ac].rtr06!=g_rtr2_o.rtr06 OR cl_null(g_rtr2_o.rtr06)) THEN
                   CALL i130_rtr06('a','2')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtr2[l_ac].rtr06,g_errno,0)
                      LET g_rtr2[l_ac].rtr06 = g_rtr2_t.rtr06
                      DISPLAY BY NAME g_rtr2[l_ac].rtr06
                      NEXT FIELD rtr06_1
                   ELSE
                      LET g_rtr2_o.rtr06=g_rtr2[l_ac].rtr06
                   END IF
                 END IF
           ELSE
             LET g_rtr2_o.rtr06=''
             LET g_rtr2[l_ac].rtr06_desc=''
             DISPLAY BY NAME g_rtr2[l_ac].rtr06_desc
           END IF

       AFTER FIELD rtr10_1
          IF NOT cl_null(g_rtr2[l_ac].rtr10) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr2[l_ac].rtr10!=g_rtr2_t.rtr10 OR cl_null(g_rtr2_t.rtr10)) THEN
                   IF g_rtr2[l_ac].rtr10 < 0 THEN
                      CALL cl_err(g_rtr2[l_ac].rtr10,'alm-342',0)
                      LET g_rtr2[l_ac].rtr10 = g_rtr2_t.rtr10
                      DISPLAY BY NAME g_rtr2[l_ac].rtr10
                      NEXT FIELD rtr10_1
                   END IF
                 END IF
          END IF

       BEFORE DELETE
           IF g_rtr2_t.rtr05 > 0 AND (NOT cl_null(g_rtr2_t.rtr05)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtr_file
               WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                 AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                 AND rtr05 = g_rtr2_t.rtr05 AND rtr04 = '2'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b5=g_rec_b5-1
              DISPLAY g_rec_b5 TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtr2[l_ac].* = g_rtr2_t.*
              CLOSE i130_bcl5
              ROLLBACK WORK
              EXIT DIALOG 
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtr2[l_ac].* = g_rtr2_t.*
           ELSE
            IF cl_null(g_rtr2[l_ac].rtr06) THEN
              DELETE FROM rtr_file
               WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                 AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                 AND rtr05 = g_rtr2_t.rtr05 AND rtr04 = '2'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
              ELSE
                 MESSAGE "DELETE O.K"
                 COMMIT WORK
                 CALL g_rtr2.deleteelement(l_ac)
                 LET g_rec_b5=g_rec_b5-1
                 DISPLAY g_rec_b5 TO FORMONLY.cn2
              END IF
            ELSE
              UPDATE rtr_file SET rtr05 = g_rtr2[l_ac].rtr05,
                                  rtr06 = g_rtr2[l_ac].rtr06,
                                  rtr08 = g_rtr2[l_ac].rtr08,
                                  rtr09 = g_rtr2[l_ac].rtr09,
                                  rtr10 = g_rtr2[l_ac].rtr10
               WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                 AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                 AND rtr04 = '2' AND rtr05=g_rtr2_t.rtr05
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1)
                 LET g_rtr2[l_ac].* = g_rtr2_t.*
              ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,
                                      rtodate = g_rto.rtodate
                   WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
                     AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant

                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
             END IF
           END IF

        AFTER ROW
           CALL i130_b4_fill(" 1=1",'2')  #TQC-B90176 add
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtr2[l_ac].rtr06) THEN
              CALL g_rtr2.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtr2[l_ac].* = g_rtr2_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl5
              ROLLBACK WORK
              CONTINUE DIALOG
           END IF
           CLOSE i130_bcl5
           COMMIT WORK

      ON ACTION CONTROLO
           IF INFIELD(rtr05) AND l_ac > 1 THEN
              LET g_rtr2[l_ac].* = g_rtr2[l_ac-1].*
              LET g_rtr2[l_ac].rtr05 = g_rec_b5 + 1
              NEXT FIELD rtr05_1
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp
          CASE
            WHEN INFIELD(rtr06_1)
#FUN-B90092 mark START------------------------------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_oaj3"
#               LET g_qryparam.default1 = g_rtr2[l_ac].rtr06
#               CALL cl_create_qry() RETURNING g_rtr2[l_ac].rtr06
#               DISPLAY g_rtr2[l_ac].rtr06 TO rtr06_1
#               CALL i130_rtr06('d','2')
#               NEXT FIELD rtr06_1
#FUN-B90092 add START-------------------------------
               CALL cl_init_qry_var()
               SELECT MAX(rtr05) INTO l_i FROM rtr_file WHERE rtr01 = g_rto.rto01 AND rtr04 = '2'
                                                          AND rtr02 = g_rto.rto02    #TQC-B90176 add 
               IF cl_null(l_i) THEN
                  LET l_i = 0
               END IF
               LET l_i = l_i + 1
               LET g_qryparam.form ="q_oaj3"
               LET g_qryparam.default1 = g_rtr1[l_ac].rtr06
               IF NOT cl_null(g_rtr2[l_ac].rtr06) THEN
                  LET g_qryparam.default1 = g_rtr1[l_ac].rtr06
                  CALL cl_create_qry() RETURNING g_rtr1[l_ac].rtr06
                  DISPLAY g_rtr1[l_ac].rtr06 TO rtr06_1
               ELSE
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_rtr06_1 = tok.nextToken()
                       IF cl_null(l_rtr06_1) THEN
                          CONTINUE WHILE
                       ELSE
                       END IF
                       INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,rtr06,rtrplant,rtrlegal)
                            VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'2',
                                   l_i,l_rtr06_1,
                                   g_rto.rtoplant,g_rto.rtolegal)
                       LET l_i = l_i+1
                    END WHILE
                   LET l_flag = 'Y'
                   LET g_page = 's_b5'  #TQC-B90176 add
                   LET g_rtr2_t.*=g_rtr2[l_ac].*     #TQC-B90176 add
                   LET g_rtr2_o.*=g_rtr2[l_ac].*     #TQC-B90176 add 
                   CALL i130_b4_fill(" 1=1","2")
               END IF
#FUN-B90092 add END---------------------------------
            OTHERWISE EXIT CASE
          END CASE
     END INPUT         
        INPUT ARRAY g_rtr3 FROM s_b6.*
                ATTRIBUTE(COUNT=g_rec_b6,MAXCOUNT=g_max_rec,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b6 !=0 THEN
                   CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()

                BEGIN WORK
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF

                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK
                        RETURN
                END IF
                IF g_rec_b6 >= l_ac THEN
                        LET p_cmd ='u'
                        LET g_rtr3_t.*=g_rtr3[l_ac].*
                        LET g_rtr3_o.*=g_rtr3[l_ac].*
                        OPEN i130_bcl6 USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtr3_t.rtr05
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl6:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl6 INTO g_rtr3[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtr06('d','3')
                        END IF
                 END IF

       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtr3[l_ac].* TO NULL
                LET g_rtr3_t.*=g_rtr3[l_ac].*
                LET g_rtr3_o.*=g_rtr3[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtr05_2

#FUN-B90092 mark START
#       AFTER INSERT
#                IF INT_FLAG THEN
#                        CALL cl_err('',9001,0)
#                        LET INT_FLAG=0
#                        CANCEL INSERT
#                END IF
#                IF NOT cl_null(g_rtr3[l_ac].rtr06) THEN
#                INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,rtr06,rtr08,
#                                     rtr09,rtr11,rtr12,rtr14,rtr15,rtrplant,rtrlegal)
#                     VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'3',
#                            g_rtr3[l_ac].rtr05,g_rtr3[l_ac].rtr06,g_rtr3[l_ac].rtr08,
#                            g_rtr3[l_ac].rtr09,g_rtr3[l_ac].rtr11,g_rtr3[l_ac].rtr12,
#                            g_rtr3[l_ac].rtr14,g_rtr3[l_ac].rtr15,g_rto.rtoplant,g_rto.rtolegal)
#                IF SQLCA.sqlcode THEN
#                CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
#                        CANCEL INSERT
#                ELSE
#                        MESSAGE 'INSERT Ok'
#                        COMMIT WORK
#                        LET g_rec_b6=g_rec_b6+1
#                        DISPLAY g_rec_b6 TO FORMONLY.cn2
#                END IF
#                END IF
#FUN-B90092 mark END 
#TQC-B90176 add START
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtr3[l_ac].rtr06) THEN
                   IF g_page = 's_b6' THEN
                      LET g_page = NULL
                   ELSE
                     INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,rtr06,rtr08,
                                          rtr09,rtr11,rtr12,rtr14,rtr15,rtrplant,rtrlegal)
                            VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'3',
                                   g_rtr3[l_ac].rtr05,g_rtr3[l_ac].rtr06,g_rtr3[l_ac].rtr08,
                                   g_rtr3[l_ac].rtr09,g_rtr3[l_ac].rtr11,g_rtr3[l_ac].rtr12,
                                   g_rtr3[l_ac].rtr14,g_rtr3[l_ac].rtr15,g_rto.rtoplant,g_rto.rtolegal)
                      LET g_rec_b6=g_rec_b6+1
                   END IF
                IF SQLCA.sqlcode THEN
                   LET g_rec_b6=g_rec_b6-1
                    CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                   UPDATE rtr_file SET rtr05 = g_rtr3[l_ac].rtr05,
                                       rtr06 = g_rtr3[l_ac].rtr06,
                                       rtr08 = g_rtr3[l_ac].rtr08,
                                       rtr09 = g_rtr3[l_ac].rtr09,
                                       rtr11 = g_rtr3[l_ac].rtr11,
                                       rtr12 = g_rtr3[l_ac].rtr12,
                                       rtr14 = g_rtr3[l_ac].rtr14,
                                       rtr15 = g_rtr3[l_ac].rtr15
                       WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                         AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                         AND rtr05=g_rtr3_t.rtr05 AND rtr04 = '3'
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        DISPLAY g_rec_b6 TO FORMONLY.cn2
                END IF
                END IF
#TQC-B90176 add END
      BEFORE FIELD rtr05_2
        IF cl_null(g_rtr3[l_ac].rtr05) OR g_rtr3[l_ac].rtr05=0 THEN
            SELECT MAX(rtr05)+1 INTO g_rtr3[l_ac].rtr05 FROM rtr_file
             WHERE rtr01=g_rto.rto01 AND rtr02 = g_rto.rto02
               AND rtr03=g_rto.rto03 AND rtrplant = g_rto.rtoplant
               AND rtr04 = '3'
            IF cl_null(g_rtr3[l_ac].rtr05) THEN
               LET g_rtr3[l_ac].rtr05=1
            END IF
         END IF

      AFTER FIELD rtr05_2
        IF NOT cl_null(g_rtr3[l_ac].rtr05) THEN
           IF g_rtr3[l_ac].rtr05<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtr3[l_ac].rtr05=g_rtr3_t.rtr05
              NEXT FIELD rtr05_2
           END IF
                IF p_cmd='a' OR
                   (p_cmd='u' AND g_rtr3[l_ac].rtr05 <> g_rtr3_t.rtr05) THEN
                      SELECT COUNT(*) INTO l_n FROM rtr_file
                        WHERE rtr01= g_rto.rto01 AND rtr02=g_rto.rto02
                          AND rtr03= g_rto.rto03 AND rtrplant=g_rto.rtoplant
                          AND rtr05= g_rtr3[l_ac].rtr05 AND rtr04 = '3'
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtr3[l_ac].rtr05 = g_rtr3_t.rtr05
                           NEXT FIELD rtr05_2
                       END IF
                 END IF
         END IF

       AFTER FIELD rtr06_2
          IF NOT cl_null(g_rtr3[l_ac].rtr06) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr3[l_ac].rtr06!=g_rtr2_o.rtr06 OR cl_null(g_rtr3_o.rtr06)) THEN
                   CALL i130_rtr06('a','3')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtr3[l_ac].rtr06,g_errno,0)
                      LET g_rtr3[l_ac].rtr06 = g_rtr3_t.rtr06
                      DISPLAY BY NAME g_rtr3[l_ac].rtr06
                      NEXT FIELD rtr06_2
                   ELSE
                      LET g_rtr3_o.rtr06=g_rtr3[l_ac].rtr06
                   END IF
                 END IF
           ELSE
             LET g_rtr3_o.rtr06=''
             LET g_rtr3[l_ac].rtr06_desc=''
             DISPLAY BY NAME g_rtr3[l_ac].rtr06_desc
           END IF

       AFTER FIELD rtr14_2,rtr15_2
          IF FGL_DIALOG_GETBUFFER()<0 THEN
              CALL cl_err('','alm-342',0)
              NEXT FIELD CURRENT
          END IF
          IF NOT cl_null(g_rtr3[l_ac].rtr14) AND NOT cl_null(g_rtr3[l_ac].rtr15) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                   (g_rtr3[l_ac].rtr14!=g_rtr3_t.rtr14 OR g_rtr3[l_ac].rtr15!=g_rtr3_t.rtr15)) THEN
                   IF g_rtr3[l_ac].rtr14 > g_rtr3[l_ac].rtr15 THEN
                      CALL cl_err('','art-488',0)
                      NEXT FIELD CURRENT
                   END IF
                 END IF
          END IF

       BEFORE DELETE
           IF g_rtr3_t.rtr05 > 0 AND (NOT cl_null(g_rtr3_t.rtr05)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtr_file
               WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                 AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                 AND rtr05 = g_rtr3_t.rtr05 AND rtr04 ='3'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b6=g_rec_b6-1
              DISPLAY g_rec_b6 TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtr3[l_ac].* = g_rtr3_t.*
              CLOSE i130_bcl6
              ROLLBACK WORK
              EXIT DIALOG 
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtr3[l_ac].* = g_rtr3_t.*
           ELSE
             IF cl_null(g_rtr3[l_ac].rtr06) THEN
                DELETE FROM rtr_file
                 WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                   AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                   AND rtr05 = g_rtr3_t.rtr05 AND rtr04 ='3'
                IF SQLCA.sqlcode THEN
                   CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)
                   ROLLBACK WORK
                ELSE
                   MESSAGE "DELETE O.K"
                   COMMIT WORK
                   CALL g_rtr3.deleteelement(l_ac)
                   LET g_rec_b6=g_rec_b6-1
                   DISPLAY g_rec_b6 TO FORMONLY.cn2
                END IF
             ELSE
                UPDATE rtr_file SET rtr05 = g_rtr3[l_ac].rtr05,
                                    rtr06 = g_rtr3[l_ac].rtr06,
                                    rtr08 = g_rtr3[l_ac].rtr08,
                                    rtr09 = g_rtr3[l_ac].rtr09,
                                    rtr11 = g_rtr3[l_ac].rtr11,
                                    rtr12 = g_rtr3[l_ac].rtr12,
                                    rtr14 = g_rtr3[l_ac].rtr14,
                                    rtr15 = g_rtr3[l_ac].rtr15
                 WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                   AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                   AND rtr05=g_rtr3_t.rtr05 AND rtr04 = '3'
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1)
                  LET g_rtr3[l_ac].* = g_rtr3_t.*
               ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,rtodate = g_rto.rtodate
                   WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
                     AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant

                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
               END IF
              END IF
           END IF

        AFTER ROW
           CALL i130_b4_fill(" 1=1",'3')  #TQC-B90176 add
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtr3[l_ac].rtr06) THEN
              CALL g_rtr3.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtr3[l_ac].* = g_rtr3_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl6
              ROLLBACK WORK
              CONTINUE DIALOG 
           END IF
           CLOSE i130_bcl6
           COMMIT WORK

      ON ACTION CONTROLO
           IF INFIELD(rtr05) AND l_ac > 1 THEN
              LET g_rtr3[l_ac].* = g_rtr3[l_ac-1].*
              LET g_rtr3[l_ac].rtr05 = g_rec_b6 + 1
              NEXT FIELD rtr05_2
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp
          CASE
            WHEN INFIELD(rtr06_2)
#FUN-B90092 mark START-----------------------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_oaj3"
#               LET g_qryparam.default1 = g_rtr3[l_ac].rtr06
#               CALL cl_create_qry() RETURNING g_rtr3[l_ac].rtr06
#               DISPLAY g_rtr3[l_ac].rtr06 TO rtr06_2
#               CALL i130_rtr06('d','3')
#               NEXT FIELD rtr06_2
#FUN-B90092 mark END-------------------------------
#FUN-B90092 add START-------------------------------
               CALL cl_init_qry_var()
               SELECT MAX(rtr05) INTO l_i FROM rtr_file WHERE rtr01 = g_rto.rto01 AND rtr04 = '3'
                                                          AND rtr02 = g_rto.rto02    #TQC-B90176 add 
               IF cl_null(l_i) THEN
                  LET l_i = 0
               END IF
               LET l_i = l_i + 1
               LET g_qryparam.form ="q_oaj3"
               LET g_qryparam.default1 = g_rtr1[l_ac].rtr06
               IF NOT cl_null(g_rtr3[l_ac].rtr06) THEN
                  LET g_qryparam.default1 = g_rtr1[l_ac].rtr06
                  CALL cl_create_qry() RETURNING g_rtr1[l_ac].rtr06
                  DISPLAY g_rtr1[l_ac].rtr06 TO rtr06_2
               ELSE
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_rtr06_2 = tok.nextToken()
                       IF cl_null(l_rtr06_2) THEN
                          CONTINUE WHILE
                       ELSE
                       END IF
                       INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,rtr06,rtrplant,rtrlegal)
                            VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'3',
                                   l_i,l_rtr06_2,
                                   g_rto.rtoplant,g_rto.rtolegal)
                       LET l_i = l_i+1
                    END WHILE
                   LET l_flag = 'Y'
                   LET g_rtr3_t.*=g_rtr3[l_ac].*         #TQC-B90176 add
                   LET g_rtr3_o.*=g_rtr3[l_ac].*         #TQC-B90176 add          
                   LET g_page = 's_b6'   #TQC-B90176 add
                   CALL i130_b4_fill(" 1=1","3")
               END IF
#FUN-B90092 add END---------------------------------
            OTHERWISE EXIT CASE
          END CASE 
      END INPUT 
        INPUT ARRAY g_rtr4 FROM s_b7.*
                ATTRIBUTE(COUNT=g_rec_b7,MAXCOUNT=g_max_rec,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b7 !=0 THEN
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()

                BEGIN WORK
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF

                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK
                        RETURN
                END IF
                IF g_rec_b7 >= l_ac THEN
                        LET p_cmd ='u'
                        LET g_rtr4_t.* = g_rtr4[l_ac].*
                        LET g_rtr4_o.* = g_rtr4[l_ac].*
                        OPEN i130_bcl7 USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtr4_t.rtr05
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl7:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl7 INTO g_rtr4[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtr06('d','4')
                        END IF
                 END IF

       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtr4[l_ac].* TO NULL
                LET g_rtr4_t.*=g_rtr4[l_ac].*
                LET g_rtr4_o.*=g_rtr4[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtr05_3
#FUN-B90092 mark START
#       AFTER INSERT
#                IF INT_FLAG THEN
#                        CALL cl_err('',9001,0)
#                        LET INT_FLAG=0
#                        CANCEL INSERT
#                END IF
#                IF NOT cl_null(g_rtr4[l_ac].rtr06) THEN
#                INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,rtr06,
#                                     rtr08,rtr09,rtr11,rtr12,rtr13,rtrplant,rtrlegal)
#                     VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'4',
#                            g_rtr4[l_ac].rtr05,g_rtr4[l_ac].rtr06,g_rtr4[l_ac].rtr08,
#                            g_rtr4[l_ac].rtr09,g_rtr4[l_ac].rtr11,g_rtr4[l_ac].rtr12,
#                            g_rtr4[l_ac].rtr13,g_rto.rtoplant,g_rto.rtolegal)
#                IF SQLCA.sqlcode THEN
#                CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
#                        CANCEL INSERT
#                ELSE
#                        MESSAGE 'INSERT Ok'
#                        COMMIT WORK
#                        LET g_rec_b7 = g_rec_b7+1
#                        DISPLAY g_rec_b7 TO FORMONLY.cn2
#                END IF
#                END IF
#FUN-B90092 mark START
#TQC-B90176 add START
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtr4[l_ac].rtr06) THEN
                   IF g_page = 's_b7' THEN
                      LET g_page = NULL
                   ELSE
                     INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,rtr06,
                                          rtr08,rtr09,rtr11,rtr12,rtr13,rtrplant,rtrlegal)
                         VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'4',
                                g_rtr4[l_ac].rtr05,g_rtr4[l_ac].rtr06,g_rtr4[l_ac].rtr08,
                                g_rtr4[l_ac].rtr09,g_rtr4[l_ac].rtr11,g_rtr4[l_ac].rtr12,
                                g_rtr4[l_ac].rtr13,g_rto.rtoplant,g_rto.rtolegal)
                         LET g_rec_b7 = g_rec_b7+1
                      END IF
                IF SQLCA.sqlcode THEN
                   LET g_rec_b7 = g_rec_b7-1 
                   CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                   UPDATE rtr_file SET rtr05 = g_rtr4[l_ac].rtr05,
                                       rtr06 = g_rtr4[l_ac].rtr06,
                                       rtr08 = g_rtr4[l_ac].rtr08,
                                       rtr09 = g_rtr4[l_ac].rtr09,
                                       rtr11 = g_rtr4[l_ac].rtr11,
                                       rtr12 = g_rtr4[l_ac].rtr12,
                                       rtr13 = g_rtr4[l_ac].rtr13
                            WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                              AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                              AND rtr05=g_rtr4_t.rtr05 AND rtr04 = '4'
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        DISPLAY g_rec_b7 TO FORMONLY.cn2
                END IF
                END IF
#TQC-B90176 add END
      BEFORE FIELD rtr05_3
        IF cl_null(g_rtr4[l_ac].rtr05) OR g_rtr4[l_ac].rtr05=0 THEN
            SELECT MAX(rtr05)+1 INTO g_rtr4[l_ac].rtr05 FROM rtr_file
             WHERE rtr01=g_rto.rto01 AND rtr02 = g_rto.rto02
               AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
               AND rtr04 ='4'
                IF cl_null(g_rtr4[l_ac].rtr05) THEN
                        LET g_rtr4[l_ac].rtr05 = 1
                END IF
         END IF

      AFTER FIELD rtr05_3
        IF NOT cl_null(g_rtr4[l_ac].rtr05) THEN
           IF g_rtr4[l_ac].rtr05<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtr4[l_ac].rtr05=g_rtr4_t.rtr05
              NEXT FIELD rtr05_3
           END IF
                IF p_cmd='a' OR
                   (p_cmd='u' AND g_rtr4[l_ac].rtr05 <> g_rtr4_t.rtr05) THEN
                      SELECT COUNT(*) INTO l_n FROM rtr_file
                        WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                          AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                          AND rtr05 = g_rtr4[l_ac].rtr05 AND rtr04 = '4'
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtr4[l_ac].rtr05=g_rtr4_t.rtr05
                           NEXT FIELD rtr05_3
                       END IF
                 END IF
         END IF

       AFTER FIELD rtr06_3
          IF NOT cl_null(g_rtr4[l_ac].rtr06) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr4[l_ac].rtr06!=g_rtr4_o.rtr06 OR cl_null(g_rtr4_o.rtr06)) THEN
                   CALL i130_rtr06('a','4')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtr4[l_ac].rtr06,g_errno,0)
                      LET g_rtr4[l_ac].rtr06 = g_rtr4_t.rtr06
                      DISPLAY BY NAME g_rtr4[l_ac].rtr06
                      NEXT FIELD rtr06_3
                   ELSE
                      LET g_rtr4_t.rtr06 = g_rtr4[l_ac].rtr06
                   END IF
                 END IF
           ELSE
             LET g_rtr4_o.rtr06 = ''
             LET g_rtr4[l_ac].rtr06_desc=''
             DISPLAY BY NAME g_rtr4[l_ac].rtr06_desc
           END IF

       BEFORE DELETE
           IF g_rtr4_t.rtr05 > 0 AND (NOT cl_null(g_rtr4_t.rtr05)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtr_file
               WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                 AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                 AND rtr05 = g_rtr4_t.rtr05 AND rtr04 = '4'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b7 = g_rec_b7-1
              DISPLAY g_rec_b7 TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtr4[l_ac].* = g_rtr4_t.*
              CLOSE i130_bcl7
              ROLLBACK WORK
              EXIT DIALOG 
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtr4[l_ac].* = g_rtr4_t.*
           ELSE
             IF cl_null(g_rtr4[l_ac].rtr06) THEN
              DELETE FROM rtr_file
               WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                 AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                 AND rtr05 = g_rtr4_t.rtr05 AND rtr04 = '4'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
              ELSE
                 MESSAGE "DELETE O.K"
                 COMMIT WORK
                 CALL g_rtr1.deleteelement(l_ac)
                 LET g_rec_b7 = g_rec_b7-1
                 DISPLAY g_rec_b7 TO FORMONLY.cn2
              END IF
             ELSE
              UPDATE rtr_file SET rtr05 = g_rtr4[l_ac].rtr05,
                                  rtr06 = g_rtr4[l_ac].rtr06,
                                  rtr08 = g_rtr4[l_ac].rtr08,
                                  rtr09 = g_rtr4[l_ac].rtr09,
                                  rtr11 = g_rtr4[l_ac].rtr11,
                                  rtr12 = g_rtr4[l_ac].rtr12,
                                  rtr13 = g_rtr4[l_ac].rtr13
                 WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                   AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                   AND rtr05=g_rtr4_t.rtr05 AND rtr04 = '4'
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1)
                 LET g_rtr4[l_ac].* = g_rtr4_t.*
              ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,
                                      rtodate = g_rto.rtodate
                   WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
                     AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant

                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
             END IF
           END IF

        AFTER ROW
           CALL i130_b4_fill(" 1=1",'4')  #TQC-B90176 add
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtr4[l_ac].rtr06) THEN
              CALL g_rtr4.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtr4[l_ac].* = g_rtr4_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl7
              ROLLBACK WORK
              CONTINUE DIALOG
           END IF
           CLOSE i130_bcl7
           COMMIT WORK

      ON ACTION CONTROLO
           IF INFIELD(rtr05_3) AND l_ac > 1 THEN
              LET g_rtr4[l_ac].* = g_rtr4[l_ac-1].*
              LET g_rtr4[l_ac].rtr05 = g_rec_b7 + 1
              NEXT FIELD rtr05_3
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp
          CASE
            WHEN INFIELD(rtr06_3)
#FUN-B90092 mark START-----------------------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_oaj3"
#               LET g_qryparam.default1 = g_rtr4[l_ac].rtr06
#               CALL cl_create_qry() RETURNING g_rtr4[l_ac].rtr06
#               DISPLAY g_rtr4[l_ac].rtr06 TO rtr06_3
#               CALL i130_rtr06('d','4')
#               NEXT FIELD rtr06_3
#FUN-B90092 mark END-------------------------------

#FUN-B90092 add START-------------------------------
               CALL cl_init_qry_var()
               SELECT MAX(rtr05) INTO l_i FROM rtr_file WHERE rtr01 = g_rto.rto01 AND rtr04 = '4'
                                                          AND rtr02 = g_rto.rto02    #TQC-B90176 add 
               IF cl_null(l_i) THEN
                  LET l_i = 0
               END IF
               LET l_i = l_i + 1
               LET g_qryparam.form ="q_oaj3"
               LET g_qryparam.default1 = g_rtr1[l_ac].rtr06
               IF NOT cl_null(g_rtr4[l_ac].rtr06) THEN
                  LET g_qryparam.default1 = g_rtr1[l_ac].rtr06
                  CALL cl_create_qry() RETURNING g_rtr1[l_ac].rtr06
                  DISPLAY g_rtr1[l_ac].rtr06 TO rtr06_1
               ELSE
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_rtr06_3 = tok.nextToken()
                       IF cl_null(l_rtr06_3) THEN
                          CONTINUE WHILE
                       ELSE
                       END IF
                       INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,rtr06,rtrplant,rtrlegal)
                            VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'4',
                                   l_i,l_rtr06_3,
                                   g_rto.rtoplant,g_rto.rtolegal)
                       LET l_i = l_i+1
                    END WHILE
                   LET l_flag = 'Y'
                   LET g_rtr4_t.* = g_rtr4[l_ac].*           #TQC-B90176 add
                   LET g_rtr4_o.* = g_rtr4[l_ac].*             #TQC-B90176 add
                   LET g_page = 's_b7'          #TQC-B90176 add
                   CALL i130_b4_fill(" 1=1","4")
               END IF
#FUN-B90092 add END---------------------------------
            OTHERWISE EXIT CASE
          END CASE
    END INPUT   
        INPUT ARRAY g_rtr5 FROM s_b8.*
                ATTRIBUTE(COUNT=g_rec_b8,MAXCOUNT=g_max_rec,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b8 <> 0 THEN
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()

                BEGIN WORK
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF

                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK
                        RETURN
                END IF
                IF g_rec_b8 >= l_ac THEN
                        LET p_cmd = 'u'
                        LET g_rtr5_t.* = g_rtr5[l_ac].*
                        LET g_rtr5_o.* = g_rtr5[l_ac].*
                        OPEN i130_bcl8 USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtr5_t.rtr05
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl8:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl8 INTO g_rtr5[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtr06('d','5')
                        END IF
                 END IF

       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtr5[l_ac].* TO NULL
                LET g_rtr5_t.*=g_rtr5[l_ac].*
                LET g_rtr5_o.* = g_rtr5[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtr05_4
#FUN-B90092 mark START
#       AFTER INSERT
#                IF INT_FLAG THEN
#                        CALL cl_err('',9001,0)
#                        LET INT_FLAG=0
#                        CANCEL INSERT
#                END IF
#                IF NOT cl_null(g_rtr5[l_ac].rtr06) THEN
#                INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,
#                                     rtr06,rtr07,rtr10,rtrplant,rtrlegal)
#                     VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'5',
#                            g_rtr5[l_ac].rtr05,g_rtr5[l_ac].rtr06,g_rtr5[l_ac].rtr07,
#                            g_rtr5[l_ac].rtr10,g_rto.rtoplant,g_rto.rtolegal)
#                IF SQLCA.sqlcode THEN
#                CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
#                        CANCEL INSERT
#                ELSE
#                        MESSAGE 'INSERT Ok'
#                        COMMIT WORK
#                        LET g_rec_b8 = g_rec_b8+1
#                        DISPLAY g_rec_b8 TO FORMONLY.cn2
#                END IF
#                END IF
#FUN-B90092 mark END 
#TQC-B90176 add START
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtr5[l_ac].rtr06) THEN
                   IF g_page = 's_b8' THEN
                      LET g_page = NULL
                   ELSE
                      INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,
                                           rtr06,rtr07,rtr10,rtrplant,rtrlegal)
                          VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'5',
                                 g_rtr5[l_ac].rtr05,g_rtr5[l_ac].rtr06,g_rtr5[l_ac].rtr07,
                                 g_rtr5[l_ac].rtr10,g_rto.rtoplant,g_rto.rtolegal)
                      LET g_rec_b8 = g_rec_b8+1
                   END IF
                IF SQLCA.sqlcode THEN
                   LET g_rec_b8 = g_rec_b8-1
                   CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                  UPDATE rtr_file SET rtr05 = g_rtr5[l_ac].rtr05,
                                      rtr06 = g_rtr5[l_ac].rtr06,
                                      rtr07 = g_rtr5[l_ac].rtr07,
                                      rtr10 = g_rtr5[l_ac].rtr10
                       WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                         AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                         AND rtr05 = g_rtr5_t.rtr05 AND rtr04 = '5'
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        DISPLAY g_rec_b8 TO FORMONLY.cn2
                END IF
                END IF
#TQC-B90176 add END
      BEFORE FIELD rtr05_4
        IF cl_null(g_rtr5[l_ac].rtr05) OR g_rtr5[l_ac].rtr05=0 THEN
            SELECT MAX(rtr05)+1 INTO g_rtr5[l_ac].rtr05 FROM rtr_file
             WHERE rtr01=g_rto.rto01 AND rtr02 = g_rto.rto02
               AND rtr03=g_rto.rto03 AND rtrplant = g_rto.rtoplant
               AND rtr04 = '5'
                IF cl_null(g_rtr5[l_ac].rtr05) THEN
                        LET g_rtr5[l_ac].rtr05=1
                END IF
         END IF

      AFTER FIELD rtr05_4
        IF NOT cl_null(g_rtr5[l_ac].rtr05) THEN
           IF g_rtr5[l_ac].rtr05<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtr5[l_ac].rtr05=g_rtr5_t.rtr05
              NEXT FIELD rtr05_4
           END IF
                IF p_cmd='a' OR
                   (p_cmd='u' AND g_rtr5[l_ac].rtr05 <> g_rtr5_t.rtr05) THEN
                      SELECT COUNT(*) INTO l_n FROM rtr_file
                        WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                          AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                          AND rtr05 = g_rtr5[l_ac].rtr05 AND rtr04 = '5'
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtr5[l_ac].rtr05 = g_rtr5_t.rtr05
                           NEXT FIELD rtr05_4
                       END IF
                 END IF
         END IF

       AFTER FIELD rtr06_4
          IF NOT cl_null(g_rtr5[l_ac].rtr06) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr5[l_ac].rtr06!=g_rtr5_o.rtr06 OR cl_null(g_rtr5_o.rtr06)) THEN
                   CALL i130_rtr06('a','5')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtr5[l_ac].rtr06,g_errno,0)
                      LET g_rtr5[l_ac].rtr06 = g_rtr5_t.rtr06
                      DISPLAY BY NAME g_rtr5[l_ac].rtr06
                      NEXT FIELD rtr06_4
                   ELSE
                      LET g_rtr5_o.rtr06 = g_rtr5[l_ac].rtr06
                   END IF
                 END IF
           ELSE
             LET g_rtr5_o.rtr06=''
             LET g_rtr5[l_ac].rtr06_desc=''
             DISPLAY BY NAME g_rtr5[l_ac].rtr06_desc
           END IF

       AFTER FIELD rtr07_4
          IF NOT cl_null(g_rtr5[l_ac].rtr07) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr5[l_ac].rtr07!=g_rtr5_t.rtr07 OR cl_null(g_rtr5_t.rtr07)) THEN
                   IF g_rtr5[l_ac].rtr07 < g_rto.rto08 OR
                      g_rtr5[l_ac].rtr07 > g_rto.rto09 THEN
                      CALL cl_err(g_rtr5[l_ac].rtr07,'art-425',0)
                      LET g_rtr5[l_ac].rtr07 = g_rtr1_t.rtr07
                      DISPLAY BY NAME g_rtr5[l_ac].rtr07
                      NEXT FIELD rtr07_4
                   END IF
                 END IF
          END IF

       AFTER FIELD rtr10_4
          IF NOT cl_null(g_rtr5[l_ac].rtr10) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr5[l_ac].rtr10!=g_rtr5_t.rtr10 OR cl_null(g_rtr5_t.rtr10)) THEN
                   IF g_rtr5[l_ac].rtr10 < 0 THEN
                      CALL cl_err(g_rtr5[l_ac].rtr10,'alm-342',0)
                      LET g_rtr5[l_ac].rtr10 = g_rtr5_t.rtr10
                      DISPLAY BY NAME g_rtr5[l_ac].rtr10
                      NEXT FIELD rtr10_4
                   END IF
                 END IF
          END IF

       BEFORE DELETE
           IF g_rtr5_t.rtr05 > 0 AND (NOT cl_null(g_rtr5_t.rtr05)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtr_file
               WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                 AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                 AND rtr05 = g_rtr5_t.rtr05 AND rtr04 = '5'
              IF SQLCA.sqlcode THEN
                 CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b8 = g_rec_b8-1
              DISPLAY g_rec_b8 TO FORMONLY.cn2
           END IF
           COMMIT WORK

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtr5[l_ac].* = g_rtr5_t.*
              CLOSE i130_bcl8
              ROLLBACK WORK
              EXIT DIALOG 
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtr5[l_ac].* = g_rtr5_t.*
           ELSE
              IF cl_null(g_rtr5[l_ac].rtr06) THEN
                 DELETE FROM rtr_file
                  WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                    AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                    AND rtr05 = g_rtr5_t.rtr05 AND rtr04 = '5'
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)
                    ROLLBACK WORK
                 ELSE
                    MESSAGE "DELETE WORK"
                    COMMIT WORK
                    CALL g_rtr5.deleteelement(l_ac)
                    LET g_rec_b8 = g_rec_b8-1
                    DISPLAY g_rec_b8 TO FORMONLY.cn2
                 END IF
            ELSE
               UPDATE rtr_file SET rtr05 = g_rtr5[l_ac].rtr05,
                                   rtr06 = g_rtr5[l_ac].rtr06,
                                   rtr07 = g_rtr5[l_ac].rtr07,
                                   rtr10 = g_rtr5[l_ac].rtr10
                WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                  AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                  AND rtr05 = g_rtr5_t.rtr05 AND rtr04 = '5'
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1)
                  LET g_rtr5[l_ac].* = g_rtr5_t.*
               ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,
                                      rtodate = g_rto.rtodate
                      WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
                        AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant

                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
               END IF
             END IF
           END IF

        AFTER ROW
           CALL i130_b4_fill(" 1=1",'5')  #TQC-B90176 add
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtr5[l_ac].rtr06) THEN
              CALL g_rtr5.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtr5[l_ac].* = g_rtr5_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl8
              ROLLBACK WORK
              CONTINUE DIALOG 
           END IF
           CLOSE i130_bcl8
           COMMIT WORK

      ON ACTION CONTROLO
           IF INFIELD(rtr05) AND l_ac > 1 THEN
              LET g_rtr5[l_ac].* = g_rtr5[l_ac-1].*
              LET g_rtr5[l_ac].rtr05 = g_rec_b8 + 1
              NEXT FIELD rtr05_4
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION controlp
          CASE
            WHEN INFIELD(rtr06_4)
#FUN-B90092 mark START-----------------------------
#               CALL cl_init_qry_var()
#               LET g_qryparam.form ="q_oaj3"
#               LET g_qryparam.default1 = g_rtr5[l_ac].rtr06
#               CALL cl_create_qry() RETURNING g_rtr5[l_ac].rtr06
#               DISPLAY g_rtr5[l_ac].rtr06 TO rtr06_4
#               CALL i130_rtr06('d','5')
#               NEXT FIELD rtr06_4
#FUN-B90092 mark END-------------------------------

#FUN-B90092 add START-------------------------------
               CALL cl_init_qry_var()
               SELECT MAX(rtr05) INTO l_i FROM rtr_file WHERE rtr01 = g_rto.rto01 AND rtr04 = '5'
                                                          AND rtr02 = g_rto.rto02    #TQC-B90176 add 
               IF cl_null(l_i) THEN
                  LET l_i = 0
               END IF
               LET l_i = l_i + 1
               LET g_qryparam.form ="q_oaj3"
               LET g_qryparam.default1 = g_rtr1[l_ac].rtr06
               IF NOT cl_null(g_rtr5[l_ac].rtr06) THEN
                  LET g_qryparam.default1 = g_rtr1[l_ac].rtr06
                  CALL cl_create_qry() RETURNING g_rtr1[l_ac].rtr06
                  DISPLAY g_rtr1[l_ac].rtr06 TO rtr06_4
               ELSE
                  LET g_qryparam.state = "c"
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  LET tok = base.StringTokenizer.createExt(g_qryparam.multiret,"|",'',TRUE)
                    WHILE tok.hasMoreTokens()
                       LET l_rtr06_4 = tok.nextToken()
                       IF cl_null(l_rtr06_4) THEN
                          CONTINUE WHILE
                       ELSE
                       END IF
                       INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,rtr06,rtrplant,rtrlegal)
                            VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'5',
                                   l_i,l_rtr06_4,
                                   g_rto.rtoplant,g_rto.rtolegal)
                       LET l_i = l_i+1
                    END WHILE
                   LET l_flag = 'Y'
                   LET g_rtr5_t.* = g_rtr5[l_ac].*       #TQC-B90176 add
                   LET g_rtr5_o.* = g_rtr5[l_ac].*       #TQC-B90176 add  
                   LET g_page = 's_b8'         #TQC-B90176 add
                   CALL i130_b4_fill(" 1=1","5")
               END IF
#FUN-B90092 add END---------------------------------
            OTHERWISE EXIT CASE
          END CASE
      END INPUT  
        INPUT ARRAY g_rtr6 FROM s_b9.*
                ATTRIBUTE(COUNT=g_rec_b9,MAXCOUNT=g_max_rec,
                        INSERT ROW=FALSE,DELETE ROW=FALSE,
                        APPEND ROW=FALSE)
        BEFORE INPUT
                IF g_rec_b9 <> 0 THEN
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()

                BEGIN WORK
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,
                                   g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF

                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK
                        RETURN
                END IF
                IF g_rec_b9 >= l_ac THEN
                        LET p_cmd ='u'
                        LET g_rtr6_t.*=g_rtr6[l_ac].*
                        LET g_rtr6_o.*=g_rtr6[l_ac].*
                        OPEN i130_bcl9 USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtr6_t.rtr05
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl9:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl9 INTO g_rtr6[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                SELECT azp02 INTO g_rtr6[l_ac].rtr19_desc FROM azp_file
                                 WHERE azp01=g_rtr6[l_ac].rtr19
                        END IF
                 END IF

        AFTER FIELD rtr10_5
          IF NOT cl_null(g_rtr6[l_ac].rtr10) THEN
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr6[l_ac].rtr10!=g_rtr6_t.rtr10 OR cl_null(g_rtr6_t.rtr10)) THEN
                   IF g_rtr6[l_ac].rtr10 < 0 THEN
                      CALL cl_err(g_rtr6[l_ac].rtr10,'alm-342',0)
                      LET g_rtr6[l_ac].rtr10 = g_rtr6_t.rtr10
                      DISPLAY BY NAME g_rtr6[l_ac].rtr10
                      NEXT FIELD rtr10_5
                   END IF
                 END IF
          END IF

        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtr6[l_ac].* = g_rtr6_t.*
              CLOSE i130_bcl9
              ROLLBACK WORK
              EXIT DIALOG  
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtr6[l_ac].* = g_rtr6_t.*
           ELSE

              UPDATE rtr_file SET  rtr10 = g_rtr6[l_ac].rtr10
               WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                 AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                 AND rtr04='6' AND rtr05=g_rtr6_t.rtr05
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1)
                 LET g_rtr6[l_ac].* = g_rtr6_t.*
              ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,
                                  rtodate = g_rto.rtodate
                   WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
                     AND rto03 = g_rto.rto03 AND rtoplant=g_rto.rtoplant

                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF

        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtr6[l_ac].rtr05) THEN
              CALL g_rtr6.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtr6[l_ac].* = g_rtr6_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl9
              ROLLBACK WORK
              CONTINUE DIALOG 
           END IF
           CLOSE i130_bcl9
           COMMIT WORK

        ON ACTION CONTROLO
           IF INFIELD(rtr05_5) AND l_ac > 1 THEN
              LET g_rtr6[l_ac].* = g_rtr6[l_ac-1].*
              LET g_rtr6[l_ac].rtr05 = g_rec_b9 + 1
              NEXT FIELD rtr05_5
           END IF

        ON ACTION CONTROLR
           CALL cl_show_req_fields()

        ON ACTION CONTROLG
           CALL cl_cmdask()

        ON ACTION bmodify
           CALL i130_b9_check()
           LET g_exit_flag = 'Y'  #FUN-B80123 Add By shi
           ACCEPT DIALOG
        #   IF l_ac <> 1 THEN
        #      LET l_ac = 1
        #      LET g_rtr6_t.* = g_rtr6[l_ac].*
        #      LET g_rtr6_o.* = g_rtr6[l_ac].*
        #      CALL fgl_set_arr_curr(l_ac)
        #   END IF
     END INPUT
       #FUN-B80123 Add By shi
        BEFORE DIALOG
           IF g_exit_flag = 'Y' THEN
              LET g_exit_flag = 'N'
              NEXT FIELD rtr10_5
           END IF
       #FUN-B80123 Add By shi
        ON ACTION ACCEPT
           ACCEPT DIALOG

        ON ACTION CANCEL
           EXIT DIALOG
        
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang)

        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE DIALOG 

        ON ACTION about
           CALL cl_about()

        ON ACTION help
           CALL cl_show_help()

        ON ACTION controls
           CALL cl_set_head_visible("","AUTO")
   END DIALOG 
   CLOSE i130_bcl1
   CLOSE i130_bcl2
   CLOSE i130_bcl3
   CLOSE i130_bcl4
   CLOSE i130_bcl5
   CLOSE i130_bcl6
   CLOSE i130_bcl7
   CLOSE i130_bcl8
   CLOSE i130_bcl9
  #FUN-B80123 Add By shi
   IF g_exit_flag = 'Y' THEN
      CALL i130_b_all()
   END IF
  #FUN-B80123 Add By shi
END FUNCTION
 
#FUN-B80123-----------END-----------

FUNCTION i130_cs()
DEFINE  lc_qbe_sn   LIKE    gbm_file.gbm01
       CONSTRUCT BY NAME g_wc ON
           rto06,rto01,rto02,rto03,rto04,rto05,rto07,rtoplant,
           rto08,rto09,rto10,rto11,rto12,rto13,rto14,rto15,
           rto16,rto17,rto18,rto19,rtoconf,rtocond,rtoconu,
           rto20,#TQC-AB0216
           rtouser,rtogrup,rtomodu,rtocrat,rtoacti,rtodate
           ,rtooriu,rtoorig                                  #TQC-A30028 ADD

           BEFORE CONSTRUCT
                  CALL cl_qbe_init()

           ON ACTION controlp
              CASE
                 WHEN INFIELD(rto01)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rto01"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " rtoplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rto01
                    NEXT FIELD rto01
                 WHEN INFIELD(rto03)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rto03"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " rtoplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rto03
                    NEXT FIELD rto03
                 WHEN INFIELD(rto05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rto05"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " rtoplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rto05
                    NEXT FIELD rto05
                 WHEN INFIELD(rto07)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rto07"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " rtoplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rto07
                    NEXT FIELD rto07
                 WHEN INFIELD(rto17)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rto17"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " rtoplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rto17
                    NEXT FIELD rto17
                 WHEN INFIELD(rto18)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rto18"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " rtoplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rto18
                    NEXT FIELD rto18
                 WHEN INFIELD(rtoconu)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rtoconu"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = " rtoplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rtoconu
                    NEXT FIELD rtoconu
                 WHEN INFIELD(rtoplant)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_azp"
                    LET g_qryparam.state = "c"
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rtoplant
                    NEXT FIELD rtoplant
                 OTHERWISE
                    EXIT CASE
              END CASE
#FUN-B80123 mark
#          ON ACTION exit
#            LET g_action_choice="exit"
#            EXIT CONSTRUCT
#FUN-B80123 mark

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
              CALL cl_qbe_list() RETURNING lc_qbe_sn
              CALL cl_qbe_display_condition(lc_qbe_sn) 
       END CONSTRUCT
       IF INT_FLAG OR g_action_choice = "exit" THEN
          RETURN
       END IF
       #Begin:FUN-980030
       #    IF g_priv2='4' THEN
       #        LET g_wc = g_wc CLIPPED," AND rtouser = '",g_user,"'"
       #    END IF
       #    IF g_priv3='4' THEN
       #        LET g_wc = g_wc CLIPPED," AND rtogrup MATCHES '",
       #                   g_grup CLIPPED,"*'"
       #    END IF

       #    IF g_priv3 MATCHES "[5678]" THEN
       #        LET g_wc = g_wc clipped," AND rtogrup IN ",cl_chk_tgrup_list()
       #    END IF
       LET g_wc = g_wc CLIPPED,cl_get_extra_cond('rtouser', 'rtogrup')
       #End:FUN-980030
#FUN-B80123-------------STA-------------
       LET g_wc1 = " 1=1"
       LET g_wc2 = " 1=1"
       LET g_wc3 = " 1=1"
       LET g_wc4 = " 1=1"
       LET g_wc5 = " 1=1"
       LET g_wc6 = " 1=1"
       LET g_wc7 = " 1=1"
       LET g_wc8 = " 1=1"
       LET g_wc9 = " 1=1"
   DIALOG ATTRIBUTES(UNBUFFERED)
#FUN-B80123------------END-------------
       CONSTRUCT g_wc1 ON rtp04,rtp05
                       FROM s_b1[1].rtp04,s_b1[1].rtp05

         BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

          ON ACTION controlp
              CASE
                 WHEN INFIELD(rtp05)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rtp05"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.where = "rtp05 IN ",g_auth     #TQC-AC0095
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rtp05
                    NEXT FIELD rtp05

                 OTHERWISE
                    EXIT CASE
              END CASE
#FUN-B80123-------------STA-------------
#           ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE CONSTRUCT
#
#           ON ACTION about
#             CALL cl_about()
#
#           ON ACTION help
#             CALL cl_show_help()
#
#           ON ACTION controlg
#             CALL cl_cmdask()
#
#           ON ACTION qbe_save
#             CALL cl_qbe_save()
#FUN-B80123-------------END-------------

       END CONSTRUCT
       CONSTRUCT g_wc2 ON rtq04,rtq06
                       FROM s_b2[1].rtq04,s_b2[1].rtq06

         BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

          ON ACTION controlp
              CASE
                 WHEN INFIELD(rtq06)
                    CALL cl_init_qry_var()
              #     LET g_qryparam.form = "q_rtq06"        #FUN-AB0096  mark
                    LET g_qryparam.form = "q_rtq06_11"     #FUN-AB0096
                    LET g_qryparam.state = "c"
              #     LET g_qryparam.arg1 = "1"              #FUN-AB0096  mark
              #     LET g_qryparam.arg2 = "1"              #FUN-AB0096  mark
                    LET g_qryparam.where = " rtqplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rtq06
                    NEXT FIELD rtq06

                 OTHERWISE
                    EXIT CASE
              END CASE

#FUN-B80123-------------STA-------------
#           ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE CONSTRUCT
#
#           ON ACTION about
#             CALL cl_about()
#
#           ON ACTION help
#             CALL cl_show_help()
#
#           ON ACTION controlg
#             CALL cl_cmdask()
#
#           ON ACTION qbe_save
#             CALL cl_qbe_save()
#FUN-B80123-------------END-------------

       END CONSTRUCT

       CONSTRUCT g_wc3 ON rtq04,rtq06
                       FROM s_b3[1].rtq04_1,s_b3[1].rtq06_1

         BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

          ON ACTION controlp
              CASE
                 WHEN INFIELD(rtq06_1)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rtq06"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = "2"
                    LET g_qryparam.arg2 = "2"
                    LET g_qryparam.where = " rtqplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rtq06_1
                    NEXT FIELD rtq06_1

                 OTHERWISE
                    EXIT CASE
              END CASE

#FUN-B80123-------------STA-------------
 #          ON IDLE g_idle_seconds
 #            CALL cl_on_idle()
 #            CONTINUE CONSTRUCT
 #
 #          ON ACTION about
 #            CALL cl_about()
 #
 #          ON ACTION help
 #            CALL cl_show_help()
 #
 #          ON ACTION controlg
 #            CALL cl_cmdask()
 #
 #          ON ACTION qbe_save
 #            CALL cl_qbe_save()
#FUN-B80123-------------END-------------

       END CONSTRUCT

       CONSTRUCT g_wc4 ON rtr05,rtr06,rtr07,rtr10
                       FROM s_b4[1].rtr05,s_b4[1].rtr06,s_b4[1].rtr07,s_b4[1].rtr10

         BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

          ON ACTION controlp
              CASE
                 WHEN INFIELD(rtr06)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rtr06"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = "1"
                    LET g_qryparam.where = " rtrplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rtr06
                    NEXT FIELD rtr06

                 OTHERWISE
                    EXIT CASE
              END CASE

#FUN-B80123-------------STA-------------
#           ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE CONSTRUCT
#
#           ON ACTION about
#             CALL cl_about()
#
#           ON ACTION help
#             CALL cl_show_help()
#
#           ON ACTION controlg
#             CALL cl_cmdask()
#
#           ON ACTION qbe_save
#             CALL cl_qbe_save()
#FUN-B80123-------------END-------------

       END CONSTRUCT

       CONSTRUCT g_wc5 ON rtr05,rtr06,rtr08,rtr09,rtr10
                       FROM s_b5[1].rtr05_1,s_b5[1].rtr06_1,s_b5[1].rtr08_1,
                             s_b5[1].rtr09_1,s_b5[1].rtr10_1
         BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

          ON ACTION controlp
              CASE
                 WHEN INFIELD(rtr06_1)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rtr06"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = "2"
                    LET g_qryparam.arg2 = g_plant
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rtr06_1
                    NEXT FIELD rtr06_1

                 OTHERWISE
                    EXIT CASE
              END CASE

#FUN-B80123-------------STA-------------
#           ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE CONSTRUCT
#
#           ON ACTION about
#             CALL cl_about()
#
#           ON ACTION help
#             CALL cl_show_help()
#
#           ON ACTION controlg
#             CALL cl_cmdask()
#
#           ON ACTION qbe_save
#             CALL cl_qbe_save()
#
#FUN-B80123-------------END-------------
       END CONSTRUCT

       CONSTRUCT g_wc6 ON rtr05,rtr06,rtr08,rtr09,rtr11,rtr12,
                            rtr14_2,rtr15_2
                       FROM s_b6[1].rtr05_2,s_b6[1].rtr06_2,s_b6[1].rtr08_2,
                            s_b6[1].rtr09_2,s_b6[1].rtr11_2,s_b6[1].rtr12_2,
                            s_b6[1].rtr14_2,s_b6[1].rtr15_2

         BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

          ON ACTION controlp
              CASE
                 WHEN INFIELD(rtr06_2)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rtr06"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = "3"
                    LET g_qryparam.where = " rtrplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rtr06_2
                    NEXT FIELD rtr06_2

                 OTHERWISE
                    EXIT CASE
              END CASE

#FUN-B80123-------------STA-------------
#           ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE CONSTRUCT
#
#           ON ACTION about
#             CALL cl_about()
#
#           ON ACTION help
#             CALL cl_show_help()
#
#           ON ACTION controlg
#             CALL cl_cmdask()
#
#           ON ACTION qbe_save
#             CALL cl_qbe_save()
#
#FUN-B80123-------------END-------------
       END CONSTRUCT

       CONSTRUCT g_wc7 ON rtr05,rtr06,rtr08,rtr09,rtr11,rtr12,
                            rtr13_3
                       FROM s_b7[1].rtr05_3,s_b7[1].rtr06_3,s_b7[1].rtr08_3,
                            s_b7[1].rtr09_3,s_b7[1].rtr11_3,s_b7[1].rtr12_3,
                            s_b7[1].rtr13_3

         BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

          ON ACTION controlp
              CASE
                 WHEN INFIELD(rtr06_3)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rtr06"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = "4"
                    LET g_qryparam.where = " rtrplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rtr06_3
                    NEXT FIELD rtr06_3

                 OTHERWISE
                    EXIT CASE
              END CASE

#FUN-B80123-------------STA-------------
#           ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE CONSTRUCT
#
#           ON ACTION about
#             CALL cl_about()
#
#           ON ACTION help
#             CALL cl_show_help()
#
#           ON ACTION controlg
#             CALL cl_cmdask()
#
#           ON ACTION qbe_save
#             CALL cl_qbe_save()
#FUN-B80123-------------END-------------

       END CONSTRUCT

       CONSTRUCT g_wc8 ON rtr05,rtr06,rtr07,rtr10
                       FROM s_b8[1].rtr05_4,s_b8[1].rtr06_4,s_b8[1].rtr07_4,
                            s_b8[1].rtr10_4

         BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

          ON ACTION controlp
              CASE
                 WHEN INFIELD(rtr06_4)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rtr06"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = "5"
                    LET g_qryparam.where = " rtrplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rtr06_4
                    NEXT FIELD rtr06_4

                 OTHERWISE
                    EXIT CASE
              END CASE

#FUN-B80123-------------STA-------------
#           ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE CONSTRUCT
#
#           ON ACTION about
#             CALL cl_about()
#
#           ON ACTION help
#             CALL cl_show_help()
#
#           ON ACTION controlg
#             CALL cl_cmdask()
#
#           ON ACTION qbe_save
#             CALL cl_qbe_save()
#
#FUN-B80123-------------END-------------
       END CONSTRUCT

       CONSTRUCT g_wc9 ON rtr06,rtr08,rtr16,rtr17,rtr05,rtr18,
                            rtr19,rtr10
                       FROM rtr06_5,rtr08_5,rtr16_5,rtr17_5,
                            s_b9[1].rtr05_5,s_b9[1].rtr18_5,
                            s_b9[1].rtr19_5,s_b9[1].rtr10_5

         BEFORE CONSTRUCT
               CALL cl_qbe_display_condition(lc_qbe_sn)

          ON ACTION controlp
              CASE
                 WHEN INFIELD(rtr06_5)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rtr06"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = "6"
                    LET g_qryparam.where = " rtrplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rtr06_5
                    NEXT FIELD rtr06_5
                 WHEN INFIELD(rtr19_5)
                    CALL cl_init_qry_var()
                    LET g_qryparam.form = "q_rtr19"
                    LET g_qryparam.state = "c"
                    LET g_qryparam.arg1 = "6"
                    LET g_qryparam.where = " rtrplant IN ",g_auth #FUN-B40041
                    CALL cl_create_qry() RETURNING g_qryparam.multiret
                    DISPLAY g_qryparam.multiret TO rtr19_5
                    NEXT FIELD rtr19_5
                 OTHERWISE
                    EXIT CASE
              END CASE

#FUN-B80123-------------STA-------------
#           ON IDLE g_idle_seconds
#             CALL cl_on_idle()
#             CONTINUE CONSTRUCT
#
#           ON ACTION about
#             CALL cl_about()
#
#           ON ACTION help
#             CALL cl_show_help()
#
#           ON ACTION controlg
#             CALL cl_cmdask()
#
#           ON ACTION qbe_save
#             CALL cl_qbe_save()
#
#FUN-B80123-------------END-------------
       END CONSTRUCT
       ON ACTION ACCEPT
          ACCEPT DIALOG

       ON ACTION cancel
          LET INT_FLAG = 1
          EXIT DIALOG

       ON IDLE g_idle_seconds
          CALL cl_on_idle()
          CONTINUE DIALOG

       ON ACTION about
          CALL cl_about()

       ON ACTION help
          CALL cl_show_help()

       ON ACTION controlg
          CALL cl_cmdask()

       ON ACTION qbe_save
          CALL cl_qbe_save()
   END DIALOG

   IF INT_FLAG THEN
       RETURN
   END IF

   LET g_sql1="SELECT rto01,rto02,rto03,rtoplant"
   LET g_sql2=" FROM rto_file"
   LET g_sql3=" WHERE rtoplant IN ",g_auth,
              "   AND ",g_wc CLIPPED

   IF g_wc1<>" 1=1" THEN
             LET g_sql2=g_sql2 CLIPPED,",rtp_file"
             LET g_sql3=g_sql3 CLIPPED,
                        " AND rto01=rtp01 AND rto02=rtp02 ",
                        " AND rto03=rtp03 AND rtoplant=rtpplant",
                        " AND ",g_wc1 CLIPPED
   END IF
   IF g_wc2<>" 1=1" THEN
             LET g_sql2=g_sql2 CLIPPED,",rtq_file"
             LET g_sql3=g_sql3 CLIPPED,
                        " AND rto01=rtq01 AND rto02=rtq02 ",
                        " AND rto03=rtq03 AND rtoplant=rtqplant",
                        " AND rtq05='1' AND ",g_wc2 CLIPPED
   END IF
   IF g_wc3<>" 1=1" THEN
             LET g_sql2=g_sql2 CLIPPED,",rtq_file"
             LET g_sql3=g_sql3 CLIPPED,
                        " AND rto01=rtq01 AND rto02=rtq02 ",
                        " AND rto03=rtq03 AND rtoplant=rtqplant",
                        " AND rtq05='2' AND ",g_wc3 CLIPPED
   END IF
   IF g_wc4<>" 1=1" THEN
             LET g_sql2=g_sql2 CLIPPED,",rtr_file"
             LET g_sql3=g_sql3 CLIPPED,
                 " AND rto01=rtr01 AND rto02=rtr02 ",
                 " AND rto03=rtr03 AND rtoplant=rtrplant",
                 " AND rtr04='1' AND ",g_wc4 CLIPPED
   END IF
   IF g_wc5<>" 1=1" THEN
             LET g_sql2=g_sql2 CLIPPED,",rtr_file"
             LET g_sql3=g_sql3 CLIPPED,
                 " AND rto01=rtr01 AND rto02=rtr02 ",
                 " AND rto03=rtr03 AND rtoplant=rtrplant",
                 " AND rtr04='2' AND ",g_wc5 CLIPPED
   END IF
   IF g_wc6<>" 1=1" THEN
             LET g_sql2=g_sql2 CLIPPED,",rtr_file"
             LET g_sql3=g_sql3 CLIPPED,
                 " AND rto01=rtr01 AND rto02=rtr02 ",
                 " AND rto03=rtr03 AND rtoplant=rtrplant",
                 " AND rtr04='3' AND ",g_wc6 CLIPPED
   END IF
   IF g_wc7<>" 1=1" THEN
             LET g_sql2=g_sql2 CLIPPED,",rtr_file"
             LET g_sql3=g_sql3 CLIPPED,
                 " AND rto01=rtr01 AND rto02=rtr02 ",
                 " AND rto03=rtr03 AND rtoplant=rtrplant",
                 " AND rtr04='4' AND ",g_wc7 CLIPPED
   END IF
   IF g_wc8<>" 1=1" THEN
             LET g_sql2=g_sql2 CLIPPED,",rtr_file"
             LET g_sql3=g_sql3 CLIPPED,
                 " AND rto01=rtr01 AND rto02=rtr02 ",
                 " AND rto03=rtr03 AND rtoplant=rtrplant",
                 " AND rtr04='5' AND ",g_wc8 CLIPPED
   END IF
   IF g_wc9<>" 1=1" THEN
             LET g_sql2=g_sql2 CLIPPED,",rtr_file"
             LET g_sql3=g_sql3 CLIPPED,
                 " AND rto01=rtr01 AND rto02=rtr02 ",
                 " AND rto03=rtr03 AND rtoplant=rtrplant",
                 " AND rtr04='6' AND ",g_wc9 CLIPPED
   END IF

   LET g_sql=g_sql1 CLIPPED,g_sql2 CLIPPED,g_sql3 CLIPPED

   PREPARE i130_prepare FROM g_sql
   DECLARE i130_cs SCROLL CURSOR WITH HOLD FOR i130_prepare

   LET g_sql1="SELECT COUNT(*) "
   LET g_sql=g_sql1 CLIPPED,g_sql2 CLIPPED,g_sql3 CLIPPED

   PREPARE i130_precount FROM g_sql
   DECLARE i130_count CURSOR FOR i130_precount
END FUNCTION
 
FUNCTION i130_q()
 
    LET g_row_count = 0
    LET g_curs_index = 0
    CALL cl_navigator_setting(g_curs_index,g_row_count)
    CALL cl_opmsg('q')   
    
    CLEAR FORM 
    CALL g_rtp.clear()  
    CALL g_rtq.clear()
    CALL g_rtq1.clear()
    CALL g_rtr1.clear()
    CALL g_rtr2.clear()
    CALL g_rtr3.clear()
    CALL g_rtr4.clear()
    CALL g_rtr5.clear()
    CALL g_rtr6.clear()    
    INITIALIZE g_rtr7.* TO NULL    
 
    MESSAGE ""
    
    DISPLAY ' ' TO FORMONLY.cnt
    
    CALL i130_cs()               
           
    IF INT_FLAG THEN
        LET INT_FLAG = 0
        INITIALIZE g_rto.* TO NULL
        RETURN
    END IF
    
    OPEN i130_cs                
    
    IF SQLCA.sqlcode THEN
        CALL cl_err('',SQLCA.sqlcode,0)
    ELSE
        OPEN i130_count
        FETCH i130_count INTO g_row_count
        IF g_row_count>0 THEN
           DISPLAY g_row_count TO FORMONLY.cnt  
           CALL i130_fetch('F') 
        ELSE 
           CALL cl_err('',100,0)
           INITIALIZE g_rto.* TO NULL
        END IF             
    END IF
END FUNCTION
 
FUNCTION i130_fetch(p_flrto)
DEFINE  p_flrto         LIKE type_file.chr1     
 
    CASE p_flrto
        WHEN 'N' FETCH NEXT     i130_cs INTO g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
        WHEN 'P' FETCH PREVIOUS i130_cs INTO g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
        WHEN 'F' FETCH FIRST    i130_cs INTO g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
        WHEN 'L' FETCH LAST     i130_cs INTO g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
        WHEN '/'
            IF (NOT mi_no_ask) THEN                   
               CALL cl_getmsg('fetch',g_lang) RETURNING g_msg
               LET INT_FLAG = 0  
               PROMPT g_msg CLIPPED,': ' FOR g_jump
                  ON IDLE g_idle_seconds
                     CALL cl_on_idle()
 
                  ON ACTION about         
                     CALL cl_about()      
 
                  ON ACTION help          
                     CALL cl_show_help()  
 
                  ON ACTION controlg      
                     CALL cl_cmdask()    
 
               END PROMPT
               IF INT_FLAG THEN
                   LET INT_FLAG = 0
                   LET g_jump = g_curs_index
                   EXIT CASE
               END IF
            END IF
            FETCH ABSOLUTE g_jump i130_cs INTO g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
            LET mi_no_ask = FALSE        
    END CASE
 
    IF SQLCA.sqlcode THEN
        CALL cl_err(g_rto.rto01,SQLCA.sqlcode,0)
        INITIALIZE g_rto.* TO NULL  
        RETURN
    ELSE
      CASE p_flrto
         WHEN 'F' LET g_curs_index = 1
         WHEN 'P' LET g_curs_index = g_curs_index - 1
         WHEN 'N' LET g_curs_index = g_curs_index + 1
         WHEN 'L' LET g_curs_index = g_row_count
         WHEN '/' LET g_curs_index = g_jump
      END CASE
 
      CALL cl_navigator_setting(g_curs_index, g_row_count)
      DISPLAY g_curs_index TO FORMONLY.idx                 
    END IF
 
    SELECT * INTO g_rto.* FROM rto_file    
     WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
       AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
    IF SQLCA.sqlcode THEN
        CALL cl_err3("sel","rto_file","","",SQLCA.sqlcode,"","",0)  
    ELSE      
        INITIALIZE g_rtr7.* TO NULL
        LET g_data_plant = g_rto.rtoplant #TQC-A10128 ADD 
        CALL i130_show()                   
    END IF
END FUNCTION
 
FUNCTION i130_rto03(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1,  
        l_azp02    LIKE azp_file.azp02
          
   LET g_errno = ' '
   SELECT azp02 INTO l_azp02
     FROM azp_file 
    WHERE azp01 = g_rto.rto03
   CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-002' 
                                 LET l_azp02=NULL 
        OTHERWISE
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azp02 TO FORMONLY.rto03_desc
  END IF
 
END FUNCTION
 
FUNCTION i130_rto05(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1,  
        l_pmcacti  LIKE pmc_file.pmcacti,
        l_pmc03    LIKE pmc_file.pmc03
        
   LET g_errno = ' '
   SELECT pmc03,pmc17,pmcacti 
     INTO l_pmc03,g_pmc17,l_pmcacti
     FROM pmc_file 
    WHERE pmc01 = g_rto.rto05
  CASE
        WHEN SQLCA.sqlcode=100   LET g_errno='art-056' 
                                 LET l_pmc03=NULL 
        WHEN l_pmcacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
 
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pmc03 TO FORMONLY.rto05_desc
  END IF
 
END FUNCTION
 
FUNCTION i130_rto07(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1,  
        l_pmaacti  LIKE pma_file.pmaacti,
        l_pma02    LIKE pma_file.pma02
          
   LET g_errno = ' '
   SELECT pma02,pmaacti INTO l_pma02,l_pmaacti
     FROM pma_file 
    WHERE pma01 = g_rto.rto07
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-073' 
                                 LET l_pma02=NULL 
        WHEN l_pmaacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_pma02 TO FORMONLY.rto07_desc
  END IF
 
END FUNCTION
 
FUNCTION i130_rto17(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1,  
        l_genacti  LIKE gen_file.genacti,
        l_gen02    LIKE gen_file.gen02
          
   LET g_errno = ' '
   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file 
    WHERE gen01 = g_rto.rto17
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-074' 
                                 LET l_gen02=NULL 
        WHEN l_genacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.rto17_desc
  END IF
 
END FUNCTION
 
FUNCTION i130_rto18(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1,  
        l_genacti  LIKE gen_file.genacti,
        l_gen02    LIKE gen_file.gen02
          
   LET g_errno = ' '
   SELECT gen02,genacti INTO l_gen02,l_genacti
     FROM gen_file 
    WHERE gen01 = g_rto.rto18
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-074' 
                                 LET l_gen02=NULL 
        WHEN l_genacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.rto18_desc
  END IF
 
END FUNCTION
 
FUNCTION i130_rtoconu(p_cmd)         
DEFINE    l_genacti  LIKE gen_file.genacti, 
          l_gen02    LIKE gen_file.gen02,    
          p_cmd      LIKE type_file.chr1   
          
   LET g_errno = ' '
   SELECT gen02,genacti INTO l_gen02,l_genacti 
     FROM gen_file
    WHERE gen01 = g_rto.rtoconu
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-075' 
                                 LET l_gen02=NULL 
        WHEN l_genacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_gen02 TO FORMONLY.rtoconu_desc
  END IF
 
END FUNCTION
 
FUNCTION i130_rtoplant(p_cmd)         
DEFINE    l_azp02    LIKE azp_file.azp02,    
          p_cmd      LIKE type_file.chr1   
          
   LET g_errno = ' '
   SELECT azp02 INTO l_azp02
     FROM azp_file
    WHERE azp01 = g_rto.rtoplant
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-002' 
                                 LET l_azp02=NULL 
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      DISPLAY l_azp02 TO FORMONLY.rtoplant_desc
  END IF
 
END FUNCTION
 
FUNCTION i130_rtp05(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1,
        l_azp02    LIKE azp_file.azp02
DEFINE l_n         LIKE type_file.num5          
   LET g_errno = ' '
   LET g_sql ="SELECT azp02 FROM azp_file ",
              " WHERE azp01 = '",g_rtp[l_ac].rtp05,"'",
              " AND  azp01 IN ",g_auth          #TQC-AC0095
               
   PREPARE azp_cs FROM g_sql
   EXECUTE azp_cs INTO l_azp02
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-002' 
                                 LET l_azp02=NULL 
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_rtp[l_ac].rtp05_desc = l_azp02
      DISPLAY BY NAME g_rtp[l_ac].rtp05_desc
  END IF
 
END FUNCTION
#FUN-AB0096 -----------------------mark 
#FUNCTION i130_rtq06(p_cmd)         
#DEFINE  p_cmd      LIKE type_file.chr1,  
#       l_tqaacti  LIKE tqa_file.tqaacti,
#       l_tqa02    LIKE tqa_file.tqa02
#         
#  LET g_errno = ' '
#  SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
#    FROM tqa_file 
#   WHERE tqa01 = g_rtq[l_ac].rtq06 AND tqa03 = '1'
# CASE                          
#       WHEN SQLCA.sqlcode=100   LET g_errno='art-076' 
#                                LET l_tqa02=NULL 
#       WHEN l_tqaacti='N'       LET g_errno='9028'     
#      OTHERWISE   
#      LET g_errno=SQLCA.sqlcode USING '------' 
# END CASE   
# IF cl_null(g_errno) OR p_cmd = 'd' THEN
#     LET g_rtq[l_ac].rtq06_desc = l_tqa02
#     DISPLAY BY NAME g_rtq[l_ac].rtq06_desc
# END IF
#
#END FUNCTION
#FUN-AB0096 --------------------------mark

#FUN-AB0096 -------------------------------STA
FUNCTION i130_rtq06(p_cmd)
   DEFINE  p_cmd      LIKE type_file.chr1
   DEFINE  l_oba02    LIKE oba_file.oba02
   DEFINE  l_obaacti  LIKE oba_file.obaacti

   LET g_errno = ' '
   SELECT oba02,obaacti INTO l_oba02,l_obaacti 
     FROM oba_file
    WHERE oba01 = g_rtq[l_ac].rtq06 AND oba14 = 0 
   CASE
       WHEN SQLCA.sqlcode=100  LET g_errno='art-076'
                                LET l_oba02=NULL
       WHEN l_obaacti='N'       LET g_errno='9028'
       OTHERWISE
            LET g_errno=SQLCA.sqlcode USING '------'
   END CASE
   IF cl_null(g_errno) OR p_cmd = 'd' THEN
       LET g_rtq[l_ac].rtq06_desc = l_oba02
       DISPLAY BY NAME g_rtq[l_ac].rtq06_desc
   END IF
END FUNCTION
#FUN-AB0096 -------------------------------END
 
FUNCTION i130_rtq06_1(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1,  
        l_tqaacti  LIKE tqa_file.tqaacti,
        l_tqa02    LIKE tqa_file.tqa02
          
   LET g_errno = ' '
   SELECT tqa02,tqaacti INTO l_tqa02,l_tqaacti
     FROM tqa_file 
    WHERE tqa01 = g_rtq1[l_ac].rtq06 AND tqa03 = '2'
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-077' 
                                 LET l_tqa02=NULL 
        WHEN l_tqaacti='N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_rtq1[l_ac].rtq06_desc = l_tqa02
      DISPLAY BY NAME g_rtq1[l_ac].rtq06_desc
  END IF
 
END FUNCTION
 
FUNCTION i130_rtr06(p_cmd,p_choice) #費用名稱         
DEFINE    p_cmd      LIKE type_file.chr1,   
          p_choice   LIKE type_file.chr1,
          l_oaj02    LIKE oaj_file.oaj02,
          l_oajacti  LIKE oaj_file.oajacti,
          l_rtr06    LIKE rtr_file.rtr06
          
   LET g_errno = ' '
   CASE p_choice
      WHEN "1"   LET l_rtr06 = g_rtr1[l_ac].rtr06
      WHEN "2"   LET l_rtr06 = g_rtr2[l_ac].rtr06
      WHEN "3"   LET l_rtr06 = g_rtr3[l_ac].rtr06
      WHEN "4"   LET l_rtr06 = g_rtr4[l_ac].rtr06
      WHEN "5"   LET l_rtr06 = g_rtr5[l_ac].rtr06
      WHEN "6"   LET l_rtr06 = g_rtr7.rtr06
   END CASE
   
   SELECT oaj02,oajacti INTO l_oaj02,l_oajacti 
     FROM oaj_file 
    WHERE oaj01 = l_rtr06 
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-078' 
                                 LET l_oaj02=NULL 
        WHEN l_oajacti = 'N'       LET g_errno='9028'     
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      CASE p_choice
        WHEN "1" LET g_rtr1[l_ac].rtr06_desc = l_oaj02
                 DISPLAY BY NAME g_rtr1[l_ac].rtr06_desc
        WHEN "2" LET g_rtr2[l_ac].rtr06_desc = l_oaj02
                 DISPLAY BY NAME g_rtr2[l_ac].rtr06_desc
        WHEN "3" LET g_rtr3[l_ac].rtr06_desc = l_oaj02
                 DISPLAY BY NAME g_rtr3[l_ac].rtr06_desc
        WHEN "4" LET g_rtr4[l_ac].rtr06_desc = l_oaj02
                 DISPLAY BY NAME g_rtr4[l_ac].rtr06_desc
        WHEN "5" LET g_rtr5[l_ac].rtr06_desc = l_oaj02
                 DISPLAY BY NAME g_rtr5[l_ac].rtr06_desc
        WHEN "6" DISPLAY l_oaj02 TO rtr06_5_desc
     END CASE
  END IF
 
END FUNCTION
 
FUNCTION i130_rtr19_5(p_cmd)         
DEFINE  p_cmd      LIKE type_file.chr1,
        l_azp02    LIKE azp_file.azp02
          
   LET g_errno = ' '
   SELECT azp02 INTO l_azp02
     FROM azp_file 
    WHERE azp01 = g_rtr6[l_ac].rtr19
  CASE                          
        WHEN SQLCA.sqlcode=100   LET g_errno='art-002' 
                                 LET l_azp02=NULL 
       OTHERWISE   
       LET g_errno=SQLCA.sqlcode USING '------' 
  END CASE   
  IF cl_null(g_errno) OR p_cmd = 'd' THEN
      LET g_rtr6[l_ac].rtr19_desc = l_azp02
      DISPLAY BY NAME g_rtr6[l_ac].rtr19_desc
  END IF
 
END FUNCTION
 
FUNCTION i130_show()
    LET g_rto_t.* = g_rto.*
    LET g_rto_o.* = g_rto.*
    DISPLAY BY NAME g_rto.rto06,g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rto04,
                    g_rto.rto05,g_rto.rto07,g_rto.rtoplant,g_rto.rto08,g_rto.rto09,
                    g_rto.rto10,g_rto.rto11,g_rto.rto12,g_rto.rto13,g_rto.rto14,
                    g_rto.rto15,g_rto.rto16,g_rto.rto17,g_rto.rto18,g_rto.rto19,
              #     g_rto.rtoconf,g_rto.rtocond,g_rto.rtoconu,g_rto.rtomksg,#TQC-AB0216
                    g_rto.rtoconf,g_rto.rtocond,g_rto.rtoconu,            #TQC-AB0216   
              #     g_rto.rto900,g_rto.rto20,g_rto.rtouser,g_rto.rtogrup,#TQC-AB0216 
                    g_rto.rto20,g_rto.rtouser,g_rto.rtogrup,#TQC-AB0216
                    g_rto.rtomodu,g_rto.rtodate,g_rto.rtoacti,g_rto.rtocrat
                   ,g_rto.rtooriu,g_rto.rtoorig                               #TQC-A30028 ADD
    CALL i130_rto03('d')
    CALL i130_rto05('d')
    CALL i130_rto07('d')
    CALL i130_rtoplant('d')
    CALL i130_rto17('d')
    CALL i130_rto18('d')
    CALL i130_rtoconu('d')
    CASE g_rto.rtoconf
        WHEN "Y"
          CALL cl_set_field_pic('Y',"","","","","")
        WHEN "N"
          CALL cl_set_field_pic('',"","","","",g_rto.rtoacti)
        WHEN "X"
          CALL cl_set_field_pic("","","","",'Y',"")
    END CASE
    
    CASE
         WHEN (g_action_flag IS NULL) OR (g_action_flag = "fixup1")
              CALL i130_b1_fill(g_wc1)
         WHEN (g_action_flag = "fixup2")
              CALL i130_b2_fill(g_wc2)
         WHEN (g_action_flag = "fixup3")
              CALL i130_b3_fill(g_wc3)
         WHEN (g_action_flag = "fixup4")
              CALL i130_b4_fill(g_wc4,'1')
         WHEN (g_action_flag = "fixup5")
              CALL i130_b4_fill(g_wc5,'2')
         WHEN (g_action_flag = "fixup6")
              CALL i130_b4_fill(g_wc6,'3')
         WHEN (g_action_flag = "fixup7")
              CALL i130_b4_fill(g_wc7,'4')
         WHEN (g_action_flag = "fixup8")
              CALL i130_b4_fill(g_wc8,'5')
         WHEN (g_action_flag = "fixup9")
              CALL i130_b9_show()
    END CASE 
    CALL i130_b1_fill(g_wc1)
    CALL cl_show_fld_cont()                   
END FUNCTION
 
FUNCTION i130_b1_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql =
        "SELECT rtp04,rtp05,'' FROM rtp_file ",
        " WHERE rtp01='",g_rto.rto01 CLIPPED,"' AND rtp02=",g_rto.rto02,
        "   AND rtp03='",g_rto.rto03 CLIPPED,"' AND rtpplant='",g_rto.rtoplant,"'"
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE i130_pb FROM g_sql
    DECLARE rtp_cs CURSOR FOR i130_pb
 
    CALL g_rtp.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rtp_cs INTO g_rtp[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        SELECT azp02 INTO g_rtp[g_cnt].rtp05_desc FROM azp_file
         WHERE azp01 = g_rtp[g_cnt].rtp05
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rtp.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b1 = g_cnt-1
    LET g_cnt = g_cnt - 1 #TQC-B90176 add
    #TQC-A30102 ADD------------------
    IF cl_null(g_rto.rto01) AND 
       cl_null(g_rto.rto03) AND cl_null(g_rto.rtoplant) THEN
       LET g_rec_b1=' '
    END IF
    #TQC-A30102 ADD------------------
    DISPLAY g_rec_b1 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION    
 
FUNCTION i130_b2_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql =
        "SELECT rtq04,rtq06,'' FROM rtq_file ",
        " WHERE rtq01='",g_rto.rto01 CLIPPED,"' AND rtq02=",g_rto.rto02,
        " AND rtq03='",g_rto.rto03 CLIPPED,"' AND rtqplant='",g_rto.rtoplant,"'",
        " AND rtq05='1'"
    
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE i130_pb1 FROM g_sql
    DECLARE rtq_cs1 CURSOR FOR i130_pb1
 
    CALL g_rtq.clear()
    
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rtq_cs1 INTO g_rtq[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
     #  SELECT tqa02 INTO g_rtq[g_cnt].rtq06_desc FROM tqa_file   #TQC-AC0095 
     #   WHERE tqa01 = g_rtq[g_cnt].rtq06 AND tqa03 = '1'         #TQC-AC0095 
        SELECT oba02   INTO g_rtq[g_cnt].rtq06_desc         #TQC-AC0095                                                                                
          FROM oba_file                                    #TQC-AC0095                                                                               
          WHERE oba01 = g_rtq[g_cnt].rtq06 AND oba14 = 0    #TQC-AC0095
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    
    CALL g_rtq.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b2 = g_cnt-1
    DISPLAY g_rec_b2 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION 
 
FUNCTION i130_b3_fill(p_wc2)              
DEFINE   p_wc2       STRING        
 
    LET g_sql =
        "SELECT rtq04,rtq06,'' FROM rtq_file ",
        " WHERE rtq01='",g_rto.rto01 CLIPPED,"' AND rtq02=",g_rto.rto02,
        " AND rtq03='",g_rto.rto03 CLIPPED,"' AND rtqplant='",g_rto.rtoplant,"'",
        " AND rtq05='2'"
    
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE i130_pb2 FROM g_sql
    DECLARE rtq_cs2 CURSOR FOR i130_pb2
 
    CALL g_rtq1.clear()
    
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rtq_cs2 INTO g_rtq1[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
        SELECT tqa02 INTO g_rtq1[g_cnt].rtq06_desc FROM tqa_file
         WHERE tqa01 = g_rtq1[g_cnt].rtq06 AND tqa03 = '2'
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
    CALL g_rtq1.deleteElement(g_cnt)
    MESSAGE ""
    LET g_rec_b3 = g_cnt-1
    DISPLAY g_rec_b3 TO FORMONLY.cn2
    LET g_cnt = 0
END FUNCTION 
 
FUNCTION i130_b4_fill(p_wc2,p_choice)              
DEFINE   p_wc2       STRING        
DEFINE   p_choice    LIKE type_file.chr1
    LET g_sql =
        "SELECT rtr05,rtr06,'',rtr07,rtr08,rtr09,rtr10,rtr11,rtr12,",
        "rtr13,rtr14,rtr15,rtr16,rtr17,rtr18,rtr19 FROM rtr_file ",
        " WHERE rtr01='",g_rto.rto01 CLIPPED,"' AND rtr02=",g_rto.rto02,
        " AND rtr03='",g_rto.rto03 CLIPPED,"' AND rtrplant='",g_rto.rtoplant,"'"
    
    LET g_sql=g_sql CLIPPED," AND rtr04='",p_choice,"'"
    IF NOT cl_null(p_wc2) THEN
      LET g_sql=g_sql CLIPPED," AND ",p_wc2 CLIPPED
    END IF
    PREPARE i130_pb3 FROM g_sql
    DECLARE rtr_cs3 CURSOR FOR i130_pb3
 
    CASE p_choice
       WHEN "1" CALL g_rtr1.clear()
       WHEN "2" CALL g_rtr2.clear()
       WHEN "3" CALL g_rtr3.clear()
       WHEN "4" CALL g_rtr4.clear()
       WHEN "5" CALL g_rtr5.clear()
       WHEN "6" CALL g_rtr6.clear()
#      INITIALIZE g_rtr7.* TO NULL
    END CASE
    CALL g_rtr.clear()
    LET g_cnt = 1
    MESSAGE "Searching!"
    FOREACH rtr_cs3 INTO g_rtr[g_cnt].*  
        IF STATUS THEN CALL cl_err('foreach:',STATUS,1) 
        EXIT FOREACH
        END IF
       SELECT oaj02 INTO g_rtr[g_cnt].rtr06_desc FROM oaj_file
                WHERE oaj01 = g_rtr[g_cnt].rtr06 
                 AND  oajacti= 'Y'
        CASE p_choice
           WHEN "1"  LET g_rtr1[g_cnt].rtr05=g_rtr[g_cnt].rtr05
                     LET g_rtr1[g_cnt].rtr06=g_rtr[g_cnt].rtr06
                     LET g_rtr1[g_cnt].rtr06_desc=g_rtr[g_cnt].rtr06_desc
                     LET g_rtr1[g_cnt].rtr07=g_rtr[g_cnt].rtr07
                     LET g_rtr1[g_cnt].rtr10=g_rtr[g_cnt].rtr10
           WHEN "2"  LET g_rtr2[g_cnt].rtr05=g_rtr[g_cnt].rtr05
                     LET g_rtr2[g_cnt].rtr06=g_rtr[g_cnt].rtr06
                     LET g_rtr2[g_cnt].rtr06_desc=g_rtr[g_cnt].rtr06_desc
                     LET g_rtr2[g_cnt].rtr08=g_rtr[g_cnt].rtr08
                     LET g_rtr2[g_cnt].rtr09=g_rtr[g_cnt].rtr09
                     LET g_rtr2[g_cnt].rtr10=g_rtr[g_cnt].rtr10
           WHEN "3"  LET g_rtr3[g_cnt].rtr05=g_rtr[g_cnt].rtr05
                     LET g_rtr3[g_cnt].rtr06=g_rtr[g_cnt].rtr06
                     LET g_rtr3[g_cnt].rtr06_desc=g_rtr[g_cnt].rtr06_desc
                     LET g_rtr3[g_cnt].rtr08=g_rtr[g_cnt].rtr08
                     LET g_rtr3[g_cnt].rtr09=g_rtr[g_cnt].rtr09
                     LET g_rtr3[g_cnt].rtr11=g_rtr[g_cnt].rtr11
                     LET g_rtr3[g_cnt].rtr12=g_rtr[g_cnt].rtr12
                     LET g_rtr3[g_cnt].rtr14=g_rtr[g_cnt].rtr14
                     LET g_rtr3[g_cnt].rtr15=g_rtr[g_cnt].rtr15
           WHEN "4"  LET g_rtr4[g_cnt].rtr05=g_rtr[g_cnt].rtr05
                     LET g_rtr4[g_cnt].rtr06=g_rtr[g_cnt].rtr06
                     LET g_rtr4[g_cnt].rtr06_desc=g_rtr[g_cnt].rtr06_desc
                     LET g_rtr4[g_cnt].rtr08=g_rtr[g_cnt].rtr08
                     LET g_rtr4[g_cnt].rtr09=g_rtr[g_cnt].rtr09
                     LET g_rtr4[g_cnt].rtr11=g_rtr[g_cnt].rtr11
                     LET g_rtr4[g_cnt].rtr12=g_rtr[g_cnt].rtr12
                     LET g_rtr4[g_cnt].rtr13=g_rtr[g_cnt].rtr13
           WHEN "5"  LET g_rtr5[g_cnt].rtr05=g_rtr[g_cnt].rtr05
                     LET g_rtr5[g_cnt].rtr06=g_rtr[g_cnt].rtr06
                     LET g_rtr5[g_cnt].rtr06_desc=g_rtr[g_cnt].rtr06_desc
                     LET g_rtr5[g_cnt].rtr07=g_rtr[g_cnt].rtr07
                     LET g_rtr5[g_cnt].rtr10=g_rtr[g_cnt].rtr10
           WHEN "6"  IF g_rtr[g_cnt].rtr17='Y' THEN
                        SELECT azp02 INTO g_rtr6[g_cnt].rtr19_desc
                            FROM azp_file 
                            WHERE azp01 = g_rtr[g_cnt].rtr19
                        LET g_rtr6[g_cnt].rtr19=g_rtr[g_cnt].rtr19
                     END IF
                     LET g_rtr7.rtr06 = g_rtr[g_cnt].rtr06
                     LET g_rtr7.rtr08 = g_rtr[g_cnt].rtr08
                     LET g_rtr7.rtr16 = g_rtr[g_cnt].rtr16
                     LET g_rtr7.rtr17 = g_rtr[g_cnt].rtr17
                     LET g_rtr6[g_cnt].rtr05=g_rtr[g_cnt].rtr05
                     LET g_rtr6[g_cnt].rtr18=g_rtr[g_cnt].rtr18
                     LET g_rtr6[g_cnt].rtr10=g_rtr[g_cnt].rtr10
           END CASE
        LET g_cnt = g_cnt + 1
        IF g_cnt > g_max_rec THEN
           CALL cl_err( '', 9035, 0 )
           EXIT FOREACH
        END IF
    END FOREACH
 
    CASE p_choice
      WHEN "1"
         CALL g_rtr1.deleteElement(g_cnt)
         LET g_rec_b4 = g_cnt-1
         DISPLAY g_rec_b4 TO FORMONLY.cn2
      WHEN "2"
         CALL g_rtr2.deleteElement(g_cnt)
         LET g_rec_b5 = g_cnt-1
         DISPLAY g_rec_b5 TO FORMONLY.cn2
      WHEN "3"
         CALL g_rtr3.deleteElement(g_cnt)
         LET g_rec_b6 = g_cnt-1
         DISPLAY g_rec_b6 TO FORMONLY.cn2
      WHEN "4"
         CALL g_rtr4.deleteElement(g_cnt)
         LET g_rec_b7 = g_cnt-1
         DISPLAY g_rec_b7 TO FORMONLY.cn2
      WHEN "5"
         CALL g_rtr5.deleteElement(g_cnt)
         LET g_rec_b8 = g_cnt-1
         DISPLAY g_rec_b8 TO FORMONLY.cn2
      WHEN "6"
         CALL g_rtr6.deleteElement(g_cnt)
         LET g_rec_b9 = g_cnt-1
         DISPLAY g_rec_b9 TO FORMONLY.cn2        
    END CASE
    MESSAGE ""
    LET g_cnt = 0
END FUNCTION 
 
#頁簽九show
FUNCTION i130_b9_show()
 
     CALL i130_b4_fill(g_wc9,'6')
     LET g_rtr7_o.*=g_rtr7.*
     DISPLAY g_rtr7.rtr06 TO rtr06_5
     DISPLAY g_rtr7.rtr08 TO rtr08_5
     DISPLAY g_rtr7.rtr16 TO rtr16_5
     DISPLAY g_rtr7.rtr17 TO rtr17_5
     CALL i130_rtr06('d','6')
     IF g_rtr7.rtr17 = 'N' THEN
        CALL cl_set_comp_visible("rtr19_5,rtr19_5_desc",FALSE)
     ELSE
        CALL cl_set_comp_visible("rtr19_5,rtr19_5_desc",TRUE)
     END IF
END FUNCTION
 
FUNCTION i130_a()   
DEFINE li_result   LIKE type_file.num5
 
   MESSAGE ""
   CLEAR FORM
   CALL g_rtq.clear()
   CALL g_rtq.clear()
   CALL g_rtq1.clear()
   CALL g_rtr2.clear()
   CALL g_rtr3.clear()
   CALL g_rtr4.clear()
   CALL g_rtr5.clear()
   CALL g_rtr6.clear()
   INITIALIZE g_rtr7.* TO NULL
   
   LET g_wc = NULL 
   LET g_wc1 = NULL
   LET g_wc2 = NULL 
   LET g_wc3 = NULL
   LET g_wc4 = NULL 
   LET g_wc5 = NULL
   LET g_wc6 = NULL 
   LET g_wc7 = NULL
   LET g_wc8 = NULL 
   LET g_wc9 = NULL
   
   IF s_shut(0) THEN
      RETURN
   END IF
 
   INITIALIZE g_rto.* LIKE rto_file.*                    
   LET g_rto_t.* = g_rto.*   #FUN-B50026 add
   CALL cl_opmsg('a')
   LET g_change = 'N'        #TQC-C20433 add
 
   WHILE TRUE
      LET g_rto.rto02 = 0             #版本號
      LET g_rto.rto08 = g_today       #生效日期
      LET g_rto.rto10 = g_today       #簽訂日期
      LET g_rto.rto18 = g_user        #簽訂人
      LET g_rto.rtoconf = 'N'         #審核碼
      LET g_rto.rtoplant = g_plant    #當前機構
      LET g_rto.rto03  = g_plant      #簽訂機構
      LET g_rto.rto900 = '0'          #狀況碼
      LET g_rto.rtomksg = 'N'         #簽核    #TQC-AB0216
      LET g_rto.rtouser=g_user        
      LET g_rto.rtooriu = g_user #FUN-980030
      LET g_rto.rtoorig = g_grup #FUN-980030
      LET g_rto.rtogrup=g_grup
      LET g_rto.rtocrat=g_today
      LET g_rto.rtoacti='Y'   
      LET g_data_plant = g_plant  #TQC-A10128 ADD
      SELECT azw02 INTO g_rto.rtolegal FROM azw_file
       WHERE azw01 = g_plant
      
    # DISPLAY BY NAME g_rto.rto03,g_rto.rtoplant,g_rto.rto900,#TQC-AB0216 
      DISPLAY BY NAME g_rto.rto03,g_rto.rtoplant,#TQC-AB0216
                      g_rto.rtoconf,g_rto.rtouser,g_rto.rtogrup,
                      g_rto.rtocrat,g_rto.rtoacti
                     ,g_rto.rtooriu,g_rto.rtoorig               #TQC-A30028 ADD
                      
      CALL i130_rtoplant('d')  #當前機構
      CALL i130_rto03('d')     #簽訂機構
      CALL i130_rto18('d')     #簽訂人
      
      LET g_rto_t.* = g_rto.*
      LET g_rto_o.* = g_rto.*
      CALL i130_i("a")                          
 
      IF INT_FLAG THEN                          
         INITIALIZE g_rto.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         EXIT WHILE
      END IF
 
      IF cl_null(g_rto.rto01) THEN       
         CONTINUE WHILE
      END IF
 
      BEGIN WORK
#     CALL s_auto_assign_no("axm",g_rto.rto01,g_today,"","rto_file","rto01,rto02,rto03,rtoplant","","","")  #FUN-A70130 mark
      CALL s_auto_assign_no("art",g_rto.rto01,g_today,"A3","rto_file","rto01,rto02,rto03,rtoplant","","","")  #FUN-A70130 mod
          RETURNING li_result,g_rto.rto01
       IF (NOT li_result) THEN                                                                           
           CONTINUE WHILE                                                                     
       END IF
       DISPLAY BY NAME g_rto.rto01
      INSERT INTO rto_file VALUES (g_rto.*)
      IF SQLCA.sqlcode THEN                     
         CALL cl_err3("ins","rto_file",g_rto.rto01,"",SQLCA.sqlcode,"","",1)  
         CONTINUE WHILE
      ELSE
         COMMIT WORK                                                   
      END IF
      
      SELECT * INTO g_rto.* FROM rto_file
       WHERE rto01 = g_rto.rto01 AND rto02=g_rto.rto02 
         AND rto03=g_rto.rto03 AND rtoplant=g_rto.rtoplant
               
      LET g_rto_t.* = g_rto.*
      LET g_rto_o.* = g_rto.*
      
#FUN-B80123-------------STA-------------
      CALL g_rtp.clear()
      LET g_rec_b1 = 0  
      LET g_rec_b2 = 0 
      LET g_rec_b3 = 0 
      LET g_rec_b4 = 0 
      LET g_rec_b5 = 0 
      LET g_rec_b6 = 0 
      LET g_rec_b7 = 0 
      LET g_rec_b8 = 0 
      LET g_rec_b9 = 0   
      CALL i130_b_all()
      CALL i130_delall()
#FUN-B80123-------------END-------------
#FUN-B80123-------------STA-------------
#      CALL i130_b('1')  
#      IF g_intflag THEN
#         RETURN
#      END IF
#      CALL g_rtq.clear() 
#      LET g_rec_b2 = 0  
#      CALL i130_b('2')
#      IF g_intflag THEN
#         RETURN
#      END IF
#      CALL g_rtq1.clear()
#      LET g_rec_b3 = 0  
#      CALL i130_b('3')
#      IF g_intflag THEN
#         RETURN
#      END IF
#      CALL g_rtr1.clear()
#      LET g_rec_b4 = 0  
#      CALL i130_b('4')
#      IF g_intflag THEN
#         RETURN
#      END IF
#      CALL g_rtr2.clear()
#      LET g_rec_b5 = 0  
#      CALL i130_b('5')
#      IF g_intflag THEN
#         RETURN
#      END IF
#      CALL g_rtr3.clear()
#      LET g_rec_b6 = 0  
#      CALL i130_b('6')
#      IF g_intflag THEN
#         RETURN
#      END IF
#      CALL g_rtr4.clear()
#      LET g_rec_b7 = 0  
#      CALL i130_b('7')
#      IF g_intflag THEN
#         RETURN
#      END IF
#      CALL g_rtr5.clear()
#      LET g_rec_b8 = 0  
#      CALL i130_b('8')  
#      IF g_intflag THEN
#         RETURN
#      END IF
#      CALL i130_b9_a()
#      IF g_intflag THEN
#         RETURN
#      END IF             
#      CALL i130_expandcheck()
#      CALL i130_b('9')
#      IF g_intflag THEN
#         RETURN
#      END IF
#FUN-B80123-------------END-------------
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i130_i(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1,     
            l_input   LIKE type_file.chr1,          
            l_n       LIKE type_file.num5,           
            li_result    LIKE type_file.num5
   CALL cl_set_head_visible("","YES")
   
   INPUT BY NAME g_rto.rto06,g_rto.rto01,g_rto.rto02,g_rto.rto04,
                 g_rto.rto05,g_rto.rto07,g_rto.rto08,g_rto.rto09,
                 g_rto.rto10,g_rto.rto12,g_rto.rto13,g_rto.rto14,
                 g_rto.rto15,g_rto.rto16,g_rto.rto17,g_rto.rto18,
             #   g_rto.rto19,g_rto.rtomksg,g_rto.rto20     #TQC-AB0216   
                 g_rto.rto19,g_rto.rto20     #TQC-AB0216  
      WITHOUT DEFAULTS
 
      BEFORE INPUT       
          LET g_before_input_done = FALSE
          CALL i130_set_entry(p_cmd)
          CALL i130_set_no_entry(p_cmd)
          CALL cl_set_docno_format("rto01")
          LET g_before_input_done = TRUE
	
      AFTER FIELD rto01
         IF NOT cl_null(g_rto.rto01) THEN
            IF p_cmd = "a" OR                    
               (p_cmd = "u" AND g_rto.rto01 != g_rto_t.rto01) THEN
#              CALL s_check_no("axm",g_rto.rto01,g_rto_t.rto01,"A3","rto_file","rto01,rto02,rto03,rtoplant","") #FUN-A70130 mark
               CALL s_check_no("art",g_rto.rto01,g_rto_t.rto01,"A3","rto_file","rto01,rto02,rto03,rtoplant","") #FUN-A70130 mod
                    RETURNING li_result,g_rto.rto01
               IF (NOT li_result) THEN                                                            
                  LET g_rto.rto01=g_rto_t.rto01                                                                 
                  NEXT FIELD rto01                                                                                      
               END IF             
           END IF
        END IF
     AFTER FIELD rto05
        IF NOT cl_null(g_rto.rto05) THEN
           IF p_cmd = "a" OR (p_cmd = "u" AND               
              g_rto.rto05 <> g_rto_o.rto05 OR cl_null(g_rto_o.rto05)) THEN
               CALL i130_rto05('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rto.rto05,g_errno,0)
                  NEXT FIELD rto05 
               ELSE
                  IF NOT cl_null(g_pmc17) AND cl_null(g_rto.rto07) THEN
                     LET g_rto.rto07 = g_pmc17
                     DISPLAY BY NAME g_rto.rto07
                     CALL i130_rto07('a')
                     IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_rto.rto07,g_errno,0)
                     END IF
                  END IF
                  LET g_rto_o.rto05 = g_rto.rto05             
               END IF
           END IF
        ELSE
           LET g_rto_o.rto05 = ''
           DISPLAY '' TO rto05_desc
        END IF
         
     AFTER FIELD rto07
        IF NOT cl_null(g_rto.rto07) THEN
           IF p_cmd = "a" OR (p_cmd = "u" AND                   
              g_rto.rto07 != g_rto_o.rto07 OR cl_null(g_rto_o.rto07)) THEN
               CALL i130_rto07('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rto.rto07,g_errno,0)
                  NEXT FIELD rto07
               ELSE
                  LET g_rto_o.rto07 = g_rto.rto07
               END IF
           END IF
        ELSE
          LET g_rto_o.rto07 = ''
          DISPLAY '' TO rto07_desc
        END IF
     
     AFTER FIELD rto08,rto09
        IF NOT cl_null(g_rto.rto08) AND NOT cl_null(g_rto.rto09) THEN
           IF g_rto.rto08>=g_rto.rto09 THEN
              CALL cl_err('','art-108',0)
              NEXT FIELD CURRENT
           END IF
        END IF
               
     AFTER FIELD rto17
        IF NOT cl_null(g_rto.rto17) THEN
           IF p_cmd = "a" OR (p_cmd = "u" AND                   
              g_rto.rto17 != g_rto_o.rto17 OR cl_null(g_rto_o.rto17)) THEN
              
               CALL i130_rto17('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rto.rto17,g_errno,0)
                  NEXT FIELD rto17
               ELSE
                  LET g_rto_o.rto17 = g_rto.rto17
               END IF
           END IF
        ELSE
          LET g_rto_o.rto17 = ''
          DISPLAY '' TO rto17_desc
        END IF
     
     AFTER FIELD rto18
        IF NOT cl_null(g_rto.rto18) THEN
           IF p_cmd = "a" OR (p_cmd = "u" AND                   
              g_rto.rto18 != g_rto_o.rto18 OR cl_null(g_rto_o.rto18)) THEN
               CALL i130_rto18('a')
               IF NOT cl_null(g_errno) THEN
                  CALL cl_err(g_rto.rto18,g_errno,0)
                  NEXT FIELD rto18
               ELSE
                  LET g_rto_o.rto18 = g_rto.rto18
               END IF
           END IF
         ELSE
           DISPLAY '' TO rto18_desc
         END IF
         
         
     AFTER INPUT
            IF INT_FLAG THEN
               EXIT INPUT
            END IF
            IF cl_null(g_rto.rto01) OR cl_null(g_rto.rto03) THEN
               DISPLAY BY NAME g_rto.rto01
               LET l_input='Y'
            END IF
            IF l_input='Y' THEN
               NEXT FIELD rto01
            END IF
 
      ON ACTION CONTROLO                        
         IF INFIELD(rto01) THEN
            LET g_rto.* = g_rto_t.*
            CALL i130_show()
            NEXT FIELD rto01
         END IF
 
     ON ACTION controlp
        CASE
           WHEN INFIELD(rto01)  #合同編號
                LET g_t1=s_get_doc_no(g_rto.rto01)
                CALL q_oay(FALSE,FALSE,g_t1,'A3','art') RETURNING g_t1     #FUN-A70130 
                LET g_rto.rto01=g_t1                                                                                             
                DISPLAY BY NAME g_rto.rto01                                                                                      
                NEXT FIELD rto01
           WHEN INFIELD(rto05) #供應商編號
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_pmc3"
              LET g_qryparam.default1 = g_rto.rto05
              CALL cl_create_qry() RETURNING g_rto.rto05
              DISPLAY BY NAME g_rto.rto05
              CALL i130_rto05('a')
              NEXT FIELD rto05
           WHEN INFIELD(rto07) #付款方式
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_ryd01"
              LET g_qryparam.default1 = g_rto.rto07
              CALL cl_create_qry() RETURNING g_rto.rto07
              DISPLAY BY NAME g_rto.rto07
              CALL i130_rto07('a')
              NEXT FIELD rto07
           WHEN INFIELD(rto17) #簽訂人(供應商)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_rto.rto17
              CALL cl_create_qry() RETURNING g_rto.rto17
              DISPLAY BY NAME g_rto.rto17
              CALL i130_rto17('a')
              NEXT FIELD rto17
            WHEN INFIELD(rto18) #簽訂人(內部)
              CALL cl_init_qry_var()
              LET g_qryparam.form = "q_gen"
              LET g_qryparam.default1 = g_rto.rto18
              CALL cl_create_qry() RETURNING g_rto.rto18
              DISPLAY BY NAME g_rto.rto18
              CALL i130_rto18('a')
              NEXT FIELD rto18
           OTHERWISE
              EXIT CASE
        END CASE
 
   ON ACTION CONTROLR
      CALL cl_show_req_fields()
 
      ON ACTION CONTROLG
         CALL cl_cmdask()
 
      ON ACTION CONTROLF                       
         CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name 
         CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE INPUT
 
      ON ACTION about         
         CALL cl_about()      
 
      ON ACTION help         
         CALL cl_show_help() 
 
 
   END INPUT
 
END FUNCTION
 
FUNCTION i130_set_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1          
 
     IF p_cmd = 'a'  AND (NOT g_before_input_done) THEN
         CALL cl_set_comp_entry("rto01",TRUE)
     END IF
     IF g_change = 'Y' THEN
        CALL cl_set_comp_entry("rto05,rto06",FALSE)
     ELSE
        CALL cl_set_comp_entry("rto05,rto06",TRUE)
     END IF
 
END FUNCTION
 
FUNCTION i130_set_no_entry(p_cmd)
   DEFINE   p_cmd     LIKE type_file.chr1         
    IF p_cmd = 'u' AND g_chkey = 'N' AND (NOT g_before_input_done) THEN
       CALL cl_set_comp_entry("rto01",FALSE)
       
    END IF
 
END FUNCTION
 
FUNCTION i130_b(p_choice) #驅動其他頁簽
DEFINE p_choice LIKE type_file.chr1
                
        LET g_action_choice=""
        IF s_shut(0) THEN 
           RETURN
        END IF
        
        IF cl_null(g_rto.rto01) THEN
           RETURN 
        END IF
        
        SELECT * INTO g_rto.* FROM rto_file
         WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
           AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
        
        IF g_rto.rtoacti='N' THEN 
           CALL cl_err(g_rto.rto01,'mfg1000',0)
           RETURN 
        END IF
 
       IF g_rto.rtoconf <>'N' THEN
          CALL cl_err('',9022,0)
          RETURN
       END IF
       CALL cl_opmsg('b')
        
       LET l_allow_insert=cl_detail_input_auth("insert")
       LET l_allow_delete=cl_detail_input_auth("delete")
        
       LET g_sql2 =  " FROM rtr_file",
                     " WHERE rtr01=? AND rtr02=? ",
                     "   AND rtr03=? AND rtrplant=?",
                     "   AND rtr05=?"
        CASE p_choice
          WHEN "1"      
             LET g_forupd_sql="SELECT  rtp04,rtp05,''",
                              " FROM rtp_file",
                              " WHERE rtp01=? AND rtp02=? ",
                              "   AND rtp03=? AND rtpplant=?",
                              "   AND rtp04=? FOR UPDATE "
             LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
          WHEN "2"
             LET g_forupd_sql="SELECT  rtq04,rtq06,''",
                        " FROM rtq_file",
                        " WHERE rtq01=? AND rtq02=? ",
                        "   AND rtq03=? AND rtqplant=?",
                        "   AND rtq04=? AND rtq05='1' FOR UPDATE"
             LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
          WHEN "3"     
             LET g_forupd_sql="SELECT  rtq04,rtq06,''",
                        " FROM rtq_file",
                        " WHERE rtq01=? AND rtq02=? ",
                        "   AND rtq03=? AND rtqplant=?",
                        " AND rtq04=? AND rtq05='2' FOR UPDATE"
             LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
          WHEN "4" 
            LET g_forupd_sql="SELECT  rtr05,rtr06,'',rtr07,rtr10",g_sql2 CLIPPED,
                            " AND rtr04='1' FOR UPDATE"
            LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
          WHEN "5"
            LET g_forupd_sql="SELECT  rtr05,rtr06,'',rtr08,rtr09,rtr10",g_sql2 CLIPPED,
                              " AND rtr04='2' FOR UPDATE"
            LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
          WHEN "6"
            LET g_forupd_sql="SELECT  rtr05,rtr06,'',rtr08,rtr09,rtr11,rtr12,rtr14,rtr15",g_sql2 CLIPPED,
                             " AND rtr04='3' FOR UPDATE"
            LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
          WHEN "7"
            LET g_forupd_sql="SELECT  rtr05,rtr06,'',rtr08,rtr09,rtr11,rtr12,rtr13",g_sql2 CLIPPED,
                             " AND rtr04='4' FOR UPDATE" 
            LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
          WHEN "8"
            LET g_forupd_sql="SELECT  rtr05,rtr06,'',rtr07,rtr10",g_sql2 CLIPPED,
                              " AND rtr04='5' FOR UPDATE"
            LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
          WHEN "9"
            LET g_forupd_sql="SELECT  rtr05,rtr18,rtr19,'',rtr10",g_sql2 CLIPPED,
                             " AND rtr04='6' FOR UPDATE"
            LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
 
        END CASE
        
        DECLARE i130_bcl CURSOR FROM g_forupd_sql
        
        CASE p_choice
          WHEN "1" CALL i130_b1()
          WHEN "2" CALL i130_b2_fill(g_wc2)             #MOD-B10196
                   CALL i130_b2()
          WHEN "3" CALL i130_b3_fill(g_wc3)             #MOD-B10196
                   CALL i130_b3()
          WHEN "4" CALL i130_b4_fill(g_wc4,'1')         #MOD-B10196
                   CALL i130_b4()
          WHEN "5" CALL i130_b4_fill(g_wc5,'2')         #MOD-B10196
                   CALL i130_b5()
          WHEN "6" CALL i130_b4_fill(g_wc6,'3')         #MOD-B10196
                   CALL i130_b6()
          WHEN "7" CALL i130_b4_fill(g_wc7,'4')         #MOD-B10196
                   CALL i130_b7()
          WHEN "8" CALL i130_b4_fill(g_wc8,'5')         #MOD-B10196
                   CALL i130_b8()
          WHEN "9" CALL i130_b4_fill(g_wc9,'6')         #MOD-B10196
                   CALL i130_b9()
        END CASE        
 
       CLOSE i130_bcl
       COMMIT WORK
       CALL i130_delall()
       CALL i130_show()
END FUNCTION                 
 
FUNCTION i130_chkrtp05()
DEFINE l_azw07 LIKE azw_file.azw07
DEFINE l_n     LIKE type_file.num5    
#DEFINE l_dbs   LIKE azp_file.azp03    #FUN-A50102
DEFINE l_sql STRING
 
       LET g_errno=''
       SELECT COUNT(*) INTO l_n FROM rtp_file
        WHERE rtp01 = g_rto.rto01
          AND rtp05 = g_rtp[l_ac].rtp05
          AND rtp04 <> g_rtp[l_ac].rtp04
       IF l_n >0 THEN
          LET g_errno = '-239'
       END IF
       IF cl_null(g_errno) THEN
          IF g_rtp[l_ac].rtp05 <> g_rto.rtoplant THEN
             SELECT azw07 INTO l_azw07 FROM azw_file 
              WHERE azw01=g_rtp[l_ac].rtp05     
             IF NOT cl_null(l_azw07) THEN
                IF l_azw07<>g_rto.rtoplant THEN
                   LET g_errno='art-071'
                 END IF
             ELSE
                 LET g_errno='art-071'
             END IF
          END IF
       END IF
       IF cl_null(g_errno) THEN
         #SELECT azp03 INTO l_dbs FROM azp_file          #FUN-A50102 mark
         # WHERE azp01 = g_rtp[l_ac].rtp05               #FUN-A50102 mark
          LET l_sql="SELECT COUNT(rto_file.rto01) FROM ",
             #s_dbstring(l_dbs CLIPPED),"rto_file,",s_dbstring(l_dbs CLIPPED),"rtp_file ",    #FUN-A50102 mark
              cl_get_target_table(g_rtp[l_ac].rtp05,'rto_file'),",",                          #FUN-A50102
              cl_get_target_table(g_rtp[l_ac].rtp05,'rtp_file'),                              #FUN-A50102 
              " WHERE rto01=rtp01 AND rto02=rtp02 AND rto03=rtp03 AND rtoplant=rtpplant",                 
              " AND rto05=? AND rto06=?",
              " AND (rto08 BETWEEN ? AND ? OR rto09 BETWEEN ? AND ?)",
              " AND rtp05=? AND rtoplant=? AND rtoconf<>'X'",
              " AND rtp04 <> ? "     #FUN-BC0010 add
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql                      #FUN-A50102 
         CALL cl_parse_qry_sql(l_sql,g_rtp[l_ac].rtp05) RETURNING l_sql    #FUN-A50102
         PREPARE rtp05_cs1 FROM l_sql
         EXECUTE rtp05_cs1 INTO l_n USING g_rto.rto05,g_rto.rto06,
                              g_rto.rto08,g_rto.rto09,g_rto.rto08,g_rto.rto09,
                              g_rtp[l_ac].rtp05,g_rtp[l_ac].rtp05,
                              g_rtp[l_ac].rtp04     #FUN-BC0010 add    
         IF sqlca.sqlcode THEN
            LET g_errno = SQLCA.sqlcode
         ELSE
           IF l_n>0 THEN
            LET g_errno = 'art-072'
           END IF
         END IF                     
       END IF
END FUNCTION
 
FUNCTION i130_b1()
DEFINE l_ac_t  LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_cnt   LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1     
       IF cl_null(g_rto.rto01) THEN
          RETURN 
       END IF
        
       SELECT * INTO g_rto.* FROM rto_file
        WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
          AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
        
       IF g_rto.rtoacti='N' THEN 
          CALL cl_err(g_rto.rto01,'mfg1000',0)
          RETURN 
       END IF
       INPUT ARRAY g_rtp WITHOUT DEFAULTS FROM s_b1.*
             ATTRIBUTE(COUNT=g_rec_b1,MAXCOUNT=g_max_rec,UNBUFFERED,
                       INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                       APPEND ROW= l_allow_insert)
       BEFORE INPUT
        IF g_rec_b1 !=0 THEN 
           CALL fgl_set_arr_curr(l_ac)
        END IF
       BEFORE ROW
        LET p_cmd =''
        LET l_ac =ARR_CURR()
        LET l_lock_sw ='N'
        LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF
                
                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err("",SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b1 >=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rtp_t.*=g_rtp[l_ac].*
                        LET g_rtp_o.*=g_rtp[l_ac].*
                        OPEN i130_bcl USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtp_t.rtp04
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl INTO g_rtq[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtp05('d')
                        END IF
                 END IF
                 
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtp[l_ac].* TO NULL
                LET g_rtp_t.*=g_rtp[l_ac].*
                LET g_rtp_o.*=g_rtp[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtp04
                
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtp[l_ac].rtp05) THEN
                INSERT INTO rtp_file(rtp01,rtp02,rtp03,rtp04,rtp05,rtpplant,rtplegal)
                     VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,
                            g_rtp[l_ac].rtp04,g_rtp[l_ac].rtp05,
                            g_rto.rtoplant,g_rto.rtolegal)                       
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rtp_file",'','',SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b1=g_rec_b1+1
                        DISPLAY g_rec_b1 TO FORMONLY.cn2
                END IF
                END IF
                
      BEFORE FIELD rtp04
        IF cl_null(g_rtp[l_ac].rtp04) OR g_rtp[l_ac].rtp04=0 THEN 
            SELECT MAX(rtp04)+1 INTO g_rtp[l_ac].rtp04 FROM rtp_file
                WHERE rtp01=g_rto.rto01 AND rtp02 = g_rto.rto02 
                  AND rtp03=g_rto.rto03 AND rtpplant = g_rto.rtoplant
                IF cl_null(g_rtp[l_ac].rtp04) THEN
                        LET g_rtp[l_ac].rtp04=1
                END IF
         END IF
         
      AFTER FIELD rtp04
        IF NOT cl_null(g_rtp[l_ac].rtp04) THEN 
           IF g_rtp[l_ac].rtp04<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtp[l_ac].rtp04=g_rtp_t.rtp04
              NEXT FIELD rtp04
           END IF
                IF p_cmd='a' OR 
                   (p_cmd='u' AND g_rtp[l_ac].rtp04!=g_rtp_t.rtp04) THEN                       
                      SELECT COUNT(*) INTO l_cnt FROM rtp_file
                        WHERE rtp01= g_rto.rto01 AND rtp02=g_rto.rto02
                          AND rtp03= g_rto.rto03 AND rtpplant=g_rto.rtoplant
                          AND rtp04= g_rtp[l_ac].rtp04 
                       IF l_cnt>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtp[l_ac].rtp04=g_rtp_t.rtp04
                           NEXT FIELD rtp04
                       END IF
                 END IF
         END IF
       
       AFTER FIELD rtp05
          IF NOT cl_null(g_rtp[l_ac].rtp05) THEN 
             IF p_cmd='a' OR (p_cmd='u' AND
                g_rtp[l_ac].rtp05!=g_rtp_o.rtp05 OR cl_null(g_rtp_o.rtp05)) THEN
                   CALL i130_rtp05('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtp[l_ac].rtp05,g_errno,0)  
                      NEXT FIELD rtp05
                   ELSE
                      CALL i130_chkrtp05()
                      IF NOT cl_null(g_errno) THEN
                        CALL cl_err(g_rtp[l_ac].rtp05,g_errno,0)  
                        NEXT FIELD rtp05
                      ELSE
                        LET g_rtp_o.rtp05=g_rtp[l_ac].rtp05
                      END IF
                   END IF
            END IF
         ELSE
           LET g_rtp_o.rtp05=''
           LET g_rtp[l_ac].rtp05_desc=''
           DISPLAY BY NAME g_rtp[l_ac].rtp05_desc
         END IF
           
       BEFORE DELETE                      
           IF g_rtp_t.rtp04 > 0 AND (NOT cl_null(g_rtp_t.rtp04)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtp_file
               WHERE rtp01 = g_rto.rto01 AND rtp02 = g_rto.rto02 
                 AND rtp03 = g_rto.rto03 AND rtpplant = g_rto.rtoplant
                 AND rtp04 = g_rtp_t.rtp04
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtp_file","","",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b1=g_rec_b1-1
              DISPLAY g_rec_b1 TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtp[l_ac].* = g_rtp_t.*
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtp[l_ac].* = g_rtp_t.*
           ELSE
            IF cl_null(g_rtp[l_ac].rtp05) THEN
               DELETE FROM rtp_file
               WHERE rtp01 = g_rto.rto01 AND rtp02 = g_rto.rto02 
                 AND rtp03 = g_rto.rto03 AND rtpplant=g_rto.rtoplant 
                 AND rtp04 = g_rtp_t.rtp04
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtp_file","","",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
              ELSE
                 MESSAGE 'DELETE Ok'
                 COMMIT WORK
                 CALL g_rtp.deleteelement(l_ac)
                 LET g_rec_b1=g_rec_b1-1
                 DISPLAY g_rec_b1 TO FORMONLY.cn2
              END IF
            ELSE
              UPDATE rtp_file SET rtp04=g_rtp[l_ac].rtp04,
                                  rtp05=g_rtp[l_ac].rtp05
                 WHERE rtp01=g_rto.rto01 AND rtp02=g_rto.rto02 
                   AND rtp03=g_rto.rto03 AND rtpplant=g_rto.rtoplant
                   AND rtp04=g_rtp_t.rtp04
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtp_file","","",SQLCA.sqlcode,"","",1) 
                 LET g_rtp[l_ac].* = g_rtp_t.*
              ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,
                                      rtodate = g_rto.rtodate
                   WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02 
                     AND rto03 = g_rto.rto03 AND rtoplant=g_rto.rtoplant
                 
                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
            END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtp[l_ac].rtp05) THEN
              CALL g_rtp.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtp[l_ac].* = g_rtp_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i130_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rtp04) AND l_ac > 1 THEN
              LET g_rtp[l_ac].* = g_rtp[l_ac-1].*
              LET g_rtp[l_ac].rtp04 = g_rec_b1 + 1
              NEXT FIELD rtp04
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rtp05)                    
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_azp" 
               LET g_qryparam.default1 = g_rtp[l_ac].rtp05
               LET g_qryparam.where = "azp01 IN ",g_auth     #TQC-AC0095  
               CALL cl_create_qry() RETURNING g_rtp[l_ac].rtp05
               DISPLAY BY NAME g_rtp[l_ac].rtp05
               CALL i130_rtp05('d')
               NEXT FIELD rtp05
            OTHERWISE EXIT CASE
          END CASE
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  

    END INPUT
END FUNCTION
 
FUNCTION i130_b2()
DEFINE l_ac_t  LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_cnt   LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1
        
        INPUT ARRAY g_rtq WITHOUT DEFAULTS FROM s_b2.*
                ATTRIBUTE(COUNT=g_rec_b2,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b2 !=0 THEN 
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF
                
                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err("",SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b2 >=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rtq_t.*=g_rtq[l_ac].*
                        LET g_rtq_o.*=g_rtq[l_ac].*
                        
                        OPEN i130_bcl USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtq_t.rtq04
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl INTO g_rtq[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtq06('d')
                        END IF
                 END IF
                 
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtq[l_ac].* TO NULL
                LET g_rtq_t.*=g_rtq[l_ac].*
                LET g_rtq_o.*=g_rtq[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtq04
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtq[l_ac].rtq06) THEN
                INSERT INTO rtq_file(rtq01,rtq02,rtq03,rtq04,rtq05,rtq06,rtqplant,rtqlegal)
                     VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rtq[l_ac].rtq04,
                            '1',g_rtq[l_ac].rtq06,g_rto.rtoplant,g_rto.rtolegal)                       
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rtq_file",'','',SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b2=g_rec_b2+1
                        DISPLAY g_rec_b2 TO FORMONLY.cn2
                END IF
                END IF
                
      BEFORE FIELD rtq04
        IF cl_null(g_rtq[l_ac].rtq04) OR g_rtq[l_ac].rtq04=0 THEN 
            SELECT MAX(rtq04)+1 INTO g_rtq[l_ac].rtq04 FROM rtq_file
             WHERE rtq01=g_rto.rto01 AND rtq02 = g_rto.rto02 
               AND rtq03=g_rto.rto03 AND rtqplant=g_rto.rtoplant
               AND rtq05='1'
            IF cl_null(g_rtq[l_ac].rtq04) THEN
               LET g_rtq[l_ac].rtq04=1
            END IF
         END IF
         
      AFTER FIELD rtq04
        IF NOT cl_null(g_rtq[l_ac].rtq04) THEN 
           IF g_rtq[l_ac].rtq04<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtq[l_ac].rtq04=g_rtq_t.rtq04
              NEXT FIELD rtq04
           END IF
                IF p_cmd='a' OR 
                   (p_cmd='u' AND g_rtq[l_ac].rtq04!=g_rtq_t.rtq04) THEN                       
                      SELECT COUNT(*) INTO l_cnt FROM rtq_file
                        WHERE rtq01= g_rto.rto01 AND rtq02=g_rto.rto02
                          AND rtq03= g_rto.rto03 AND rtqplant=g_rto.rtoplant
                          AND rtq04= g_rtq[l_ac].rtq04 AND rtq05='1'
                       IF l_cnt>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtq[l_ac].rtq04=g_rtq_t.rtq04
                           NEXT FIELD rtq04
                       END IF
                 END IF
         END IF
        
       AFTER FIELD rtq06
          IF NOT cl_null(g_rtq[l_ac].rtq06) THEN 
                IF p_cmd='a' OR (p_cmd='u' AND
                   g_rtq[l_ac].rtq06!=g_rtq_o.rtq06 OR cl_null(g_rtq_o.rtq06)) THEN
                   SELECT COUNT(*) INTO l_cnt FROM rtq_file
                        WHERE rtq01= g_rto.rto01 AND rtq02=g_rto.rto02
                          AND rtq03= g_rto.rto03 AND rtqplant=g_rto.rtoplant
                          AND rtq06= g_rtq[l_ac].rtq06 AND rtq05='1'
                   IF l_cnt>0 THEN
                           CALL cl_err('','art-194',0)
                           LET g_rtq[l_ac].rtq06=g_rtq_t.rtq06
                           NEXT FIELD rtq06
                   ELSE
                   CALL i130_rtq06('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtq[l_ac].rtq06,g_errno,0)  
                      LET g_rtq[l_ac].rtq06 = g_rtq_t.rtq06
                      DISPLAY BY NAME g_rtq[l_ac].rtq06
                      NEXT FIELD rtq06
                   ELSE
                      LET g_rtq_o.rtq06=g_rtq[l_ac].rtq06
                   END IF
                   END IF
                 END IF
           ELSE
             LET g_rtq_o.rtq06=''
             LET g_rtq[l_ac].rtq06_desc=''
             DISPLAY BY NAME g_rtq[l_ac].rtq06_desc
           END IF
            
       BEFORE DELETE                      
           IF g_rtq_t.rtq04 > 0 AND (NOT cl_null(g_rtq_t.rtq04)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtq_file
               WHERE rtq01 = g_rto.rto01 AND rtq02 = g_rto.rto02 
                 AND rtq03 = g_rto.rto03 AND rtqplant = g_rto.rtoplant
                 AND rtq05 = '1' AND rtq04 = g_rtq_t.rtq04 
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtq_file","","",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b2=g_rec_b2-1
              DISPLAY g_rec_b2 TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtq[l_ac].* = g_rtq_t.*
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtq[l_ac].* = g_rtq_t.*
           ELSE
             IF cl_null(g_rtq[l_ac].rtq06) THEN
              DELETE FROM rtq_file
               WHERE rtq01 = g_rto.rto01 AND rtq02 = g_rto.rto02
                 AND rtq03 = g_rto.rto03 AND rtqplant = g_rto.rtoplant
                 AND rtq05 = '1' AND rtq04 = g_rtq_t.rtq04 
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtq_file","","",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
              ELSE
                 MESSAGE "DELETE O.K"
                 COMMIT WORK
                 CALL g_rtq.deleteelement(l_ac)
                 LET g_rec_b2=g_rec_b2-1
                 DISPLAY g_rec_b2 TO FORMONLY.cn2
              END IF
             ELSE
              UPDATE rtq_file SET rtq04=g_rtq[l_ac].rtq04,
                                  rtq06=g_rtq[l_ac].rtq06
                 WHERE rtq01=g_rto.rto01 AND rtq02=g_rto.rto02 
                   AND rtq03=g_rto.rto03 AND rtqplant=g_rto.rtoplant
                   AND rtq04=g_rtq_t.rtq04 AND rtq05 = '1'
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtq_file","","",SQLCA.sqlcode,"","",1) 
                 LET g_rtq[l_ac].* = g_rtq_t.*
              ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,
                                      rtodate = g_rto.rtodate
                      WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02 
                        AND rto03 = g_rto.rto03 AND rtoplant=g_rto.rtoplant
                 
                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
             END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtq[l_ac].rtq06) THEN
              CALL g_rtq.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtq[l_ac].* = g_rtq_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i130_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rtq04) AND l_ac > 1 THEN
              LET g_rtq[l_ac].* = g_rtq[l_ac-1].*
              LET g_rtq[l_ac].rtq04 = g_rec_b1 + 1
              NEXT FIELD rtq04
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rtq06)                     
               CALL cl_init_qry_var()
       #        LET g_qryparam.form ="q_tqa1"                       #FUN-AB0096  mark
               LET g_qryparam.form ="q_oba_11"                      #FUN-AB0096
       #        LET g_qryparam.arg1 = '1'                           #FUN-AB0096  mark
               LET g_qryparam.default1 = g_rtq[l_ac].rtq06
               CALL cl_create_qry() RETURNING g_rtq[l_ac].rtq06
               DISPLAY BY NAME g_rtq[l_ac].rtq06
               CALL i130_rtq06('d')
               NEXT FIELD rtq06
            OTHERWISE EXIT CASE
          END CASE
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
     END INPUT 
END FUNCTION
 
FUNCTION i130_b3()
DEFINE l_ac_t  LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_cnt   LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1
        INPUT ARRAY g_rtq1 WITHOUT DEFAULTS FROM s_b3.*
                ATTRIBUTE(COUNT=g_rec_b3,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b3 !=0 THEN 
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF
                
                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err("",SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b3>=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rtq1_t.*=g_rtq1[l_ac].*
                        LET g_rtq1_o.*=g_rtq1[l_ac].*
                        OPEN i130_bcl USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtq1_t.rtq04
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl INTO g_rtq1[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtq06_1('d')
                        END IF
                 END IF
                 
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtq1[l_ac].* TO NULL
                LET g_rtq1_t.*=g_rtq1[l_ac].*
                LET g_rtq1_o.*=g_rtq1[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtq04_1
                
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtq1[l_ac].rtq06) THEN
                 INSERT INTO rtq_file(rtq01,rtq02,rtq03,rtq04,rtq05,rtq06,rtqplant,rtqlegal)
                     VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,
                            g_rtq1[l_ac].rtq04,'2',g_rtq1[l_ac].rtq06,
                            g_rto.rtoplant,g_rto.rtolegal)
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("ins","rtq_file",'','',SQLCA.sqlcode,"","",1)
                    CANCEL INSERT
                 ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b3=g_rec_b3+1
                        DISPLAY g_rec_b3 TO FORMONLY.cn2
                 END IF
                END IF
                
     BEFORE FIELD rtq04_1
        IF cl_null(g_rtq1[l_ac].rtq04) OR g_rtq1[l_ac].rtq04=0 THEN 
            SELECT max(rtq04)+1 INTO g_rtq1[l_ac].rtq04 FROM rtq_file
             WHERE rtq01=g_rto.rto01 AND rtq02 = g_rto.rto02 
               AND rtq03=g_rto.rto03 AND rtqplant=g_rto.rtoplant
               AND rtq05 = '2'
            IF cl_null(g_rtq1[l_ac].rtq04) THEN
               LET g_rtq1[l_ac].rtq04=1
            END IF
         END IF
         
      AFTER FIELD rtq04_1
        IF NOT cl_null(g_rtq1[l_ac].rtq04) THEN 
           IF g_rtq1[l_ac].rtq04<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtq1[l_ac].rtq04=g_rtq1_t.rtq04
              NEXT FIELD rtq04_1
           END IF
                IF p_cmd='a' OR 
                   (p_cmd='u' AND g_rtq1[l_ac].rtq04!=g_rtq1_t.rtq04) THEN                       
                      SELECT COUNT(*) INTO l_cnt FROM rtq_file
                        WHERE rtq01= g_rto.rto01 AND rtq02=g_rto.rto02
                          AND rtq03= g_rto.rto03 AND rtqplant=g_rto.rtoplant
                          AND rtq04= g_rtq1[l_ac].rtq04 AND rtq05 = '2'
                       IF l_cnt>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtq1[l_ac].rtq04=g_rtq1_t.rtq04
                           NEXT FIELD rtq04_1
                       END IF
                 END IF
         END IF
         
       AFTER FIELD rtq06_1
          IF NOT cl_null(g_rtq1[l_ac].rtq06) THEN 
                IF p_cmd='a' OR (p_cmd='u' AND
                   g_rtq1[l_ac].rtq06!=g_rtq1_o.rtq06 OR cl_null(g_rtq1_o.rtq06)) THEN
                   SELECT COUNT(*) INTO l_cnt FROM rtq_file
                        WHERE rtq01= g_rto.rto01 AND rtq02=g_rto.rto02
                          AND rtq03= g_rto.rto03 AND rtqplant=g_rto.rtoplant
                          AND rtq06= g_rtq1[l_ac].rtq06 AND rtq05 = '2'
                   IF l_cnt>0 THEN
                           CALL cl_err('','art-194',0)
                           LET g_rtq1[l_ac].rtq06=g_rtq1_t.rtq06
                           NEXT FIELD rtq06_1
                   ELSE
                   CALL i130_rtq06_1('a')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtq1[l_ac].rtq06,g_errno,0)  
                      LET g_rtq1[l_ac].rtq06 = g_rtq1_t.rtq06
                      DISPLAY BY NAME g_rtq1[l_ac].rtq06
                      NEXT FIELD rtq06_1
                   ELSE
                      LET g_rtq1_t.rtq06=g_rtq1[l_ac].rtq06
                   END IF
                   END IF
                 END IF
           ELSE
             LET g_rtq1_o.rtq06 = ''
             LET g_rtq1[l_ac].rtq06_desc=''
             DISPLAY BY NAME g_rtq1[l_ac].rtq06_desc
           END IF
           
       BEFORE DELETE                      
           IF g_rtq1_t.rtq04 > 0 AND (NOT cl_null(g_rtq1_t.rtq04)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtq_file
               WHERE rtq01 = g_rto.rto01 AND rtq02 = g_rto.rto02
                 AND rtq03 = g_rto.rto03 AND rtqplant = g_rto.rtoplant
                 AND rtq04 = g_rtq1_t.rtq04 AND rtq05 = '2'
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtq_file","","",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b3=g_rec_b3-1
              DISPLAY g_rec_b3 TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtq1[l_ac].* = g_rtq1_t.*
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtq1[l_ac].* = g_rtq1_t.*
           ELSE
             IF cl_null(g_rtq1[l_ac].rtq06) THEN
                DELETE FROM rtq_file
                 WHERE rtq01 = g_rto.rto01 AND rtq02 = g_rto.rto02  
                   AND rtq03 = g_rto.rto03 AND rtqplant = g_rto.rtoplant
                   AND rtq04 = g_rtq1_t.rtq04 AND rtq05 = '2'
                IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtq_file","","",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                ELSE
                  MESSAGE "DELETE O.K"
                  COMMIT WORK
                  CALL g_rtq.deleteelement(l_ac)
                  LET g_rec_b3=g_rec_b3-1
                  DISPLAY g_rec_b3 TO FORMONLY.cn2
                END IF
             ELSE
              UPDATE rtq_file SET rtq04=g_rtq1[l_ac].rtq04,
                                  rtq06=g_rtq1[l_ac].rtq06
                 WHERE rtq01=g_rto.rto01 AND rtq02=g_rto.rto02
                   AND rtq03=g_rto.rto03 AND rtqplant=g_rto.rtoplant
                   AND rtq04=g_rtq1_t.rtq04 AND rtq05 = '2' 
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtq_file","","",SQLCA.sqlcode,"","",1) 
                 LET g_rtq1[l_ac].* = g_rtq1_t.*
              ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,
                                      rtodate = g_rto.rtodate
                      WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02 
                        AND rto03 = g_rto.rto03 AND rtoplant=g_rto.rtoplant
                 
                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
             END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtq1[l_ac].rtq06) THEN
              CALL g_rtq1.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtq1[l_ac].* = g_rtq1_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i130_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rtq04) AND l_ac > 1 THEN
              LET g_rtq1[l_ac].* = g_rtq1[l_ac-1].*
              LET g_rtq1[l_ac].rtq04 = g_rec_b3 + 1
              NEXT FIELD rtq04
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rtq06_1)                     
               CALL cl_init_qry_var()
               #No.TQC-AC0005  --Begin
               #LET g_qryparam.form ="q_tqa1" 
               LET g_qryparam.form ="q_tqa05" 
               #No.TQC-AC0005  --End  
               LET g_qryparam.arg1 = '2'
               LET g_qryparam.default1 = g_rtq1[l_ac].rtq06
               CALL cl_create_qry() RETURNING g_rtq1[l_ac].rtq06
               DISPLAY g_rtq1[l_ac].rtq06 TO rtq06_1
               CALL i130_rtq06_1('d')
               NEXT FIELD rtq06_1
            OTHERWISE EXIT CASE
          END CASE
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT
END FUNCTION
 
FUNCTION i130_b4()
DEFINE l_ac_t  LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1
        INPUT ARRAY g_rtr1 WITHOUT DEFAULTS FROM s_b4.*
                ATTRIBUTE(COUNT=g_rec_b4,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b4 <> 0 THEN 
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF
                
                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b4 >=l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rtr1_t.*=g_rtr1[l_ac].*
                        LET g_rtr1_o.*=g_rtr1[l_ac].*
                        OPEN i130_bcl USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtr1_t.rtr05
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl INTO g_rtr1[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtr06('d','1')
                        END IF
                 END IF
                 
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtr1[l_ac].* TO NULL
                LET g_rtr1_t.*=g_rtr1[l_ac].*
                LET g_rtr1_o.*=g_rtr1[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtr05
                
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtr1[l_ac].rtr06) THEN
                INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,rtr06,rtr07,rtr10,rtrplant,rtrlegal)
                     VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'1',
                            g_rtr1[l_ac].rtr05,g_rtr1[l_ac].rtr06,g_rtr1[l_ac].rtr07,
                            g_rtr1[l_ac].rtr10,g_rto.rtoplant,g_rto.rtolegal)                       
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b4=g_rec_b4+1
                        DISPLAY g_rec_b4 TO FORMONLY.cn2
                END IF
                END IF
                
      BEFORE FIELD rtr05
        IF cl_null(g_rtr1[l_ac].rtr05) OR g_rtr1[l_ac].rtr05=0 THEN 
            SELECT MAX(rtr05)+1 INTO g_rtr1[l_ac].rtr05 FROM rtr_file
             WHERE rtr01=g_rto.rto01 AND rtr02 = g_rto.rto02 
               AND rtr03=g_rto.rto03 AND rtrplant = g_rto.rtoplant
               AND rtr04 = '1'
            IF cl_null(g_rtr1[l_ac].rtr05) THEN
               LET g_rtr1[l_ac].rtr05=1
            END IF
         END IF
         
      AFTER FIELD rtr05
        IF NOT cl_null(g_rtr1[l_ac].rtr05) THEN 
           IF g_rtr1[l_ac].rtr05<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtr1[l_ac].rtr05=g_rtr1_t.rtr05
              NEXT FIELD rtr05
           END IF
                IF p_cmd='a' OR 
                   (p_cmd='u' AND g_rtr1[l_ac].rtr05 <> g_rtr1_t.rtr05) THEN                       
                      SELECT COUNT(*) INTO l_n FROM rtr_file
                        WHERE rtr01= g_rto.rto01 AND rtr02=g_rto.rto02
                          AND rtr03= g_rto.rto03 AND rtrplant=g_rto.rtoplant
                          AND rtr04 = '1' AND rtr05= g_rtr1[l_ac].rtr05 
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtr1[l_ac].rtr05=g_rtr1_t.rtr05
                           NEXT FIELD rtr05
                       END IF
                 END IF
         END IF
         
       AFTER FIELD rtr06
          IF NOT cl_null(g_rtr1[l_ac].rtr06) THEN 
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr1[l_ac].rtr06!=g_rtr1_o.rtr06 OR cl_null(g_rtr1_o.rtr06)) THEN
                   CALL i130_rtr06('a','1')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtr1[l_ac].rtr06,g_errno,0)  
                      LET g_rtr1[l_ac].rtr06 = g_rtr1_t.rtr06
                      DISPLAY BY NAME g_rtr1[l_ac].rtr06
                      NEXT FIELD rtr06
                   ELSE
                      LET g_rtr1_t.rtr06=g_rtr1[l_ac].rtr06
                   END IF
                 END IF
           ELSE
             LET g_rtr1_o.rtr06=''
             LET g_rtr1[l_ac].rtr06_desc=''
             DISPLAY BY NAME g_rtr1[l_ac].rtr06_desc
           END IF
       
       AFTER FIELD rtr07        
          IF NOT cl_null(g_rtr1[l_ac].rtr07) THEN 
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr1[l_ac].rtr07!=g_rtr1_t.rtr07 OR cl_null(g_rtr1_t.rtr07)) THEN      
                   IF g_rtr1[l_ac].rtr07 < g_rto.rto08 OR
                      g_rtr1[l_ac].rtr07 > g_rto.rto09 THEN
                      CALL cl_err(g_rtr1[l_ac].rtr07,'art-425',0)     
                      LET g_rtr1[l_ac].rtr07 = g_rtr1_t.rtr07
                      DISPLAY BY NAME g_rtr1[l_ac].rtr07
                      NEXT FIELD rtr07
                   END IF
                 END IF
          END IF
          
       AFTER FIELD rtr10        
          IF NOT cl_null(g_rtr1[l_ac].rtr10) THEN 
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr1[l_ac].rtr10!=g_rtr1_t.rtr10 OR cl_null(g_rtr1_t.rtr10)) THEN      
                   IF g_rtr1[l_ac].rtr10 < 0 THEN
                      CALL cl_err(g_rtr1[l_ac].rtr10,'alm-342',0)     
                      LET g_rtr1[l_ac].rtr10 = g_rtr1_t.rtr10
                      DISPLAY BY NAME g_rtr1[l_ac].rtr10
                      NEXT FIELD rtr10
                   END IF
                 END IF
          END IF
          
       BEFORE DELETE                      
           IF g_rtr1_t.rtr05 > 0 AND (NOT cl_null(g_rtr1_t.rtr05)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtr_file
               WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02 
                 AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                 AND rtr04 = '1' AND rtr05 = g_rtr1_t.rtr05
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b4=g_rec_b4-1
              DISPLAY g_rec_b4 TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtr1[l_ac].* = g_rtr1_t.*
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtr1[l_ac].* = g_rtr1_t.*
           ELSE
              IF cl_null(g_rtr1[l_ac].rtr06) THEN
                DELETE FROM rtr_file
                 WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02  
                   AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                   AND rtr04 = '1' AND rtr05 = g_rtr1_t.rtr05
                IF SQLCA.sqlcode THEN   
                   CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)  
                   ROLLBACK WORK
                ELSE
                  MESSAGE "DELETE O.K"
                  COMMIT WORK
                  CALL g_rtr1.deleteelement(l_ac)
                  LET g_rec_b4=g_rec_b4-1
                  DISPLAY g_rec_b4 TO FORMONLY.cn2
                END IF
              ELSE
              UPDATE rtr_file SET rtr05=g_rtr1[l_ac].rtr05,
                                  rtr06=g_rtr1[l_ac].rtr06,
                                  rtr07=g_rtr1[l_ac].rtr07,
                                  rtr10=g_rtr1[l_ac].rtr10
                 WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02 
                   AND rtr03=g_rto.rto03 AND rtrplant = g_rto.rtoplant
                   AND rtr04= '1' AND rtr05 = g_rtr1_t.rtr05
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1) 
                 LET g_rtr1[l_ac].* = g_rtr1_t.*
              ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,rtodate = g_rto.rtodate
                   WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02 
                     AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
                 
                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtr1[l_ac].rtr06) THEN
              CALL g_rtr1.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtr1[l_ac].* = g_rtr1_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i130_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rtr05) AND l_ac > 1 THEN
              LET g_rtr1[l_ac].* = g_rtr1[l_ac-1].*
              LET g_rtr1[l_ac].rtr05 = g_rec_b4 + 1
              NEXT FIELD rtq04
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rtr06)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oaj3" 
               LET g_qryparam.default1 = g_rtr1[l_ac].rtr06
               CALL cl_create_qry() RETURNING g_rtr1[l_ac].rtr06
               DISPLAY g_rtr1[l_ac].rtr06 TO rtr06
               CALL i130_rtr06('d','1')
               NEXT FIELD rtr06
            OTHERWISE EXIT CASE
          END CASE
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
           
     END INPUT       
END FUNCTION
 
FUNCTION i130_b5()
DEFINE l_ac_t  LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1
        
        INPUT ARRAY g_rtr2 WITHOUT DEFAULTS FROM s_b5.*
                ATTRIBUTE(COUNT=g_rec_b5,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b5 !=0 THEN 
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF
                
                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b5 >= l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rtr2_t.*=g_rtr2[l_ac].*
                        LET g_rtr2_o.*=g_rtr2[l_ac].*
                        OPEN i130_bcl USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtr2_t.rtr05
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl INTO g_rtr2[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtr06('d','2')
                        END IF
                 END IF
                 
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtr2[l_ac].* TO NULL
                LET g_rtr2_t.*=g_rtr2[l_ac].*
                LET g_rtr2_o.*=g_rtr2[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtr05_1
                
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtr2[l_ac].rtr06) THEN
                INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,
                                     rtr06,rtr08,rtr09,rtr10,rtrplant,rtrlegal)
                     VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'2',
                            g_rtr2[l_ac].rtr05,g_rtr2[l_ac].rtr06,g_rtr2[l_ac].rtr08,
                            g_rtr2[l_ac].rtr09,g_rtr2[l_ac].rtr10,g_rto.rtoplant,g_rto.rtolegal)                       
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b5=g_rec_b5+1
                        DISPLAY g_rec_b5 TO FORMONLY.cn2
                END IF
                END IF
      BEFORE FIELD rtr05_1
        IF cl_null(g_rtr2[l_ac].rtr05) OR g_rtr2[l_ac].rtr05=0 THEN 
            SELECT MAX(rtr05)+1 INTO g_rtr2[l_ac].rtr05 FROM rtr_file
             WHERE rtr01=g_rto.rto01 AND rtr02 = g_rto.rto02 
               AND rtr03=g_rto.rto03 AND rtrplant = g_rto.rtoplant
               AND rtr04 = '2'
            IF cl_null(g_rtr2[l_ac].rtr05) THEN
               LET g_rtr2[l_ac].rtr05=1
            END IF
         END IF
         
      AFTER FIELD rtr05_1
        IF NOT cl_null(g_rtr2[l_ac].rtr05) THEN 
           IF g_rtr1[l_ac].rtr05<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtr1[l_ac].rtr05=g_rtr1_t.rtr05
              NEXT FIELD rtr05_1
           END IF
                IF p_cmd='a' OR 
                   (p_cmd='u' AND g_rtr2[l_ac].rtr05 <> g_rtr2_t.rtr05) THEN                       
                      SELECT COUNT(*) INTO l_n FROM rtr_file
                        WHERE rtr01= g_rto.rto01 AND rtr02=g_rto.rto02
                          AND rtr03= g_rto.rto03 AND rtrplant=g_rto.rtoplant
                          AND rtr05= g_rtr2[l_ac].rtr05 AND rtr04 = '2'
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtr2[l_ac].rtr05=g_rtr2_t.rtr05
                           NEXT FIELD rtr05_1
                       END IF
                 END IF
         END IF
         
       AFTER FIELD rtr06_1
          IF NOT cl_null(g_rtr2[l_ac].rtr06) THEN 
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr2[l_ac].rtr06!=g_rtr2_o.rtr06 OR cl_null(g_rtr2_o.rtr06)) THEN
                   CALL i130_rtr06('a','2')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtr2[l_ac].rtr06,g_errno,0)  
                      LET g_rtr2[l_ac].rtr06 = g_rtr2_t.rtr06
                      DISPLAY BY NAME g_rtr2[l_ac].rtr06
                      NEXT FIELD rtr06_1
                   ELSE
                      LET g_rtr2_o.rtr06=g_rtr2[l_ac].rtr06
                   END IF                   
                 END IF
           ELSE
             LET g_rtr2_o.rtr06=''
             LET g_rtr2[l_ac].rtr06_desc=''
             DISPLAY BY NAME g_rtr2[l_ac].rtr06_desc
           END IF
       
       AFTER FIELD rtr10_1       
          IF NOT cl_null(g_rtr2[l_ac].rtr10) THEN 
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr2[l_ac].rtr10!=g_rtr2_t.rtr10 OR cl_null(g_rtr2_t.rtr10)) THEN      
                   IF g_rtr2[l_ac].rtr10 < 0 THEN
                      CALL cl_err(g_rtr2[l_ac].rtr10,'alm-342',0)     
                      LET g_rtr2[l_ac].rtr10 = g_rtr2_t.rtr10
                      DISPLAY BY NAME g_rtr2[l_ac].rtr10
                      NEXT FIELD rtr10_1
                   END IF
                 END IF
          END IF
              
       BEFORE DELETE                      
           IF g_rtr2_t.rtr05 > 0 AND (NOT cl_null(g_rtr2_t.rtr05)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtr_file
               WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                 AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                 AND rtr05 = g_rtr2_t.rtr05 AND rtr04 = '2'
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b5=g_rec_b5-1
              DISPLAY g_rec_b5 TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtr2[l_ac].* = g_rtr2_t.*
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtr2[l_ac].* = g_rtr2_t.*
           ELSE
            IF cl_null(g_rtr2[l_ac].rtr06) THEN
              DELETE FROM rtr_file
               WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                 AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                 AND rtr05 = g_rtr2_t.rtr05 AND rtr04 = '2'
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
              ELSE
                 MESSAGE "DELETE O.K"
                 COMMIT WORK
                 CALL g_rtr2.deleteelement(l_ac)
                 LET g_rec_b5=g_rec_b5-1
                 DISPLAY g_rec_b5 TO FORMONLY.cn2
              END IF
            ELSE
              UPDATE rtr_file SET rtr05 = g_rtr2[l_ac].rtr05,
                                  rtr06 = g_rtr2[l_ac].rtr06,
                                  rtr08 = g_rtr2[l_ac].rtr08,
                                  rtr09 = g_rtr2[l_ac].rtr09,
                                  rtr10 = g_rtr2[l_ac].rtr10                                
               WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                 AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                 AND rtr04 = '2' AND rtr05=g_rtr2_t.rtr05
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1) 
                 LET g_rtr2[l_ac].* = g_rtr2_t.*
              ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,
                                      rtodate = g_rto.rtodate
                   WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02 
                     AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
                 
                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
             END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtr2[l_ac].rtr06) THEN
              CALL g_rtr2.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtr2[l_ac].* = g_rtr2_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i130_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rtr05) AND l_ac > 1 THEN
              LET g_rtr2[l_ac].* = g_rtr2[l_ac-1].*
              LET g_rtr2[l_ac].rtr05 = g_rec_b5 + 1
              NEXT FIELD rtr05_1
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rtr06_1)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oaj3" 
               LET g_qryparam.default1 = g_rtr2[l_ac].rtr06
               CALL cl_create_qry() RETURNING g_rtr2[l_ac].rtr06
               DISPLAY g_rtr2[l_ac].rtr06 TO rtr06_1
               CALL i130_rtr06('d','2')
               NEXT FIELD rtr06_1
            OTHERWISE EXIT CASE
          END CASE
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
     END INPUT      
END FUNCTION
 
FUNCTION i130_b6()
DEFINE l_ac_t  LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1
        INPUT ARRAY g_rtr3 WITHOUT DEFAULTS FROM s_b6.*
                ATTRIBUTE(COUNT=g_rec_b6,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b6 !=0 THEN 
                   CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF
                
                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b6 >= l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rtr3_t.*=g_rtr3[l_ac].*
                        LET g_rtr3_o.*=g_rtr3[l_ac].*
                        OPEN i130_bcl USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtr3_t.rtr05
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl INTO g_rtr3[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtr06('d','3')
                        END IF
                 END IF
                 
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtr3[l_ac].* TO NULL
                LET g_rtr3_t.*=g_rtr3[l_ac].*
                LET g_rtr3_o.*=g_rtr3[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtr05_2
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtr3[l_ac].rtr06) THEN
                INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,rtr06,rtr08,
                                     rtr09,rtr11,rtr12,rtr14,rtr15,rtrplant,rtrlegal)
                     VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'3',
                            g_rtr3[l_ac].rtr05,g_rtr3[l_ac].rtr06,g_rtr3[l_ac].rtr08,
                            g_rtr3[l_ac].rtr09,g_rtr3[l_ac].rtr11,g_rtr3[l_ac].rtr12,
                            g_rtr3[l_ac].rtr14,g_rtr3[l_ac].rtr15,g_rto.rtoplant,g_rto.rtolegal)                       
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b6=g_rec_b6+1
                        DISPLAY g_rec_b6 TO FORMONLY.cn2
                END IF
                END IF
                
      BEFORE FIELD rtr05_2
        IF cl_null(g_rtr3[l_ac].rtr05) OR g_rtr3[l_ac].rtr05=0 THEN 
            SELECT MAX(rtr05)+1 INTO g_rtr3[l_ac].rtr05 FROM rtr_file
             WHERE rtr01=g_rto.rto01 AND rtr02 = g_rto.rto02 
               AND rtr03=g_rto.rto03 AND rtrplant = g_rto.rtoplant
               AND rtr04 = '3'
            IF cl_null(g_rtr3[l_ac].rtr05) THEN
               LET g_rtr3[l_ac].rtr05=1
            END IF
         END IF
         
      AFTER FIELD rtr05_2
        IF NOT cl_null(g_rtr3[l_ac].rtr05) THEN 
           IF g_rtr3[l_ac].rtr05<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtr3[l_ac].rtr05=g_rtr3_t.rtr05
              NEXT FIELD rtr05_2
           END IF
                IF p_cmd='a' OR 
                   (p_cmd='u' AND g_rtr3[l_ac].rtr05 <> g_rtr3_t.rtr05) THEN                       
                      SELECT COUNT(*) INTO l_n FROM rtr_file
                        WHERE rtr01= g_rto.rto01 AND rtr02=g_rto.rto02
                          AND rtr03= g_rto.rto03 AND rtrplant=g_rto.rtoplant
                          AND rtr05= g_rtr3[l_ac].rtr05 AND rtr04 = '3'
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtr3[l_ac].rtr05 = g_rtr3_t.rtr05
                           NEXT FIELD rtr05_2
                       END IF
                 END IF
         END IF
       
       AFTER FIELD rtr06_2
          IF NOT cl_null(g_rtr3[l_ac].rtr06) THEN 
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr3[l_ac].rtr06!=g_rtr2_o.rtr06 OR cl_null(g_rtr3_o.rtr06)) THEN
                   CALL i130_rtr06('a','3')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtr3[l_ac].rtr06,g_errno,0)  
                      LET g_rtr3[l_ac].rtr06 = g_rtr3_t.rtr06
                      DISPLAY BY NAME g_rtr3[l_ac].rtr06
                      NEXT FIELD rtr06_2
                   ELSE
                      LET g_rtr3_o.rtr06=g_rtr3[l_ac].rtr06
                   END IF
                 END IF
           ELSE
             LET g_rtr3_o.rtr06=''
             LET g_rtr3[l_ac].rtr06_desc=''
             DISPLAY BY NAME g_rtr3[l_ac].rtr06_desc
           END IF
       
       AFTER FIELD rtr14_2,rtr15_2 
          IF FGL_DIALOG_GETBUFFER()<0 THEN
              CALL cl_err('','alm-342',0)
              NEXT FIELD CURRENT 
          END IF      
          IF NOT cl_null(g_rtr3[l_ac].rtr14) AND NOT cl_null(g_rtr3[l_ac].rtr15) THEN 
                IF p_cmd='a' OR (p_cmd='u' AND
                   (g_rtr3[l_ac].rtr14!=g_rtr3_t.rtr14 OR g_rtr3[l_ac].rtr15!=g_rtr3_t.rtr15)) THEN      
                   IF g_rtr3[l_ac].rtr14 > g_rtr3[l_ac].rtr15 THEN
                      CALL cl_err('','art-488',0)     
                      NEXT FIELD CURRENT
                   END IF
                 END IF
          END IF
                
       BEFORE DELETE                      
           IF g_rtr3_t.rtr05 > 0 AND (NOT cl_null(g_rtr3_t.rtr05)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtr_file
               WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02 
                 AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                 AND rtr05 = g_rtr3_t.rtr05 AND rtr04 ='3'
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b6=g_rec_b6-1
              DISPLAY g_rec_b6 TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtr3[l_ac].* = g_rtr3_t.*
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtr3[l_ac].* = g_rtr3_t.*
           ELSE
             IF cl_null(g_rtr3[l_ac].rtr06) THEN
                DELETE FROM rtr_file
                 WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02 
                   AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                   AND rtr05 = g_rtr3_t.rtr05 AND rtr04 ='3'
                IF SQLCA.sqlcode THEN   
                   CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)  
                   ROLLBACK WORK
                ELSE
                   MESSAGE "DELETE O.K"
                   COMMIT WORK
                   CALL g_rtr3.deleteelement(l_ac)
                   LET g_rec_b6=g_rec_b6-1
                   DISPLAY g_rec_b6 TO FORMONLY.cn2
                END IF
             ELSE
                UPDATE rtr_file SET rtr05 = g_rtr3[l_ac].rtr05,
                                    rtr06 = g_rtr3[l_ac].rtr06,
                                    rtr08 = g_rtr3[l_ac].rtr08,
                                    rtr09 = g_rtr3[l_ac].rtr09,
                                    rtr11 = g_rtr3[l_ac].rtr11,
                                    rtr12 = g_rtr3[l_ac].rtr12,
                                    rtr14 = g_rtr3[l_ac].rtr14,
                                    rtr15 = g_rtr3[l_ac].rtr15                                  
                 WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02 
                   AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                   AND rtr05=g_rtr3_t.rtr05 AND rtr04 = '3'
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1) 
                  LET g_rtr3[l_ac].* = g_rtr3_t.*
               ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,rtodate = g_rto.rtodate
                   WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02 
                     AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
                 
                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
               END IF
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtr3[l_ac].rtr06) THEN
              CALL g_rtr3.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtr3[l_ac].* = g_rtr3_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i130_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rtr05) AND l_ac > 1 THEN
              LET g_rtr3[l_ac].* = g_rtr3[l_ac-1].*
              LET g_rtr3[l_ac].rtr05 = g_rec_b6 + 1
              NEXT FIELD rtr05_2
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rtr06_2)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oaj3" 
               LET g_qryparam.default1 = g_rtr3[l_ac].rtr06
               CALL cl_create_qry() RETURNING g_rtr3[l_ac].rtr06
               DISPLAY g_rtr3[l_ac].rtr06 TO rtr06_2
               CALL i130_rtr06('d','3')
               NEXT FIELD rtr06_2
            OTHERWISE EXIT CASE
          END CASE
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT     
END FUNCTION
 
FUNCTION i130_b7()
DEFINE l_ac_t  LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1
        
        INPUT ARRAY g_rtr4 WITHOUT DEFAULTS FROM s_b7.*
                ATTRIBUTE(COUNT=g_rec_b7,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b7 !=0 THEN 
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF
                
                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b7 >= l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rtr4_t.* = g_rtr4[l_ac].*
                        LET g_rtr4_o.* = g_rtr4[l_ac].*
                        OPEN i130_bcl USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtr4_t.rtr05
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl INTO g_rtr4[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtr06('d','4')
                        END IF
                 END IF
                 
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtr4[l_ac].* TO NULL
                LET g_rtr4_t.*=g_rtr4[l_ac].*
                LET g_rtr4_o.*=g_rtr4[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtr05_3
                
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtr4[l_ac].rtr06) THEN
                INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,rtr06,
                                     rtr08,rtr09,rtr11,rtr12,rtr13,rtrplant,rtrlegal)
                     VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'4',
                            g_rtr4[l_ac].rtr05,g_rtr4[l_ac].rtr06,g_rtr4[l_ac].rtr08,
                            g_rtr4[l_ac].rtr09,g_rtr4[l_ac].rtr11,g_rtr4[l_ac].rtr12,
                            g_rtr4[l_ac].rtr13,g_rto.rtoplant,g_rto.rtolegal)                       
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b7 = g_rec_b7+1
                        DISPLAY g_rec_b7 TO FORMONLY.cn2
                END IF
                END IF
                
      BEFORE FIELD rtr05_3
        IF cl_null(g_rtr4[l_ac].rtr05) OR g_rtr4[l_ac].rtr05=0 THEN 
            SELECT MAX(rtr05)+1 INTO g_rtr4[l_ac].rtr05 FROM rtr_file
             WHERE rtr01=g_rto.rto01 AND rtr02 = g_rto.rto02 
               AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
               AND rtr04 ='4'
                IF cl_null(g_rtr4[l_ac].rtr05) THEN
                        LET g_rtr4[l_ac].rtr05 = 1
                END IF
         END IF
         
      AFTER FIELD rtr05_3
        IF NOT cl_null(g_rtr4[l_ac].rtr05) THEN 
           IF g_rtr4[l_ac].rtr05<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtr4[l_ac].rtr05=g_rtr4_t.rtr05
              NEXT FIELD rtr05_3
           END IF
                IF p_cmd='a' OR 
                   (p_cmd='u' AND g_rtr4[l_ac].rtr05 <> g_rtr4_t.rtr05) THEN                       
                      SELECT COUNT(*) INTO l_n FROM rtr_file
                        WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                          AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                          AND rtr05 = g_rtr4[l_ac].rtr05 AND rtr04 = '4'  
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtr4[l_ac].rtr05=g_rtr4_t.rtr05
                           NEXT FIELD rtr05_3
                       END IF
                 END IF
         END IF
        
       AFTER FIELD rtr06_3
          IF NOT cl_null(g_rtr4[l_ac].rtr06) THEN 
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr4[l_ac].rtr06!=g_rtr4_o.rtr06 OR cl_null(g_rtr4_o.rtr06)) THEN
                   CALL i130_rtr06('a','4')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtr4[l_ac].rtr06,g_errno,0)  
                      LET g_rtr4[l_ac].rtr06 = g_rtr4_t.rtr06
                      DISPLAY BY NAME g_rtr4[l_ac].rtr06
                      NEXT FIELD rtr06_3
                   ELSE
                      LET g_rtr4_t.rtr06 = g_rtr4[l_ac].rtr06
                   END IF
                 END IF
           ELSE
             LET g_rtr4_o.rtr06 = ''
             LET g_rtr4[l_ac].rtr06_desc=''
             DISPLAY BY NAME g_rtr4[l_ac].rtr06_desc
           END IF
             
       BEFORE DELETE                      
           IF g_rtr4_t.rtr05 > 0 AND (NOT cl_null(g_rtr4_t.rtr05)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtr_file
               WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02 
                 AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                 AND rtr05 = g_rtr4_t.rtr05 AND rtr04 = '4'
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b7 = g_rec_b7-1
              DISPLAY g_rec_b7 TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtr4[l_ac].* = g_rtr4_t.*
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtr4[l_ac].* = g_rtr4_t.*
           ELSE
             IF cl_null(g_rtr4[l_ac].rtr06) THEN
              DELETE FROM rtr_file
               WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02 
                 AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                 AND rtr05 = g_rtr4_t.rtr05 AND rtr04 = '4'
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
              ELSE
                 MESSAGE "DELETE O.K"
                 COMMIT WORK
                 CALL g_rtr1.deleteelement(l_ac)
                 LET g_rec_b7 = g_rec_b7-1
                 DISPLAY g_rec_b7 TO FORMONLY.cn2
              END IF
             ELSE
              UPDATE rtr_file SET rtr05 = g_rtr4[l_ac].rtr05,
                                  rtr06 = g_rtr4[l_ac].rtr06,
                                  rtr08 = g_rtr4[l_ac].rtr08,
                                  rtr09 = g_rtr4[l_ac].rtr09,
                                  rtr11 = g_rtr4[l_ac].rtr11,
                                  rtr12 = g_rtr4[l_ac].rtr12,
                                  rtr13 = g_rtr4[l_ac].rtr13
                 WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02 
                   AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                   AND rtr05=g_rtr4_t.rtr05 AND rtr04 = '4'
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1) 
                 LET g_rtr4[l_ac].* = g_rtr4_t.*
              ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,
                                      rtodate = g_rto.rtodate
                   WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02 
                     AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
                 
                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
             END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtr4[l_ac].rtr06) THEN
              CALL g_rtr4.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtr4[l_ac].* = g_rtr4_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i130_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rtr05_3) AND l_ac > 1 THEN
              LET g_rtr4[l_ac].* = g_rtr4[l_ac-1].*
              LET g_rtr4[l_ac].rtr05 = g_rec_b7 + 1
              NEXT FIELD rtr05_3
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rtr06_3)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oaj3"
               LET g_qryparam.default1 = g_rtr4[l_ac].rtr06
               CALL cl_create_qry() RETURNING g_rtr4[l_ac].rtr06
               DISPLAY g_rtr4[l_ac].rtr06 TO rtr06_3
               CALL i130_rtr06('d','4')
               NEXT FIELD rtr06_3

            OTHERWISE EXIT CASE
          END CASE
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
    END INPUT 
END FUNCTION
 
FUNCTION i130_b8()
DEFINE l_ac_t  LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1
        INPUT ARRAY g_rtr5 WITHOUT DEFAULTS FROM s_b8.*
                ATTRIBUTE(COUNT=g_rec_b8,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=l_allow_insert,DELETE ROW=l_allow_delete,
                        APPEND ROW= l_allow_insert)
        BEFORE INPUT
                IF g_rec_b8 <> 0 THEN 
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF
                
                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b8 >= l_ac THEN 
                        LET p_cmd = 'u'
                        LET g_rtr5_t.* = g_rtr5[l_ac].*
                        LET g_rtr5_o.* = g_rtr5[l_ac].*
                        OPEN i130_bcl USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtr5_t.rtr05
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl INTO g_rtr5[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                CALL i130_rtr06('d','5')
                        END IF
                 END IF
                 
       BEFORE INSERT
                LET l_n=ARR_COUNT()
                LET p_cmd='a'
                INITIALIZE g_rtr5[l_ac].* TO NULL
                LET g_rtr5_t.*=g_rtr5[l_ac].*
                LET g_rtr5_o.* = g_rtr5[l_ac].*
                CALL cl_show_fld_cont()
                NEXT FIELD rtr05_4
                
       AFTER INSERT
                IF INT_FLAG THEN
                        CALL cl_err('',9001,0)
                        LET INT_FLAG=0
                        CANCEL INSERT
                END IF
                IF NOT cl_null(g_rtr5[l_ac].rtr06) THEN
                INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtr05,
                                     rtr06,rtr07,rtr10,rtrplant,rtrlegal)
                     VALUES(g_rto.rto01,g_rto.rto02,g_rto.rto03,'5',
                            g_rtr5[l_ac].rtr05,g_rtr5[l_ac].rtr06,g_rtr5[l_ac].rtr07,
                            g_rtr5[l_ac].rtr10,g_rto.rtoplant,g_rto.rtolegal)                       
                IF SQLCA.sqlcode THEN
                CALL cl_err3("ins","rtr_file",'','',SQLCA.sqlcode,"","",1)
                        CANCEL INSERT
                ELSE
                        MESSAGE 'INSERT Ok'
                        COMMIT WORK
                        LET g_rec_b8 = g_rec_b8+1
                        DISPLAY g_rec_b8 TO FORMONLY.cn2
                END IF
                END IF
                
      BEFORE FIELD rtr05_4
        IF cl_null(g_rtr5[l_ac].rtr05) OR g_rtr5[l_ac].rtr05=0 THEN 
            SELECT MAX(rtr05)+1 INTO g_rtr5[l_ac].rtr05 FROM rtr_file
             WHERE rtr01=g_rto.rto01 AND rtr02 = g_rto.rto02 
               AND rtr03=g_rto.rto03 AND rtrplant = g_rto.rtoplant
               AND rtr04 = '5'
                IF cl_null(g_rtr5[l_ac].rtr05) THEN
                        LET g_rtr5[l_ac].rtr05=1
                END IF
         END IF
         
      AFTER FIELD rtr05_4
        IF NOT cl_null(g_rtr5[l_ac].rtr05) THEN 
           IF g_rtr5[l_ac].rtr05<=0 THEN
              CALL cl_err('','aec-994',0)
              LET g_rtr5[l_ac].rtr05=g_rtr5_t.rtr05
              NEXT FIELD rtr05_4
           END IF
                IF p_cmd='a' OR 
                   (p_cmd='u' AND g_rtr5[l_ac].rtr05 <> g_rtr5_t.rtr05) THEN                       
                      SELECT COUNT(*) INTO l_n FROM rtr_file
                        WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                          AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                          AND rtr05 = g_rtr5[l_ac].rtr05 AND rtr04 = '5'
                       IF l_n>0 THEN
                           CALL cl_err('',-239,0)
                           LET g_rtr5[l_ac].rtr05 = g_rtr5_t.rtr05
                           NEXT FIELD rtr05_4
                       END IF
                 END IF
         END IF
        
       AFTER FIELD rtr06_4
          IF NOT cl_null(g_rtr5[l_ac].rtr06) THEN 
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr5[l_ac].rtr06!=g_rtr5_o.rtr06 OR cl_null(g_rtr5_o.rtr06)) THEN
                   CALL i130_rtr06('a','5')
                   IF NOT cl_null(g_errno) THEN
                      CALL cl_err(g_rtr5[l_ac].rtr06,g_errno,0)  
                      LET g_rtr5[l_ac].rtr06 = g_rtr5_t.rtr06
                      DISPLAY BY NAME g_rtr5[l_ac].rtr06
                      NEXT FIELD rtr06_4
                   ELSE
                      LET g_rtr5_o.rtr06 = g_rtr5[l_ac].rtr06
                   END IF
                 END IF
           ELSE
             LET g_rtr5_o.rtr06=''
             LET g_rtr5[l_ac].rtr06_desc=''
             DISPLAY BY NAME g_rtr5[l_ac].rtr06_desc
           END IF
           
       AFTER FIELD rtr07_4    
          IF NOT cl_null(g_rtr5[l_ac].rtr07) THEN 
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr5[l_ac].rtr07!=g_rtr5_t.rtr07 OR cl_null(g_rtr5_t.rtr07)) THEN      
                   IF g_rtr5[l_ac].rtr07 < g_rto.rto08 OR
                      g_rtr5[l_ac].rtr07 > g_rto.rto09 THEN
                      CALL cl_err(g_rtr5[l_ac].rtr07,'art-425',0)     
                      LET g_rtr5[l_ac].rtr07 = g_rtr1_t.rtr07
                      DISPLAY BY NAME g_rtr5[l_ac].rtr07
                      NEXT FIELD rtr07_4
                   END IF
                 END IF
          END IF       
         
       AFTER FIELD rtr10_4       
          IF NOT cl_null(g_rtr5[l_ac].rtr10) THEN 
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr5[l_ac].rtr10!=g_rtr5_t.rtr10 OR cl_null(g_rtr5_t.rtr10)) THEN      
                   IF g_rtr5[l_ac].rtr10 < 0 THEN
                      CALL cl_err(g_rtr5[l_ac].rtr10,'alm-342',0)     
                      LET g_rtr5[l_ac].rtr10 = g_rtr5_t.rtr10
                      DISPLAY BY NAME g_rtr5[l_ac].rtr10
                      NEXT FIELD rtr10_4
                   END IF
                 END IF
          END IF
             
       BEFORE DELETE                      
           IF g_rtr5_t.rtr05 > 0 AND (NOT cl_null(g_rtr5_t.rtr05)) THEN
              IF NOT cl_delb(0,0) THEN
                 CANCEL DELETE
              END IF
              IF l_lock_sw = "Y" THEN
                 CALL cl_err("", -263, 1)
                 CANCEL DELETE
              END IF
              DELETE FROM rtr_file
               WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
                 AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                 AND rtr05 = g_rtr5_t.rtr05 AND rtr04 = '5'
              IF SQLCA.sqlcode THEN   
                 CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)  
                 ROLLBACK WORK
                 CANCEL DELETE
              END IF
              LET g_rec_b8 = g_rec_b8-1
              DISPLAY g_rec_b8 TO FORMONLY.cn2
           END IF
           COMMIT WORK
 
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtr5[l_ac].* = g_rtr5_t.*
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtr5[l_ac].* = g_rtr5_t.*
           ELSE
              IF cl_null(g_rtr5[l_ac].rtr06) THEN
                 DELETE FROM rtr_file
                  WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02 
                    AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
                    AND rtr05 = g_rtr5_t.rtr05 AND rtr04 = '5'
                 IF SQLCA.sqlcode THEN   
                    CALL cl_err3("del","rtr_file","","",SQLCA.sqlcode,"","",1)  
                    ROLLBACK WORK
                 ELSE
                    MESSAGE "DELETE WORK"
                    COMMIT WORK
                    CALL g_rtr5.deleteelement(l_ac)
                    LET g_rec_b8 = g_rec_b8-1
                    DISPLAY g_rec_b8 TO FORMONLY.cn2
                 END IF
            ELSE
               UPDATE rtr_file SET rtr05 = g_rtr5[l_ac].rtr05,
                                   rtr06 = g_rtr5[l_ac].rtr06,
                                   rtr07 = g_rtr5[l_ac].rtr07,
                                   rtr10 = g_rtr5[l_ac].rtr10
                WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                  AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                  AND rtr05 = g_rtr5_t.rtr05 AND rtr04 = '5'
               IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                  CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1) 
                  LET g_rtr5[l_ac].* = g_rtr5_t.*
               ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,
                                      rtodate = g_rto.rtodate
                      WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02 
                        AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
                 
                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
               END IF
             END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtr5[l_ac].rtr06) THEN
              CALL g_rtr5.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtr5[l_ac].* = g_rtr5_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i130_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rtr05) AND l_ac > 1 THEN
              LET g_rtr5[l_ac].* = g_rtr5[l_ac-1].*
              LET g_rtr5[l_ac].rtr05 = g_rec_b8 + 1
              NEXT FIELD rtr05_4
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
 
        ON ACTION controlp                         
          CASE
            WHEN INFIELD(rtr06_4)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oaj3" 
               LET g_qryparam.default1 = g_rtr5[l_ac].rtr06
               CALL cl_create_qry() RETURNING g_rtr5[l_ac].rtr06
               DISPLAY g_rtr5[l_ac].rtr06 TO rtr06_4
               CALL i130_rtr06('d','5')
               NEXT FIELD rtr06_4

            OTHERWISE EXIT CASE
          END CASE
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")  
     END INPUT 
END FUNCTION
 
FUNCTION i130_b9_check() #check 頁簽九新增或修改
DEFINE l_n LIKE type_file.num5
      SELECT COUNT(*) INTO l_n FROM rtr_file 
            WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02 
              AND rtr03 = g_rto.rto03 AND rtr04 = '6' AND rtrplant = g_rto.rtoplant
      IF l_n = 0 THEN
         CALL i130_b9_a()
         CALL i130_expand()
      ELSE
         CALL i130_b9_u()
         CALL i130_expandcheck()
      END IF
      
END FUNCTION
 
FUNCTION i130_b9_a()   #頁簽九新增
 
   IF cl_null(g_rto.rto01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   
   SELECT rto_file.* INTO g_rto.* FROM rto_file
    WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
      AND  rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
 
   IF g_rto.rtoacti ='N' THEN    
      CALL cl_err('','mfg1000',0)
      RETURN
   END IF
   IF g_rto.rtoconf <>'N' THEN
          CALL cl_err('',9022,0)
          RETURN
   END IF
   WHILE TRUE
      LET g_rtr7.rtr17 = 'Y'                    
      LET g_rtr7.rtr08 = '1'
      LET g_rtr7_t.* = g_rtr7.*
      LET g_rtr7_o.* = g_rtr7.*
      CALL i130_b9_i("a")                          
 
      IF INT_FLAG THEN                          
         INITIALIZE g_rtr7.* TO NULL
         LET INT_FLAG = 0
         CALL cl_err('',9001,0)
         LET g_intflag=1
         EXIT WHILE
      END IF
      
      IF cl_null(g_rtr7.rtr08) THEN
         CONTINUE WHILE
      END IF    
      EXIT WHILE
   END WHILE
 
END FUNCTION
 
FUNCTION i130_b9_i(p_cmd)
DEFINE p_cmd LIKE type_file.chr1
DEFINE l_n   LIKE type_file.num5     
  
       INPUT g_rtr7.rtr06,g_rtr7.rtr08,g_rtr7.rtr16,g_rtr7.rtr17
             WITHOUT DEFAULTS
             FROM rtr06_5,rtr08_5,rtr16_5,rtr17_5
             
       AFTER FIELD rtr06_5
          IF NOT cl_null(g_rtr7.rtr06) THEN
             IF p_cmd='a' OR (p_cmd='u' AND 
                g_rtr7.rtr06<>g_rtr7_o.rtr06 OR cl_null(g_rtr7_o.rtr06)) THEN
                CALL i130_rtr06('a','6')
                IF NOT cl_null(g_errno) THEN
                   CALL cl_err('',g_errno,0)
                   NEXT FIELD rtr06_5
                ELSE
                   LET g_rtr7_o.rtr06 = g_rtr7.rtr06
                END IF
              END IF
          ELSE          
             LET g_rtr7_o.rtr06=''
             DISPLAY '' TO rtr06_5_desc
          END IF
        
       ON CHANGE rtr17_5
          IF NOT cl_null(g_rtr7.rtr17) THEN
             IF g_rtr7.rtr17 = 'Y' THEN
                SELECT COUNT(rtp05) INTO l_n FROM rtp_file 
                         WHERE rtp01=g_rto.rto01 AND rtp02=g_rto.rto02
                          AND  rtp03=g_rto.rto03
                IF l_n<0 THEN
                   CALL cl_err('','art-105',0)
                   LET g_rtr7.rtr17='N'
                   DISPLAY g_rtr7.rtr17 TO rtr17_5
                ELSE
                   CALL cl_set_comp_visible("rtr19_5,rtr19_5_desc",TRUE)
                END IF
             ELSE
                CALL cl_set_comp_visible("rtr19_5,rtr19_5_desc",FALSE)
             END IF
          END IF
          
       AFTER INPUT
          IF INT_FLAG THEN
             EXIT INPUT
          END IF
       ON ACTION controlp                         
          CASE
            WHEN INFIELD(rtr06_5)                     
               CALL cl_init_qry_var()
               LET g_qryparam.form ="q_oaj3"
               LET g_qryparam.default1 = g_rtr7.rtr06
               CALL cl_create_qry() RETURNING g_rtr7.rtr06
               DISPLAY g_rtr7.rtr06 TO rtr06_5
               CALL i130_rtr06('d','6')
               NEXT FIELD rtr06_5
          
            OTHERWISE EXIT CASE
          END CASE
       ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT      
     END INPUT
END FUNCTION
 
FUNCTION i130_b9_u() #頁簽九修改
 
   IF s_shut(0) THEN
      RETURN
   END IF
   IF cl_null(g_rto.rto01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
   SELECT rto_file.* INTO g_rto.* FROM rto_file
    WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
      AND  rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
 
   IF g_rto.rtoacti ='N' THEN    
      CALL cl_err('','mfg1000',0)
      RETURN
   END IF
   IF g_rto.rtoconf <>'N' THEN
          CALL cl_err('',9022,0)
          RETURN
   END IF
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
 
   OPEN i130_cl USING g_rto.rto01,g_rto.rto02, 
                      g_rto.rto03,g_rto.rtoplant
   IF STATUS THEN
      CALL cl_err("OPEN i130_cl:", STATUS, 1)
      CLOSE i130_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i130_cl INTO g_rto.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rto.rto01,SQLCA.sqlcode,0)    
       CLOSE i130_cl
       ROLLBACK WORK
       RETURN
   END IF
   LET g_rtr7_t.*=g_rtr7.*
   WHILE TRUE
      CALL i130_b9_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rtr7.*=g_rtr7_t.*
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
         
         UPDATE rtr_file SET rtr06 = g_rtr7.rtr06,
                             rtr08 = g_rtr7.rtr08,
                             rtr16 = g_rtr7.rtr16,
                             rtr17 = g_rtr7.rtr17
           WHERE rtr01 = g_rto_t.rto01 AND rtr02 = g_rto_t.rto02
             AND rtr03 = g_rto_t.rto03 AND rtrplant = g_rto_t.rtoplant 
             AND rtr04 = '6'       
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
         END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i130_cl
   COMMIT WORK
   CALL i130_b9_show()
END FUNCTION
 
FUNCTION i130_b9()
DEFINE l_ac_t  LIKE type_file.num5,
       l_n     LIKE type_file.num5,
       l_lock_sw       LIKE type_file.chr1,
       p_cmd   LIKE type_file.chr1
 
       IF cl_null(g_rto.rto01) THEN
          RETURN
       END IF 
       IF cl_null(g_rtr7.rtr08) THEN
         RETURN
       END IF
 
        INPUT ARRAY g_rtr6 WITHOUT DEFAULTS FROM s_b9.*
                ATTRIBUTE(COUNT=g_rec_b9,MAXCOUNT=g_max_rec,UNBUFFERED,
                        INSERT ROW=FALSE,DELETE ROW=FALSE,
                        APPEND ROW=FALSE)
        BEFORE INPUT
                IF g_rec_b9 <> 0 THEN 
                        CALL fgl_set_arr_curr(l_ac)
                END IF
        BEFORE ROW
                LET p_cmd =''
                LET l_ac =ARR_CURR()
                LET l_lock_sw ='N'
                LET l_n =ARR_COUNT()
                
                BEGIN WORK 
                OPEN i130_cl USING g_rto.rto01,g_rto.rto02,
                                   g_rto.rto03,g_rto.rtoplant
                IF STATUS THEN
                        CALL cl_err("OPEN i130_cl:",STATUS,1)
                        CLOSE i130_cl
                        ROLLBACK WORK
                END IF
                
                FETCH i130_cl INTO g_rto.*
                IF SQLCA.sqlcode THEN
                        CALL cl_err('',SQLCA.sqlcode,0)
                        CLOSE i130_cl
                        ROLLBACK WORK 
                        RETURN
                END IF
                IF g_rec_b9 >= l_ac THEN 
                        LET p_cmd ='u'
                        LET g_rtr6_t.*=g_rtr6[l_ac].*
                        LET g_rtr6_o.*=g_rtr6[l_ac].*
                        OPEN i130_bcl USING g_rto.rto01,g_rto.rto02,
                                            g_rto.rto03,g_rto.rtoplant,
                                            g_rtr6_t.rtr05
                        IF STATUS THEN
                                CALL cl_err("OPEN i130_bcl:",STATUS,1)
                                LET l_lock_sw='Y'
                        ELSE
                                FETCH i130_bcl INTO g_rtr6[l_ac].*
                                IF SQLCA.sqlcode THEN
                                        CALL cl_err("",SQLCA.sqlcode,1)
                                        LET l_lock_sw="Y"
                                END IF
                                SELECT azp02 INTO g_rtr6[l_ac].rtr19_desc FROM azp_file
                                 WHERE azp01=g_rtr6[l_ac].rtr19
                        END IF
                 END IF                                                         

        AFTER FIELD rtr10_5       
          IF NOT cl_null(g_rtr6[l_ac].rtr10) THEN 
                IF p_cmd='a' OR (p_cmd='u' AND
                    g_rtr6[l_ac].rtr10!=g_rtr6_t.rtr10 OR cl_null(g_rtr6_t.rtr10)) THEN      
                   IF g_rtr6[l_ac].rtr10 < 0 THEN
                      CALL cl_err(g_rtr6[l_ac].rtr10,'alm-342',0)     
                      LET g_rtr6[l_ac].rtr10 = g_rtr6_t.rtr10
                      DISPLAY BY NAME g_rtr6[l_ac].rtr10
                      NEXT FIELD rtr10_5
                   END IF
                 END IF
          END IF
          
        ON ROW CHANGE
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              LET g_rtr6[l_ac].* = g_rtr6_t.*
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           IF l_lock_sw = 'Y' THEN
              CALL cl_err("",-263,1)
              LET g_rtr6[l_ac].* = g_rtr6_t.*
           ELSE
             
              UPDATE rtr_file SET  rtr10 = g_rtr6[l_ac].rtr10
               WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02 
                 AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                 AND rtr04='6' AND rtr05=g_rtr6_t.rtr05
              IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
                 CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1) 
                 LET g_rtr6[l_ac].* = g_rtr6_t.*
              ELSE
                  LET g_rto.rtomodu = g_user
                  LET g_rto.rtodate = g_today
                  UPDATE rto_file SET rtomodu = g_rto.rtomodu,
                                  rtodate = g_rto.rtodate
                   WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02 
                     AND rto03 = g_rto.rto03 AND rtoplant=g_rto.rtoplant
                 
                 DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
                 MESSAGE 'UPDATE O.K'
                 COMMIT WORK
              END IF
           END IF
 
        AFTER ROW
           LET l_ac = ARR_CURR()
           LET l_ac_t = l_ac
           IF cl_null(g_rtr6[l_ac].rtr05) THEN
              CALL g_rtr6.deleteelement(l_ac)
           END IF
           IF INT_FLAG THEN
              CALL cl_err('',9001,0)
              LET INT_FLAG = 0
              IF p_cmd = 'u' THEN
                 LET g_rtr6[l_ac].* = g_rtr6_t.*
              END IF
              LET g_intflag=1
              CLOSE i130_bcl
              ROLLBACK WORK
              EXIT INPUT
           END IF
           CLOSE i130_bcl
           COMMIT WORK
           
      ON ACTION CONTROLO                        
           IF INFIELD(rtr05_5) AND l_ac > 1 THEN
              LET g_rtr6[l_ac].* = g_rtr6[l_ac-1].*
              LET g_rtr6[l_ac].rtr05 = g_rec_b9 + 1
              NEXT FIELD rtr05_5
           END IF
 
        ON ACTION CONTROLR
           CALL cl_show_req_fields()
 
        ON ACTION CONTROLG
           CALL cl_cmdask()
     
        ON ACTION CONTROLF
           CALL cl_set_focus_form(ui.Interface.getRootNode()) RETURNING g_fld_name,g_frm_name
           CALL cl_fldhelp(g_frm_name,g_fld_name,g_lang) 
 
        ON IDLE g_idle_seconds
           CALL cl_on_idle()
           CONTINUE INPUT
 
        ON ACTION about       
           CALL cl_about()     
 
        ON ACTION help          
           CALL cl_show_help()  
 
        ON ACTION controls                    
           CALL cl_set_head_visible("","AUTO")   
     END INPUT 
  
END FUNCTION
 
 
FUNCTION i130_delall()
DEFINE l_n1,l_n2,l_n3  LIKE type_file.num5
 
   SELECT COUNT(*) INTO l_n1 FROM rtp_file
     WHERE rtp01 = g_rto.rto01 AND rtp02 = g_rto.rto02
      AND  rtp03 = g_rto.rto03 AND rtpplant = g_rto.rtoplant
   SELECT COUNT(*) INTO l_n2 FROM rtq_file
     WHERE rtq01 = g_rto.rto01 AND rtq02 = g_rto.rto02
      AND  rtq03 = g_rto.rto03 AND rtqplant = g_rto.rtoplant 
   SELECT COUNT(*) INTO l_n3 FROM rtr_file
     WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
      AND  rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant 
           
   IF (l_n1=0) AND (l_n2=0) AND (l_n3=0) THEN                  
      CALL cl_getmsg('9044',g_lang) RETURNING g_msg
      ERROR g_msg CLIPPED
      DELETE FROM rto_file WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
                            AND  rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
      CLEAR FORM
      INITIALIZE g_rto.* TO NULL
   END IF
 
END FUNCTION
      
FUNCTION i130_u()
DEFINE l_success LIKE type_file.chr1
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rto.rto01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rto.* FROM rto_file
    WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
      AND  rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
 
   IF g_rto.rtoacti ='N' THEN    
      CALL cl_err(g_rto.rto01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rto.rtoconf <>'N' THEN
      CALL cl_err('',9022,0)
      RETURN
   END IF
   
   MESSAGE ""
   CALL cl_opmsg('u')
   BEGIN WORK
 
   OPEN i130_cl USING g_rto.rto01,g_rto.rto02,
                      g_rto.rto03,g_rto.rtoplant
   IF STATUS THEN
      CALL cl_err("OPEN i130_cl:", STATUS, 1)
      CLOSE i130_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i130_cl INTO g_rto.*                      
   IF SQLCA.sqlcode THEN
       CALL cl_err(g_rto.rto01,SQLCA.sqlcode,0)    
       CLOSE i130_cl
       ROLLBACK WORK
       RETURN
   END IF
 
   CALL i130_show()
 
   WHILE TRUE
      LET g_rto_t.* = g_rto.*
      LET g_rto_o.* = g_rto.*
      LET g_rto.rtomodu=g_user
      LET g_rto.rtodate=g_today
      DISPLAY BY NAME g_rto.rtomodu,g_rto.rtodate
      
      CALL i130_i("u")                            
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0
         LET g_rto.*=g_rto_t.*
         CALL i130_show()
         CALL cl_err('','9001',0)
         EXIT WHILE
      END IF
 
      IF g_rto.rto01 <> g_rto_t.rto01 OR g_rto.rto03 <> g_rto_t.rto03 THEN            
         UPDATE rtq_file SET rtq01 = g_rto.rto01,
                             rtq03 = g_rto.rto03                            
           WHERE rtq01 = g_rto_t.rto01 AND rtq02 = g_rto_t.rto02
             AND rtq03 = g_rto_t.rto03 AND rtqplant = g_rto_t.rtoplant        
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rtq_file","","",SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
         END IF
         
         UPDATE rtq_file SET rtq01 = g_rto.rto01,
                             rtq03 = g_rto.rto03
           WHERE rtq01 = g_rto_t.rto01 AND rtq02 = g_rto_t.rto02
             AND rtq03 = g_rto_t.rto03 AND rtqplant = g_rto_t.rtoplant      
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rtq_file","","",SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
         END IF
         
         UPDATE rtr_file SET rtr01 = g_rto.rto01,
                             rtr03 = g_rto.rto03
           WHERE rtr01 = g_rto_t.rto01 AND rtr02 = g_rto_t.rto02
             AND rtr03 = g_rto_t.rto03 AND rtrplant = g_rto_t.rtoplant        
         IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
            CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1)  
            CONTINUE WHILE
         END IF         
      END IF
      
      UPDATE rto_file SET rto_file.* = g_rto.*
       WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
         AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
 
      IF SQLCA.sqlcode OR SQLCA.sqlerrd[3] = 0 THEN
         CALL cl_err3("upd","rto_file","","",SQLCA.sqlcode,"","",1)
         CONTINUE WHILE
      ELSE
        IF g_rto.rto08 <> g_rto_t.rto08 OR
           g_rto.rto09 <> g_rto_t.rto09 THEN
           CALL i130_b4_fill(" 1=1",'6')
           IF NOT cl_null(g_rtr7.rtr08) THEN
              CASE 
               WHEN g_rtr7.rtr08 ='1'
                IF YEAR(g_rto.rto08)<>YEAR(g_rto_t.rto08) OR
                   YEAR(g_rto.rto09)<>YEAR(g_rto_t.rto09) THEN
                   LET l_success = 'Y'
                END IF
               WHEN g_rtr7.rtr08 MATCHES '[234]'
                IF MONTH(g_rto.rto08)<>MONTH(g_rto_t.rto08) OR
                   MONTH(g_rto.rto08)<>MONTH(g_rto_t.rto09) THEN
                   LET l_success = 'Y'
                END IF
              END CASE
              IF l_success = 'Y' THEN
                 DELETE FROM rtr_file 
                  WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                    AND rtr03=g_rto.rto03 AND rtrplant = g_rto.rtoplant
                    AND rtr04='6'
                 CALL i130_expand()
              END IF
            END IF
          END IF
        END IF
      EXIT WHILE
   END WHILE
 
   CLOSE i130_cl
   COMMIT WORK
   CALL i130_show()
 
END FUNCTION          
                
FUNCTION i130_r()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rto.rto01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   SELECT * INTO g_rto.* FROM rto_file
    WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02 
      AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
   IF g_rto.rtoacti ='N' THEN    
      CALL cl_err(g_rto.rto01,'mfg1000',0)
      RETURN
   END IF
   
   IF g_rto.rtoconf <>'N' THEN
      CALL cl_err('',9022,0)
      RETURN
   END IF
   
   BEGIN WORK
 
   OPEN i130_cl USING g_rto.rto01,g_rto.rto02,
                      g_rto.rto03,g_rto.rtoplant
   IF STATUS THEN
      CALL cl_err("OPEN i130_cl:", STATUS, 1)
      CLOSE i130_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i130_cl INTO g_rto.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rto.rto01,SQLCA.sqlcode,0)         
      ROLLBACK WORK
      RETURN
   END IF
 
   CALL i130_show()
 
   IF cl_delh(0,0) THEN                   
       INITIALIZE g_doc.* TO NULL          #No.FUN-9B0098 10/02/24
       LET g_doc.column1 = "rto01"         #No.FUN-9B0098 10/02/24
       LET g_doc.column2 = "rto02"         #No.FUN-9B0098 10/02/24
       LET g_doc.column3 = "rto03"         #No.FUN-9B0098 10/02/24
       LET g_doc.value1 = g_rto.rto01      #No.FUN-9B0098 10/02/24
       LET g_doc.value2 = g_rto.rto02      #No.FUN-9B0098 10/02/24
       LET g_doc.value3 = g_rto.rto03      #No.FUN-9B0098 10/02/24
       CALL cl_del_doc()                                                            #No.FUN-9B0098 10/02/24
      DELETE FROM rto_file WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02 
                             AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
      DELETE FROM rtp_file WHERE rtp01 = g_rto.rto01 AND rtp02 = g_rto.rto02 
                             AND rtp03 = g_rto.rto03 AND rtpplant = g_rto.rtoplant
      DELETE FROM rtq_file WHERE rtq01 = g_rto.rto01 AND rtq02 = g_rto.rto02 
                             AND rtq03 = g_rto.rto03 AND rtqplant = g_rto.rtoplant
      DELETE FROM rtr_file WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02 
                             AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant
      CLEAR FORM
      CALL g_rtp.clear()
      CALL g_rtq.clear()
      CALL g_rtq1.clear()
      CALL g_rtr1.clear()
      CALL g_rtr2.clear()
      CALL g_rtr3.clear()
      CALL g_rtr4.clear()
      CALL g_rtr5.clear()
      CALL g_rtr6.clear()
      OPEN i130_count
      #FUN-B50064-add-start--
      IF STATUS THEN
         CLOSE i130_cs
         CLOSE i130_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      FETCH i130_count INTO g_row_count
      #FUN-B50064-add-start--
      IF STATUS OR (cl_null(g_row_count) OR  g_row_count = 0 ) THEN
         CLOSE i130_cs
         CLOSE i130_count
         COMMIT WORK
         RETURN
      END IF
      #FUN-B50064-add-end-- 
      DISPLAY g_row_count TO FORMONLY.cnt
      OPEN i130_cs
      IF g_row_count >0 THEN
         IF g_curs_index = g_row_count + 1 THEN
            LET g_jump = g_row_count
            CALL i130_fetch('L')
         ELSE
            LET g_jump = g_curs_index
            LET mi_no_ask = TRUE      
            CALL i130_fetch('/')
         END IF
      END IF
   END IF
 
   CLOSE i130_cl
   COMMIT WORK
   
END FUNCTION
 
FUNCTION i130_copy()
   DEFINE l_newno1    LIKE rto_file.rto01,
          l_newno3    LIKE rto_file.rto03,
          l_oldno1    LIKE rto_file.rto01,
          l_oldno3    LIKE rto_file.rto03,
          l_cnt       LIKE type_file.num5,
          li_result   LIKE type_file.num5 
 
   IF s_shut(0) THEN RETURN END IF
 
   IF cl_null(g_rto.rto01) THEN
      CALL cl_err('',-400,0)
      RETURN
   END IF
 
   LET g_before_input_done = FALSE
   LET l_newno3 = g_rto.rto02
   
   CALL cl_set_head_visible("","YES")       
   
   IF g_change = 'N' THEN
      CALL i130_set_entry('a')
     INPUT l_newno1 FROM rto01
       BEFORE INPUT
         CALL cl_set_docno_format("rto01")
       
       AFTER FIELD rto01
          IF NOT cl_null(l_newno1) THEN                                          
             SELECT COUNT(*) INTO l_cnt FROM rto_file                          
              WHERE rto01 = l_newno1 AND rto02 = g_rto.rto02
                AND rto03 = g_rto.rto03 AND rtoplant = g_plant
             IF l_cnt > 0 THEN                                                 
                CALL cl_err('',-239,0)                                    
                NEXT FIELD rto01                                              
             END IF                                                                                                              
             #FUN-B50026 add
             CALL s_check_no("art",l_newno1,"","A3","rto_file","rto01,rto02,rto03,rtoplant","")
                  RETURNING li_result,l_newno1
             IF (NOT li_result) THEN                                                            
                NEXT FIELD rto01                                                                                      
             END IF             
             #FUN-B50026 add--end
          END IF                 
                 
       ON ACTION controlp
          CASE
             WHEN INFIELD(rto01)  #合同編號
                LET g_t1=s_get_doc_no(l_newno1)
                CALL q_oay(FALSE,FALSE,g_t1,'A3','art') RETURNING g_t1    #FUN-A70130 
                LET l_newno1=g_t1                                                                                             
                DISPLAY l_newno1 TO rto01                                                                                 
                NEXT FIELD rto01
            OTHERWISE EXIT CASE
           END CASE
 
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
         LET INT_FLAG = 0
         DISPLAY BY NAME g_rto.rto01,g_rto.rto03 
         RETURN
      END IF
 
#     CALL s_auto_assign_no("axm",l_newno1,g_today,"","rto_file","rto01,rto02,rto03,rtoplant","","","")  #FUN-A70130 mark
      CALL s_auto_assign_no("art",l_newno1,g_today,"A3","rto_file","rto01,rto02,rto03,rtoplant","","","")  #FUN-A70130 mod
           RETURNING li_result,l_newno1
      IF (NOT li_result) THEN                                                                           
          ROLLBACK WORK
          RETURN                                                                    
      END IF
   ELSE #合同變更
       IF g_rto.rtoconf='N' THEN
          CALL cl_err('','art-080',0)
          RETURN
       END IF
       IF g_rto.rtoconf='X' THEN
 #         CALL cl_err('',9024,0)             #FUN-B90094 mark
          CALL cl_err('','art-868',0)        #FUN-B90094 add
          RETURN
       END IF
       IF g_rto.rtoplant <> g_rto.rto03 THEN
          CALL cl_err('','art-491',0)
          RETURN
       END IF
       SELECT COUNT(*) INTO l_cnt FROM rto_file
        WHERE rto01 = g_rto.rto01 AND rto03 = g_rto.rto03
          AND rtoconf = 'N'
       IF l_cnt > 0 THEN
          CALL cl_err('','art-492',0)
          RETURN
       END IF
       IF NOT cl_confirm('art-469') THEN 
          RETURN
       END IF
       LET l_newno1 = g_rto.rto01
       #版本號加一
       SELECT MAX(rto02)+1 INTO l_newno3 FROM rto_file
        WHERE rto01=g_rto.rto01
          AND rto03=g_rto.rto03
   END IF
   BEGIN WORK
 
   DROP TABLE y
   SELECT * FROM rto_file         
    WHERE rto01=g_rto.rto01 AND rto02 = g_rto.rto02
      AND rto03=g_rto.rto03 AND rtoplant = g_rto.rtoplant
    INTO TEMP y
 
   UPDATE y
       SET rto01 = l_newno1,    
           rto02 = l_newno3,
           rtouser = g_user,   
           rtogrup = g_grup,   
           rtomodu = NULL,     
           rtodate = g_today,  
           rtoacti = 'Y',
           rtoconf = 'N',
           rtoconu = NULL,
           rtocond = NULL,
           rtooriu = g_user,       #TQC-A30028 ADD
           rtoorig = g_grup,       #TQC-A30028 ADD
           rto11 = NULL     
 
   INSERT INTO rto_file SELECT * FROM y
   
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rto_file","","",SQLCA.sqlcode,"","",1) 
      ROLLBACK WORK
      RETURN
   ELSE
  
   DROP TABLE x
 
   SELECT * FROM rtp_file         
    WHERE rtp01 = g_rto.rto01 AND rtp02 = g_rto.rto02
      AND rtp03 = g_rto.rto03 AND rtpplant = g_rto.rtoplant
       INTO TEMP x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rtp_file","","",SQLCA.sqlcode,"","",1) 
      RETURN
   END IF
 
   UPDATE x SET rtp01=l_newno1,
                rtp02=l_newno3
   INSERT INTO rtp_file
       SELECT * FROM x
   IF SQLCA.sqlcode THEN
      CALL cl_err3("ins","rtp_file","","",SQLCA.sqlcode,"","",1)
      ROLLBACK WORK 
      RETURN
   ELSE
       
       DROP TABLE w
 
      SELECT * FROM rtq_file         
          WHERE rtq01 = g_rto.rto01 AND rtq02 = g_rto.rto02
            AND rtq03 = g_rto.rto03 AND rtqplant = g_rto.rtoplant
           INTO TEMP w
      IF SQLCA.sqlcode THEN
          CALL cl_err3("ins","rtq_file","","",SQLCA.sqlcode,"","",1) 
          RETURN
      END IF
 
      UPDATE w SET rtq01=l_newno1,
                   rtq02=l_newno3
     INSERT INTO rtq_file
         SELECT * FROM w
     IF SQLCA.sqlcode THEN
        CALL cl_err3("ins","rtq_file","","",SQLCA.sqlcode,"","",1)
        ROLLBACK WORK 
        RETURN
     ELSE
     
        DROP TABLE v
 
        SELECT * FROM rtr_file         
         WHERE rtr01 = g_rto.rto01 AND rtr02 = g_rto.rto02
           AND rtr03 = g_rto.rto03 AND rtrplant = g_rto.rtoplant 
          INTO TEMP v
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rtr_file","","",SQLCA.sqlcode,"","",1) 
         RETURN
      END IF
 
      UPDATE v SET rtr01=l_newno1,
                   rtr02=l_newno3
      INSERT INTO rtr_file
         SELECT * FROM v
      IF SQLCA.sqlcode THEN
         CALL cl_err3("ins","rtr_file","","",SQLCA.sqlcode,"","",1)
         ROLLBACK WORK 
         RETURN
      ELSE
         COMMIT WORK
         LET g_cnt=SQLCA.SQLERRD[3]
         MESSAGE '(',g_cnt USING '##&',') ROW of (',l_newno1,') O.K'
      END IF
     END IF
   END IF
   END IF
    
   LET l_oldno1 = g_rto.rto01
   LET l_oldno3 = g_rto.rto02
   SELECT rto_file.* INTO g_rto.* FROM rto_file 
    WHERE rto01 = l_newno1 AND rto02 = l_newno3
      AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant 
   
   CALL i130_u()
   CALL i130_b_all()                  #FUN-B80123
#FUN-B80123-------------STA-------------
#   CALL i130_b('1')
#   CALL i130_b('2')
#   CALL i130_b('3')
#   CALL i130_b('4')
#   CALL i130_b('5')
#   CALL i130_b('6')
#   CALL i130_b('7')
#   CALL i130_b('8')
#   CALL i130_b9_a()
#FUN-B80123-------------END-------------
#FUN-B90094 mark START---------------------
#   SELECT rto_file.* INTO g_rto.* FROM rto_file 
#    WHERE rto01 = l_oldno1 AND rto02 = l_oldno3
#      AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
#FUN-B90094 mark END-----------------------

#FUN-B90094 add START---------------------
   SELECT rto_file.* INTO g_rto.* FROM rto_file
    WHERE rto01 = l_newno1 AND rto02 = l_newno3
      AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
#FUN-B90094 add END-----------------------
   CALL i130_show()
 
END FUNCTION
 
FUNCTION i130_x()
 
   IF s_shut(0) THEN
      RETURN
   END IF
 
   IF cl_null(g_rto.rto01) THEN
      CALL cl_err("",-400,0)
      RETURN
   END IF
 
   BEGIN WORK
 
   OPEN i130_cl USING g_rto.rto01,g_rto.rto02,
                      g_rto.rto03,g_rto.rtoplant
   IF STATUS THEN
      CALL cl_err("OPEN i130_cl:", STATUS, 1)
      CLOSE i130_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i130_cl INTO g_rto.*               
   IF SQLCA.sqlcode THEN
      CALL cl_err(g_rto.rto01,SQLCA.sqlcode,0)          
      ROLLBACK WORK
      RETURN
   END IF
   
   IF g_rto.rtoconf <>'N' THEN
      CALL cl_err('',9022,0)
      RETURN
   END IF
   
   LET g_success = 'Y'
 
   CALL i130_show()
 
   IF cl_exp(0,0,g_rto.rtoacti) THEN                   
      LET g_chr=g_rto.rtoacti
      IF g_rto.rtoacti='Y' THEN
         LET g_rto.rtoacti='N'
      ELSE
         LET g_rto.rtoacti='Y'
      END IF
 
      UPDATE rto_file SET rtoacti=g_rto.rtoacti,
                          rtomodu=g_user,
                          rtodate=g_today
       WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02 
         AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
      IF SQLCA.sqlcode OR SQLCA.SQLERRD[3]=0 THEN
         CALL cl_err3("upd","rto_file",g_rto.rto01,"",SQLCA.sqlcode,"","",1)  
         LET g_rto.rtoacti=g_chr
      END IF
   END IF
 
   CLOSE i130_cl
 
   IF g_success = 'Y' THEN
      COMMIT WORK
   ELSE
      ROLLBACK WORK
   END IF
 
   SELECT rtoacti,rtomodu,rtodate
     INTO g_rto.rtoacti,g_rto.rtomodu,g_rto.rtodate FROM rto_file
    WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02 
      AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
   DISPLAY BY NAME g_rto.rtoacti,g_rto.rtomodu,g_rto.rtodate
 
END FUNCTION                                                            
 
FUNCTION i130_y() #審核
DEFINE l_cnt   LIKE type_file.num5
#DEFINE l_azp03 LIKE azp_file.azp03     #FUN-A50102
DEFINE l_sql   STRING
DEFINE l_rtp05 LIKE rtp_file.rtp05
#FUN-B90094 add START---------------------
DEFINE l_rtp05_o  LIKE rtp_file.rtp05
DEFINE l_rto02_o  LIKE rto_file.rto02
#FUN-B90094 add END-----------------------
 
   IF cl_null(g_rto.rto01) THEN 
        CALL cl_err('',-400,0) 
        RETURN 
   END IF
#CHI-C30107 --------------- add ----------------- begin
    IF g_rto.rtoacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
    END IF

    IF g_rto.rtoconf='Y' THEN
        CALL cl_err('','9023',0)
        RETURN
    END IF

    IF g_rto.rtoconf='X' THEN
      CALL cl_err('','art-868',0)      
      RETURN
    END IF
    IF NOT cl_confirm('axm-108') THEN
        RETURN
    END IF
    SELECT * INTO g_rto.* FROM rto_file WHERE rto01   = g_rto.rto01
                                          AND rto02   = g_rto.rto02
                                          AND rto03   = g_rto.rto03
                                          AND rtoplant= g_rto.rtoplant 
#CHI-C30107 --------------- add ----------------- end
#FUN-B90094 add START---------------------
   IF g_plant <> g_rto.rto03 THEN
      CALL cl_err('','art-867',0)
      RETURN
   END IF
#FUN-B90094 add END-----------------------
   CALL i130_createtable()
   
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i130_cl USING g_rto.rto01,g_rto.rto02, 
                      g_rto.rto03,g_rto.rtoplant
   IF STATUS THEN
      CALL cl_err("OPEN i130_cl:", STATUS, 1)
      CLOSE i130_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i130_cl INTO g_rto.*    
     IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)      
      CLOSE i130_cl
      ROLLBACK WORK
      RETURN
    END IF

    #FUN-C90046-------mark-----str
    ##TQC-B50138--add--str--
    #LET l_cnt = 0
    #SELECT COUNT(*) INTO l_cnt FROM rtq_file
    # WHERE rtq01 = g_rto.rto01
    #   AND rtq02 = g_rto.rto02
    #   AND rtq03 = g_rto.rto03
    #   AND rtqplant = g_rto.rtoplant
    #   AND rtq06 IS NOT NULL
    #IF l_cnt < 1 THEN
    #   CALL cl_err('','art-727',0)
    #   RETURN
    #END IF
    ##TQC-B50138--add--end--
    #FUN-C90046-------mark-----end

    IF g_rto.rtoacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
    END IF
   
    IF g_rto.rtoconf='Y' THEN 
        CALL cl_err('','9023',0)
        RETURN
    END IF
   
    IF g_rto.rtoconf='X' THEN
 #     CALL cl_err('',9024,0)            #FUN-B90094 mark
      CALL cl_err('','art-868',0)        #FUN-B90094 add
      RETURN
    END IF
       
    LET l_sql="SELECT rtp05 FROM rtp_file ",
              " WHERE rtp01=? AND rtp02=? ",
              "   AND rtp03=? AND rtpplant=?"
    PREPARE rtp_pre1 FROM l_sql
    DECLARE rtp_cs1 CURSOR FOR rtp_pre1
    CALL s_showmsg_init()
    FOREACH rtp_cs1 USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
                     INTO l_rtp05   
       IF SQLCA.sqlcode THEN
          LET g_success = 'N'
          CALL s_errmsg('','','Foreach rtp_cs1:',SQLCA.sqlcode,1)                         
          CONTINUE FOREACH
       END IF
#      SELECT azp03 INTO l_azp03 FROM azp_file       #FUN-A50102
#       WHERE azp01=l_rtp05                          #FUN-A50102
        LET l_sql="SELECT COUNT(rto_file.rto01) FROM ",
             #s_dbstring(l_azp03 CLIPPED),"rto_file,",s_dbstring(l_azp03 CLIPPED),"rtp_file ",     #FUN-A50102 mark
              cl_get_target_table(l_rtp05,'rto_file'),",",      #FUN-A50102
              cl_get_target_table(l_rtp05,'rtp_file'),          #FUN-A50102
              " WHERE rto01=rtp01 AND rto02=rtp02 AND rto03=rtp03 AND rtoplant=rtpplant",                 
              " AND rto05=? AND rto06=?",
              " AND (rto08 BETWEEN ? AND ? OR rto09 BETWEEN ? AND ?)",
              " AND rtp05=? AND rtoplant=? AND rtoconf='Y'",
              " AND rto01 <> '",g_rto.rto01,"' " #No.FUN-960130 注:合同变更后合同号一样情况下此方法修改
       CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102 
       CALL cl_parse_qry_sql(l_sql,l_rtp05) RETURNING l_sql     #FUN-A50102
       PREPARE rtp05_cs FROM l_sql
       EXECUTE rtp05_cs INTO l_cnt USING g_rto.rto05,g_rto.rto06,
                             g_rto.rto08,g_rto.rto09,g_rto.rto08,g_rto.rto09,
                             l_rtp05,l_rtp05    
       IF sqlca.sqlcode THEN
          LET g_success = 'N'
          CALL s_errmsg('','','Foreach rtp_cs1:',SQLCA.sqlcode,1)                         
          CONTINUE FOREACH
       ELSE
         IF l_cnt>0 THEN
            LET g_success = 'N'
            CALL s_errmsg('rtp05',l_rtp05,'','art-072',1)                         
            CONTINUE FOREACH
         END IF   
       END IF
    END FOREACH  
    IF g_success = 'N' THEN
       CALL s_showmsg()
       ROLLBACK WORK
       RETURN
    END IF  
#CHI-C30107 ------------------- mark ------------------- begin
#   IF NOT cl_confirm('axm-108') THEN 
#       RETURN
#   END IF 
#CHI-C30107 ------------------- mark ------------------- end
    #將副本廢止
    SELECT COUNT(*) INTO l_cnt FROM rto_file
     WHERE rto01 = g_rto.rto01 AND rto03 = g_rto.rto03
       AND rtoconf = 'Y'  AND  rtoplant=g_rto.rtoplant #No.FUN-960130 
    IF l_cnt = 1 THEN  
       UPDATE rto_file SET rtoconf = 'X',
                           rtoconu = g_user,
                           rtocond = g_today,
                           rtomodu = g_user,
                           rtodate = g_today,
                           rto11 = g_today
        WHERE rto01 = g_rto.rto01 AND rtoconf = 'Y'
          AND rto03 = g_rto.rto03 AND rtoplant=g_rto.rtoplant
       IF SQLCA.sqlcode THEN
          CALL cl_err3("upd","rto_file",g_rto.rto01,"",STATUS,"","",1) 
          LET g_success = 'N'
       ELSE
          IF SQLCA.sqlerrd[3]=0 THEN
             CALL cl_err3("upd","rto_file",g_rto.rto01,"","9050","","",1) 
             LET g_success = 'N'
          ELSE                     
             #拋轉
             LET g_flag1 = 'X'   #FUN-B90094 add
             CALL i130_transfer()
             LET g_flag1 = 'Y'   #FUN-B90094 add
          END IF
        END IF
     END IF
     IF g_success = 'Y' THEN
            UPDATE rto_file SET rtoconf = 'Y',
                                rtoconu = g_user,
                                rtocond = g_today,
                                rtomodu = g_user,
                                rtodate = g_today
               WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
                 AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","rto_file",g_rto.rto01,"",STATUS,"","",1) 
               LET g_success = 'N'
            ELSE
               IF SQLCA.sqlerrd[3]=0 THEN
                  CALL cl_err3("upd","rto_file",g_rto.rto01,"","9050","","",1) 
                  LET g_success = 'N'
               ELSE
                  LET g_flag1 = 'Y'   #FUN-B90094 add
                  CALL i130_transfer()   
                  ##TQC-C60107 add此函数用来判断和生成是否,新增加的营运中心没有对应的采购协议
                  CALL i130_transfer2() #TQC-C60107 add                                                        
               END IF
           END IF
     END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_rto.rtoconf = 'Y'
      LET g_rto.rtoconu = g_user
      LET g_rto.rtocond = g_today
      LET g_rto.rtomodu = g_user
      LET g_rto.rtodate = g_today
      DISPLAY BY NAME g_rto.rtoconf,g_rto.rtoconu,g_rto.rtocond,
                      g_rto.rtomodu,g_rto.rtodate
      CALL i130_rtoconu('d')
      CALL cl_set_field_pic(g_rto.rtoconf,"","","","","")
      CALL cl_err('','art-169',0)
   ELSE
      ROLLBACK WORK
   END IF
   
END FUNCTION           
 
FUNCTION i130_v() #廢止
DEFINE l_n LIKE type_file.num5
 
   IF cl_null(g_rto.rto01) THEN 
        CALL cl_err('',-400,0) 
        RETURN 
   END IF
   
   IF g_rto.rtoacti='N' THEN
        CALL cl_err('','atm-364',0)
        RETURN
   END IF
   
   IF g_rto.rtoconf ='X' THEN
#      CALL cl_err('',9024,0)            #FUN-B90094 mark
      CALL cl_err('','art-868',0)        #FUN-B90094 add
      RETURN
   END IF
   IF g_rto.rtoconf = 'N' THEN
      CALL cl_err('','art-081',0)
      RETURN
   END IF
#FUN-B90094 add START---------------------
   IF g_plant <> g_rto.rto03 THEN
      CALL cl_err('','art-866',0)
      RETURN
   END IF
#FUN-B90094 add END-----------------------
   SELECT COUNT(*) INTO l_n FROM rto_file
    WHERE rto01 = g_rto.rto01 AND rto03 = g_rto.rto03
      AND rtoconf = 'N' AND rtoplant = g_rto.rtoplant
   IF l_n > 0 THEN
      CALL cl_err('','art-490',0)
      RETURN
   END IF
#   IF NOT cl_confirm('lib-016') THEN  #FUN-B90094 mark 
   IF NOT cl_confirm('art-869') THEN   #FUN-B90094 add 
       RETURN
   END IF
   CALL i130_createtable()
   BEGIN WORK
   LET g_success = 'Y'
 
   OPEN i130_cl USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant
   IF STATUS THEN
      CALL cl_err("OPEN i130_cl:", STATUS, 1)
      CLOSE i130_cl
      ROLLBACK WORK
      RETURN
   END IF
 
   FETCH i130_cl INTO g_rto.*    
     IF SQLCA.sqlcode THEN
      CALL cl_err('',SQLCA.sqlcode,0)      
      CLOSE i130_cl
      ROLLBACK WORK
      RETURN
     END IF          
      UPDATE rto_file SET rtoconf = 'X',
                          rto11 = g_today,
                          rtoconu = g_user,
                          rtocond = g_today,
                          rtomodu = g_user,
                          rtodate = g_today
       WHERE rto01 = g_rto.rto01 AND rto02 = g_rto.rto02
         AND rto03 = g_rto.rto03 AND rtoplant = g_rto.rtoplant
       IF SQLCA.sqlcode THEN
              CALL cl_err3("upd","rto_file",g_rto.rto01,"",STATUS,"","",1) 
              LET g_success = 'N'
       ELSE
            IF SQLCA.sqlerrd[3]=0 THEN
              CALL cl_err3("upd","rto_file",g_rto.rto01,"","9050","","",1) 
              LET g_success = 'N'
            ELSE
              SELECT COUNT(*) INTO l_n FROM rts_file
               WHERE rts04=g_rto.rto01
                 AND rtsconf <> 'X'  #CHI-C80041
              IF l_n>0 THEN
                 UPDATE rts_file SET rtsconf = 'X',
                                     rtsconu = g_user,
                                     rtscond = g_today,
                                     rtsmodu = g_user,
                                     rtsdate = g_today
                  WHERE rts04 = g_rto.rto01
                 IF SQLCA.sqlcode THEN
                    CALL cl_err3("upd","rts_file",g_rto.rto01,"",STATUS,"","",1) 
                    LET g_success = 'N'
                 ELSE
                   IF SQLCA.sqlerrd[3]=0 THEN
                      CALL cl_err3("upd","rts_file",g_rto.rto01,"","9050","","",1) 
                      LET g_success = 'N'
                   END IF
                 END IF
              END IF
            END IF
        END IF
   IF g_success = 'Y' THEN
      CALL i130_transfer()
   END IF
   IF g_success = 'Y' THEN
      COMMIT WORK
      LET g_rto.rtoconf = 'X'
      LET g_rto.rto11 = g_today
      LET g_rto.rtoconu = g_user
      LET g_rto.rtocond = g_today
      LET g_rto.rtomodu = g_user
      LET g_rto.rtodate = g_today
      DISPLAY BY NAME g_rto.rtoconf,g_rto.rto11,g_rto.rtoconu,g_rto.rtocond,
                      g_rto.rtouser,g_rto.rtodate
      CALL i130_rtoconu('d')
      CALL cl_set_field_pic("","","","",'Y',"")
   ELSE
      ROLLBACK WORK
   END IF
   
END FUNCTION               
 
FUNCTION i130_transfer() #拋轉
DEFINE  l_dbname LIKE azp_file.azp03
DEFINE  l_sql STRING 
DEFINE  l_n,l_cnt   LIKE type_file.num5
DEFINE  l_rtp05   LIKE rtp_file.rtp05
DEFINE  li_result LIKE type_file.num5
DEFINE  l_legal   LIKE rto_file.rtolegal
DEFINE  l_rto02_o LIKE rto_file.rto02   #FUN-B90094  add
   LET l_rto02_o = NULL   #FUN-B90094  add 
   LET l_sql="SELECT azp03,rtp05 FROM azp_file,rtp_file ",    
             " WHERE rtp05=azp01 ",
             " AND rtp01=? AND rtp02=? AND rtp03=? AND rtpplant=?"
   PREPARE trans_pre FROM l_sql
   DECLARE trans_cs  CURSOR FOR trans_pre
   LET l_rto02_o = g_rto.rto02-1   #FUN-B90094 add
#FUN-B90094 add START---------------------
   IF g_flag1 = 'X' THEN
      LET l_rto02_o = g_rto.rto02 - 1
   ELSE
      LET l_rto02_o = g_rto.rto02
   END IF
#FUN-B90094 add END----------------------- 

#   FOREACH trans_cs USING g_rto.rto01,g_rto.rto02,g_rto.rto03,g_rto.rtoplant         #FUN-B90094 mark
#                    INTO l_dbname,l_rtp05                                            #FUN-B90094 mark 
   FOREACH trans_cs USING g_rto.rto01,l_rto02_o,g_rto.rto03,g_rto.rtoplant            #FUN-B90094 add 
                    INTO l_dbname,l_rtp05                                             #FUN-B90094 add
      IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)                         
          RETURN                                                    
      END IF   
      IF l_rtp05 <> g_rto.rtoplant THEN
        #LET l_sql="SELECT COUNT(*) FROM ",s_dbstring(l_dbname CLIPPED),"rto_file",     #FUN-A50102  mark
         LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_rtp05,'rto_file'),     #FUN-A50102
                   " WHERE rto01 = ? AND rto03=? AND rtoplant=? AND rtoconf = 'Y'"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102
         CALL cl_parse_qry_sql(l_sql,l_rtp05) RETURNING l_sql     #FUN-A50102
         PREPARE trans_sel FROM l_sql
         EXECUTE trans_sel INTO l_cnt USING g_rto.rto01,g_rto.rto03,l_rtp05
         
        IF l_cnt=0 THEN
            DELETE FROM rto_temp
            INSERT INTO rto_temp
            SELECT * FROM rto_file WHERE rto01 = g_rto.rto01 AND rto02= g_rto.rto02
                                     AND rto03= g_rto.rto03 AND rtoplant = g_rto.rtoplant
            SELECT azw02 INTO l_legal FROM azw_file WHERE azw01=l_rtp05
            UPDATE rto_temp SET rtolegal=l_legal,
                                rtoplant=l_rtp05
           #LET l_sql = "INSERT INTO ",s_dbstring(l_dbname CLIPPED),"rto_file",                 #FUN-A50102 mark  
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_rtp05,'rto_file'),                 #FUN-A50102 
                        " SELECT * FROM rto_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,l_rtp05) RETURNING l_sql    #FUN-A50102
            PREPARE trans_ins_rto FROM l_sql
            EXECUTE trans_ins_rto          
           IF SQLCA.sqlcode THEN
              CALL cl_err3("ins","rto_file","","",SQLCA.sqlcode,"","",1)
              LET g_success = 'N'
              EXIT FOREACH
           END IF
         SELECT COUNT(*) INTO l_cnt FROM rtp_file
          WHERE rtp01=g_rto.rto01 AND rtp02=g_rto.rto02
            AND rtp03=g_rto.rto03 AND rtpplant=g_rto.rtoplant
         IF l_cnt>0 THEN
            DELETE FROM rtp_temp
            INSERT INTO rtp_temp
            SELECT * FROM rtp_file WHERE rtp01 = g_rto.rto01 AND rtp02= g_rto.rto02
                                     AND rtp03= g_rto.rto03 AND rtpplant = g_rto.rtoplant
            UPDATE rtp_temp SET rtplegal=l_legal,
                                rtpplant=l_rtp05
        #LET l_sql = "INSERT INTO ",s_dbstring(l_dbname CLIPPED),"rtp_file",    #FUN-A50102 mark
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_rtp05,'rtp_file'),    #FUN-A50102 
                     " SELECT * FROM rtp_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql           #FUN-A50102
         CALL cl_parse_qry_sql(l_sql,l_rtp05) RETURNING l_sql   #FUN-A50102 
         PREPARE trans_ins_rtp FROM l_sql
         EXECUTE trans_ins_rtp 
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rtp_file","","",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         END IF
         SELECT COUNT(*) INTO l_cnt FROM rtq_file
          WHERE rtq01=g_rto.rto01 AND rtq02=g_rto.rto02
            AND rtq03=g_rto.rto03 AND rtqplant=g_rto.rtoplant
         IF l_cnt>0 THEN
            DELETE FROM rtq_temp
            INSERT INTO rtq_temp
            SELECT * FROM rtq_file WHERE rtq01 = g_rto.rto01 AND rtq02= g_rto.rto02
                                     AND rtq03= g_rto.rto03 AND rtqplant=g_rto.rtoplant
            UPDATE rtq_temp SET rtqlegal=l_legal,
                                rtqplant=l_rtp05
           #LET l_sql = "INSERT INTO ",s_dbstring(l_dbname CLIPPED),"rtq_file",     #FUN-A50102 mark
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_rtp05,'rtq_file'),     #FUN-A50102
                        " SELECT * FROM rtq_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql           #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,l_rtp05) RETURNING l_sql   #FUN-A50102
            PREPARE trans_ins_rtq FROM l_sql
            EXECUTE trans_ins_rtq
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rtq_file","","",SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF
         SELECT COUNT(*) INTO l_cnt FROM rtr_file
          WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
            AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
         IF l_cnt>0 THEN
            DELETE FROM rtr_temp
            INSERT INTO rtr_temp
            SELECT * FROM rtr_file WHERE rtr01 = g_rto.rto01 AND rtr02= g_rto.rto02
                                     AND rtr03= g_rto.rto03 AND rtrplant=g_rto.rtoplant
            UPDATE rtr_temp SET rtrlegal=l_legal,
                                rtrplant=l_rtp05
           #LET l_sql = "INSERT INTO ",s_dbstring(l_dbname CLIPPED),"rtr_file",      #FUN-A50102 mark
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_rtp05,'rtr_file'),      #FUN-A50102
                        " SELECT * FROM rtr_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql          #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,l_rtp05) RETURNING l_sql  #FUN-A50102
            PREPARE trans_ins_rtr FROM l_sql
            EXECUTE trans_ins_rtr  
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rtr_file","","",SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               EXIT FOREACH
            END IF
         END IF
      ELSE
           #LET l_sql = "UPDATE ",s_dbstring(l_dbname CLIPPED),"rto_file",          #FUN-A50102 mark
            LET l_sql = "UPDATE ",cl_get_target_table(l_rtp05,'rto_file'),          #FUN-A50102
                        " SET  rtoconf='X',rtoconu='",g_user,"',rtocond='",g_today,
                        "',rtomodu='",g_user,"',rtodate='",g_today,"', rto11='",g_today,
                        "' WHERE rto01 = ? AND rtoconf = 'Y' AND rto03=? AND rtoplant=?"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-A50102
            CALL cl_parse_qry_sql(l_sql,l_rtp05) RETURNING l_sql    #FUN-A50102
            PREPARE trans_upd_rto FROM l_sql
            EXECUTE trans_upd_rto USING g_rto.rto01,g_rto.rto03,l_rtp05
            IF SQLCA.sqlcode THEN
               CALL cl_err3("upd","rtr_file","","",SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
               EXIT FOREACH
            ELSE
             #LET l_sql="SELECT COUNT(*) FROM ",s_dbstring(l_dbname CLIPPED),"rto_file",     #FUN-A50102 mark
              LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_rtp05,'rto_file'),     #FUN-A50102
                        " WHERE rto01=? AND rto03 = ? AND rtoplant=?"
              CALL cl_replace_sqldb(l_sql) RETURNING l_sql             #FUN-A50102 
              CALL cl_parse_qry_sql(l_sql,l_rtp05) RETURNING l_sql     #FUN-A50102
              PREPARE sel_rto FROM l_sql
              EXECUTE sel_rto INTO l_cnt USING g_rto.rto01,g_rto.rto03,g_rto.rtoplant
              IF l_cnt = 1 THEN
                #LET l_sql="SELECT COUNT(*) FROM ",s_dbstring(l_dbname CLIPPED),"rts_file",  #FUN-A50102  mark
                 LET l_sql="SELECT COUNT(*) FROM ",cl_get_target_table(l_rtp05,'rts_file'),  #FUN-A50102
                        " WHERE rts04=? AND rtsplant=?",
                        "   AND rtsconf <> 'X'"  #CHI-C80041
                 CALL cl_replace_sqldb(l_sql) RETURNING l_sql          #FUN-A50102
                 CALL cl_parse_qry_sql(l_sql,l_rtp05) RETURNING l_sql  #FUN-A50102
                 PREPARE trans_sel_rts FROM l_sql
                 EXECUTE trans_sel_rts USING g_rto.rto01,l_rtp05 INTO l_cnt
                 IF l_cnt>0 THEN
                 #  LET l_sql="UPDATE ",s_dbstring(l_dbname CLIPPED),"rts_file SET rtsconf = 'X',",     #FUN-A50102 mark
                    LET l_sql="UPDATE ",cl_get_target_table(l_rtp05,'rts_file')," SET rtsconf = 'X',",  #FUN-A50102    
                           " rtsconu = '",g_user,"',rtscond = '",g_today,
                           "',rtsmodu='",g_user,"',rtsdate='",g_today,"'",
                           " WHERE rts04 = ? AND rtsplant = ?",
                           "   AND rtsconf <> 'X' "  #CHI-C80041
                    CALL cl_replace_sqldb(l_sql) RETURNING l_sql            #FUN-A50102
                    CALL cl_parse_qry_sql(l_sql,l_rtp05) RETURNING l_sql    #FUN-A50102
                    PREPARE trans_upd_rts FROM l_sql
                    EXECUTE trans_upd_rts USING g_rto.rto01,l_rtp05
                    IF SQLCA.sqlcode THEN
                       CALL cl_err3("upd","rts_file",g_rto.rto01,"",STATUS,"","",1) 
                       LET g_success = 'N'
                    ELSE
                      IF SQLCA.sqlerrd[3]=0 THEN
                         CALL cl_err3("upd","rts_file",g_rto.rto01,"","9050","","",1) 
                         LET g_success = 'N'
                      END IF
                    END IF
                END IF
              END IF
            END IF
        END IF
      END IF
    END FOREACH
    
END FUNCTION
 
FUNCTION i130_expandcheck() #判斷單身是否重新生成
DEFINE l_n LIKE type_file.num5
      IF cl_null(g_rtr7.rtr08) THEN
         RETURN
      END IF
      SELECT COUNT(*) INTO l_n FROM rtr_file 
       WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
         AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
         AND rtr04='6'
      IF l_n=0 THEN
          CALL i130_expand()
      ELSE
          IF g_rtr7.rtr08<>g_rtr7_t.rtr08 THEN
             DELETE FROM rtr_file 
              WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                AND rtr04='6'
             CALL i130_expand()
          ELSE
             IF g_rtr7.rtr17<>g_rtr7_t.rtr17 THEN
                DELETE FROM rtr_file 
                 WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                   AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                   AND rtr04='6'
                CALL i130_expand()
             ELSE
               SELECT COUNT(DISTINCT rtr19) INTO l_n FROM rtr_file 
                WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                  AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                  AND rtr04='6'
               IF l_n<>g_rtp.getlength() THEN
                  DELETE FROM rtr_file 
                   WHERE rtr01=g_rto.rto01 AND rtr02=g_rto.rto02
                     AND rtr03=g_rto.rto03 AND rtrplant=g_rto.rtoplant
                     AND rtr04='6'
                  CALL i130_expand()
               END IF
             END IF
          END IF
      END IF
 
END FUNCTION
 
FUNCTION i130_expand()  #單身展開
DEFINE ln_i,ln_j,ln_k    LIKE type_file.num5
DEFINE l_i,l_j,l_k,l_n   LIKE type_file.num5
DEFINE l_sql  STRING
DEFINE ls_msg ARRAY[13] OF VARCHAR(20)
DEFINE ln_ret1,ln_ret2,ln_ret3 LIKE type_file.num5
DEFINE l_rtr18 LIKE rtr_file.rtr18
DEFINE ls_str  STRING
      
 
      LET l_sql = "INSERT INTO rtr_file(rtr01,rtr02,rtr03,rtr04,rtrplant,rtrlegal,rtr06,rtr08,",
                  "rtr16,rtr17,rtr05,rtr18,rtr19)values('",g_rto.rto01,"',",
                  g_rto.rto02,",'",g_rto.rto03,"','6','",g_rto.rtoplant,"','",g_rto.rtolegal,
                  "','",g_rtr7.rtr06,"','",g_rtr7.rtr08,
                  "','",g_rtr7.rtr16,"','",g_rtr7.rtr17,"',?,?,?)"
 
      PREPARE i130_ins FROM l_sql
      
      SELECT COUNT(rtp05) INTO ln_k FROM rtp_file 
                         WHERE rtp01=g_rto.rto01 AND rtp02=g_rto.rto02
                          AND  rtp03=g_rto.rto03 AND rtpplant=g_rto.rtoplant
 
     CALL i130_checkdate() RETURNING ln_ret1,ln_ret2,ln_ret3
     IF ln_ret1=9999 THEN
        RETURN
     END IF 
     LET ln_i=0
     LET l_i=1 
 
      CASE g_rtr7.rtr08
        WHEN "1"  #
               LET ls_msg[1]=cl_getmsg("art-082",g_lang)
               FOR l_i=1 TO ln_ret3                
                 LET ls_str=(YEAR(g_rto.rto08)+l_i-1)
                 LET l_rtr18=ls_str.trim(),ls_msg[1]
                 IF g_rtr7.rtr17='Y' THEN
                  FOR l_k=1 TO ln_k
                   LET ln_i=ln_i+1
                   EXECUTE i130_ins USING ln_i,l_rtr18,g_rtp[l_k].rtp05  
                  END FOR
                 ELSE
                   EXECUTE i130_ins USING l_i,l_rtr18,''
                 END IF
               END FOR
         WHEN "2" #
              LET ls_msg[1]=cl_getmsg("art-083",g_lang)
              LET ls_msg[2]=cl_getmsg("art-084",g_lang)  
              LET ls_msg[3]=cl_getmsg("art-082",g_lang)
              FOR l_i=1 TO ln_ret3
                  LET l_j=(l_i+ln_ret2-1)/ 2
                  LET ls_str=YEAR(g_rto.rto08)+l_j
                  CASE ((l_i+ln_ret2-2) MOD 2)
                    WHEN 0 LET l_rtr18=ls_str.trim(),ls_msg[3] CLIPPED,ls_msg[2] CLIPPED
                    WHEN 1 LET l_rtr18=ls_str.trim(),ls_msg[3] CLIPPED,ls_msg[1] CLIPPED
                  END CASE
                  IF g_rtr7.rtr17='Y' THEN
                   FOR l_k=1 TO ln_k
                    LET ln_i=ln_i+1
                    EXECUTE i130_ins USING ln_i,l_rtr18,g_rtp[l_k].rtp05
                   END FOR
                  ELSE
                    EXECUTE i130_ins USING l_i,l_rtr18,''
                  END IF
             END FOR 
              
        WHEN "3"  #       
              LET ls_msg[1]=cl_getmsg("art-085",g_lang)    
              LET ls_msg[2]=cl_getmsg("art-086",g_lang)
              LET ls_msg[3]=cl_getmsg("art-087",g_lang)
              LET ls_msg[4]=cl_getmsg("art-088",g_lang) 
              LET ls_msg[5]=cl_getmsg("art-082",g_lang)   
              FOR l_i=1 TO ln_ret3
                  LET l_j=(l_i+ln_ret2-2)/4
                  LET ls_str=YEAR(g_rto.rto08)+l_j
                  CASE ((l_i+ln_ret2-2) MOD 4)
                    WHEN 0  LET l_rtr18=ls_str.trim(),ls_msg[5] CLIPPED,ls_msg[1] CLIPPED
                    WHEN 1  LET l_rtr18=ls_str.trim(),ls_msg[5] CLIPPED,ls_msg[2] CLIPPED
                    WHEN 2  LET l_rtr18=ls_str.trim(),ls_msg[5] CLIPPED,ls_msg[3] CLIPPED
                    WHEN 3  LET l_rtr18=ls_str.trim(),ls_msg[5] CLIPPED,ls_msg[4] CLIPPED
                  END CASE
                  IF g_rtr7.rtr17='Y' THEN
                  FOR l_k=1 TO ln_k
                   LET ln_i=ln_i+1
                   EXECUTE i130_ins USING ln_i,l_rtr18,g_rtp[l_k].rtp05 
                  END FOR
                  ELSE
                   EXECUTE i130_ins USING l_i,l_rtr18,''
                  END IF
             END FOR
             
        WHEN "4" #
              LET ls_msg[1]=cl_getmsg("art-089",g_lang)    
              LET ls_msg[2]=cl_getmsg("art-090",g_lang)
              LET ls_msg[3]=cl_getmsg("art-091",g_lang)
              LET ls_msg[4]=cl_getmsg("art-092",g_lang) 
              LET ls_msg[5]=cl_getmsg("art-093",g_lang)  
              LET ls_msg[6]=cl_getmsg("art-094",g_lang)    
              LET ls_msg[7]=cl_getmsg("art-095",g_lang)
              LET ls_msg[8]=cl_getmsg("art-097",g_lang)
              LET ls_msg[9]=cl_getmsg("art-098",g_lang) 
              LET ls_msg[10]=cl_getmsg("art-099",g_lang) 
              LET ls_msg[11]=cl_getmsg("art-100",g_lang)
              LET ls_msg[12]=cl_getmsg("art-101",g_lang) 
              LET ls_msg[13]=cl_getmsg("art-082",g_lang) 
              FOR l_i=1 TO ln_ret3
                  LET l_j=(l_i+ln_ret2-2)/12
                  LET ls_str=YEAR(g_rto.rto08)+l_j
                  CASE ((l_i+ln_ret2-2) MOD 12)
                    WHEN 0 LET l_rtr18=ls_str.trim(),ls_msg[13] CLIPPED,ls_msg[1] CLIPPED
                    WHEN 1 LET l_rtr18=ls_str.trim(),ls_msg[13] CLIPPED,ls_msg[2] CLIPPED
                    WHEN 2 LET l_rtr18=ls_str.trim(),ls_msg[13] CLIPPED,ls_msg[3] CLIPPED
                    WHEN 3 LET l_rtr18=ls_str.trim(),ls_msg[13] CLIPPED,ls_msg[4] CLIPPED
                    WHEN 4 LET l_rtr18=ls_str.trim(),ls_msg[13] CLIPPED,ls_msg[5] CLIPPED
                    WHEN 5 LET l_rtr18=ls_str.trim(),ls_msg[13] CLIPPED,ls_msg[6] CLIPPED
                    WHEN 6 LET l_rtr18=ls_str.trim(),ls_msg[13] CLIPPED,ls_msg[7] CLIPPED
                    WHEN 7 LET l_rtr18=ls_str.trim(),ls_msg[13] CLIPPED,ls_msg[8] CLIPPED
                    WHEN 8 LET l_rtr18=ls_str.trim(),ls_msg[13] CLIPPED,ls_msg[9] CLIPPED
                    WHEN 9 LET l_rtr18=ls_str.trim(),ls_msg[13] CLIPPED,ls_msg[10] CLIPPED
                    WHEN 10 LET l_rtr18=ls_str.trim(),ls_msg[13] CLIPPED,ls_msg[11] CLIPPED
                    WHEN 11 LET l_rtr18=ls_str.trim(),ls_msg[13] CLIPPED,ls_msg[12] CLIPPED
                  END CASE
                  IF g_rtr7.rtr17='Y' THEN
                   FOR l_k=1 TO ln_k
                     LET ln_i=ln_i+1
                     EXECUTE i130_ins USING ln_i,l_rtr18,g_rtp[l_k].rtp05 
                   END FOR
                  ELSE
                   EXECUTE i130_ins USING l_i,l_rtr18,''
                  END IF
             END FOR                                                    
      END CASE  
     
     CALL i130_b4_fill(" 1=1",'6')   
     
END FUNCTION
 
#Desciption:check year,semi-year,Quarter,month
#Return: 1:year number
#        2:start of
#        3:number of
FUNCTION i130_checkdate()
DEFINE ln_year LIKE type_file.num5         
DEFINE ln_i   LIKE type_file.num5
DEFINE ln_ret1,ln_ret2 LIKE type_file.num5
DEFINE l_azm DYNAMIC ARRAY OF RECORD LIKE azm_file.*
DEFINE l_sql STRING
DEFINE l_i,l_j,l_k LIKE type_file.num5      
 
      LET ln_year=YEAR(g_rto.rto09)-YEAR(g_rto.rto08)
      LET l_sql = "SELECT * FROM azm_file",
                  " WHERE azm01=?"
      PREPARE i130_date_pre FROM l_sql
      DECLARE date_cs CURSOR FOR i130_date_pre
      FOR l_i = 1 TO ln_year+1
        LET l_j=YEAR(g_rto.rto08)+l_i-1
        FOREACH date_cs USING l_j INTO l_azm[l_i].*
        IF STATUS THEN 
                CALL cl_err('foreach:',STATUS,1) 
                EXIT FOREACH
        END IF
        END FOREACH
        IF cl_null(l_azm[l_i].azm01) THEN
           CALL l_azm.deleteelement(l_i)
        END IF
      END FOR
        
      
      IF l_azm.getlength()<>(ln_year+1) THEN
         CALL cl_err(YEAR(g_rto.rto09),'art-107',1)
         RETURN 9999,0,0
      ELSE
      LET l_k=l_azm.getlength()
       CASE g_rtr7.rtr08
         WHEN "1"
           LET ln_ret1=YEAR(g_rto.rto08)
           LET ln_ret2=ln_year+1
         WHEN "2"
              IF g_rto.rto08<=l_azm[1].azm062 THEN
                 LET ln_ret1=0
                 IF g_rto.rto09 <=l_azm[l_k].azm062 THEN
                    LET ln_ret2=3+(ln_year-1)*2
                 ELSE
                    LET ln_ret2=4+(ln_year-1)*2
                 END IF
              ELSE             
                 LET ln_ret1=1
                 IF g_rto.rto09 <=l_azm[l_k].azm062 THEN
                    LET ln_ret2=2+(ln_year-1)*2
                 ELSE
                    LET ln_ret2=3+(ln_year-1)*2
                 END IF
              END IF
         WHEN "3"
              IF g_rto.rto08>=l_azm[1].azm011 THEN
                IF g_rto.rto08>=l_azm[1].azm041 THEN
                 IF g_rto.rto08>=l_azm[1].azm071 THEN
                  IF g_rto.rto08>=l_azm[1].azm101 THEN
                     LET ln_ret1=4
                  ELSE
                     LET ln_ret1=3
                  END IF
                 ELSE
                  LET ln_ret1=2
                 END IF
                ELSE
                 LET ln_ret1=1
                END IF
             END IF
             IF g_rto.rto09>=l_azm[l_k].azm011 THEN
                IF g_rto.rto09>=l_azm[l_k].azm041 THEN
                 IF g_rto.rto09>=l_azm[l_k].azm071 THEN
                  IF g_rto.rto09>=l_azm[l_k].azm101 THEN
                     LET ln_ret2=4
                  ELSE
                     LET ln_ret2=3                 
                  END IF
                ELSE
                 LET ln_ret2=2
                END IF
               ELSE
                LET ln_ret2=1
               END IF
             END IF
             LET ln_ret2=5-ln_ret1+ln_ret2+(ln_year-1)*4
         WHEN "4"
             IF g_rto.rto08>l_azm[1].azm012 THEN
                IF g_rto.rto08>l_azm[1].azm022 THEN
                   IF g_rto.rto08>l_azm[1].azm032 THEN
                      IF g_rto.rto08>l_azm[1].azm042 THEN
                        IF g_rto.rto08>l_azm[1].azm052 THEN
                          IF g_rto.rto08>l_azm[1].azm062 THEN
                             IF g_rto.rto08>l_azm[1].azm072 THEN
                                IF g_rto.rto08>l_azm[1].azm082 THEN
                                   IF g_rto.rto08>l_azm[1].azm092 THEN
                                      IF g_rto.rto08>l_azm[1].azm102 THEN
                                         IF g_rto.rto08>l_azm[1].azm112 THEN
                                            IF g_rto.rto08<=l_azm[1].azm122 THEN
                                               LET ln_ret1=12
                                            END IF
                                         ELSE
                                          LET ln_ret1=11
                                         END IF
                                      ELSE
                                        LET ln_ret1=10
                                      END IF
                                   ELSE
                                     LET ln_ret1=9
                                   END IF
                                ELSE
                                 LET ln_ret1=8
                                END IF
                             ELSE
                              LET ln_ret1=7    
                             END IF                          
                          ELSE
                           LET ln_ret1=6
                          END IF
                        ELSE
                         LET ln_ret1=5
                        END IF
                      ELSE
                       LET ln_ret1=4
                      END IF
                   ELSE
                    LET ln_ret1=3   
                   END IF
                ELSE
                LET ln_ret1=2
                END IF
             ELSE 
              LET ln_ret1=1
             END IF
             IF g_rto.rto09>l_azm[l_k].azm012 THEN
                IF g_rto.rto09>l_azm[l_k].azm022 THEN
                   IF g_rto.rto09>l_azm[l_k].azm032 THEN
                      IF g_rto.rto09>l_azm[l_k].azm042 THEN
                        IF g_rto.rto09>l_azm[l_k].azm052 THEN
                          IF g_rto.rto09>l_azm[l_k].azm062 THEN
                             IF g_rto.rto09>l_azm[l_k].azm072 THEN
                                IF g_rto.rto09>l_azm[l_k].azm082 THEN
                                   IF g_rto.rto09>l_azm[l_k].azm092 THEN
                                      IF g_rto.rto09>l_azm[l_k].azm102 THEN
                                         IF g_rto.rto09>l_azm[l_k].azm112 THEN
                                            IF g_rto.rto09<=l_azm[l_k].azm122 THEN
                                               LET ln_ret2=12
                                            END IF
                                         ELSE
                                          LET ln_ret2=11
                                         END IF
                                      ELSE
                                        LET ln_ret2=10
                                      END IF
                                   ELSE
                                     LET ln_ret2=9
                                   END IF
                                ELSE
                                 LET ln_ret2=8
                                END IF
                             ELSE
                              LET ln_ret2=7    
                             END IF                          
                          ELSE
                           LET ln_ret2=6
                          END IF
                        ELSE
                         LET ln_ret2=5
                        END IF
                      ELSE
                       LET ln_ret2=4
                      END IF
                   ELSE
                    LET ln_ret2=3   
                   END IF
                ELSE
                LET ln_ret2=2
                END IF
             ELSE 
              LET ln_ret2=1
           END IF
           LET ln_ret2=13-ln_ret1+ln_ret2+(ln_year-1)*12
      END CASE
      RETURN ln_year,ln_ret1,ln_ret2
      END IF            
END FUNCTION
 
FUNCTION i130_createtable()
    DROP TABLE rto_temp
    SELECT * FROM rto_file WHERE 1=0 INTO TEMP rto_temp
    DROP TABLE rtp_temp
    SELECT * FROM rtp_file WHERE 1=0 INTO TEMP rtp_temp
    DROP TABLE rtq_temp
    SELECT * FROM rtq_file WHERE 1=0 INTO TEMP rtq_temp
    DROP TABLE rtr_temp
    SELECT * FROM rtr_file WHERE 1=0 INTO TEMP rtr_temp
   ##TQC-C60107 创建临时表
    DROP TABLE rts_temp
    SELECT * FROM rts_file WHERE 1=0 INTO TEMP rts_temp
    DROP TABLE rtt_temp
    SELECT * FROM rtt_file WHERE 1=0 INTO TEMP rtt_temp
   ##TQC-C60107 创建临时表     
END FUNCTION
 
  #FUN-A70130 --------------------mark------------------------------
  # FUNCTION i130_def_no(l_dbs,l_rye01,l_rye02)
  # DEFINE l_dbs   LIKE azp_file.azp03
  # DEFINE l_rye01 LIKE rye_file.rye01
  # DEFINE l_rye02 LIKE rye_file.rye02
  # DEFINE l_sql STRING
  #   DEFINE l_no LIKE rva_file.rva01
  #     
  #       LET l_sql = "SELECT rye03 FROM ",s_dbstring(l_dbs CLIPPED),"rye_file",
  #                   " WHERE rye01 = ? AND rye02 = ? AND ryeacti='Y'"
  #       PREPARE rye_trans FROM l_sql
  #       EXECUTE rye_trans USING l_rye01,l_rye02 INTO l_no
  #       IF cl_null(l_no) THEN
  #          CALL s_errmsg('rye03',l_no,'rye_file','art-330',1)
  #          LET g_success = 'N'
  #          RETURN ''
  #       END IF
  #       RETURN l_no
  #    END FUNCTION
  # ##FUN-870007  
  #FUN-A70130 --------------------mark---------------------------------    


#TQC-C60107 add begin---------
 
#此函数用来判断和生成是否,新增加的营运中心没有对应的采购协议
FUNCTION i130_transfer2()
DEFINE  l_dbname  LIKE azp_file.azp03
DEFINE  l_sql,l_sql2  STRING 
DEFINE  l_n   LIKE type_file.num5
DEFINE  l_rtoplant LIKE rtp_file.rtp05
DEFINE  l_no  LIKE rts_file.rts01
DEFINE  li_result LIKE type_file.num5
DEFINE  l_rts01 LIKE rts_file.rts01
DEFINE  l_legal LIKE rts_file.rtslegal
DEFINE  l_rto02    LIKE rtp_file.rtp02
DEFINE  l_cnt   LIKE type_file.num5
DEFINE  l_rts03  LIKE rts_file.rts03


#如果存在此营运中心的采购协议,则continue foreach,否则插入此营运中心的采购协议
   SELECT MAX(rto02) INTO l_rto02 FROM rto_file WHERE rto01=g_rto.rto01 AND rto03=g_rto.rto03
       AND rtoplant=g_rto.rtoplant 
   LET g_sql = "SELECT DISTINCT rtp05 FROM ",cl_get_target_table(g_rto.rto03, 'rtp_file'),
               " WHERE rtp01='",g_rto.rto01,"'",
               "   AND rtp02='",l_rto02,"'",
               "   AND rtp03='",g_rto.rto03,"'",
               "   AND rtpplant='",g_rto.rto03,"'"
   PREPARE i130_count2 FROM g_sql
   DECLARE rtp2_cur CURSOR FOR i130_count2
   FOREACH rtp2_cur INTO l_rtoplant
      IF SQLCA.sqlcode THEN
         CALL cl_err('foreach:',SQLCA.sqlcode,1)
         EXIT FOREACH
      END IF
      #如果有效機構中包含當前機構，不用判断
      #IF l_rtoplant = g_rtw.rtwplant THEN
      #   CONTINUE FOREACH
      #END IF
      #取得该合同下的协议编号
      SELECT DISTINCT rts01 INTO l_rts01 FROM rts_file
       WHERE rts02 = g_rto.rto03
         AND rts04 = g_rto.rto01
         AND rtsplant = g_rto.rtoplant 
         AND rtsconf <> 'X'  #CHI-C80041
      #判断是否存在此营运中心的采购协议
      LET l_sql2 = "SELECT COUNT(*) FROM ", cl_get_target_table(l_rtoplant, 'rts_file'),
                  " WHERE rts01='",l_rts01,"' AND rts02='",g_rto.rto03,
                  "' AND rtsplant='",l_rtoplant,"'",
                  "  AND rtsconf <> 'X'"  #CHI-C80041
      PREPARE i130_count3 FROM l_sql2
      EXECUTE i130_count3 INTO l_cnt
      #如果不存在此营运中心的采购协议,则插入一笔rts,rtt,来源为该协议的签订机构所对应的采购协议
      IF l_cnt = 0 THEN  
         SELECT MAX(rts03) INTO l_rts03 FROM rts_file
          WHERE rts01 = l_rts01 AND rts02= g_rto.rto03
            AND rtsconf ='Y' AND rtsplant=g_rto.rto03 
            
         DELETE FROM rts_temp
         INSERT INTO rts_temp
         SELECT * FROM rts_file WHERE rts01 = l_rts01 AND rts02= g_rto.rto03
                                  AND rts03 = l_rts03 AND rtsplant=g_rto.rto03
         SELECT azw02 INTO l_legal FROM azw_file WHERE azw01=l_rtoplant
         UPDATE rts_temp SET rtslegal=l_legal,
                             rtsplant=l_rtoplant
         LET l_sql = "INSERT INTO ",cl_get_target_table(l_rtoplant,'rts_file'),   
                     " SELECT * FROM rts_temp"
         CALL cl_replace_sqldb(l_sql) RETURNING l_sql           
         CALL cl_parse_qry_sql(l_sql,l_rtoplant) RETURNING l_sql  
         PREPARE trans_ins_rts FROM l_sql
         EXECUTE trans_ins_rts           
         IF SQLCA.sqlcode THEN
            CALL cl_err3("ins","rts_file","","",SQLCA.sqlcode,"","",1)
            LET g_success = 'N'
         ELSE
            DELETE FROM rtt_temp
            INSERT INTO rtt_temp
            SELECT * FROM rtt_file WHERE rtt01 = l_rts01 AND rtt02= g_rto.rto03
                                     AND rttplant=g_rto.rto03
            UPDATE rtt_temp SET rttlegal=l_legal,
                                rttplant=l_rtoplant
            LET l_sql = "INSERT INTO ",cl_get_target_table(l_rtoplant,'rtt_file'),    
                        " SELECT * FROM rtt_temp"
            CALL cl_replace_sqldb(l_sql) RETURNING l_sql              
            CALL cl_parse_qry_sql(l_sql,l_rtoplant) RETURNING l_sql     
            PREPARE trans_ins_rtt FROM l_sql
            EXECUTE trans_ins_rtt
            IF SQLCA.sqlcode THEN
               CALL cl_err3("ins","rtt_file","","",SQLCA.sqlcode,"","",1)
               LET g_success = 'N'
            END IF
         END IF     
      END IF 
   END FOREACH

END FUNCTION      
 
#TQC-C60107 add end----------- 
