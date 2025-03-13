# Prog. Version..: '5.30.06-13.04.22(00007)'     #
#
# Pattern name...: sapcp102.4gl
# Descriptions...: POS数据恢复
# Date & Author..: No.FUN-C50090 12/05/29 By yangxf
# Modify.........: No.FUN-C50017 12/08/02 By yangxf 任务表 tk_TransTaskHead 字段调整
# Modify.........: No.FUN-CB0112 12/11/23 By baogc INS tk_TransTaskHead將字段名列出
# Modify.........: No.FUN-D30046 13/03/18 By dongsz 機號還原調整
# Modify.........: No.FUN-D30071 13/03/21 By dongsz 添加控制以及提示信息
# Modify.........: No.FUN-D30092 13/03/25 By dongsz 添加卡券POS還原邏輯
# Modify.........: No.FUN-D40001 13/04/01 By xumm 邏輯調整

DATABASE ds
GLOBALS "../../config/top.global"

DEFINE g_trans_no   LIKE ryy_file.ryy01  #傳輸序號
DEFINE g_plantstr   STRING               #指定营运中心
DEFINE g_mach       STRING               #指定POS機號
DEFINE g_err_count  LIKE type_file.num5
DEFINE g_down_n     LIKE type_file.num10 #下传成功的标识
DEFINE g_ryk01      LIKE ryk_file.ryk01  #当前-传输的项次
DEFINE g_ryy        RECORD LIKE ryy_file.*
DEFINE g_fdate      LIKE type_file.chr8   #起始營業日期
DEFINE g_posdbs     LIKE ryg_file.ryg00  #傳輸DB.
DEFINE g_db_links   LIKE ryg_file.ryg02  #@DB LINK
DEFINE g_sql        STRING
DEFINE g_msg1       LIKE type_file.chr1000  #其他錯誤信息
DEFINE g_msg        LIKE type_file.chr1000  #錯誤訊息
DEFINE g_plant      STRING
DEFINE g_machstr    STRING
DEFINE g_table      STRING
#FUN-D30071--add--str---
DEFINE g_n          LIKE type_file.num5
DEFINE g_cnt        LIKE type_file.num5
DEFINE g_msg2       LIKE type_file.chr1000
DEFINE g_msg_array  DYNAMIC ARRAY OF RECORD
             shop   LIKE ryc_file.ryc01,
             mach   LIKE ryc_file.ryc02,
             type   LIKE type_file.chr1,
             cnt    LIKE type_file.num5
                    END RECORD     
#FUN-D30071--add--end---

