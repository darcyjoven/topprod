# Prog. Version..: '5.30.06-13.04.22(00010)'     #
#
# Pattern name...: capq001.4gl
# Descriptions...: 採購料件詢價維護作業
# Date & Author..: 91/09/05 By Wu

DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"
 
#模組變數(Module Variables)
DEFINE 
       g_rvw         DYNAMIC ARRAY OF RECORD       #程式變數(Program Variables)
          rvw02        LIKE rvw_file.rvw02,      #发票入账日期
          rvw01        LIKE rvw_file.rvw01,      #发票号码
          rvv06        LIKE rvv_file.rvv06,      #厂商编号
          pmc081       LIKE pmc_file.pmc081,     #厂商全称
          rvw18        LIKE rvw_file.rvw18,      #账款编号
          rvw08        LIKE rvw_file.rvw08,      #入库/仓退单
          rvw09        LIKE rvw_file.rvw09,      #项次
          rvw10        LIKE rvw_file.rvw10,      #发票匹配数量
          rvw17        LIKE rvw_file.rvw17,      #发票单价rvw17*rvw12
          rvw05        LIKE rvw_file.rvw05,      #发票税前金额
          apb09        LIKE apb_file.apb09,      #立账数量
          apb081       LIKE apb_file.apb081,     #立账单价
          apb101       LIKE apb_file.apb101,      #立账税前金额
          qty_dif      LIKE type_file.num15_3,      #qty_dif数量差异=发票匹配数量-立账数量
          amt_dif      LIKE type_file.num15_3      #amt_dif税前金额差异=发票税前金额-立账税前金额
                     END RECORD,
       g_sql         STRING,                       #CURSOR暫存 TQC-5B0183
       #g_wc          STRING,                       #單頭CONSTRUCT結果
       g_wc2         STRING,                       #單身CONSTRUCT結果
       g_rec_b       LIKE type_file.num5,          #單身筆數  #No.FUN-680136 
       l_ac          LIKE type_file.num5           #目前處理的ARRAY CNT  #No.FUN-680136 

DEFINE g_cnt               LIKE type_file.num10   
DEFINE g_argv1             LIKE rvv_file.rvv01     #單號 
DEFINE g_argv2             STRING                  #指定執行的功能 #TQC-630074
DEFINE l_table             STRING
DEFINE g_type              LIKE type_file.chr1
  
MAIN

#  IF FGL_GETENV("FGLGUI") <> "0" THEN      #若為整合EF自動簽核功能: 需抑制此段落 此處不適用
      OPTIONS                               #改變一些系統預設值
         INPUT NO WRAP
      DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理
#  END IF
 
   LET g_argv1=ARG_VAL(1)           #TQC-630074
   LET g_argv2=ARG_VAL(2)           #TQC-630074

 
   IF (NOT cl_user()) THEN                #預設部份參數(g_prog,g_user,...)
      EXIT PROGRAM                        #切換成使用者預設的營運中心
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log     #遇錯則記錄log檔
 
   IF (NOT cl_setup("CAP")) THEN          #抓取權限共用變數及模組變數(g_aza.*...)
      EXIT PROGRAM                        #判斷使用者執行程式權限
   END IF
 
