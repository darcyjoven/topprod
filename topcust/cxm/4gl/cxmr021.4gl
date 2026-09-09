# Prog. Version..:
#
# Pattern name...: cxmr021.4gl
# Descriptions...: 订单分析报表
# Date & Author..: darcy:2025/09/19 
#HFBG-16030001
import libsummary
DATABASE ds
 
GLOBALS "../../../tiptop/config/top.global"

DEFINE tm  RECORD
      begin_yy    like type_file.num5,
      begin_mm    like type_file.num5,
      end_yy      like type_file.num5,
      end_mm      like type_file.num5
   END RECORD  
 
DEFINE   g_cnt           LIKE type_file.num10      
DEFINE   g_i             LIKE type_file.num5       
DEFINE   g_msg           LIKE type_file.chr1000   
 
DEFINE   l_table         STRING
DEFINE   g_str           STRING
DEFINE   g_sql           STRING

MAIN
   OPTIONS
       INPUT NO WRAP
   DEFER INTERRUPT                      
 
   IF (NOT cl_user()) THEN
      EXIT PROGRAM
   END IF
 
   WHENEVER ERROR CALL cl_err_msg_log
 
   IF (NOT cl_setup("CXM")) THEN
      EXIT PROGRAM
   END IF
   CALL cl_used(g_prog,g_time,1) RETURNING g_time  
  
    
 
   INITIALIZE tm.* TO NULL         

   CALL cxmr021_tm(0,0)
   CALL cl_used(g_prog,g_time,2) RETURNING g_time 
END MAIN


FUNCTION cxmr021_tm(p_row,p_col)
DEFINE lc_qbe_sn      LIKE gbm_file.gbm01   
DEFINE p_row,p_col    LIKE type_file.num5,        
       l_cmd        LIKE type_file.chr1000      
 
   LET p_row = 9 LET p_col = 8
 
   OPEN WINDOW cxmr021_w AT p_row,p_col WITH FORM "cxm/42f/cxmr021"
       ATTRIBUTE (STYLE = g_win_style CLIPPED) 
 
    CALL cl_ui_init()
   LET g_pdate = g_today
   LET g_rlang = g_lang
   LET g_bgjob = 'N'
   LET g_copies = '1' 
 
   CALL cl_opmsg('p')
   WHILE TRUE
      input by name tm.* without defaults
                              
         BEFORE INPUT
             CALL cl_qbe_display_condition(lc_qbe_sn)
 
         ON ACTION CONTROLR
            CALL cl_show_req_fields()

         ON ACTION CONTROLG 
            CALL cl_cmdask()    # Command execution

         ON IDLE g_idle_seconds
            CALL cl_on_idle()
            CONTINUE INPUT
   
         ON ACTION about         #MOD-4C0121
            CALL cl_about()      #MOD-4C0121
   
         ON ACTION help          #MOD-4C0121
            CALL cl_show_help()  #MOD-4C0121

         ON ACTION exit
            LET INT_FLAG = 1
            EXIT INPUT

         ON ACTION qbe_savecs_uuid
            CALL cl_qbe_save()

      END input
      IF g_action_choice = "locale" THEN
         LET g_action_choice = ""
         CALL cl_dynamic_locale()
         CONTINUE WHILE
      END IF
 
      IF INT_FLAG THEN
         LET INT_FLAG = 0 CLOSE WINDOW cxmr021_w 
         CALL cl_used(g_prog,g_time,2) RETURNING g_time #No.FUN-690126
         EXIT PROGRAM
      END IF 

      CALL cl_wait()
      CALL cxmr021()
      ERROR ""
   END WHILE
   CLOSE WINDOW cxmr021_w
END FUNCTION


FUNCTION cxmr021()
   define l_uuid ,l_period1,l_period2    varchar(40)
   define l_str      string
   define l_begin,l_end date
   define l_file   string

-- period 

   let l_period1 = sfmt("%1%2",tm.begin_yy,tm.begin_mm using '&&' )
   let l_period2 = sfmt("%1%2",tm.end_yy,tm.end_mm using '&&' )

-- uuid
   call cs_uuid() returning l_uuid

-- 日期获得

   let l_str = " SELECT  TO_DATE(?, 'YYYYMM') AS first_date, ",
               "         LAST_DAY(TO_DATE(?, 'YYYYMM')) AS last_date ",
               " FROM DUAL "
   prepare cxmr021_dat from l_str
   execute cxmr021_dat using l_period1,l_period2 into l_begin,l_end