FUNCTION p102(l_posstr,l_plantstr,l_date,l_mach,p_trans_no)
   DEFINE l_posstr     STRING               # 指定傳輸的table对应的项次
   DEFINE l_plantstr   STRING               # 指定营运中心
   DEFINE l_date       LIKE type_file.dat   # 指定日期
   DEFINE l_posway     LIKE type_file.chr1  # 1.手工異動下傳 2.初始化下傳
   DEFINE l_mach       STRING               #指定POS機號
   DEFINE p_trans_no   LIKE ryy_file.ryy01 
   DEFINE l_n          LIKE type_file.num5
   DEFINE l_i          LIKE type_file.num5  #FUN-D30071 add
   DEFINE l_cnt        STRING               #FUN-D30071 add
   DEFINE tok          base.StringTokenizer

   LET g_trans_no = p_trans_no 
   LET g_ryy.ryy01 = p_trans_no
   LET g_ryy.ryy02 = g_today
   LET g_ryy.ryy03 = TIME
   LET g_plant = l_plantstr              #营运中心
   LET g_mach = l_mach
   LET g_fdate = YEAR(l_date) USING "&&&&",MONTH(l_date) USING "&&",DAY(l_date) USING "&&"  
   CALL s_showmsg_init()        #錯誤訊息統整初始化函式
   LET g_err_count = 0
   CALL p102_ryc_temp('cre')    #FUN-D30046 add
   CALL p102_plant()
   CALL p102_mach()
   LET g_sql = " SELECT DISTINCT ryg00,ryg02 ",
               "   FROM ryg_file ",
               "  WHERE ryg01 IN ",g_plantstr  
   PREPARE sel_ryg00_pre FROM g_sql
   DECLARE sel_ryg00_cur CURSOR FOR sel_ryg00_pre
   EXECUTE sel_ryg00_cur INTO g_posdbs,g_db_links
   LET g_posdbs = s_dbstring(g_posdbs)
   LET g_db_links = p102_dblinks(g_db_links)
   LET tok = base.StringTokenizer.create(l_posstr,"|")
   BEGIN WORK
   WHILE tok.hasMoreTokens()                               #遍历项次（即table)
      LET g_ryk01 = tok.nextToken()
      LET g_success = 'Y'
      LET g_down_n = 0
      CALL p102_postable_copy(g_ryk01)
      IF g_success <> 'Y' THEN          #事务结束
         EXIT WHILE
      END IF
   END WHILE   
  #FUN-D30071--add--str---
   IF g_success = 'Y' THEN
      CALL p102_show_msg()
   END IF
  #FUN-D30071--add--end---
   IF g_success = 'Y' THEN  
      CALL p102_tk_TransTaskHead_ins()
      IF g_success = 'Y' THEN          #事务结束
         IF g_down_n  > 0 THEN
            LET g_ryy.ryy04 = g_today
            LET g_ryy.ryy05 = TIME
            SELECT COUNT(*) INTO l_n FROM ryy_file WHERE ryy01 = g_trans_no
            IF l_n = 0 THEN
               INSERT INTO ryy_file VALUES (g_ryy.*)
            ELSE
               UPDATE ryy_file SET ryy04 = g_ryy.ryy04,
                                   ryy05 = g_ryy.ryy05
                  WHERE ryy01 = g_trans_no
            END IF
         END IF
         MESSAGE l_posstr," PLANT:",g_plantstr," success!"
         CALL ui.Interface.refresh()
         COMMIT WORK
         CALL p102_ryc_temp('del')          #FUN-D30046 add
      ELSE
         LET g_err_count = g_err_count + 1
         IF g_bgjob = "N" THEN
            MESSAGE g_ryk01," PLANT:",g_plantstr," failure!"
            CALL ui.Interface.refresh()
         END IF
         ROLLBACK WORK
         CALL p102_ryc_temp('del')          #FUN-D30046 add
         CALL p200_log(g_trans_no,' ',' ',' ',' ',g_errno,g_msg,'1','N',g_msg1)
      END IF      
   ELSE
      LET g_err_count = g_err_count + 1
      IF g_bgjob = "N" THEN
         MESSAGE g_ryk01," PLANT:",g_plantstr," failure!"
         CALL ui.Interface.refresh()
      END IF
      ROLLBACK WORK
      CALL p102_ryc_temp('del')             #FUN-D30046 add
      CALL p200_log(g_trans_no,' ',' ',' ',' ',g_errno,g_msg,'1','N',g_msg1)
   END IF
  #FUN-D30071--add--str---
   IF g_success = 'Y' THEN
      LET g_msg2 = ''
      FOR l_i = 1 TO g_msg_array.getLength()
         LET l_cnt = g_msg_array[l_i].cnt
         IF g_msg_array[l_i].cnt = 0 THEN
           #FUN-D30092--mark--str---
           #IF g_msg_array[l_i].type = '1' THEN
           #   LET g_msg2 = cl_getmsg("apc-208",g_lang),cl_getmsg("apc-214",g_lang),l_date,cl_getmsg("apc-211",g_lang)
           #ELSE
           #   IF g_msg_array[l_i].type = '2' THEN
           #      LET g_msg2 = cl_getmsg("apc-209",g_lang),cl_getmsg("apc-214",g_lang),l_date,cl_getmsg("apc-211",g_lang)
           #   ELSE
           #      LET g_msg2 = cl_getmsg("apc-210",g_lang),cl_getmsg("apc-214",g_lang),l_date,cl_getmsg("apc-211",g_lang)
           #   END IF
           #END IF
           #FUN-D30092--mark--end---
           #FUN-D30092--add--str---
            CASE g_msg_array[l_i].type
               WHEN '1'
                  LET g_msg2 = cl_getmsg("apc-208",g_lang),cl_getmsg("apc-214",g_lang),l_date,cl_getmsg("apc-211",g_lang)
               WHEN '2' 
                  LET g_msg2 = cl_getmsg("apc-209",g_lang),cl_getmsg("apc-214",g_lang),l_date,cl_getmsg("apc-211",g_lang)
               WHEN '3'
                  LET g_msg2 = cl_getmsg("apc-210",g_lang),cl_getmsg("apc-214",g_lang),l_date,cl_getmsg("apc-211",g_lang)
               WHEN '4'
                  LET g_msg2 = cl_getmsg("apc-215",g_lang),cl_getmsg("apc-214",g_lang),l_date,cl_getmsg("apc-211",g_lang) 
               WHEN '5'
                  LET g_msg2 = cl_getmsg("apc-216",g_lang),cl_getmsg("apc-214",g_lang),l_date,cl_getmsg("apc-211",g_lang)
               WHEN '6'
                  LET g_msg2 = cl_getmsg("apc-217",g_lang),cl_getmsg("apc-214",g_lang),l_date,cl_getmsg("apc-211",g_lang)
               WHEN '7'
                  LET g_msg2 = cl_getmsg("apc-218",g_lang),cl_getmsg("apc-214",g_lang),l_date,cl_getmsg("apc-211",g_lang)
               WHEN '8'
                  LET g_msg2 = cl_getmsg("apc-219",g_lang),cl_getmsg("apc-214",g_lang),l_date,cl_getmsg("apc-211",g_lang)
               WHEN '9'
                  LET g_msg2 = cl_getmsg("apc-220",g_lang),cl_getmsg("apc-214",g_lang),l_date,cl_getmsg("apc-211",g_lang)
            END CASE  
           #FNN-D30092--add--end---
         ELSE
           #FUN-D30092--mark--str---
           #IF g_msg_array[l_i].type = '1' THEN
           #   LET g_msg2 = cl_getmsg("apc-208",g_lang),cl_getmsg("apc-212",g_lang),l_cnt,cl_getmsg("apc-213",g_lang)
           #ELSE
           #   IF g_msg_array[l_i].type = '2' THEN
           #      LET g_msg2 = cl_getmsg("apc-209",g_lang),cl_getmsg("apc-212",g_lang),l_cnt,cl_getmsg("apc-213",g_lang)
           #   ELSE
           #      LET g_msg2 = cl_getmsg("apc-210",g_lang),cl_getmsg("apc-212",g_lang),l_cnt,cl_getmsg("apc-213",g_lang)
           #   END IF
           #END IF
           #FUN-D30092--mark--end---
           #FUN-D30092--add--str---
            CASE g_msg_array[l_i].type 
               WHEN '1'
                  LET g_msg2 = cl_getmsg("apc-208",g_lang),cl_getmsg("apc-212",g_lang),l_cnt,cl_getmsg("apc-213",g_lang)
               WHEN '2'
                  LET g_msg2 = cl_getmsg("apc-209",g_lang),cl_getmsg("apc-212",g_lang),l_cnt,cl_getmsg("apc-213",g_lang)
               WHEN '3'
                  LET g_msg2 = cl_getmsg("apc-210",g_lang),cl_getmsg("apc-212",g_lang),l_cnt,cl_getmsg("apc-213",g_lang)
               WHEN '4'
                  LET g_msg2 = cl_getmsg("apc-215",g_lang),cl_getmsg("apc-212",g_lang),l_cnt,cl_getmsg("apc-213",g_lang) 
               WHEN '5'
                  LET g_msg2 = cl_getmsg("apc-216",g_lang),cl_getmsg("apc-212",g_lang),l_cnt,cl_getmsg("apc-213",g_lang)
               WHEN '6'
                  LET g_msg2 = cl_getmsg("apc-217",g_lang),cl_getmsg("apc-212",g_lang),l_cnt,cl_getmsg("apc-213",g_lang)
               WHEN '7'
                  LET g_msg2 = cl_getmsg("apc-218",g_lang),cl_getmsg("apc-212",g_lang),l_cnt,cl_getmsg("apc-213",g_lang)
               WHEN '8'
                  LET g_msg2 = cl_getmsg("apc-219",g_lang),cl_getmsg("apc-212",g_lang),l_cnt,cl_getmsg("apc-213",g_lang)
               WHEN '9'
                  LET g_msg2 = cl_getmsg("apc-220",g_lang),cl_getmsg("apc-212",g_lang),l_cnt,cl_getmsg("apc-213",g_lang)
            END CASE
           #FUN-D30092--add--end---
         END IF
         CALL s_errmsg('ryc01,ryc02',g_msg_array[l_i].shop||'/'||g_msg_array[l_i].mach,g_msg2,'',2)
      END FOR
   END IF
  #FUN-D30071--add--end---
   CALL s_showmsg()