#   LET g_sql = " rvw02.rvw_file.rvw02, ",       #发票入账日期
#               " rvw01.rvw_file.rvw01, ",       #发票号码
#               " rvv06.rvv_file.rvv06, " ,      #厂商编号
#               " pmc081.pmc_file.pmc081, ",     #厂商全称
#               " rvw18.rvw_file.rvw18, ",       #账款编号
#               " rvw08.rvw_file.rvw08, ",       #入库/仓退单
#               " rvw09.rvw_file.rvw09, ",       #项次
#               " rvw10.rvw_file.rvw10, ",       #发票匹配数量
#               " rvw17.rvw_file.rvw17, ",       #发票单价rvw17*rvw12
#               " rvw05.rvw_file.rvw05, ",       #发票税前金额
#               " apb09.apb_file.apb09, ",       #立账数量
#               " apb081.apb_file.apb081, ",     #立账单价
#               " apb101.apb_file.apb101, ",       #立账税前金额
#               " qty_dif.type_file.num20, ",      #qty_dif数量差异=发票匹配数量-立账数量
#               " amt_dif.type_file.num20 "        #amt_dif税前金额差异=发票税前金额-立账税前金额
#   LET l_table = cl_prt_temptable('capq001',g_sql) CLIPPED  #建立temp table,回傳狀態值
#   IF  l_table = -1 THEN EXIT PROGRAM END IF                #依照狀態值決定程式是否繼續
#                                                            #單頭Lock Cursor
   CALL cl_used(g_prog,g_time,1) RETURNING g_time           #計算使用時間 (進入時間)
 
 
  IF g_bgjob='N' OR cl_null(g_bgjob) THEN            #若為整合EF自動簽核功能: 需抑制此段落 此處不適用 
      OPEN WINDOW q001_w WITH FORM "cap/42f/capq001"
         ATTRIBUTE (STYLE = g_win_style CLIPPED) 
      CALL cl_set_locale_frm_name("capq001")          #共用程式在 cl_ui_init前須做指定畫面名稱處理
      CALL cl_ui_init()                               #轉換介面語言別、匯入ToolBar、Action...等資訊
  END IF
 
   CALL q001_menu()                                   #進入主視窗選單
   CLOSE WINDOW q001_w                                #結束畫面
 
   CALL cl_used(g_prog,g_time,2) RETURNING g_time     #計算使用時間 (退出時間)
END MAIN
 
 
FUNCTION q001_menu()
 
   WHILE TRUE
      #IF cl_null(g_action_choice) THEN 
      CALL q001_bp('G')
      #END IF
      CASE g_action_choice
        
         WHEN "query"
            IF cl_chk_act_auth() THEN
               CALL q001_cs()
#            ELSE                          
#               LET g_action_choice = " "  
            END IF
 
         WHEN "help"
            CALL cl_show_help()
 
         WHEN "exit"
            EXIT WHILE
 
         WHEN "controlg"
            CALL cl_cmdask()
 
         WHEN "exporttoexcel"                       #單身匯出最多可匯三個Table資料
            IF cl_chk_act_auth() THEN
              CALL cl_export_to_excel(ui.Interface.getRootNode(),base.TypeInfo.create(g_rvw),'','')
            END IF
      END CASE
   END WHILE
END FUNCTION


FUNCTION q001_bp(p_ud)
   DEFINE   p_ud   LIKE type_file.chr1   
 

   LET g_action_choice = " "
   CALL cl_set_act_visible("accept,cancel", FALSE)
 
   DISPLAY ARRAY g_rvw TO s_tc_rvw.* ATTRIBUTE(COUNT=g_rec_b)   
      BEFORE ROW
         LET l_ac = ARR_CURR()
         CALL cl_show_fld_cont()     
 
      ON ACTION query
         LET g_action_choice="query"
         EXIT DISPLAY  
 
      ON ACTION help
         LET g_action_choice="help"
         EXIT DISPLAY 
 
      ON ACTION locale
         CALL cl_dynamic_locale()
         CALL cl_show_fld_cont()   
         EXIT DISPLAY 
 
      ON ACTION exit
         LET g_action_choice="exit"
         EXIT DISPLAY  
 
      ON ACTION cancel
         LET INT_FLAG=FALSE 
         LET g_action_choice="exit"
         EXIT DISPLAY 
 
      ON ACTION controlg
         LET g_action_choice="controlg"
         EXIT DISPLAY 
 
      ON IDLE g_idle_seconds
         CALL cl_on_idle()
         CONTINUE DISPLAY 
 
      ON ACTION about   
         CALL cl_about()
 
      ON ACTION exporttoexcel
         LET g_action_choice = 'exporttoexcel'
         EXIT DISPLAY
    
      ON ACTION controls                                                                                        	
         CALL cl_set_head_visible("","AUTO")
  
   END DISPLAY 
   CALL cl_set_act_visible("accept,cancel", TRUE)
