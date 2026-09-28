# Pattern name...: cxcq102.4gl
# Descriptions...: 出货未开票应收立账作业
# Date & Author..: 220829   by darcy
 
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE tm  record
         yy  like type_file.num5,
         mm  like type_file.num5,
         eyy like type_file.num5,
         emm like type_file.num5,
         wc  string
      end record
    
define g_cxcq102    DYNAMIC ARRAY OF RECORD
                  OGA03       like OGA_file.OGA03,
                  OGA032      like OGA_file.OGA032,
                  OGA01       like OGA_file.OGA01,
                  OGA02       like OGA_file.OGA02,
                  OEA10       like OEA_file.OEA10,
                  OGA011      like OGA_file.OGA011,
                  OGAUD05     like OGA_file.OGAUD05,
                  OGA23       like OGA_file.OGA23,
                  OGA24       like OGA_file.OGA24,
                  OGA211      like OGA_file.OGA211,
                  OGB03       like OGB_file.OGB03,
                  OGB31       like OGB_file.OGB31,
                  OGB32       like OGB_file.OGB32,
                  OGB04       like OGB_file.OGB04,
                  IMA02       like IMA_file.IMA02,
                  IMA021      like IMA_file.IMA021,
                  OGB05       like OGB_file.OGB05,
                  OGB12       like OGB_file.OGB12,
                  OGB13       like OGB_file.OGB13,
                  OGB14       like OGB_file.OGB14,
                  OGB14T      like OGB_file.OGB14T,
                  OGB14a      like OGB_file.OGB14,
                  OGB14Ta     like OGB_file.OGB14T,
                  TC_OMB001   like TC_OMB_file.TC_OMB001,
                  TC_OMB002   like TC_OMB_file.TC_OMB002,
                  TC_OMB003   like TC_OMB_file.TC_OMB003,
                  TC_OMB902   like TC_OMB_file.TC_OMB902,
                  TC_OMB01    like TC_OMB_file.TC_OMB01,
                  TC_OMB02    like TC_OMB_file.TC_OMB02,
                  TC_OMB10    like TC_OMB_file.TC_OMB10,
                  TC_OMB12    like TC_OMB_file.TC_OMB12,
                  TC_OMB19    like TC_OMB_file.TC_OMB19,
                  TC_OMB20    like TC_OMB_file.TC_OMB20,
                  TC_OMB21    like TC_OMB_file.TC_OMB21,
                  TC_OMB23    like TC_OMB_file.TC_OMB23,
                  TC_OMB24    like TC_OMB_file.TC_OMB24,
                  TC_OMB26    like TC_OMB_file.TC_OMB26,
                  TC_OMB29    like TC_OMB_file.TC_OMB29,
                  TC_OMB30    like TC_OMB_file.TC_OMB30,
                  TC_OMB908   like TC_OMB_file.TC_OMB908,
                  TC_OMB909   like TC_OMB_file.TC_OMB909,
                  OMA01       like OMA_file.OMA01,
                  OMA02       like OMA_file.OMA02,
                  OMA33       like OMA_file.OMA33,
                  OMA76       like OMA_file.OMA76,
                  OMA10       like OMA_file.OMA10,
                  OMB03       like OMB_file.OMB03,
                  OMB31       like OMB_file.OMB31,
                  OMB32       like OMB_file.OMB32,
                  OMB04       like OMB_file.OMB04,
                  OMB12       like OMB_file.OMB12,
                  OMB13       like OMB_file.OMB13,
                  OMB14       like OMB_file.OMB14,
                  OMB14T      like OMB_file.OMB14T,
                  OMB15       like OMB_file.OMB15,
                  OMB16       like OMB_file.OMB16,
                  OMB16T      like OMB_file.OMB16T
                END RECORD, 
       g_cxcq102_t     RECORD
                  OGA03       like OGA_file.OGA03,
                  OGA032      like OGA_file.OGA032,
                  OGA01       like OGA_file.OGA01,
                  OGA02       like OGA_file.OGA02,
                  OEA10       like OEA_file.OEA10,
                  OGA011      like OGA_file.OGA011,
                  OGAUD05     like OGA_file.OGAUD05,
                  OGA23       like OGA_file.OGA23,
                  OGA24       like OGA_file.OGA24,
                  OGA211      like OGA_file.OGA211,
                  OGB03       like OGB_file.OGB03,
                  OGB31       like OGB_file.OGB31,
                  OGB32       like OGB_file.OGB32,
                  OGB04       like OGB_file.OGB04,
                  IMA02       like IMA_file.IMA02,
                  IMA021      like IMA_file.IMA021,
                  OGB05       like OGB_file.OGB05,
                  OGB12       like OGB_file.OGB12,
                  OGB13       like OGB_file.OGB13,
                  OGB14       like OGB_file.OGB14,
                  OGB14T      like OGB_file.OGB14T,
                  OGB14a      like OGB_file.OGB14,
                  OGB14Ta     like OGB_file.OGB14T,
                  TC_OMB001   like TC_OMB_file.TC_OMB001,
                  TC_OMB002   like TC_OMB_file.TC_OMB002,
                  TC_OMB003   like TC_OMB_file.TC_OMB003,
                  TC_OMB902   like TC_OMB_file.TC_OMB902,
                  TC_OMB01    like TC_OMB_file.TC_OMB01,
                  TC_OMB02    like TC_OMB_file.TC_OMB02,
                  TC_OMB10    like TC_OMB_file.TC_OMB10,
                  TC_OMB12    like TC_OMB_file.TC_OMB12,
                  TC_OMB19    like TC_OMB_file.TC_OMB19,
                  TC_OMB20    like TC_OMB_file.TC_OMB20,
                  TC_OMB21    like TC_OMB_file.TC_OMB21,
                  TC_OMB23    like TC_OMB_file.TC_OMB23,
                  TC_OMB24    like TC_OMB_file.TC_OMB24,
                  TC_OMB26    like TC_OMB_file.TC_OMB26,
                  TC_OMB29    like TC_OMB_file.TC_OMB29,
                  TC_OMB30    like TC_OMB_file.TC_OMB30,
                  TC_OMB908   like TC_OMB_file.TC_OMB908,
                  TC_OMB909   like TC_OMB_file.TC_OMB909,
                  OMA01       like OMA_file.OMA01,
                  OMA02       like OMA_file.OMA02,
                  OMA33       like OMA_file.OMA33,
                  OMA76       like OMA_file.OMA76,
                  OMA10       like OMA_file.OMA10,
                  OMB03       like OMB_file.OMB03,
                  OMB31       like OMB_file.OMB31,
                  OMB32       like OMB_file.OMB32,
                  OMB04       like OMB_file.OMB04,
                  OMB12       like OMB_file.OMB12,
                  OMB13       like OMB_file.OMB13,
                  OMB14       like OMB_file.OMB14,
                  OMB14T      like OMB_file.OMB14T,
                  OMB15       like OMB_file.OMB15,
                  OMB16       like OMB_file.OMB16,
                  OMB16T      like OMB_file.OMB16T
                END RECORD, 

       g_query_flag    LIKE type_file.num5,        #第一次進入程式時即進入Query之後進入N.下筆
       g_sql           STRING,                     #WHERE CONDITION 
       g_rec_b         LIKE type_file.num5         #單身筆數