-- cxmq021_sales
   let l_str = " insert into cxmq021_sales (",
               "     uuid,yy,mm,oea032,tc_sma03,oea01,oea02,oeatype,oeb04_1,oeb04,oeb13,layer,",
               "     sum01,cnt01,cnt02,cnt03,cnt04,cnt05,cnt06,cnt07,cnt08,cnt09,cnt10,cnt11,cnt12, ",
               "     cnt13,cnt14,cnt15,cnt16,cnt17,cnt18,cnt19,cnt20,cnt21,cnt22,cnt23,cnt24,cnt25,cnt26, ",
               "     cnt27,cnt28,cnt29,cnt30,cnt31, ",
               "     sum02,amt01,amt02,amt03,amt04,amt05,amt06,amt07,amt08,amt09,amt10,amt11,amt12, ",
               "     amt13,amt14,amt15,amt16,amt17,amt18,amt19,amt20,amt21,amt22,amt23,amt24,amt25,amt26, ",
               "     amt27,amt28,amt29,amt30,amt31  )",
               "  select '",l_uuid,"',year(oea02),month(oea02),oea032,tc_sma03, ",
               "       oea01,oea02,substr(oea01,1,3),substr(oeb04,1,6),oeb04,oeb13, ",
               "       case when substr(oeb04,8,1) between '0' and '9' then ASCII(substr(oeb04,8,1)) - ASCII('0') ",
               "       when substr(oeb04,8,1) between 'A' and 'Z' then ASCII(substr(oeb04,8,1)) - ASCII('A') end  layer, ",
               "       sum(tc_oeb12), ",
               "       sum(case day(tc_oeb16) when 1 then tc_oeb12 else 0 end  ) cnt01, ",
               "       sum(case day(tc_oeb16) when 2 then tc_oeb12 else 0 end  ) cnt02, ",
               "       sum(case day(tc_oeb16) when 3 then tc_oeb12 else 0 end  ) cnt03, ",
               "       sum(case day(tc_oeb16) when	4	then tc_oeb12 else 0 end ) cnt04, ", 
               "       sum(case day(tc_oeb16) when	5	then tc_oeb12 else 0 end ) cnt05, ", 
               "       sum(case day(tc_oeb16) when	6	then tc_oeb12 else 0 end ) cnt06, ", 
               "       sum(case day(tc_oeb16) when	7	then tc_oeb12 else 0 end ) cnt07, ", 
               "       sum(case day(tc_oeb16) when	8	then tc_oeb12 else 0 end ) cnt08, ", 
               "       sum(case day(tc_oeb16) when	9	then tc_oeb12 else 0 end ) cnt09, ", 
               "       sum(case day(tc_oeb16) when	10	then tc_oeb12 else 0 end ) cnt10, ", 
               "       sum(case day(tc_oeb16) when	11	then tc_oeb12 else 0 end ) cnt11, ", 
               "       sum(case day(tc_oeb16) when	12	then tc_oeb12 else 0 end ) cnt12, ", 
               "       sum(case day(tc_oeb16) when	13	then tc_oeb12 else 0 end ) cnt13, ", 
               "       sum(case day(tc_oeb16) when	14	then tc_oeb12 else 0 end ) cnt14, ", 
               "       sum(case day(tc_oeb16) when	15	then tc_oeb12 else 0 end ) cnt15, ", 
               "       sum(case day(tc_oeb16) when	16	then tc_oeb12 else 0 end ) cnt16, ", 
               "       sum(case day(tc_oeb16) when	17	then tc_oeb12 else 0 end ) cnt17, ", 
               "       sum(case day(tc_oeb16) when	18	then tc_oeb12 else 0 end ) cnt18, ", 
               "       sum(case day(tc_oeb16) when	19	then tc_oeb12 else 0 end ) cnt19, ", 
               "       sum(case day(tc_oeb16) when	20	then tc_oeb12 else 0 end ) cnt20, ", 
               "       sum(case day(tc_oeb16) when	21	then tc_oeb12 else 0 end ) cnt21, ", 
               "       sum(case day(tc_oeb16) when	22	then tc_oeb12 else 0 end ) cnt22, ", 
               "       sum(case day(tc_oeb16) when	23	then tc_oeb12 else 0 end ) cnt23, ", 
               "       sum(case day(tc_oeb16) when	24	then tc_oeb12 else 0 end ) cnt24, ", 
               "       sum(case day(tc_oeb16) when	25	then tc_oeb12 else 0 end ) cnt25, ", 
               "       sum(case day(tc_oeb16) when	26	then tc_oeb12 else 0 end ) cnt26, ", 
               "       sum(case day(tc_oeb16) when	27	then tc_oeb12 else 0 end ) cnt27, ", 
               "       sum(case day(tc_oeb16) when	28	then tc_oeb12 else 0 end ) cnt28, ", 
               "       sum(case day(tc_oeb16) when	29	then tc_oeb12 else 0 end ) cnt29, ", 
               "       sum(case day(tc_oeb16) when	30	then tc_oeb12 else 0 end ) cnt30, ", 
               "       sum(case day(tc_oeb16) when	31	then tc_oeb12 else 0 end ) cnt31, ",
               "       sum(tc_oeb12*oeb13), ",
               "       sum(case day(tc_oeb16) when 1 then tc_oeb12*oeb13 else 0 end  ) amt01, ",
               "       sum(case day(tc_oeb16) when 2 then tc_oeb12*oeb13 else 0 end  ) amt02, ",
               "       sum(case day(tc_oeb16) when 3 then tc_oeb12*oeb13 else 0 end  ) amt03, ",
               "       sum(case day(tc_oeb16) when	4	then tc_oeb12*oeb13 else 0 end ) amt04, ", 
               "       sum(case day(tc_oeb16) when	5	then tc_oeb12*oeb13 else 0 end ) amt05, ", 
               "       sum(case day(tc_oeb16) when	6	then tc_oeb12*oeb13 else 0 end ) amt06, ", 
               "       sum(case day(tc_oeb16) when	7	then tc_oeb12*oeb13 else 0 end ) amt07, ", 
               "       sum(case day(tc_oeb16) when	8	then tc_oeb12*oeb13 else 0 end ) amt08, ", 
               "       sum(case day(tc_oeb16) when	9	then tc_oeb12*oeb13 else 0 end ) amt09, ", 
               "       sum(case day(tc_oeb16) when	10	then tc_oeb12*oeb13 else 0 end ) amt10, ", 
               "       sum(case day(tc_oeb16) when	11	then tc_oeb12*oeb13 else 0 end ) amt11, ", 
               "       sum(case day(tc_oeb16) when	12	then tc_oeb12*oeb13 else 0 end ) amt12, ", 
               "       sum(case day(tc_oeb16) when	13	then tc_oeb12*oeb13 else 0 end ) amt13, ", 
               "       sum(case day(tc_oeb16) when	14	then tc_oeb12*oeb13 else 0 end ) amt14, ", 
               "       sum(case day(tc_oeb16) when	15	then tc_oeb12*oeb13 else 0 end ) amt15, ", 
               "       sum(case day(tc_oeb16) when	16	then tc_oeb12*oeb13 else 0 end ) amt16, ", 
               "       sum(case day(tc_oeb16) when	17	then tc_oeb12*oeb13 else 0 end ) amt17, ", 
               "       sum(case day(tc_oeb16) when	18	then tc_oeb12*oeb13 else 0 end ) amt18, ", 
               "       sum(case day(tc_oeb16) when	19	then tc_oeb12*oeb13 else 0 end ) amt19, ", 
               "       sum(case day(tc_oeb16) when	20	then tc_oeb12*oeb13 else 0 end ) amt20, ", 
               "       sum(case day(tc_oeb16) when	21	then tc_oeb12*oeb13 else 0 end ) amt21, ", 
               "       sum(case day(tc_oeb16) when	22	then tc_oeb12*oeb13 else 0 end ) amt22, ", 
               "       sum(case day(tc_oeb16) when	23	then tc_oeb12*oeb13 else 0 end ) amt23, ", 
               "       sum(case day(tc_oeb16) when	24	then tc_oeb12*oeb13 else 0 end ) amt24, ", 
               "       sum(case day(tc_oeb16) when	25	then tc_oeb12*oeb13 else 0 end ) amt25, ", 
               "       sum(case day(tc_oeb16) when	26	then tc_oeb12*oeb13 else 0 end ) amt26, ", 
               "       sum(case day(tc_oeb16) when	27	then tc_oeb12*oeb13 else 0 end ) amt27, ", 
               "       sum(case day(tc_oeb16) when	28	then tc_oeb12*oeb13 else 0 end ) amt28, ", 
               "       sum(case day(tc_oeb16) when	29	then tc_oeb12*oeb13 else 0 end ) amt29, ", 
               "       sum(case day(tc_oeb16) when	30	then tc_oeb12*oeb13 else 0 end ) amt30, ", 
               "       sum(case day(tc_oeb16) when	31	then tc_oeb12*oeb13 else 0 end ) amt31 ", 
               "from cxmq021_tmpview  ",
               "where tc_oeb16 between  ? and ?  ",
               "group by year(oea02),month(oea02),oea032,tc_sma03, ",
               "oea01,oea02,oeb04,oeb13 "
   prepare cxmr021_ins_sales from l_str
   execute cxmr021_ins_sales using l_begin,l_end