END FUNCTION
#FUN-DA0055--add
  
 
FUNCTION q001_cs()
DEFINE lc_qbe_sn   LIKE gbm_file.gbm01    
 
   CLEAR FORM 
   CALL cl_opmsg('q')
   CALL g_rvw.clear()
   DISPLAY ' ' TO FORMONLY.cn2

   DIALOG ATTRIBUTES(UNBUFFERED)    
      CONSTRUCT g_wc2 ON rvw02,rvw01,rvv06,pmc081,rvw18,rvw08,rvw09,rvw10,rvw05   #螢幕上取單身條件 #FUN-560193 add imd02,rvw908  #FUN-650191
                    FROM s_tc_rvw[1].rvw02,s_tc_rvw[1].rvw01,
                         s_tc_rvw[1].rvv06,s_tc_rvw[1].pmc081,s_tc_rvw[1].rvw18,
                         s_tc_rvw[1].rvw08,s_tc_rvw[1].rvw09,s_tc_rvw[1].rvw10,s_tc_rvw[1].rvw05
         BEFORE CONSTRUCT
            CALL cl_qbe_display_condition(lc_qbe_sn)
      END CONSTRUCT
      
         ON ACTION controlp
            CASE
              
                WHEN INFIELD(rvv06)   #厂商编号
                  CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form = "q_pmc"
                  #LET g_qryparam.where = " pmc03='1' "
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvv06
                  NEXT FIELD rvv06
           
                WHEN INFIELD(rvw18)   #账款编号
                CALL cl_init_qry_var()
                  LET g_qryparam.state = 'c'
                  LET g_qryparam.form ="q_apa07"   #MOD-920024 q_pmc2-->q_pmc1
                  CALL cl_create_qry() RETURNING g_qryparam.multiret
                  DISPLAY g_qryparam.multiret TO rvw18
                  NEXT FIELD rvw18
               
                WHEN INFIELD(rvw08)   #入库\仓退单
                   LET g_qryparam.multiret_index =1
                CALL q_rvv4(TRUE,TRUE,g_rvw[l_ac].rvv06,g_rvw[l_ac].rvw08,
                           #g_rvw[l_ac].rvw09,g_type,'0',g_head_1.rvw01)   #FUN-9B0130
                           g_rvw[l_ac].rvw09,g_type,'0',g_rvw[l_ac].rvw01,'')  #FUN-9B0130
                 RETURNING g_qryparam.multiret
               DISPLAY g_qryparam.multiret TO rvw08
               
                  NEXT FIELD rvw08
               
                
              
               OTHERWISE EXIT CASE
            END CASE
         
         ON IDLE g_idle_seconds                         #每個交談指令必備以下四個功能
            CALL cl_on_idle()                           #idle、about、help、controlg
            CONTINUE DIALOG
            
        ON ACTION accept
           ACCEPT DIALOG

         ON ACTION exit
            LET INT_FLAG = TRUE
            EXIT DIALOG
         
         ON ACTION cancel
            LET INT_FLAG = TRUE
            EXIT DIALOG
               
         ON ACTION about       
            CALL cl_about()   
      
         ON ACTION help         
            CALL cl_show_help() 
      
         ON ACTION controlg    
            CALL cl_cmdask()
      
         ON ACTION qbe_select                           #查詢提供條件選擇，選擇後直接帶入畫面
            CALL cl_qbe_list() RETURNING lc_qbe_sn      #提供列表選擇
            CALL cl_qbe_display_condition(lc_qbe_sn)    #顯示條件
         
         ON ACTION qbe_save                       #條件儲存
            CALL cl_qbe_save()
   END DIALOG 
   IF INT_FLAG THEN
      LET INT_FLAG = 0  
      CALL  cl_used(g_prog,g_time,2) RETURNING g_time  
      EXIT PROGRAM                                     
   END IF          
   CALL q001_b_fill(g_wc2)
 