DEFINE p_row,p_col     LIKE type_file.num5       
DEFINE g_cnt           LIKE type_file.num10     
DEFINE g_msg           LIKE type_file.chr1000  
DEFINE g_row_count     LIKE type_file.num10   
DEFINE g_curs_index    LIKE type_file.num10     
DEFINE g_jump          LIKE type_file.num10    
DEFINE g_no_ask        LIKE type_file.num5      
DEFINE l_ac            LIKE type_file.num5      
DEFINE g_action_flag   STRING
DEFINE w        ui.Window
DEFINE f        ui.Form
DEFINE page     om.DomNode
#str------ add by dengsy170212
DEFINE g_bookno        LIKE aaa_file.aaa01  
DEFINE l_str1          STRING 
DEFINE g_forupd_sql     STRING  
DEFINE l_aba19          LIKE aba_file.aba19
DEFINE l_abapost        LIKE aba_file.abapost
#end------ add by dengsy170212
 
MAIN
   OPTIONS                                 #改變一些系統預設值
        INPUT NO WRAP
    DEFER INTERRUPT                        #擷取中斷鍵, 由程式處理
    IF (NOT cl_user()) THEN
        EXIT PROGRAM
    END IF
   
    WHENEVER ERROR CALL cl_err_msg_log
   
    IF (NOT cl_setup("CXC")) THEN
       EXIT PROGRAM
    END IF
 
    CALL cl_used(g_prog,g_time,1) RETURNING g_time   #計算使用時間 (開始時間) 
 
    LET g_query_flag = 1
    LET p_row = 3 LET p_col = 15
 
    OPEN WINDOW q102_w AT p_row,p_col WITH FORM "cxc/42f/cxcq102"
         ATTRIBUTE(STYLE = g_win_style)
    CALL cl_ui_init()
    #str------ add by dengsy170212
    LET g_forupd_sql = "SELECT tc_omb001,tc_omb002,tc_omb003,tc_omb902  ",   
                       "  FROM tc_omb_file WHERE tc_omb001=?  and tc_omb002=? FOR UPDATE"
   LET g_forupd_sql = cl_forupd_sql(g_forupd_sql)
   DECLARE q102_cl CURSOR FROM g_forupd_sql
   LET l_str1='%' CLIPPED 
    #end------ add by dengsy170212
  #  CALL cl_set_comp_visible("cdc06,cdc07",FALSE)
    CALL q102_menu()
    CLOSE WINDOW q102_w
    CALL cl_used(g_prog,g_time,2) RETURNING g_time   #計算使用時間 (退出時間) 