END FUNCTION

#FUN-D30046--add--str---
FUNCTION p102_ryc_temp(p_action)
DEFINE p_action LIKE type_file.chr10   
   IF p_action = 'cre' THEN
      CREATE TEMP TABLE ryc_temp(
             ryc01 LIKE ryc_file.ryc01,
             ryc02 LIKE ryc_file.ryc02)
   ELSE
      DROP TABLE ryc_temp
   END IF
END FUNCTION
#FUN-D30046--add--end---

FUNCTION p102_plant()
DEFINE l_tok          base.StringTokenizer
DEFINE l_plant        LIKE azw_file.azw01
DEFINE l_sql          STRING     #FUN-D30046 add
   LET g_plantstr = ' '
   IF NOT cl_null(g_plant) THEN
      LET l_tok = base.StringTokenizer.create(g_plant,'|')
      WHILE l_tok.hasMoreTokens()
          LET l_plant = l_tok.nextToken()
          IF cl_null(g_plantstr) THEN
             LET g_plantstr = "'",l_plant,"'"
          ELSE
             LET g_plantstr = g_plantstr,",'",l_plant,"'"
          END IF

         #FUN-D30046--add--str---
          IF NOT cl_null(g_mach) THEN					
             SELECT * FROM azw_file WHERE azw01 = l_plant AND azwacti = 'Y'					
             IF SQLCA.sqlcode = 100 THEN CONTINUE WHILE END IF					
             LET l_sql = " INSERT INTO ryc_temp (ryc01,ryc02) ",					
                         " SELECT ryc01,ryc02 FROM ",cl_get_target_table(l_plant,'ryc_file'),					
                         "  WHERE ryc01 = '",l_plant CLIPPED,"' AND rycacti = 'Y' "					
             PREPARE ins_ryc_temp_pre FROM l_sql					
             EXECUTE ins_ryc_temp_pre					
          END IF
         #FUN-D30046--add--end---

      END WHILE
   END IF
   IF NOT cl_null(g_plantstr) THEN
      LET g_plantstr = "(",g_plantstr,")"
   END IF
END FUNCTION 

FUNCTION p102_mach()
DEFINE l_tok          base.StringTokenizer
DEFINE l_mach         STRING
   LET g_machstr = ' '
   IF NOT cl_null(g_mach) THEN
      LET l_tok = base.StringTokenizer.create(g_mach,'|')
      WHILE l_tok.hasMoreTokens()
          LET l_mach = l_tok.nextToken()
          IF cl_null(g_machstr) THEN
            #LET g_machstr = "'||''''||'",l_mach,"'||''''||"      #FUN-D30046 mark
             LET g_machstr = "'",l_mach,"'"                       #FUN-D30046 add
          ELSE
            #LET g_machstr = g_machstr,"','||''''||'",l_mach,"'||''''||"   #FUN-D30046 mark
             LET g_machstr = g_machstr,",'",l_mach,"'"                     #FUN-D30046 add
          END IF
      END WHILE
   END IF

   IF NOT cl_null(g_machstr) THEN            #FUN-D30046 add
      LET g_machstr = "(",g_machstr,")"      #FUN-D30046 add
   END IF                                    #FUN-D30046 add
END FUNCTION

FUNCTION p102_postable_copy(p_ryk01)
   DEFINE p_ryk01  LIKE ryk_file.ryk01
   CASE p_ryk01
      WHEN '901'   #POS銷售資料
        CALL p102_transref_ins_901() 
        IF g_success = 'N' THEN RETURN END IF
      WHEN '902'   #POS訂單資料
        CALL p102_transref_ins_902()
        IF g_success = 'N' THEN RETURN END IF
      WHEN '903'   #POS訂金退回資料
        CALL p102_transref_ins_903()
        IF g_success = 'N' THEN RETURN END IF
     #FUN-D30092--add--str---
      WHEN '904'   #POS卡異動資料
         CALL p102_transref_ins_904()
         IF g_success = 'N' THEN RETURN END IF
      WHEN '905'   #POS券異動資料
         CALL p102_transref_ins_905()
         IF g_success = 'N' THEN RETURN END IF
     #FUN-D30092--add--end---
   END CASE
END FUNCTION 

FUNCTION p102_transref_ins_901()

   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
  #FUN-D30046--mark--str---
  #IF cl_null(g_mach) THEN
  #   LET g_sql = g_sql CLIPPED,
  #            " SELECT azw01,' ','",g_trans_no,"','td_Sale',' Shop = '||''''||azw01||''''||' AND TYPE IN ('||''''||0||''''||','||''''||1||''''||','||''''||2||''''||') AND BDate >= '||''''||'",g_fdate,"'||'''','D' "
  #ELSE 
  #   LET g_sql = g_sql CLIPPED,
  #            " SELECT azw01,' ','",g_trans_no,"','td_Sale',' Shop = '||''''||azw01||''''||' AND TYPE IN ('||''''||0||''''||','||''''||1||''''||','||''''||2||''''||') AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine IN (",g_machstr,"')','D' "
  #END IF 
  #LET g_sql = g_sql CLIPPED,
  #            "   FROM azw_file ",
  #            "  WHERE azw01 IN ",g_plantstr
  #FUN-D30046--mark--end---
  #FUN-D30046--add--str---
   IF cl_null(g_mach) THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','td_Sale',' Shop = '||''''||azw01||''''||' AND TYPE IN ('||''''||0||''''||','||''''||1||''''||','||''''||2||''''||') AND BDate >= '||''''||'",g_fdate,"'||'''','D' ",
               "   FROM azw_file ",
               "  WHERE azw01 IN ",g_plantstr
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT ryc01,ryc02,'",g_trans_no,"','td_Sale',' Shop = '||''''||ryc01||''''||' AND TYPE IN ('||''''||0||''''||','||''''||1||''''||','||''''||2||''''||') AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine = '||''''||ryc02||'''','D' ",
               "   FROM ryc_temp",
               "  WHERE ryc01 IN ",g_plantstr CLIPPED," AND ryc02 IN ",g_machstr CLIPPED
   END IF 
  #FUN-D30046--add--end---
   LET g_table = "(td_Sale)"
   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')