END FUNCTION
 
 
FUNCTION q001_b_fill(p_wc2)
DEFINE p_wc2          STRING
DEFINE l_rvw17        LIKE rvw_file.rvw17
DEFINE l_rvw18        LIKE rvw_file.rvw18
DEFINE l_rvw12        LIKE rvw_file.rvw12
DEFINE l_qty_dif      LIKE type_file.num15_3 
DEFINE l_amt_dif      LIKE type_file.num15_3 
DEFINE l_tot_rvw10    LIKE rvw_file.rvw10
DEFINE l_tot_rvw05    LIKE rvw_file.rvw05
DEFINE l_tot_apb09    LIKE apb_file.apb09
DEFINE l_tot_apb101   LIKE apb_file.apb101
DEFINE l_tot_qty_dif  LIKE type_file.num15_3
DEFINE l_tot_amt_dif  LIKE type_file.num15_3
DEFINE l_pmc081       LIKE pmc_file.pmc081
DEFINE l_rvv03        LIKE rvv_file.rvv03
DEFINE l_apa00        LIKE apa_file.apa00
DEFINE l_rvw10        LIKE rvw_file.rvw10
DEFINE l_apb09        LIKE apb_file.apb09
DEFINE l_apb101        LIKE apb_file.apb101

   IF cl_null(p_wc2) THEN LET p_wc2 = ' 1=1' END IF
   
   LET g_sql = " SELECT rvw02,rvw01,rvv06,pmc081,rvw18,rvw08,rvw09,rvw10,rvw17*rvw12,rvw05,apb09,apb081,apb101,'',''",                                         
               "   FROM rvw_file,rvv_file,pmc_file,apb_file ",  
               "  WHERE rvw08 =rvv01(+) ",  
               "    AND rvw09 =rvv02(+) ",  
               "    AND rvw09 =apb22(+) ",
               "    AND rvw08 =apb21(+) ",
               "    AND rvv06 =pmc01(+) ",
               "   AND ",p_wc2 CLIPPED,
               " ORDER BY rvw02 "
   
#   LET g_sql = " SELECT rvw02,rvw01,rvu04,pmc081,rvw18,rvw08,rvw09,rvw10,rvw17*rvw12,rvw05,apb09,apb081,apb101,'','', ",
#               "        rvu00,apa00 ",
#               "  FROM rvw_file left join rvu_file on rvw08 = rvu01 ",
#               "                left join apb_file on rvw08 = apb21 and rvw09 = apb22  and rvw18 = apb01  ",
#               "                left join apa_file on apb01 = apa01 ",
#               "                left join pmc_file on rvu04 = pmc01 ",
#               "   AND ",p_wc2 CLIPPED,
#               " ORDER BY rvw02 "
#   DISPLAY g_sql
   

   PREPARE q001_pb FROM g_sql
   DECLARE rvw_cs CURSOR FOR q001_pb
   CALL g_rvw.clear()
   LET g_cnt = 1

   LET l_qty_dif = 0
   LET l_amt_dif = 0
   LET l_tot_rvw10 = 0
   LET l_tot_rvw05 = 0
   LET l_tot_apb09 = 0
   LET l_tot_apb101 = 0
   LET l_tot_qty_dif = 0
   LET l_tot_amt_dif = 0
   
   FOREACH rvw_cs INTO g_rvw[g_cnt].*   #單身 ARRAY 填充
       IF SQLCA.sqlcode THEN
          CALL cl_err('foreach:',SQLCA.sqlcode,1)
          EXIT FOREACH
       END IF
       #手动刷新画面 
       MESSAGE "发票:"||g_rvw[g_cnt].rvw01
       CALL ui.interface.refresh()