END MAIN
 
#QBE 查詢資料
FUNCTION q102_cs()
   DEFINE   l_cnt   LIKE type_file.num5     
 
   LET tm.wc = ''

      CLEAR FORM #清除畫面
      CALL g_cxcq102.clear() 
      CALL cl_opmsg('q')
      CALL cl_set_head_visible("","YES")  
   
   DIALOG ATTRIBUTES(UNBUFFERED,FIELD ORDER FORM)

      INPUT BY NAME tm.yy,tm.mm,tm.eyy,tm.emm 
         BEFORE INPUT
         #NOTE nothing 
         #NOTE 开窗

         # ON ACTION accept
         #    ACCEPT CONSTRUCT

         # ON ACTION cancel
         #    LET INT_FLAG = 1
         #    EXIT CONSTRUCT 

      END INPUT

      CONSTRUCT tm.wc ON oga03 FROM s_cxcq102[1].oga03
         
         BEFORE CONSTRUCT
            CALL cl_qbe_init()
         #NOTE nothing
         #NOTE 开窗

         # ON ACTION accept
         #    ACCEPT CONSTRUCT

         # ON ACTION cancel
         #    LET INT_FLAG = 1
         # EXIT CONSTRUCT

      END CONSTRUCT

      # BEFORE DIALOG
         # CALL cl_qbe_init() 
      #    # LET g_inbb_d[1].inbbseq = ""
          
      ON ACTION accept
         ACCEPT DIALOG

      ON ACTION cancel
         LET INT_FLAG = 1
         EXIT DIALOG

   END DIALOG

   #TODO wc 条件组合
     
  IF INT_FLAG THEN 
      RETURN 
  ELSE
    let tm.wc = " 1=1"
  END IF       
 
   
END FUNCTION
 
FUNCTION q102_menu()

DEFINE l_msg  STRING 
DEFINE l_wc   STRING 

   WHILE TRUE
      CALL q102_bp("G")
      CASE g_action_choice
         WHEN "query" 
            IF cl_chk_act_auth() THEN
               CALL q102_q()
            END IF

         WHEN "exporttoexcel"
            IF cl_chk_act_auth() THEN
              LET w = ui.Window.getCurrent()  
              LET f = w.getForm()              
              IF cl_null(g_action_flag) OR g_action_flag = "pc6" THEN
                 LET page = f.FindNode("Page","pc6")
                 CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_cxcq102),'','')
              END IF
            END IF

         WHEN "help" 
            CALL cl_show_help()       
         WHEN "exit"
            EXIT WHILE
         WHEN "controlg"
            CALL cl_cmdask() 
                                        
      END CASE
   END WHILE
 
END FUNCTION
 
FUNCTION q102_q()
   LET g_row_count = 0                                                        
   LET g_curs_index = 0                                                       
   CALL cl_navigator_setting( g_curs_index, g_row_count )                    
   CALL cl_opmsg('q')
   DISPLAY '   ' TO FORMONLY.cnt  #ATTRIBUTE(YELLOW)
   CALL q102_cs()
   
   IF INT_FLAG THEN
      LET INT_FLAG = 0 
      RETURN 
      CALL g_cxcq102.clear() 

      RETURN
   END IF
   CALL cl_msg(" SEARCHING ! ") 

   call q102_b_fill()