#   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
#               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
#   IF cl_null(g_mach) THEN
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Detail',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Detail.Shop = td_Sale.Shop AND td_Sale_Detail.SaleNO = td_Sale.SaleNO AND TYPE IN ('||''''||0||''''||','||''''||1||''''||','||''''||2||''''||') AND BDate >= '||''''||'",g_fdate,"'||''''||')','D' "
#   ELSE
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Detail',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Detail.Shop = td_Sale.Shop AND td_Sale_Detail.SaleNO = td_Sale.SaleNO AND TYPE IN ('||''''||0||''''||','||''''||1||''''||','||''''||2||''''||') AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine IN (",g_machstr,"'))','D' "
#   END IF
#   LET g_sql = g_sql CLIPPED,
#               "   FROM azw_file",
#               "  WHERE azw01 IN ",g_plantstr
#   LET g_table = "(td_Sale_Detail)"
#   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')
#
#   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
#               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
#   IF cl_null(g_mach) THEN
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Detail_Agio',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Detail_Agio.Shop = td_Sale.Shop AND td_Sale_Detail_Agio.SaleNO = td_Sale.SaleNO AND TYPE IN ('||''''||0||''''||','||''''||1||''''||','||''''||2||''''||') AND BDate >= '||''''||'",g_fdate,"'||''''||')','D' "
#   ELSE
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Detail_Agio',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Detail_Agio.Shop = td_Sale.Shop AND td_Sale_Detail_Agio.SaleNO = td_Sale.SaleNO AND TYPE IN ('||''''||0||''''||','||''''||1||''''||','||''''||2||''''||') AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine IN (",g_machstr,"'))','D' "
#   END IF
#   LET g_sql = g_sql CLIPPED,
#               "   FROM azw_file",
#               "  WHERE azw01 IN ",g_plantstr
#   LET g_table = "(td_Sale_Detail_Agio)"
#   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')
#
#   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
#               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
#   IF cl_null(g_mach) THEN
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Pay',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Pay.Shop = td_Sale.Shop AND td_Sale_Pay.SaleNO = td_Sale.SaleNO AND TYPE IN ('||''''||0||''''||','||''''||1||''''||','||''''||2||''''||') AND BDate >= '||''''||'",g_fdate,"'||''''||')','D' "
#   ELSE
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Pay',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Pay.Shop = td_Sale.Shop AND td_Sale_Pay.SaleNO = td_Sale.SaleNO AND TYPE IN ('||''''||0||''''||','||''''||1||''''||','||''''||2||''''||') AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine IN (",g_machstr,"'))' ,'D' "
#   END IF
#   LET g_sql = g_sql CLIPPED,
#               "   FROM azw_file",
#               "  WHERE azw01 IN ",g_plantstr
#   LET g_table = "(td_Sale_Pay)"
#   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')
#
#   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
#               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
#   IF cl_null(g_mach) THEN
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Pay_Detail',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Pay_Detail.Shop = td_Sale.Shop AND td_Sale_Pay_Detail.SaleNO = td_Sale.SaleNO AND TYPE IN ('||''''||0||''''||','||''''||1||''''||','||''''||2||''''||') AND BDate >= '||''''||'",g_fdate,"'||''''||')','D' "
#   ELSE
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Pay_Detail',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Pay_Detail.Shop = td_Sale.Shop AND td_Sale_Pay_Detail.SaleNO = td_Sale.SaleNO AND TYPE IN ('||''''||0||''''||','||''''||1||''''||','||''''||2||''''||') AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine IN (",g_machstr,"'))' ,'D' "
#   END IF
#   LET g_sql = g_sql CLIPPED,
#               "   FROM azw_file",
#               "  WHERE azw01 IN ",g_plantstr
#   LET g_table = "(td_Sale_Pay_Detail)"
#   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')

END FUNCTION

FUNCTION p102_transref_ins_902()
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
  #FUN-D30046--mark--str---
  #IF cl_null(g_mach) THEN
  #   LET g_sql = g_sql CLIPPED,
  #            " SELECT azw01,' ','",g_trans_no,"','td_Sale',' Shop = '||''''||azw01||''''||' AND TYPE = '||''''||3||''''||' AND BDate >= '||''''||'",g_fdate,"'||'''','D' "
  #ELSE 
  #   LET g_sql = g_sql CLIPPED,
  #            " SELECT azw01,' ','",g_trans_no,"','td_Sale',' Shop = '||''''||azw01||''''||' AND TYPE = '||''''||3||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine IN (",g_machstr,"')','D' "
  #END IF 
  #LET g_sql = g_sql CLIPPED,
  #            "   FROM azw_file",
  #            "  WHERE azw01 IN ",g_plantstr
  #FUN-D30046--mark--end---
  #FUN-D30046--add--str---
   IF cl_null(g_mach) THEN
      LET g_sql = g_sql CLIPPED,
              #" SELECT azw01,' ','",g_trans_no,"','td_Sale',' Shop = '||''''||azw01||''''||' AND TYPE = '||''''||3||''''||' AND BDate >= '||''''||'",g_fdate,"'||'''','D' ",  #FUN-D40001 Mark
               " SELECT azw01,' ','",g_trans_no,"','td_Sale',' Shop = '||''''||azw01||''''||' AND TYPE = '||''''||3||''''||' AND (BDate >= '||''''||'",g_fdate,"'||''''||' OR (BDate < '||''''||'",g_fdate,"'||''''||' AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"td_Sale",g_db_links," a WHERE a.Type IN ( '||''''||0||''''||','||''''||4||''''||') AND a.Shop = '||''''||azw01||''''||' AND a.Saleno = Saleno)))','D' ", #FUN-D40001 Add
               "   FROM azw_file",
               "  WHERE azw01 IN ",g_plantstr
   ELSE
      LET g_sql = g_sql CLIPPED,
              #" SELECT ryc01,ryc02,'",g_trans_no,"','td_Sale',' Shop = '||''''||ryc01||''''||' AND TYPE = '||''''||3||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine = '||''''||ryc02||'''','D' ",   #FUN-D40001 Mark
               " SELECT ryc01,ryc02,'",g_trans_no,"','td_Sale',' Shop = '||''''||ryc01||''''||' AND TYPE = '||''''||3||''''||' AND (BDate >= '||''''||'",g_fdate,"'||''''||' OR (BDate < '||''''||'",g_fdate,"'||''''||' AND NOT EXISTS (SELECT 1 FROM ",g_posdbs,"td_Sale",g_db_links," a WHERE a.Type IN ( '||''''||0||''''||','||''''||4||''''||') AND a.Shop = '||''''||ryc01||''''||' AND a.Saleno = Saleno))) AND Machine = '||''''||ryc02||'''','D' ",  #FUN-D40001 Add
               "   FROM ryc_temp",
               "  WHERE ryc01 IN ",g_plantstr CLIPPED," AND ryc02 IN ",g_machstr CLIPPED
   END IF
  #FUN-D30046--add--end---
   LET g_table = "(td_Sale)"
   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')