#       SELECT rvv03 INTO l_rvv03 FROM rvv_file WHERE rvv01 = g_rvw[g_cnt].rvw08
#          AND rvv02 =  g_rvw[g_cnt].rvw09

#       IF  l_rvv03 MATCHES '1*' THEN 
#          LET l_rvw10 = g_rvw[g_cnt].rvw10 
#       END IF
#       IF  l_rvv03 MATCHES '[23]' THEN 
#          LET l_rvw10 = g_rvw[g_cnt].rvw10*(-1)
#       END IF 
    
       SELECT apa00 INTO l_apa00 FROM  apa_file  WHERE apa01 = g_rvw[g_cnt].rvw18
       
#       IF  l_apa00 MATCHES '1*' THEN 
#          LET l_apb09 = g_rvw[g_cnt].apb09
#       END IF 
       IF  l_apa00 MATCHES '2*' THEN
          LET l_apb09 = g_rvw[g_cnt].apb09*-1
          LET l_apb101 = g_rvw[g_cnt].apb101*(-1)
       END IF 
       
       IF cl_null (g_rvw[g_cnt].rvw10) THEN   LET g_rvw[g_cnt].rvw10=0  END IF
       IF cl_null (g_rvw[g_cnt].apb09) THEN   LET g_rvw[g_cnt].apb09=0  END IF 
       IF cl_null (g_rvw[g_cnt].rvw05) THEN   LET g_rvw[g_cnt].rvw05=0  END IF 
       IF cl_null (g_rvw[g_cnt].apb101) THEN  LET g_rvw[g_cnt].apb101=0  END IF 
       
       LET g_rvw[g_cnt].qty_dif = g_rvw[g_cnt].rvw10 - g_rvw[g_cnt].apb09
       LET g_rvw[g_cnt].amt_dif = g_rvw[g_cnt].rvw05 - g_rvw[g_cnt].apb101
         
       IF g_rvw[g_cnt].qty_dif = 0 AND g_rvw[g_cnt].amt_dif =0 THEN 
           CONTINUE FOREACH
       END IF 
       
       LET l_tot_rvw10 = l_tot_rvw10 + g_rvw[g_cnt].rvw10
       LET l_tot_rvw05 = l_tot_rvw05 + g_rvw[g_cnt].rvw05
       LET l_tot_apb09 = l_tot_apb09 + g_rvw[g_cnt].apb09
       LET l_tot_apb101 = l_tot_apb101 + g_rvw[g_cnt].apb101
       LET l_tot_qty_dif = l_tot_qty_dif + g_rvw[g_cnt].qty_dif
       LET l_tot_amt_dif = l_tot_amt_dif + g_rvw[g_cnt].amt_dif
       
       LET g_cnt = g_cnt + 1
       IF g_cnt > g_max_rec THEN
          CALL cl_err( '', 9035, 0 )
          EXIT FOREACH
       END IF
   END FOREACH

   LET  g_rvw[g_cnt].rvw08 = ' 合计 '
   LET  g_rvw[g_cnt].rvw10 = l_tot_rvw10
   LET  g_rvw[g_cnt].rvw05 = l_tot_rvw05
   LET  g_rvw[g_cnt].apb09 = l_tot_apb09
   LET  g_rvw[g_cnt].apb101 = l_tot_apb101
   LET  g_rvw[g_cnt].qty_dif = l_tot_qty_dif
   LET  g_rvw[g_cnt].amt_dif = l_tot_amt_dif
        
   LET g_rec_b=g_cnt-1
   DISPLAY g_rec_b TO FORMONLY.cn2
   LET g_cnt = 0
   
   DISPLAY l_rvw17 TO rvw17
   DISPLAY l_qty_dif TO qty_dif
   DISPLAY l_amt_dif TO amt_dif

END FUNCTION


 