END FUNCTION
 
 
FUNCTION q102_b_fill()                  #BODY FILL UP
   DEFINE     l_sql    STRING     #NO.FUN-910082   
   define     l_ogb01  like ogb_file.ogb01
   define     l_ogb03  like ogb_file.ogb03

   let l_sql ="SELECT * FROM (
               SELECT OGA03,
                     OGA032,
                     OGA01,
                     OGA02,
                     oea10,
                     OGA011,
                     ogaud05,
                     OGA23,
                     OGA24,
                     OGA211,
                     OGB03,
                     OGB31,
                     OGB32,
                     OGB04,
                     IMA02,
                     IMA021,
                     OGB05,
                     OGB12,
                     OGB13,
                     OGB14,
                     OGB14T,
                     OGB14*oga24,
                     OGB14T*oea24
               FROM oga_file, ogb_file
               LEFT JOIN oea_file ON oea01 = ogb31
               , ima_file
               WHERE oga01 = ogb01
                  AND ima01 = ogb04
                  AND YEAR(oga02) = ",tm.yy,"  AND MONTH(oga02)=",tm.mm,"
                  AND oga09 = '8'
                  AND ogaconf = 'Y'
                UNION all 
                SELECT oha03,
                     oha032,
                     oha01,
                     oha02,
                     oea10,
                     '' oha011,
                     ohaud05,
                     oha23,
                     oha24,
                     oha211,
                     ohb03,
                     ohb31,
                     ohb32,
                     ohb04,
                     IMA02,
                     IMA021,
                     ohb05,
                     -1*ohb12,
                     ohb13,
                     -1*ohb14,
                     -1*ohb14T,
                     -1*ohb14*oha24,
                     -1*ohb14T*oea24
               FROM oha_file, ohb_file
               LEFT JOIN oea_file ON oea01 = ohb31
               , ima_file
               WHERE oha01 = ohb01
                  AND ima01 = ohb04
                  AND YEAR(oha02) = ",tm.yy,"  AND MONTH(oha02)=",tm.mm,"
                  AND ohaconf = 'Y'
               ) a
               LEFT JOIN (
               SELECT TC_OMB001,
                     TC_OMB002,
                     TC_OMB003,
                     TC_OMB902,
                     TC_OMB01,
                     tc_omb02,
                     TC_OMB10,
                     TC_OMB12,
                     TC_OMB19,
                     TC_OMB20,
                     TC_OMB21,
                     TC_OMB23,
                     TC_OMB24,
                     TC_OMB26,
                     TC_OMB29,
                     TC_OMB30,
                     TC_OMB908,
                     TC_OMB909
               FROM tc_omb_file
               WHERE tc_omb001 * 12 + tc_omb002 <= ",tm.eyy," * 12 + ",tm.emm,"
               ) b ON tc_omb01 = oga01 AND tc_omb10 = ogb03
               LEFT JOIN (
               SELECT OMA01,
               OMA02,
               OMA33,
               OMA76,
               OMA10,
               OMB03,
               OMB31,
               OMB32,
               OMB04,
               OMB12,
               OMB13,
               OMB14,
               OMB14T,
               OMB15,
               OMB16,
               OMB16T
               FROM oma_file,omb_file
               WHERE oma01 = omb01 AND omaconf='Y'
                 and YEAR(oma02) *12 + MONTH(oma02) <= ",tm.eyy," * 12 + ",tm.emm,"
               ) c ON omb31=oga01 AND omb32=ogb03 "
   
   prepare q102_b_fill_p from l_sql
   declare q102_b_fill cursor for q102_b_fill_p

   let g_cnt=1
   foreach q102_b_fill into g_cxcq102[g_cnt].*
      if sqlca.sqlcode then
         call cl_err("q102_b_fill","!",1)
         exit foreach
      end if
      #darcy:2022/10/31 add s---
      # 出货单分批次过账，只显示一次出货金额
      if g_cxcq102[g_cnt].OGA01 = l_ogb01 and g_cxcq102[g_cnt].OGB03 = l_ogb03 then
         let g_cxcq102[g_cnt].OGB12   = 0
         let g_cxcq102[g_cnt].OGB13   = 0
         let g_cxcq102[g_cnt].OGB14   = 0
         let g_cxcq102[g_cnt].OGB14T  = 0
         let g_cxcq102[g_cnt].OGB14a  = 0
         let g_cxcq102[g_cnt].OGB14Ta = 0
         let g_cxcq102[g_cnt].TC_OMB19  = 0
         let g_cxcq102[g_cnt].TC_OMB20  = 0
         let g_cxcq102[g_cnt].TC_OMB21  = 0
         let g_cxcq102[g_cnt].TC_OMB23  = 0
         let g_cxcq102[g_cnt].TC_OMB24  = 0
         let g_cxcq102[g_cnt].TC_OMB26  = 0
         let g_cxcq102[g_cnt].TC_OMB29  = 0
         let g_cxcq102[g_cnt].TC_OMB30  = 0
         let g_cxcq102[g_cnt].TC_OMB908 = 0
         let g_cxcq102[g_cnt].TC_OMB909 = 0
      end if
      let l_ogb01 = g_cxcq102[g_cnt].OGA01
      let l_ogb03 = g_cxcq102[g_cnt].OGB03
      #darcy:2022/10/31 add e---
      let g_cnt = g_cnt + 1
   end foreach
   #darcy:2022/10/27 add s---
   #增加其它类别的立账
   let l_sql = "SELECT oma03,
                       oma032,
                       OMA01,
                       OMA02,
                       OMA33,
                       OMA76,
                       OMA10,
                       OMB03,
                       OMB31,
                       OMB32,
                       OMB04,
                       OMB12,
                       OMB13,
                       OMB14,
                       OMB14T,
                       OMB15,
                       OMB16,
                       OMB16T
                     FROM oma_file,
                        omb_file
                     WHERE oma01 = omb01
                        AND omaconf = 'Y'
                        and YEAR(oma02) * 12 + MONTH(oma02) = ",tm.eyy," * 12 + ",tm.emm,"
                           AND omb38=99"
   prepare q102_b_fill2_p from l_sql
   declare q102_b_fill2 cursor for q102_b_fill2_p

   foreach q102_b_fill2 into g_cxcq102[g_cnt].oga03,g_cxcq102[g_cnt].oga032,
                             g_cxcq102[g_cnt].OMA01,g_cxcq102[g_cnt].OMA02,g_cxcq102[g_cnt].OMA33,g_cxcq102[g_cnt].OMA76,g_cxcq102[g_cnt].OMA10,g_cxcq102[g_cnt].OMB03,g_cxcq102[g_cnt].OMB31,
                             g_cxcq102[g_cnt].OMB32,g_cxcq102[g_cnt].OMB04,g_cxcq102[g_cnt].OMB12,g_cxcq102[g_cnt].OMB13,g_cxcq102[g_cnt].OMB14,g_cxcq102[g_cnt].OMB14T,g_cxcq102[g_cnt].OMB15,
                             g_cxcq102[g_cnt].OMB16,g_cxcq102[g_cnt].OMB16T      
      if sqlca.sqlcode then
         call cl_err("q102_b_fill2","!",1)
         exit foreach
      end if
      let g_cnt = g_cnt + 1
   end foreach
   call g_cxcq102.deleteElement(g_cnt)
   let g_cnt = g_cnt - 1
   #darcy:2022/10/27 add e---