#   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
#               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
#   IF cl_null(g_mach) THEN
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Detail',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Detail.Shop = td_Sale.Shop AND td_Sale_Detail.SaleNO = td_Sale.SaleNO AND TYPE = '||''''||3||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||')','D' "
#   ELSE
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Detail',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Detail.Shop = td_Sale.Shop AND td_Sale_Detail.SaleNO = td_Sale.SaleNO AND TYPE = '||''''||3||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine IN (",g_machstr,"'))','D' "
#   END IF
#   LET g_sql = g_sql CLIPPED,
#               "   FROM azw_file",
#               "  WHERE azw01 IN ",g_plantstr
#   LET g_table = "(td_Sale_Detail)"
#   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')
#
#   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
#               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
#   IF cl_null(g_mach) THEN
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Detail_Agio',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Detail_Agio.Shop = td_Sale.Shop AND td_Sale_Detail_Agio.SaleNO = td_Sale.SaleNO AND TYPE = '||''''||3||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||')','D' "
#   ELSE
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Detail_Agio',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Detail_Agio.Shop = td_Sale.Shop AND td_Sale_Detail_Agio.SaleNO = td_Sale.SaleNO AND TYPE = '||''''||3||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine IN (",g_machstr,"'))','D' "
#   END IF
#   LET g_sql = g_sql CLIPPED,
#               "   FROM azw_file",
#               "  WHERE azw01 IN ",g_plantstr
#   LET g_table = "(td_Sale_Detail_Agio)"
#   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')
#
#   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
#               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
#   IF cl_null(g_mach) THEN
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Pay',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Pay.Shop = td_Sale.Shop AND td_Sale_Pay.SaleNO = td_Sale.SaleNO AND TYPE = '||''''||3||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||')','D' "
#   ELSE
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Pay',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Pay.Shop = td_Sale.Shop AND td_Sale_Pay.SaleNO = td_Sale.SaleNO AND TYPE = '||''''||3||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine IN (",g_machstr,"'))','D' "
#   END IF
#   LET g_sql = g_sql CLIPPED,
#               "   FROM azw_file",
#               "  WHERE azw01 IN ",g_plantstr
#   LET g_table = "(td_Sale_Pay)"
#   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')
#
#   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
#               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
#   IF cl_null(g_mach) THEN
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Pay_Detail',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Pay_Detail.Shop = td_Sale.Shop AND td_Sale_Pay_Detail.SaleNO = td_Sale.SaleNO AND TYPE = '||''''||3||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||')','D' "
#   ELSE
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Pay_Detail',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Pay_Detail.Shop = td_Sale.Shop AND td_Sale_Pay_Detail.SaleNO = td_Sale.SaleNO AND TYPE = '||''''||3||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine IN (",g_machstr,"'))' ,'D' "
#   END IF
#   LET g_sql = g_sql CLIPPED,
#               "   FROM azw_file",
#               "  WHERE azw01 IN ",g_plantstr
#   LET g_table = "(td_Sale_Pay_Detail)"
#   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION 

FUNCTION p102_transref_ins_903()
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
  #FUN-D30046--mark--str---
  #IF cl_null(g_mach) THEN
  #   LET g_sql = g_sql CLIPPED,
  #            " SELECT azw01,' ','",g_trans_no,"','td_Sale',' Shop = '||''''||azw01||''''||' AND TYPE = '||''''||4||''''||' AND BDate >= '||''''||'",g_fdate,"'||'''','D' "
  #ELSE 
  #   LET g_sql = g_sql CLIPPED,
  #            " SELECT azw01,' ','",g_trans_no,"','td_Sale',' Shop = '||''''||azw01||''''||' AND TYPE = '||''''||4||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine IN (",g_machstr,"')','D' "
  #END IF 
  #LET g_sql = g_sql CLIPPED,
  #            "   FROM azw_file",
  #            "  WHERE azw01 IN ",g_plantstr
  #FUN-D30046--mark--end---
  #FUN-D30046--add--str---
   IF cl_null(g_mach) THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','td_Sale',' Shop = '||''''||azw01||''''||' AND TYPE = '||''''||4||''''||' AND BDate >= '||''''||'",g_fdate,"'||'''','D' ",
               "   FROM azw_file",
               "  WHERE azw01 IN ",g_plantstr
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT ryc01,ryc02,'",g_trans_no,"','td_Sale',' Shop = '||''''||ryc01||''''||' AND TYPE = '||''''||4||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine = '||''''||ryc02||'''','D' ",
               "   FROM ryc_temp",
               "  WHERE ryc01 IN ",g_plantstr CLIPPED," AND ryc02 IN ",g_machstr CLIPPED
   END IF
  #FUN-D30046--add--end---
   LET g_table = "(td_Sale)"
   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')

#   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
#               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
#   IF cl_null(g_mach) THEN
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Detail',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Detail.Shop = td_Sale.Shop AND td_Sale_Detail.SaleNO = td_Sale.SaleNO AND TYPE = '||''''||4||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||')','D' "
#   ELSE
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Detail',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Detail.Shop = td_Sale.Shop AND td_Sale_Detail.SaleNO = td_Sale.SaleNO AND TYPE = '||''''||4||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine IN (",g_machstr,"'))','D' "
#   END IF
#   LET g_sql = g_sql CLIPPED,
#               "   FROM azw_file",
#               "  WHERE azw01 IN ",g_plantstr
#   LET g_table = "(td_Sale_Detail)"
#   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')
#
#   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
#               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
#   IF cl_null(g_mach) THEN
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Pay',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Pay.Shop = td_Sale.Shop AND td_Sale_Pay.SaleNO = td_Sale.SaleNO AND TYPE = '||''''||4||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||')','D' "
#   ELSE
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Pay',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Pay.Shop = td_Sale.Shop AND td_Sale_Pay.SaleNO = td_Sale.SaleNO AND TYPE = '||''''||4||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine IN (",g_machstr,"'))','D' "
#   END IF
#   LET g_sql = g_sql CLIPPED,
#               "   FROM azw_file",
#               "  WHERE azw01 IN ",g_plantstr
#   LET g_table = "(td_Sale_Pay)"
#   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')
#
#   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
#               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
#   IF cl_null(g_mach) THEN
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Pay_Detail',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Pay_Detail.Shop = td_Sale.Shop AND td_Sale_Pay_Detail.SaleNO = td_Sale.SaleNO AND TYPE = '||''''||4||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||')','D' "
#   ELSE
#      LET g_sql = g_sql CLIPPED,
#               " SELECT azw01,' ','",g_trans_no,"','td_Sale_Pay_Detail',' Shop = '||''''||azw01||''''||' AND EXISTS (SELECT 1 FROM td_Sale WHERE td_Sale_Pay_Detail.Shop = td_Sale.Shop AND td_Sale_Pay_Detail.SaleNO = td_Sale.SaleNO AND TYPE = '||''''||4||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine IN (",g_machstr,"'))' ,'D' "
#   END IF
#   LET g_sql = g_sql CLIPPED,
#               "   FROM azw_file",
#               "  WHERE azw01 IN ",g_plantstr
#   LET g_table = "(td_Sale_Pay_Detail)"
#   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')
END FUNCTION 