-- cxmq021_fcst

   let l_str = " insert into cxmq021_fcst (uuid,yy,mm,oeb04,tc_sma06) ",
               " select '",l_uuid,"',substr(tc_sma03, 1, 4) yy, ",
               "       substr(tc_sma03, 5, 2) mm, ",
               "       tc_sma02, ",
               "       sum(tc_sma06) tc_sma06 ",
               " from tc_sma_file ",
               " where tc_sma01 = 'csmi119' ",
               "    and tc_sma03 between ? and ? ",
               "    group by tc_sma03,tc_sma02 "
   prepare cxmr021_ins_fsct from l_str
   execute cxmr021_ins_fsct using l_period1,l_period2

   let l_str = " merge into cxmq021_fcst a ",
               " using (select uuid,yy,mm,oeb04,layer,sum(sum01) wo  ",
               "         from cxmq021_sales ",
               "        where uuid = ? ",
               "        group by uuid,yy,mm,oeb04,layer)b ",
               " on (a.uuid=b.uuid and a.yy=b.yy and a.mm=b.mm and a.oeb04 = b.oeb04 ) ",
               " when not matched then insert (a.uuid,a.yy,a.mm,a.oeb04,a.layer,a.oeb12) ",
               " values (b.uuid,b.yy,b.mm,b.oeb04,b.layer,b.wo ) ",
               " when matched then update set a.layer=b.layer,a.oeb12=b.wo "
   prepare cxmr021_fcst_1 from l_str
   execute cxmr021_fcst_1 using l_uuid

   let l_str = " merge into cxmq021_fcst a  ",
               " using cxmq021_price b ",
               " on (a.oeb04= b.tc_xmf03) ",
               " when matched then update set a.oea032 = b.occ02 ,a.tc_sma03=b.tc_sma03, ",
               " a.tc_xme05=b.total,a.tc_xme10=b.bare,a.tc_xme08=b.smt,a.tc_xme07=b.component ",
               " where uuid =? "
   prepare cxmr021_fcst_2 from l_str
   execute cxmr021_fcst_2 using l_uuid