END FUNCTION
 
FUNCTION q102_bp(p_ud)
   DEFINE p_ud     LIKE type_file.chr1
 
   IF p_ud <> "G" OR g_action_choice = "detail" THEN
      RETURN
   END IF
 
   LET g_action_choice = " "
 
   CALL cl_set_act_visible("accept,cancel", FALSE)
   DISPLAY ARRAY g_cxcq102 TO s_cxcq102.* ATTRIBUTE(COUNT=g_rec_b,UNBUFFERED)
      BEFORE DISPLAY                                                            
         CALL cl_navigator_setting( g_curs_index, g_row_count )
 
      BEFORE ROW
         LET l_ac = ARR_CURR()
      CALL cl_show_fld_cont()          
 
      ##########################################################################
      # Standard 4ad ACTION
      ##########################################################################
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY

#str----add by huanglf170113
     ON ACTION exporttoexcel
         LET g_action_choice = "exporttoexcel"
         EXIT DISPLAY
#str----end by huanglf170113
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY

 
      ON ACTION controlg 
         LET g_action_choice="controlg"
         EXIT DISPLAY
      ON ACTION accept
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
      ON ACTION controls   
         CALL cl_set_head_visible("","AUTO")     
                
      AFTER DISPLAY
         CONTINUE DISPLAY
 
   END DISPLAY
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION

  
FUNCTION  q102_set_entry_b()
  CALL cl_set_comp_entry("tc_omb005 ,tc_omb01 ,tc_omb02,tc_omb03,tc_omb032,tc_omb04,tc_omb042,
                        tc_omb05,gen02,tc_omb06,gem02,tc_omb07,tc_omb08,tc_omb10,tc_omb11,
                        tc_omb13,tc_ombud01,tc_omb15,tc_omb12,tc_omb22,tc_omb19,tc_omb20,tc_omb21,
                        tc_omb17,tc_omb18,aag02,aag02_3,tc_omb24,aag02t,aag02_4,tc_omb26,aag02tt,
                        tc_omb28,tc_omb29,tc_omb30,tc_omb31,tc_omb908,tc_omb909",false )
   CALL cl_set_comp_entry("tc_omb23,tc_omb903,tc_omb25,tc_omb904,tc_omb27",true)
END FUNCTION 
 