#FUN-D30092--add--str---
FUNCTION p102_transref_ins_904()   #POS卡異動資料

   #發卡
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF cl_null(g_mach) THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tg_SaleCard',' Shop = '||''''||azw01||''''||' AND TYPE = '||''''||0||''''||' AND BDate >= '||''''||'",g_fdate,"'||'''','D' ",
               "   FROM azw_file",
               "  WHERE azw01 IN ",g_plantstr
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT ryc01,ryc02,'",g_trans_no,"','tg_SaleCard',' Shop = '||''''||ryc01||''''||' AND TYPE = '||''''||0||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine = '||''''||ryc02||'''','D' ",
               "   FROM ryc_temp",
               "  WHERE ryc01 IN ",g_plantstr CLIPPED," AND ryc02 IN ",g_machstr CLIPPED
   END IF
   LET g_table = "(tg_SaleCard)"
   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')

   #退卡
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF cl_null(g_mach) THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tg_SaleCard',' Shop = '||''''||azw01||''''||' AND TYPE = '||''''||1||''''||' AND BDate >= '||''''||'",g_fdate,"'||'''','D' ",
               "   FROM azw_file",
               "  WHERE azw01 IN ",g_plantstr
   ELSE        
      LET g_sql = g_sql CLIPPED,
               " SELECT ryc01,ryc02,'",g_trans_no,"','tg_SaleCard',' Shop = '||''''||ryc01||''''||' AND TYPE = '||''''||1||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine = '||''''||ryc02||'''','D' ",
               "   FROM ryc_temp",
               "  WHERE ryc01 IN ",g_plantstr CLIPPED," AND ryc02 IN ",g_machstr CLIPPED
   END IF
   LET g_table = "(tg_SaleCard)"
   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')

   #儲值
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF cl_null(g_mach) THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tg_Recharge',' Shop = '||''''||azw01||''''||' AND BillType = '||''''||0||''''||' AND BDate >= '||''''||'",g_fdate,"'||'''','D' ",
               "   FROM azw_file",
               "  WHERE azw01 IN ",g_plantstr
   ELSE        
      LET g_sql = g_sql CLIPPED,
               " SELECT ryc01,ryc02,'",g_trans_no,"','tg_Recharge',' Shop = '||''''||ryc01||''''||' AND BillType = '||''''||0||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine = '||''''||ryc02||'''','D' ",
               "   FROM ryc_temp",
               "  WHERE ryc01 IN ",g_plantstr CLIPPED," AND ryc02 IN ",g_machstr CLIPPED
   END IF      
   LET g_table = "(tg_Recharge)"
   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')

   #換卡
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF cl_null(g_mach) THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tg_ChangeCard',' Shop = '||''''||azw01||''''||' AND BDate >= '||''''||'",g_fdate,"'||'''','D' ",
               "   FROM azw_file",
               "  WHERE azw01 IN ",g_plantstr
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT ryc01,ryc02,'",g_trans_no,"','tg_ChangeCard',' Shop = '||''''||ryc01||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine = '||''''||ryc02||'''','D' ",
               "   FROM ryc_temp",
               "  WHERE ryc01 IN ",g_plantstr CLIPPED," AND ryc02 IN ",g_machstr CLIPPED
   END IF
   LET g_table = "(tg_ChangeCard)"
   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')

END FUNCTION

FUNCTION p102_transref_ins_905()    #POS 券異動資料

   #售券
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF cl_null(g_mach) THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tg_SaleCoupon',' Shop = '||''''||azw01||''''||' AND TYPE = '||''''||0||''''||' AND BDate >= '||''''||'",g_fdate,"'||'''','D' ",
               "   FROM azw_file",
               "  WHERE azw01 IN ",g_plantstr
   ELSE
      LET g_sql = g_sql CLIPPED,
               " SELECT ryc01,ryc02,'",g_trans_no,"','tg_SaleCoupon',' Shop = '||''''||ryc01||''''||' AND TYPE = '||''''||0||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine = '||''''||ryc02||'''','D' ",
               "   FROM ryc_temp",
               "  WHERE ryc01 IN ",g_plantstr CLIPPED," AND ryc02 IN ",g_machstr CLIPPED
   END IF
   LET g_table = "(tg_SaleCoupon)"
   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')

   #退券
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskDetail",g_db_links," (",
               " TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql,TRANS_DIRECTION ) "
   IF cl_null(g_mach) THEN
      LET g_sql = g_sql CLIPPED,
               " SELECT azw01,' ','",g_trans_no,"','tg_SaleCoupon',' Shop = '||''''||azw01||''''||' AND TYPE = '||''''||1||''''||' AND BDate >= '||''''||'",g_fdate,"'||'''','D' ",
               "   FROM azw_file",
               "  WHERE azw01 IN ",g_plantstr
   ELSE        
      LET g_sql = g_sql CLIPPED,
               " SELECT ryc01,ryc02,'",g_trans_no,"','tg_SaleCoupon',' Shop = '||''''||ryc01||''''||' AND TYPE = '||''''||1||''''||' AND BDate >= '||''''||'",g_fdate,"'||''''||' AND Machine = '||''''||ryc02||'''','D' ",
               "   FROM ryc_temp",
               "  WHERE ryc01 IN ",g_plantstr CLIPPED," AND ryc02 IN ",g_machstr CLIPPED
   END IF
   LET g_table = "(tg_SaleCoupon)"
   CALL p102_tk_TransTaskDetail_ins(g_sql,'Y')

END FUNCTION  
#FUN-D30092--add--end---


FUNCTION  p102_tk_TransTaskDetail_ins(p_sql,p_y)
DEFINE p_sql   STRING
DEFINE p_y     LIKE type_file.chr1            #主表否

 IF g_success = 'N' THEN RETURN END IF      #如果标示为N则不执行
 TRY
   CALL cl_replace_sqldb(p_sql) RETURNING p_sql
   PREPARE ins_transtask_pre FROM p_sql
   EXECUTE ins_transtask_pre
   CATCH
     IF SQLCA.sqlcode THEN
        DISPLAY "ERROR SQL : ", p_sql
        LET g_success='N'
        LET g_errno = SQLCA.sqlcode
        LET g_msg  = g_ryk01
        LET g_msg1 = g_ryk01,g_table,":INSERT INTO tk_TransTaskDetail ERROR:"
        CALL s_errmsg('ryk01',g_msg,g_msg1,SQLCA.sqlcode,1)
        LET g_msg1="ryk01:",g_ryk01,"DOWN_ERROR"
        CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
            LET g_msg=g_msg[1,255]
     END IF
     RETURN
   END TRY
   IF SQLCA.sqlerrd[3] = 0  THEN
   ELSE
      LET g_down_n = SQLCA.sqlerrd[3]
   END IF

END FUNCTION


FUNCTION p102_dblinks(l_db_links)
DEFINE l_db_links LIKE ryg_file.ryg02
  IF l_db_links IS NULL OR l_db_links = ' ' THEN
     RETURN ' '
  ELSE
     LET l_db_links = '@',l_db_links CLIPPED
     RETURN l_db_links
  END IF
END FUNCTION

FUNCTION p102_tk_TransTaskHead_ins()
DEFINE  l_date LIKE type_file.chr20

   LET l_date = g_today USING 'YYYYMMDD'
   IF g_success = 'N'  THEN RETURN END IF

  #FUN-CB0112 Mark&Add Begin ---
  #LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskHead",g_db_links,
  #            " SELECT DISTINCT TRANS_SHOP,TRANS_MACH,'",g_trans_no,"' ,'D','2','NP','",l_date,"','",g_time[1,2],g_time[4,5],g_time[7,8],"'  ",       #FUN-C50017 MARK
  #            " SELECT DISTINCT TRANS_SHOP,TRANS_MACH,'",g_trans_no,"' ,'D','2','NP','','','",l_date,"','",g_time[1,2],g_time[4,5],g_time[7,8],"'  ", #FUN-C50017 ADD
  #            "   FROM ",g_posdbs,"tk_TransTaskDetail",g_db_links,
  #            "  WHERE TASK_NO = '",g_trans_no,"'"
   LET g_sql = " INSERT INTO ",g_posdbs,"tk_TransTaskHead",g_db_links,
               "       (TRANS_SHOP,TRANS_MACH,TASK_NO,TASK_DIRECTION,TRANS_TYPE,TRANS_FLG,TRANS_DATE,TRANS_TIME,IMPORTDATE,IMPORTTIME) ",
               " SELECT DISTINCT TRANS_SHOP,TRANS_MACH,'",g_trans_no,"' ,'D','2','NP','','','",l_date,"','",g_time[1,2],g_time[4,5],g_time[7,8],"'  ",
               "   FROM ",g_posdbs,"tk_TransTaskDetail",g_db_links,
               "  WHERE TASK_NO = '",g_trans_no,"'"
  #FUN-CB0112 Mark&Add End -----
   TRY
   CALL cl_replace_sqldb(g_sql) RETURNING g_sql
   PREPARE ins_transtaskhead_pre FROM g_sql
   EXECUTE ins_transtaskhead_pre
   CATCH
     IF SQLCA.sqlcode THEN
        DISPLAY "ERROR SQL : ", g_sql
        LET g_success='N'
        LET g_errno = SQLCA.sqlcode
        LET g_msg  = g_ryk01
        LET g_msg1 = "INS tk_TransTaskHead ERROR:"
        CALL s_errmsg('ryk01',g_msg,g_msg1,SQLCA.sqlcode,1)
        LET g_msg1=g_ryk01," PLANT:",g_plantstr," failure!"
        LET g_msg1="ryk01:",g_ryk01,",INS tk_TransTaskHead DOWN_ERROR"
        CALL cl_getmsg(g_errno,g_lang) RETURNING g_msg
            LET g_msg=g_msg[1,255]
     END IF
     IF g_bgjob = "N" THEN
        MESSAGE "failure to Down"
        CALL ui.Interface.refresh()
     END IF
     RETURN
   END TRY
END FUNCTION
#FUN-C50090 

#FUN-D30071--add--str---
FUNCTION p102_show_msg()
DEFINE l_shop      LIKE ryc_file.ryc01
DEFINE l_mach      LIKE ryc_file.ryc02
DEFINE l_no        LIKE ryy_file.ryy01
DEFINE l_table     LIKE ryk_file.ryk03
DEFINE l_wheresql  LIKE type_file.chr1000
DEFINE l_type      LIKE type_file.chr1
DEFINE l_sql       STRING
DEFINE l_wheresql_str STRING
   
   CALL g_msg_array.clear()
   LET g_n = 1
  #FUN-D30092--mark--str---
  #LET l_sql = " SELECT TRANS_SHOP,TRANS_MACH,TASK_NO,TRANS_HTBName,WhereSql FROM ",g_posdbs,"tk_TransTaskDetail",g_db_links,
  #            "  WHERE TASK_NO = '",g_trans_no,"'"
  #PREPARE sel_taskdetail_pre FROM l_sql
  #DECLARE sel_taskdetail_cs  CURSOR FOR sel_taskdetail_pre
  #FOREACH sel_taskdetail_cs  INTO l_shop,l_mach,l_no,l_table,l_wheresql 
  #FUN-D30092--mark--end---
  #FUN-D30092--add--str---
   LET l_sql = " SELECT TASK_NO,TRANS_HTBName,WhereSql,TRANS_SHOP,TRANS_MACH FROM ",g_posdbs,"tk_TransTaskDetail",g_db_links,
               "  WHERE TASK_NO = '",g_trans_no,"'"
   PREPARE sel_taskdetail_pre FROM l_sql
   DECLARE sel_taskdetail_cs  CURSOR FOR sel_taskdetail_pre
   FOREACH sel_taskdetail_cs  INTO l_no,l_table,l_wheresql,l_shop,l_mach
  #FUN-D30092--add--end---
      LET g_cnt = 0
      LET l_wheresql_str = l_wheresql
      LET l_sql = " SELECT COUNT(*) FROM ",g_posdbs,l_table,g_db_links,
                  "  WHERE ",l_wheresql," "
      PREPARE sel_trans_htbname_pre FROM l_sql
      EXECUTE sel_trans_htbname_pre INTO g_cnt 
      IF g_cnt = 0 THEN
         LET l_sql = " DELETE FROM ",g_posdbs,"tk_TransTaskDetail",g_db_links,
                     "  WHERE TRANS_SHOP = '",l_shop,"' AND TRANS_MACH = '",l_mach,"' AND TASK_NO = '",l_no,"' ",
                    #"    AND TRANS_HTBName = '",l_table,"' AND WhereSql = '",l_wheresql,"' "
                     "    AND TRANS_HTBName = '",l_table,"' "
        #FUN-D30092--add--str---
         CASE l_table
            WHEN "td_Sale"
        #FUN-D30092--add--end---
               IF l_wheresql_str.getIndexOf("TYPE = '3'",1) > 0 THEN
                  LET l_sql = l_sql CLIPPED," AND instr(WhereSql,'TYPE = ''3''') > 0 "
               ELSE
                  IF l_wheresql_str.getIndexOf("TYPE = '4'",1) > 0 THEN
                     LET l_sql = l_sql CLIPPED," AND instr(WhereSql,'TYPE = ''4''') > 0 "
                  ELSE
                     LET l_sql = l_sql CLIPPED," AND instr(WhereSql,'TYPE IN (''0'',''1'',''2'')') > 0 "
                  END IF
               END IF
        #FUN-D30092--add--str---
            WHEN "tg_SaleCard"
               IF l_wheresql_str.getIndexOf("TYPE = '0'",1) > 0 THEN
                  LET l_sql = l_sql CLIPPED," AND instr(WhereSql,'TYPE = ''0''') > 0 "
               END IF
               IF l_wheresql_str.getIndexOf("TYPE = '1'",1) > 0 THEN
                  LET l_sql = l_sql CLIPPED," AND instr(WhereSql,'TYPE = ''1''') > 0 "
               END IF
            WHEN "tg_Recharge"
               IF l_wheresql_str.getIndexOf("BillType = '0'",1) > 0 THEN
                  LET l_sql = l_sql CLIPPED," AND instr(WhereSql,'BillType = ''0''') > 0 "
               END IF
            WHEN "tg_ChangeCard"
           
            WHEN "tg_SaleCoupon"
               IF l_wheresql_str.getIndexOf("TYPE = '0'",1) > 0 THEN
                  LET l_sql = l_sql CLIPPED," AND instr(WhereSql,'TYPE = ''0''') > 0 "
               END IF
               IF l_wheresql_str.getIndexOf("TYPE = '1'",1) > 0 THEN
                  LET l_sql = l_sql CLIPPED," AND instr(WhereSql,'TYPE = ''1''') > 0 "
               END IF
         END CASE 
        #FUN-D30092--add--end---
         PREPARE del_taskdetail_pre FROM l_sql
         EXECUTE del_taskdetail_pre
      END IF
      LET g_msg_array[g_n].shop = l_shop
      LET g_msg_array[g_n].mach = l_mach
     #FUN-D30092--add--str---
      CASE l_table
         WHEN "td_Sale"
     #FUN-D30092--add--end---
            IF l_wheresql_str.getIndexOf("TYPE = '3'",1) > 0 THEN
               LET g_msg_array[g_n].type = '2'     #訂單
            ELSE
               IF l_wheresql_str.getIndexOf("TYPE = '4'",1) > 0 THEN
                  LET g_msg_array[g_n].type = '3'  #訂金退回單
               ELSE
                  LET g_msg_array[g_n].type = '1'  #銷售銷退單
               END IF
            END IF
     #FUN-D30092--add--str---
         WHEN "tg_SaleCard"
            IF l_wheresql_str.getIndexOf("TYPE = '0'",1) > 0 THEN
               LET g_msg_array[g_n].type = '4'     #發卡
            END IF
            IF l_wheresql_str.getIndexOf("TYPE = '1'",1) > 0 THEN
               LET g_msg_array[g_n].type = '5'     #退卡
            END IF
         WHEN "tg_Recharge"
            IF l_wheresql_str.getIndexOf("BillType = '0'",1) > 0 THEN
               LET g_msg_array[g_n].type = '6'     #儲值
            END IF
         WHEN "tg_ChangeCard"
            LET g_msg_array[g_n].type = '7'        #換卡
         WHEN "tg_SaleCoupon"
            IF l_wheresql_str.getIndexOf("TYPE = '0'",1) > 0 THEN
               LET g_msg_array[g_n].type = '8'     #售券
            END IF
            IF l_wheresql_str.getIndexOf("TYPE = '1'",1) > 0 THEN
               LET g_msg_array[g_n].type = '9'     #退券
            END IF
      END CASE
     #FUN-D30092--add--end---  
      LET g_msg_array[g_n].cnt  = g_cnt 
      LET g_n = g_n + 1
   END FOREACH
END FUNCTION
#FUN-D30071--add--end---