-- 更新层数
   let l_str = " update cxmq021_fcst ",
               " set layer = (CASE  ",
               "          WHEN ASCII(SUBSTR(oeb04, 8, 1)) BETWEEN ASCII('0') AND ASCII('9') THEN  ",
               "          TO_NUMBER(SUBSTR(oeb04, 8, 1)) ",
               "          WHEN ASCII(SUBSTR(oeb04, 8, 1)) BETWEEN ASCII('A') AND ASCII('Z') THEN  ",
               "          ASCII(SUBSTR(oeb04, 8, 1)) - ASCII('A') + 10 ",
               "          ELSE 0 ",
               "       end ) ",
               "       , ",
               "       tc_sma06=nvl(tc_sma06,0), ",
               "       oeb12 = nvl(oeb12,0), ",
               "       tc_xme05 = nvl(tc_xme05,0), ",
               "       tc_xme10 = nvl(tc_xme10,0), ",
               "       tc_xme08 = nvl(tc_xme08,0), ",
               "       tc_xme07 = nvl(tc_xme07,0) ",
               "  where uuid = ?"
   prepare cxmr021_fcst_3 from l_str
   execute cxmr021_fcst_3 using l_uuid

-- call cgo
   call expSales(l_uuid) returning l_file
-- del uuid 
  delete from cxmq021_fsct where uuid = l_uuid
  delete from cxmq021_sales where uuid = l_uuid
-- export
   call cl_download_by_explorer(l_file)

END FUNCTION


