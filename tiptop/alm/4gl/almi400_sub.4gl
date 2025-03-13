# Prog. Version..: '5.30.06-13.03.12(00008)'     #
#
# Pattern name...: almi400_sub.4gl
# Descriptions...: 合同产生日核算和费用单
# Date & Author..: No:FUN-BA0118 11/11/07 By shiwuying
# Modify.........: No:FUN-C20078 12/02/14 By shiwuying 比例日核算更新
# Modify.........: No:TQC-C20395 12/02/23 By shiwuying 费用方案延用规格调整
# Modify.........: No:TQC-C30027 12/03/02 By fanbj 終止變更中產生費用單包含違約金的費用單
# Modify.........: No:CHI-C80016 12/08/09 By Lori 修正l_lua.lua23(單價含稅否) 的 Y 或 N 時, l_lub.lub04(未稅金額) 計算公式都一樣
# Modify.........: No:FUN-CA0081 12/10/09 By shiwuying 比例方案增加分段区间
# Modify.........: No:FUN-C90050 12/10/25 By Lori 預設單別/預設POS上傳單別改以s_get_defslip取得
# Modify.........: No.CHI-C80041 13/01/18 By bart 排除作廢

DATABASE ds

GLOBALS "../../config/top.global"
DEFINE gs_lnt           RECORD LIKE lnt_file.*   #合同单头
DEFINE gs_lji           RECORD LIKE lji_file.*   #变更单单头
DEFINE gs_lla           RECORD LIKE lla_file.*   #招商参数
DEFINE gs_tmp           RECORD                   #临时表
         type           LIKE type_file.chr1,     #类型 1.almi360,2.almi365
         no             LIKE lil_file.lil01,     #方案编号
         version        LIKE lil_file.lil02,     #方案版本号
         bdate          LIKE type_file.dat,      #开始时间
         edate          LIKE type_file.dat,      #结束时间
         flg1           LIKE type_file.chr1,     #方案是否延用
         flg2           LIKE type_file.chr1      #是否为延用的方案
                        END RECORD
DEFINE gs_tmp_t         RECORD
         type           LIKE type_file.chr1,     #类型 1.almi360,2.almi365
         no             LIKE lil_file.lil01,     #方案编号
         version        LIKE lil_file.lil02,     #方案版本号
         bdate          LIKE type_file.dat,      #开始时间
         edate          LIKE type_file.dat,      #结束时间
         flg1           LIKE type_file.chr1,     #方案是否延用
         flg2           LIKE type_file.chr1      #是否为延用的方案
                        END RECORD
DEFINE g_success1       LIKE type_file.chr1      #记录是否有断续的区间没有设置费用方案,且可以延用
DEFINE g_showmsg        STRING                   #报错用
DEFINE gs_sql           STRING
DEFINE g_cnt            LIKE type_file.num5
DEFINE g_flg            LIKE type_file.chr1      #收付实现制产生日核算用
DEFINE g_liu08          LIKE liu_file.liu08

#产生p_bdate~p_edate之间的日核算
#p_type     #类型     1-almi400,   2-almt410延期日核算, 3-almt410面积变更日核算
#p_no       #单号     合同号       合同变更单号
#p_bdate    #开始日期 合同计租起日 合同租赁止日+1        面积变更日
#p_edate    #结束日期 合同计租止日 延期截止日            合同计租止日
FUNCTION i400sub_standard(p_type,p_no,p_bdate,p_edate)
 DEFINE p_type          LIKE type_file.chr1
 DEFINE p_no            LIKE lnt_file.lnt01
 DEFINE p_bdate         LIKE lnt_file.lnt17
 DEFINE p_edate         LIKE lnt_file.lnt18
 DEFINE l_lij02         LIKE lij_file.lij02
 DEFINE l_lij04         LIKE lij_file.lij04
 
   WHENEVER ERROR CALL cl_err_msg_log

   IF cl_null(p_type) OR cl_null(p_no) OR cl_null(p_bdate) OR cl_null(p_edate) THEN
      RETURN
   END IF
   IF p_type = '1' THEN
      SELECT * INTO gs_lnt.* FROM lnt_file WHERE lnt01 = p_no
   END IF
   IF p_type = '2' OR p_type = '3' THEN
      SELECT * INTO gs_lji.* FROM lji_file WHERE lji01 = p_no
   END IF
   IF p_type = '2' OR p_type = '3' THEN #后面的变量统一用gs_lnt来做
      LET gs_lnt.lnt01 = gs_lji.lji01 #单号
      LET gs_lnt.lntplant = gs_lji.ljiplant
      LET gs_lnt.lnt06 = gs_lji.lji08     #摊位编号
      LET gs_lnt.lnt55 = gs_lji.lji09     #摊位用途
      LET gs_lnt.lnt08 = gs_lji.lji11     #楼栋编号
      LET gs_lnt.lnt09 = gs_lji.lji12     #楼层编号
      LET gs_lnt.lnt60 = gs_lji.lji13     #区域编号
      LET gs_lnt.lnt33 = gs_lji.lji51     #小类编号
      LET gs_lnt.lnt11 = gs_lji.lji14     #建筑面积
      LET gs_lnt.lnt61 = gs_lji.lji15     #测量面积
      LET gs_lnt.lnt10 = gs_lji.lji16     #经营面积
      IF gs_lji.lji02 = '4' THEN
         LET gs_lnt.lnt61 = gs_lji.lji151 #测量面积
         LET gs_lnt.lnt10 = gs_lji.lji161 #经营面积
      END IF
      LET gs_lnt.lnt17 = gs_lji.lji22     #合同租赁起日
      LET gs_lnt.lnt18 = gs_lji.lji23     #合同租赁止日
   END IF
   #抓取参数
   SELECT * INTO gs_lla.* FROM lla_file WHERE llastore = gs_lnt.lntplant
   LET g_success = 'Y'
   CALL i400sub_create_tmp_table()  #创建临时表，记录方案和日期区间
   IF g_success = 'N' THEN RETURN END IF
   BEGIN WORK
   CALL s_showmsg_init()
   LET g_success = 'Y'
   LET g_success1= 'Y'
   CALL i400sub_delliv(p_type,p_bdate,p_edate)
   IF p_type = '3' THEN #p_type = '3'的情况特殊处理
      CALL i400sub_area(p_type,p_no,p_bdate,p_edate)
   END IF
   IF p_type = '1' OR p_type = '2' THEN
      #抓取合同费用项方案中的标准费用编号,根据费用编号依次产生日核算
      IF p_type = '1' THEN
         LET gs_sql = "SELECT lij02,lij04 FROM lij_file,lii_file",
                      " WHERE lij01=lii01 ",
                      "   AND lii05 = '",gs_lnt.lnt55,"'", #摊位用途
                      "   AND lii01 = '",gs_lnt.lnt71,"'", #合同费用项方案
                      "   AND lij06 = 'Y'",
                      "   AND liiconf <> 'X' ",  #CHI-C80041
                      " ORDER BY lij02"
      ELSE
         LET gs_sql = "SELECT lij02,lij04 FROM lij_file,lii_file,oaj_file",
                      " WHERE lij01=lii01 ",
                      "   AND oaj01 = lij02 ",
                      "   AND lii05 = '",gs_lji.lji09,"'", #摊位用途
                      "   AND lii01 = '",gs_lji.lji40,"'", #合同费用项方案
                      "   AND lij06 = 'Y'",
                      "   AND liiconf <> 'X' ",  #CHI-C80041
                      "   AND oaj05 = '02'",               #延期只抓收入类型的费用编号
                      "   AND lij05 = '0'",                #延期只抓权责发生制的费用编号 #TQC-C20395
                      " ORDER BY lij02"
      END IF
      PREPARE i400sub_pre1 FROM gs_sql
      DECLARE i400sub_cs1 CURSOR FOR i400sub_pre1
      FOREACH i400sub_cs1 INTO l_lij02,l_lij04
         IF STATUS THEN
            CALL cl_err('i400sub_cs1',STATUS,0)
            LET g_success = 'N'
            EXIT FOREACH
         END IF

        #20111220 By shi Begin---
        #如果是延期，且方案设置合同期，不计算延期
         IF p_type = '2' AND i400sub_chk_lij05(l_lij02) THEN
            CONTINUE FOREACH
         END IF
        #20111220 By shi End-----
         CALL i400sub_gen_project(p_type,p_bdate,p_edate,l_lij02)  #抓取方案，按照日期区间写入临时表
         IF g_success = 'N' THEN CONTINUE FOREACH END IF
         CALL i400sub_gen_expenses(p_type,l_lij02,l_lij04)         #计算日核算
      END FOREACH
   END IF

   IF g_success = 'Y' THEN
      IF g_success1 = 'N' THEN
         #提示用户哪些区间没有设置费用标准方案，或者摊位个别计价方案
         #让用户选择是否延用？
         #是，COMMIT，否ROLLBACK
         CALL s_showmsg()
         IF NOT cl_confirm('alm1167') THEN
            IF p_type = '1' THEN
               CALL cl_err('','alm1327',0)
            ELSE
               CALL cl_err('','abm-020',0)
            END IF
            ROLLBACK WORK
            LET g_success = 'N'
         ELSE
            IF p_type = '1' THEN
               CALL cl_err('','alm1326',0)
            ELSE
               CALL cl_err('','abm-019',0)
            END IF
            COMMIT WORK
         END IF
      ELSE
         CALL s_showmsg()
         IF p_type = '1' THEN
            CALL cl_err('','alm1326',0)
         ELSE
            CALL cl_err('','abm-019',0)
         END IF
         COMMIT WORK
      END IF
   ELSE
      CALL s_showmsg()
      IF p_type = '1' THEN
         CALL cl_err('','alm1327',0)
      ELSE
         CALL cl_err('','abm-020',0)
      END IF
      ROLLBACK WORK
   END IF
   DROP TABLE i400_tmp
END FUNCTION

FUNCTION i400sub_gen_project(p_type,p_bdate,p_edate,p_lij02)
 DEFINE p_type          LIKE type_file.chr1
 DEFINE p_bdate         LIKE lnt_file.lnt17
 DEFINE p_edate         LIKE lnt_file.lnt18
 DEFINE p_lij02         LIKE lij_file.lij02
 DEFINE l_lnl03         LIKE lnl_file.lnl03
 DEFINE l_lnl04         LIKE lnl_file.lnl04
 DEFINE l_lnl05         LIKE lnl_file.lnl05
 DEFINE l_lnl09         LIKE lnl_file.lnl09
 DEFINE l_lil01         LIKE lil_file.lil01
 DEFINE l_lil14         LIKE lil_file.lil14
 DEFINE l_success       LIKE type_file.chr1  #记录是否有断续的区间没有设置费用方案
 DEFINE l_date          LIKE type_file.dat
 DEFINE l_bdate         LIKE type_file.dat
 DEFINE l_edate         LIKE type_file.dat

   DELETE FROM i400_tmp
   #先抓取almi350中的设置
   SELECT lnl03,lnl04,lnl05,lnl09 INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
     FROM lnl_file
    WHERE lnl01 = p_lij02
      AND lnlstore = gs_lnt.lntplant
   #费用方案设置按照区域设置，合同中没有设置区域，报错：费用标准参数设置中有按照区域设置费用标准，但是合同中没有设置区域！
   IF cl_null(gs_lnt.lnt60) AND l_lnl05 = 'Y' THEN
      CALL s_errmsg('lnt01',gs_lnt.lnt01,'','alm1144',1)
      LET g_success = 'N'
      RETURN
   END IF
   #根据合同日期区间和费用标准设置先抓取almi365中的设置
   LET gs_sql = "SELECT DISTINCT '2',lip01,lip02,lip14,lip15,lip16,'N' FROM lip_file,liq_file",
                " WHERE lip01 = liq01 ",
                "   AND lip06 = '",p_lij02,"'",            #费用编号
                "   AND lipplant = '",gs_lnt.lntplant,"'", #门店编号
                "   AND lip11 = '",gs_lnt.lnt55,"'",       #摊位用途
                "   AND liq03 = '",gs_lnt.lnt06,"'",       #摊位编号
                "   AND (lip14 BETWEEN '",p_bdate,"' AND '",p_edate,"'",
                "    OR  lip15 BETWEEN '",p_bdate,"' AND '",p_edate,"'",
                "    OR  '",p_bdate,"' BETWEEN lip14 AND lip15)",
                "   AND lipconf = 'Y' ",
                " ORDER BY lip14"
   PREPARE i400sub_pre2 FROM gs_sql
   DECLARE i400sub_cs2 CURSOR FOR i400sub_pre2
   FOREACH i400sub_cs2 INTO gs_tmp.*
      IF STATUS THEN
         CALL s_errmsg('','','i400sub_cs2',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      
      IF gs_tmp.bdate < p_bdate THEN
         LET gs_tmp.bdate = p_bdate
      END IF
      IF gs_tmp.edate > p_edate THEN
         LET gs_tmp.edate = p_edate
      END IF
      INSERT INTO i400_tmp VALUES(gs_tmp.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','ins i400_tmp',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END FOREACH
   
   #根据合同日期区间和费用标准设置先抓取almi360中的设置
   LET gs_sql = "SELECT '1',lil01,lil02,lil12,lil13,lil14,'N' FROM lil_file ",
                " WHERE lil04 = '",p_lij02,"'",           #费用编号
                "   AND lilplant = '",gs_lnt.lntplant,"'", #门店编号
                "   AND lil09 = '",gs_lnt.lnt55,"'",       #摊位用途
                "   AND (lil12 BETWEEN '",p_bdate,"' AND '",p_edate,"'",
                "    OR  lil13 BETWEEN '",p_bdate,"' AND '",p_edate,"'",
                "    OR  '",p_bdate,"' BETWEEN lil12 AND lil13)",
                "   AND lilconf = 'Y' "
   IF l_lnl03 = 'Y' THEN #按照楼栋设置费用标准
      LET gs_sql = gs_sql CLIPPED,"   AND lil05 = '",gs_lnt.lnt08,"'"
   ELSE
      LET gs_sql = gs_sql CLIPPED,"   AND lil05 IS NULL "
   END IF
   IF l_lnl04 = 'Y' THEN #按照楼层设置费用标准
      LET gs_sql = gs_sql CLIPPED,"   AND lil06 = '",gs_lnt.lnt09,"'"
   ELSE
      LET gs_sql = gs_sql CLIPPED,"   AND lil06 IS NULL "
   END IF
   IF l_lnl05 = 'Y' THEN #按照区域设置费用标准
      LET gs_sql = gs_sql CLIPPED,"   AND lil07 = '",gs_lnt.lnt60,"'"
   ELSE
      LET gs_sql = gs_sql CLIPPED,"   AND lil07 IS NULL "
   END IF
   IF l_lnl09 = 'Y' THEN #按照小类设置费用标准
      LET gs_sql = gs_sql CLIPPED,"   AND lil08 = '",gs_lnt.lnt33,"'"
   ELSE
      LET gs_sql = gs_sql CLIPPED,"   AND lil08 IS NULL "
   END IF
   LET gs_sql = gs_sql CLIPPED," ORDER BY lil12"
   
   PREPARE i400sub_pre3 FROM gs_sql
   DECLARE i400sub_cs3 CURSOR FOR i400sub_pre3
   FOREACH i400sub_cs3 INTO gs_tmp.*
      IF STATUS THEN
         CALL s_errmsg('','','i400sub_cs3',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF gs_tmp.bdate < p_bdate THEN
         LET gs_tmp.bdate = p_bdate
      END IF
      IF gs_tmp.edate > p_edate THEN
         LET gs_tmp.edate = p_edate
      END IF

      #判断这个区间有没有365,如果有的话,看有没有空余的区间，有这段区间写入360的方案到临时表，否则CONTINUE
      DECLARE i400sub_cs11 CURSOR FOR
       SELECT bdate,edate FROM i400_tmp
        WHERE type = '2'
          AND (bdate BETWEEN gs_tmp.bdate AND gs_tmp.edate
           OR  edate BETWEEN gs_tmp.bdate AND gs_tmp.edate)
       ORDER BY bdate
      LET l_date = gs_tmp.bdate
      LET gs_tmp_t.* = gs_tmp.*
      FOREACH i400sub_cs11 INTO l_bdate,l_edate
         IF STATUS THEN
            CALL s_errmsg('','','i400sub_cs11',STATUS,1)
            LET g_success = 'N'
            EXIT FOREACH
         END IF
         
         IF l_date = gs_tmp.bdate THEN
            IF gs_tmp.bdate >= l_bdate THEN
               LET l_date = l_edate+1
               CONTINUE FOREACH
            ELSE
               LET gs_tmp_t.edate = l_bdate-1
               INSERT INTO i400_tmp VALUES(gs_tmp_t.*)
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','ins i400_tmp',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
               LET l_date = l_edate+1
            END IF
         ELSE
            IF l_date = l_bdate THEN
               LET l_date = l_edate+1
               CONTINUE FOREACH
            ELSE
               LET gs_tmp_t.bdate = l_date
               LET gs_tmp_t.edate = l_bdate-1
               INSERT INTO i400_tmp VALUES(gs_tmp_t.*)
               IF SQLCA.sqlcode THEN
                  CALL s_errmsg('','','ins i400_tmp',SQLCA.sqlcode,1)
                  LET g_success = 'N'
                  RETURN
               END IF
               LET l_date = l_edate+1
            END IF
         END IF
      END FOREACH
      IF (l_date <> gs_tmp.bdate AND l_date-1 <> gs_tmp.edate AND l_date <= gs_tmp.edate) OR l_date = gs_tmp.bdate THEN
         LET gs_tmp_t.bdate = l_date
         LET gs_tmp_t.edate = gs_tmp.edate
         INSERT INTO i400_tmp VALUES(gs_tmp_t.*)
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','','ins i400_tmp',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
     #INSERT INTO i400_tmp VALUES(gs_tmp.*)
     #IF SQLCA.sqlcode THEN
     #   CALL s_errmsg('','','ins i400_tmp',SQLCA.sqlcode,1)
     #   LET g_success = 'N'
     #END IF
   END FOREACH

   #判断延用，根据临时表中的方案，抓取方案单身设置
   INITIALIZE gs_tmp.* TO NULL
   INITIALIZE gs_tmp_t.* TO NULL
   DECLARE i400sub_cs4 CURSOR FOR SELECT * FROM i400_tmp ORDER BY bdate
   LET g_cnt = 1
   FOREACH i400sub_cs4 INTO gs_tmp.*
      IF STATUS THEN
         CALL s_errmsg('','','i400sub_cs4',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF
      IF g_cnt = 1 THEN
         LET gs_tmp_t.* = gs_tmp.*
         LET g_cnt = g_cnt + 1
         IF gs_tmp.bdate <> p_bdate THEN
            #报错：费用编号p_lij02在p_bdate ~ gs_tmp.bdate-1时间段内无费用标准方案设置！
            LET g_showmsg = p_lij02,'IN(',p_bdate,'~',gs_tmp.bdate-1,')'
            CALL s_errmsg('lij02',g_showmsg,'','alm1145',1)
            LET g_success = 'N'
         END IF
         CONTINUE FOREACH
      END IF
      #判断上一个时间段的结束时间不等于这段时间的开始时间，且上一个方案延用
      #是则断续的区间内延用上一个方案，否则记录断续的时间段，报错
      IF gs_tmp_t.edate+1 <> gs_tmp.bdate THEN
         IF gs_tmp_t.flg1 = 'Y' THEN
            #暂时另外写一笔临时表资料
            #如果后续需要，可以并到上一个方案中，更新方案结束日期
            INSERT INTO i400_tmp VALUES(gs_tmp_t.type,gs_tmp_t.no,gs_tmp_t.version,
                                        gs_tmp_t.edate+1,gs_tmp.bdate-1,
                                        gs_tmp_t.flg1,'Y')
            IF SQLCA.sqlcode THEN
               CALL s_errmsg('','','ins i400_tmp',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
            LET g_success1 = 'N'
         ELSE
            IF gs_tmp_t.flg1 = 'N' AND gs_tmp_t.type = '2' THEN
               #如果上一个方案是摊位个别计价且不延用，看有没有结束日期=摊位个别计价结束日期的费用标准方案
               #如果有看是否延用，是则延用费用标准方案INSERT 到临时表 flg2='Y'
               CALL i400sub_use_last(p_type,p_lij02,gs_tmp_t.edate+1,gs_tmp.bdate-1)
            ELSE
               #报错：费用编号p_lij02在i400_tmp_t.edate+1 ~ i400_tmp.b_date-1时间段内无费用标准方案设置！
               LET g_showmsg = p_lij02,'IN(',gs_tmp_t.edate+1,'~',gs_tmp.bdate-1,')'
               CALL s_errmsg('lij02',g_showmsg,'','alm1145',1)
               LET g_success = 'N'
            END IF
         END IF
      END IF

      LET gs_tmp_t.* = gs_tmp.*
      LET g_cnt = g_cnt + 1
   END FOREACH
   IF g_cnt = 1 THEN
      #看上一期的合同费用是否有延用，如果有的话，延用上一期的，新增到临时表，日期区间为合同计租期,flg2='Y'
      CALL i400sub_use_last1(p_type,p_lij02,p_bdate,p_edate)
  #ELSE
  #   #报错：费用编号p_lij02在合同计租期间没有设置费用标准！
  #   LET g_showmsg = p_lij02,' IN(',p_bdate,'~',p_edate,')'
  #   CALL s_errmsg('lij02',g_showmsg,'','alm1145',1)
  #   LET g_success = 'N'
   END IF
   IF gs_tmp_t.edate <> p_edate THEN #合同期没有方案，延用上一期的，日期取合同期，这一段走不到
      IF gs_tmp_t.flg1 = 'Y' THEN
         #如果最后的结束日期gs_tmp_t.edate <> p_edate AND 最后一个费用方案有延用
         #暂时另外写一笔临时表资料
         #如果后续需要，可以并到上一个方案中，更新方案结束日期
         INSERT INTO i400_tmp VALUES (gs_tmp_t.type,gs_tmp_t.no,gs_tmp_t.version,
                                      gs_tmp_t.edate+1,p_edate,
                                      gs_tmp_t.flg1,'Y')
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('','','ins i400_tmp',SQLCA.sqlcode,1)
            LET g_success = 'N'
         END IF
         LET g_success1 = 'N'
      ELSE
         IF gs_tmp_t.flg1 = 'N' AND gs_tmp.type = '2' THEN
            #如果摊位个别计价的方案不延用，看有没有结束日期=摊位个别计价结束日期的费用标准方案
            #如果有看是否延用，是则延用费用标准方案
            CALL i400sub_use_last(p_type,p_lij02,gs_tmp_t.edate+1,p_edate)
         ELSE
            #报错：费用编号p_lij02在i400_tmp_t.edate+1 ~ p_edate时间段内无费用标准方案设置！
            LET g_showmsg = p_lij02,' IN(',gs_tmp_t.edate+1,'~',p_edate,')'
            CALL s_errmsg('lij02',g_showmsg,'','alm1145',1)
            LET g_success = 'N'
         END IF
      END IF
   END IF
END FUNCTION

#根据临时表中的方案，抓取对应的方案设置的费用标准，产生日核算
FUNCTION i400sub_gen_expenses(p_type,p_lij02,p_lij04)
 DEFINE p_type          LIKE type_file.chr1
 DEFINE p_lij02         LIKE lij_file.lij02
 DEFINE p_lij04         LIKE lij_file.lij04

   INITIALIZE gs_tmp.* TO NULL
   DECLARE i400sub_cs7 CURSOR FOR
    SELECT * FROM i400_tmp
     ORDER BY bdate
   LET g_cnt = 1
   FOREACH i400sub_cs7 INTO gs_tmp.*
      IF STATUS THEN
         CALL s_errmsg('','','i400sub_cs7',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

     #如果费用编号设置的是收付实现制，且第一个方案中的日前类型是5.合同期，这是不需要计算日核算
     #只要写一笔日核算放在合同计租起日这天
     #如果费用编号设置的是收付实现制，且第一个方案中的日前类型不是合同期，按照正常逻辑做
     #其他的按照正常流程走
      IF g_cnt = 1 THEN
         IF p_type = '1' THEN
            SELECT liu08 INTO g_liu08 FROM liu_file
             WHERE liu01 = gs_lnt.lnt01
               AND liu04 = p_lij02
            IF SQLCA.sqlcode = 100 THEN
               SELECT lij05 INTO g_liu08 FROM lij_file,lii_file
                WHERE lii01 = lij01
                  AND lii01 = gs_lnt.lnt71
                  AND lij02 = p_lij02
                  AND liiconf <> 'X'  #CHI-C80041
            END IF
         ELSE
            SELECT ljm08 INTO g_liu08 FROM ljm_file
             WHERE ljm01 = gs_lji.lji01
               AND ljm04 = p_lij02
         END IF
         IF g_liu08 = '1' THEN
            LET g_flg = 'N'
            CALL i400sub_insliv(p_type,p_lij02,p_lij04,'1') #写日核算
            CALL i400sub_inslnv(p_type,p_lij02)             #写合同标准费用单身
            IF g_flg = 'Y' THEN EXIT FOREACH END IF
         ELSE
            CALL i400sub_insliv(p_type,p_lij02,p_lij04,'0') #写日核算
            CALL i400sub_inslnv(p_type,p_lij02)             #写合同标准费用单身
         END IF
      ELSE
         CALL i400sub_insliv(p_type,p_lij02,p_lij04,'0') #写日核算
         CALL i400sub_inslnv(p_type,p_lij02)             #写合同标准费用单身
      END IF

      LET gs_tmp_t.* = gs_tmp.*
      LET g_cnt = g_cnt + 1
   END FOREACH

END FUNCTION

FUNCTION i400sub_insliv(p_type,p_lij02,p_lij04,p_flg)
 DEFINE p_type          LIKE type_file.chr1
 DEFINE p_lij02         LIKE lij_file.lij02
 DEFINE p_lij04         LIKE lij_file.lij04
 DEFINE p_flg           LIKE type_file.chr1 #收付实现制且第一个方案为1，否则为0
 DEFINE l_lil00         LIKE lil_file.lil00
 DEFINE l_lil10         LIKE lil_file.lil10
 DEFINE l_lil11         LIKE lil_file.lil11
 DEFINE l_lim           RECORD LIKE lim_file.*
 DEFINE l_liv           RECORD LIKE liv_file.*
 DEFINE l_ljp           RECORD LIKE ljp_file.*
 DEFINE l_date          LIKE type_file.dat
 DEFINE l_amt           LIKE liv_file.liv06
 DEFINE l_year_amt      LIKE liv_file.liv06
 DEFINE l_month_amt     LIKE liv_file.liv06
 DEFINE l_day_amt       LIKE liv_file.liv06
 DEFINE l_diff_amt      LIKE liv_file.liv06
 DEFINE l_year_days     LIKE type_file.num5
 DEFINE l_month_days    LIKE type_file.num5
 DEFINE l_all_days      LIKE type_file.num5
 DEFINE l_year_first_date  LIKE type_file.dat
 DEFINE l_year_last_date   LIKE type_file.dat
 DEFINE l_month_first_date LIKE type_file.dat
 DEFINE l_month_last_date  LIKE type_file.dat
 DEFINE l_rate             LIKE type_file.num20_6
 DEFINE l_ljp06            LIKE ljp_file.ljp06
 DEFINE l_lim04            LIKE lim_file.lim04
 DEFINE l_date_t           LIKE type_file.dat   #判断方案单身日期区间是否连续
 
   #抓取方案中设置的方案类型，日期类型，定义方式
   IF gs_tmp.type = '1' THEN
      SELECT lil00,lil10,lil11 INTO l_lil00,l_lil10,l_lil11
        FROM lil_file
       WHERE lil01 = gs_tmp.no
      IF gs_tmp.flg2 = 'Y' THEN  #如果是延用的方案，直接抓方案单身中日前最大的那笔标准延用
         SELECT MAX(lim04) INTO l_lim04 FROM lim_file
          WHERE lim01 = gs_tmp.no
      END IF
      LET gs_sql = "SELECT lim01,lim02,lim03,lim04,lim05,lim051,lim06,lim061,lim062,lim07,lim071,lim072,lim073",
                   "  FROM lim_file",
                   " WHERE lim01 = '",gs_tmp.no,"'"
      IF gs_tmp.flg2 = 'Y' THEN
         LET gs_sql = gs_sql,"   AND lim04 = '",l_lim04,"'"
      ELSE
         LET gs_sql = gs_sql,"   AND lim04 >= '",gs_tmp.bdate,"'" #抓取单身结束日期大于等于该方案日期的单身
      END IF
      IF l_lil00 = '3' THEN  #只抓满足上下限范围的资料
          IF l_lil11 = '1' THEN
              LET gs_sql = gs_sql,"   AND '",gs_lnt.lnt10,"' BETWEEN lim071 AND lim072 "
          END IF
          IF l_lil11 = '2' THEN
              LET gs_sql = gs_sql,"   AND '",gs_lnt.lnt61,"' BETWEEN lim071 AND lim072 "
          END IF
      END IF
      LET gs_sql = gs_sql," ORDER BY lim03"
   ELSE
      SELECT lip04,lip12,lip13 INTO l_lil00,l_lil10,l_lil11
        FROM lip_file
       WHERE lip01 = gs_tmp.no
      IF gs_tmp.flg2 = 'Y' THEN
         SELECT MAX(liq05) INTO l_lim04 FROM liq_file
          WHERE liq01 = gs_tmp.no
      END IF
      LET gs_sql = "SELECT liq01,liq02,liq04,liq05,liq061,1,liq07,liq073,liq074,liq08,liq081,liq082,liq084",
                   "  FROM liq_file",
                   " WHERE liq01 = '",gs_tmp.no,"'",
                   "   AND liq03 = '",gs_lnt.lnt06,"'"
      IF gs_tmp.flg2 = 'Y' THEN
         LET gs_sql = gs_sql,"   AND liq05 = '",l_lim04,"'"
      ELSE
         LET gs_sql = gs_sql,"   AND liq05 >= '",gs_tmp.bdate,"'" #抓取单身结束日期大于等于该方案日期的单身
      END IF
      IF l_lil00 = '3' THEN  #只抓满足上下限范围的资料
          IF l_lil11 = '1' THEN
              LET gs_sql = gs_sql,"   AND '",gs_lnt.lnt10,"' BETWEEN liq081 AND liq082 "
          END IF
          IF l_lil11 = '2' THEN
              LET gs_sql = gs_sql,"   AND '",gs_lnt.lnt61,"' BETWEEN liq081 AND liq082 "
          END IF
      END IF
      LET gs_sql = gs_sql," ORDER BY liq04"
   END IF
   PREPARE i400sub_pre8 FROM gs_sql
   DECLARE i400sub_cs8 CURSOR FOR i400sub_pre8
   LET l_date_t = gs_tmp.bdate
   FOREACH i400sub_cs8 INTO l_lim.*
      IF STATUS THEN
         CALL s_errmsg('','','i400sub_cs8',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      IF gs_tmp.flg2 = 'Y' THEN
         LET l_lim.lim03 = gs_tmp.bdate
         LET l_lim.lim04 = gs_tmp.edate
      END IF
      IF l_lim.lim03 > gs_tmp.edate OR l_lim.lim04 < gs_tmp.bdate THEN
         CONTINUE FOREACH
      END IF
      IF l_lim.lim03 < gs_tmp.bdate THEN
         LET l_lim.lim03 = gs_tmp.bdate
      END IF
      IF l_lim.lim04 > gs_tmp.edate THEN
         LET l_lim.lim04 = gs_tmp.edate
      END IF
     #FUN-CA0081 Begin---
     #比例标准时，因为有分段，可能会有多笔资料，如果已经写了日核算，不用再写
      IF l_lil00 = '2' THEN
         LET g_cnt = 0 
         IF p_type = '1' THEN
            SELECT COUNT(*) INTO g_cnt FROM liv_file
             WHERE liv07 = l_lim.lim01
               AND liv04 BETWEEN l_lim.lim03 AND l_lim.lim04
               AND liv05 = p_lij02
               AND liv01 = gs_lnt.lnt01
         ELSE
            SELECT COUNT(*) INTO g_cnt FROM ljp_file
             WHERE ljp07 = l_lim.lim01
               AND ljp04 BETWEEN l_lim.lim03 AND l_lim.lim04
               AND ljp05 = p_lij02
               AND ljp01 = gs_lnt.lnt01
               AND ljp02 = gs_lji.lji05
         END IF
         IF g_cnt > 0 THEN CONTINUE FOREACH END IF
      END IF
     #FUN-CA0081 End-----

      IF p_type <> '3' THEN
      IF l_date_t = gs_tmp.bdate THEN
         IF l_date_t <> l_lim.lim03 THEN
            #提示：费用编号p_lij02在gs_tmp.bdate ~ l_lim.lim03-1时间段内无费用标准方案设置！
            LET g_showmsg = p_lij02,'/',l_lim.lim01,'IN(',gs_tmp.bdate,'~',l_lim.lim03-1,')'
            CALL s_errmsg('lij02,lim01',g_showmsg,'','alm1169',2)
         END IF
      ELSE
         IF l_date_t <> l_lim.lim03 THEN
            #提示：费用编号p_lij02在l_date_t ~ l_lim.lim03-1时间段内无费用标准方案设置！
            LET g_showmsg = p_lij02,'/',l_lim.lim01,'IN(',l_date_t,'~',l_lim.lim03-1,')'
            CALL s_errmsg('lij02,lim01',g_showmsg,'','alm1169',2)
         END IF
      END IF
      END IF
      LET l_date_t = l_lim.lim04+1
      
      #根据方案类型算出单身日期区间设置的费用标准
      CASE l_lil00 #方案类型
         WHEN '1'  #定额标准 费用标准*费用系数
            LET l_amt = l_lim.lim05 * l_lim.lim051
         WHEN '2'  #比例标准
            #抓取这段时间内的销售金额*比例=费用标准，小于保底金额，则费用标准=保底金额
            #l_amt = 销售金额 * l_lim.lim061
            #IF l_amt < l_lim.lim062 THEN
            #   LET l_amt = l_lim.lim062
            #END IF
             LET l_amt = 0   #FUN-C20078
         WHEN '3'  #分段标准 默认分段定义方式只能设置1/2
            IF l_lil11 = '1' THEN
               IF gs_lnt.lnt10 > l_lim.lim072 OR gs_lnt.lnt10 < l_lim.lim071 THEN
                  CONTINUE FOREACH
               END IF
            END IF
            IF l_lil11 = '2' THEN
               IF gs_lnt.lnt61 > l_lim.lim072 OR gs_lnt.lnt61 < l_lim.lim071 THEN
                  CONTINUE FOREACH
               END IF
            END IF
            LET l_amt = l_lim.lim073
      END CASE
      LET l_amt = cl_digcut(l_amt,gs_lla.lla04)

      #根据定义方式算出费用标准金额l_amt
      CASE l_lil11 #定义方式,1:经营面积，2:测量面积，3:人数，4:所填金额
         WHEN '1'
            LET l_amt = l_amt * gs_lnt.lnt10
         WHEN '2'
             LET l_amt = l_amt * gs_lnt.lnt61
         WHEN '3'
            LET l_amt = l_amt * gs_lnt.lnt72
         WHEN '4'
            LET l_amt = l_amt
         WHEN '5'             #FUN-C20078
            LET l_amt = l_amt #FUN-C20078
      END CASE
      LET l_amt = cl_digcut(l_amt,gs_lla.lla04)

##############################################################################################
#处理收付实现制且第一笔方案日期类型是合同期的日核算
      IF p_flg = '1' AND ((p_type = '1' OR gs_tmp.bdate = gs_lnt.lnt21) OR p_type = '3') THEN
         IF l_lil10 = '5' THEN
            IF gs_lnt.lnt21 <> l_lim.lim03 AND p_type <> '3' THEN
               #提示：费用编号p_lij02在gs_tmp.bdate ~ l_lim.lim03-1时间段内无费用标准方案设置！
               LET g_showmsg = p_lij02,'/',l_lim.lim01,'IN(',gs_tmp.bdate,'~',gs_tmp.bdate,')'
               CALL s_errmsg('lij02,lim01',g_showmsg,'','alm1169',2)
            ELSE
               LET l_day_amt = l_amt
               IF p_type = '1' THEN
                  LET l_liv.liv01 = gs_lnt.lnt01  #合同编号
                  LET l_liv.liv02 = gs_lnt.lnt02  #合同版本号
                  SELECT MAX(liv03)+1 INTO l_liv.liv03 FROM liv_file
                   WHERE liv01 = gs_lnt.lnt01
                  IF cl_null(l_liv.liv03) THEN
                     LET l_liv.liv03 = 1          #项次
                  END IF
                  LET l_liv.liv04 = gs_lnt.lnt21  #分摊日期
                  LET l_liv.liv05 = p_lij02       #费用编号
                  LET l_liv.liv06 = l_day_amt     #费用金额
                  LET l_liv.liv07 = l_lim.lim01   #参考单号
                  LET l_liv.liv071= gs_tmp.version#参考单号版本号
                  LET l_liv.liv08 = '1'           #数据类型  1-标准 2-优惠,3终止,4.抹零
                  LET l_liv.liv09 = '0'           #优惠类型  0.无,1.租金优惠，2.面积优惠，3.租期优惠，4.单价优惠
                  LET l_liv.livplant = gs_lnt.lntplant   #门店编号
                  LET l_liv.livlegal = gs_lnt.lntlegal   #法人
                  INSERT INTO liv_file VALUES l_liv.*
                  IF SQLCA.sqlcode THEN
                     LET g_showmsg = gs_lnt.lnt01,'/',l_liv.liv03,'/',gs_lnt.lnt21,' '
                     CALL s_errmsg('liv01,liv03,liv04',g_showmsg,'ins liv',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                  END IF
               END IF
               IF p_type = '3' THEN
                  LET l_ljp.ljp01 = gs_lji.lji01  #合同编号
                  LET l_ljp.ljp02 = gs_lji.lji05  #合同版本号
                  SELECT MAX(ljp03)+1 INTO l_ljp.ljp03 FROM ljp_file
                   WHERE ljp01 = gs_lji.lji01
                  IF cl_null(l_ljp.ljp03) THEN
                     LET l_ljp.ljp03 = 1          #项次
                  END IF
                  LET l_ljp.ljp04 = gs_lji.lji28  #分摊日期
                  LET l_ljp.ljp05 = p_lij02       #费用编号
                  LET l_ljp.ljp06 = l_day_amt     #费用金额
                  LET l_ljp.ljp07 = l_lim.lim01   #参考单号
                  LET l_ljp.ljp071= gs_tmp.version#参考单号版本号
                  LET l_ljp.ljp08 = '1'           #数据类型  1-标准 2-优惠,3终止,4.抹零
                  LET l_ljp.ljp09 = '0'           #优惠类型  0.无,1.租金优惠，2.面积优惠，3.租期优惠，4.单价优惠
                  LET l_ljp.ljpplant = gs_lji.ljiplant   #门店编号
                  LET l_ljp.ljplegal = gs_lji.ljilegal   #法人
                  IF p_type = '3' THEN
                     SELECT SUM(ljp06) INTO l_ljp06 FROM ljp_file
                      WHERE ljp01 = gs_lji.lji01
                    #   AND ljp04 = l_date
                        AND ljp05 = p_lij02
                        AND ljp07 = l_lim.lim01
                        AND ljp08 = '1'
                        AND ljpplant = gs_lji.ljiplant
                     IF cl_null(l_ljp06) THEN LET l_ljp06 = 0 END IF
                     LET l_ljp.ljp06 = l_ljp.ljp06 - l_ljp06
                  END IF
                  INSERT INTO ljp_file VALUES l_ljp.*
                  IF SQLCA.sqlcode THEN
                     LET g_showmsg = gs_lji.lji01,'/',l_ljp.ljp03,'/',gs_lji.lji28,' '
                     CALL s_errmsg('ljp01,ljp03,ljp04',g_showmsg,'ins ljp',SQLCA.sqlcode,1)
                     LET g_success = 'N'
                  END IF
               END IF
               LET g_flg = 'Y'
               EXIT FOREACH
            END IF
         END IF
      END IF
###############################################################################################
      
      LET l_date = l_lim.lim03
      LET l_year_first_date = MDY(1,1,YEAR(l_date))
      LET l_year_last_date = MDY(12,31,YEAR(l_date))
      CALL s_mothck(l_date) RETURNING l_month_first_date,l_month_last_date
     #LET l_date=cl_cal(l_date,p_mm,p_dd)
     #LET l_month_days = cl_days(YEAR(l_date),MONTH(l_date))
      LET l_year_days = i400sub_get_year_days(l_date)
      LET l_month_days = s_months(l_date)
      LET l_all_days = gs_lnt.lnt18-gs_lnt.lnt17+1
      WHILE TRUE              #产生日核算liv_file
         CASE p_lij04         #日核算算法
            WHEN '1'          #按年 先计算一年的费用l_year_amt，日核算金额l_day_amt=年费用/这一年的天数
               CASE l_lil10   #日期类型
                  WHEN '1'    #年
                     LET l_year_amt = l_amt
                     LET l_day_amt = l_year_amt/l_year_days
                  WHEN '2'    #季
                     LET l_year_amt = l_amt*4
                     LET l_day_amt = l_year_amt/l_year_days
                  WHEN '3'    #月
                     LET l_year_amt = l_amt*12
                     LET l_day_amt = l_year_amt/l_year_days
                  WHEN '4'    #日
                     #日期类型是日，l_day_amt=l_amt，不用计算这一年的天数
                     #LET l_year_amt = l_amt*这一年的天数
                     LET l_day_amt = l_amt
                  WHEN '5'    #合同期
                     LET l_day_amt = l_amt/l_all_days
               END CASE
               LET l_day_amt = cl_digcut(l_day_amt,gs_lla.lla04)
               #计算差异 lil10=4,不处理差异
               #根据参数设置lla01差异放在月首还是月尾，把差异直接加总到这一天
               IF l_lil10 MATCHES '[123]' THEN
                  IF ((l_date = l_lim.lim03 OR l_date=l_year_first_date) AND gs_lla.lla01='1') OR
                     ((l_date = l_lim.lim04 OR l_date=l_year_last_date) AND gs_lla.lla01='2') THEN
                     #把差异均摊到每一天,抓取分摊比例l_rate
                     LET l_rate = 1
                     IF YEAR(l_date)=YEAR(l_lim.lim03) AND YEAR(l_date)=YEAR(l_lim.lim04) THEN
                        LET l_rate = (l_lim.lim04-l_lim.lim03+1)/l_year_days
                     ELSE
                        IF YEAR(l_date)<>YEAR(l_lim.lim03) AND YEAR(l_date)<>YEAR(l_lim.lim04) THEN
                           LET l_rate = 1
                        ELSE
                           IF YEAR(l_date)=YEAR(l_lim.lim03) AND YEAR(l_date)<>YEAR(l_lim.lim04) THEN
                              LET l_rate = (MDY('12','31',YEAR(l_lim.lim03))-l_lim.lim03+1)/l_year_days
                           ELSE
                              IF YEAR(l_date)<>YEAR(l_lim.lim03) AND YEAR(l_date)=YEAR(l_lim.lim04) THEN
                                 LET l_rate = (l_lim.lim04-MDY('1','1',YEAR(l_lim.lim04))+1)/l_year_days
                              END IF
                           END IF
                        END IF
                     END IF
                     LET l_diff_amt = (l_year_amt - l_day_amt*l_year_days)*l_rate
                     LET l_day_amt = l_day_amt + l_diff_amt
                  END IF
               END IF
               IF l_lil10 MATCHES '[5]' THEN
                  IF (l_date = l_lim.lim03 AND gs_lla.lla01='1') OR 
                     (l_date = l_lim.lim04 AND gs_lla.lla01='2') THEN
                     LET l_diff_amt = (l_amt - l_day_amt * l_all_days)*(l_lim.lim04-l_lim.lim03+1)/l_all_days
                     LET l_day_amt = l_day_amt + l_diff_amt
                  END IF
               END IF
               LET l_day_amt = cl_digcut(l_day_amt,gs_lla.lla04)
            WHEN '2'          #按月 先计算一个月的费用l_month_amt，日核算金额l_day_amt=月费用/这一年的天数
               CASE l_lil10   #日期类型
                  WHEN '1'    #年
                     LET l_month_amt = l_amt/12
                     LET l_day_amt = l_month_amt/l_month_days
                  WHEN '2'    #季
                     LET l_month_amt = l_amt/3
                     LET l_day_amt = l_month_amt/l_month_days
                  WHEN '3'    #月
                     LET l_month_amt = l_amt
                     LET l_day_amt = l_month_amt/l_month_days
                  WHEN '4'    #日
                     #LET l_month_amt = l_amt*(本月天数)
                     LET l_day_amt = l_amt
                  WHEN '5'    #合同期
                     LET l_day_amt = l_amt/l_all_days
               END CASE
               LET l_day_amt = cl_digcut(l_day_amt,gs_lla.lla04)
               #计算差异
               #根据参数设置lla01差异放在月首还是月尾，把差异直接加总到这一天
               IF l_lil10 MATCHES '[123]' THEN
                  IF ((l_date = l_lim.lim03 OR l_date=l_month_first_date) AND gs_lla.lla01='1') OR
                     ((l_date = l_lim.lim04 OR l_date=l_month_last_date) AND gs_lla.lla01='2') THEN
                     #把差异均摊到每一天,抓取分摊比例l_rate
                     LET l_rate = 1
                     IF YEAR(l_date)=YEAR(l_lim.lim03) AND YEAR(l_date)=YEAR(l_lim.lim04) AND
                        MONTH(l_date)=MONTH(l_lim.lim03) AND MONTH(l_date)=MONTH(l_lim.lim04) THEN
                        LET l_rate = (l_lim.lim04-l_lim.lim03+1)/l_month_days
                     ELSE
                        IF (YEAR(l_date)<>YEAR(l_lim.lim03) AND MONTH(l_date)<>MONTH(l_lim.lim03)) AND
                           (YEAR(l_date)<>YEAR(l_lim.lim04) AND MONTH(l_date)<>MONTH(l_lim.lim04)) THEN
                           LET l_rate = 1
                        ELSE
                           IF YEAR(l_date)=YEAR(l_lim.lim03) AND MONTH(l_date)=MONTH(l_lim.lim03) THEN
                              LET l_rate = (MDY(MONTH(l_lim.lim03),l_month_days,YEAR(l_lim.lim03))-l_lim.lim03+1)/l_month_days
                           ELSE
                              IF YEAR(l_date)=YEAR(l_lim.lim04) AND MONTH(l_date)=MONTH(l_lim.lim04) THEN
                                 LET l_rate = (l_lim.lim04-MDY(MONTH(l_lim.lim04),'1',YEAR(l_lim.lim04))+1)/l_month_days
                              END IF
                           END IF
                        END IF
                     END IF
                     LET l_diff_amt = (l_month_amt - l_day_amt*l_month_days)*l_rate
                     LET l_day_amt = l_day_amt + l_diff_amt
                  END IF
               END IF
               IF l_lil10 MATCHES '[5]' THEN
                  IF (l_date = l_lim.lim03 AND gs_lla.lla01='1') OR 
                     (l_date = l_lim.lim04 AND gs_lla.lla01='2') THEN
                     LET l_diff_amt = (l_amt - l_day_amt * l_all_days)*(l_lim.lim04-l_lim.lim03+1)/l_all_days
                     LET l_day_amt = l_day_amt + l_diff_amt
                  END IF
               END IF
               LET l_day_amt = cl_digcut(l_day_amt,gs_lla.lla04)
         END CASE
         #产生日核算 INSERT INTO liv_file
         IF p_type = '1' THEN
            LET l_liv.liv01 = gs_lnt.lnt01  #合同编号
            LET l_liv.liv02 = gs_lnt.lnt02  #合同版本号
            SELECT MAX(liv03)+1 INTO l_liv.liv03 FROM liv_file
             WHERE liv01 = gs_lnt.lnt01
            IF cl_null(l_liv.liv03) THEN
               LET l_liv.liv03 = 1          #项次
            END IF
            LET l_liv.liv04 = l_date        #分摊日期
            LET l_liv.liv05 = p_lij02       #费用编号
            LET l_liv.liv06 = l_day_amt     #费用金额
            LET l_liv.liv07 = l_lim.lim01   #参考单号
            LET l_liv.liv071= gs_tmp.version#参考单号版本号
            LET l_liv.liv08 = '1'           #数据类型  1-标准 2-优惠,3终止,4.抹零
            LET l_liv.liv09 = '0'           #优惠类型  0.无,1.租金优惠，2.面积优惠，3.租期优惠，4.单价优惠
            LET l_liv.livplant = gs_lnt.lntplant   #门店编号
            LET l_liv.livlegal = gs_lnt.lntlegal   #法人
            INSERT INTO liv_file VALUES l_liv.*
            IF SQLCA.sqlcode THEN
               LET g_showmsg = gs_lnt.lnt01,'/',l_liv.liv03,'/',l_date,' '
               CALL s_errmsg('liv01,liv03,liv04',g_showmsg,'ins liv',SQLCA.sqlcode,1)
               LET g_success = 'N'
            END IF
         ELSE
            LET l_ljp.ljp01 = gs_lji.lji01  #合同编号
            LET l_ljp.ljp02 = gs_lji.lji05  #合同版本号
            SELECT MAX(ljp03)+1 INTO l_ljp.ljp03 FROM ljp_file
             WHERE ljp01 = gs_lji.lji01
            IF cl_null(l_ljp.ljp03) THEN
               LET l_ljp.ljp03 = 1          #项次
            END IF
            LET l_ljp.ljp04 = l_date        #分摊日期
            LET l_ljp.ljp05 = p_lij02       #费用编号
            LET l_ljp.ljp06 = l_day_amt     #费用金额
            LET l_ljp.ljp07 = l_lim.lim01   #参考单号
            LET l_ljp.ljp071= gs_tmp.version#参考单号版本号
            LET l_ljp.ljp08 = '1'           #数据类型  1-标准 2-优惠,3终止,4.抹零
            LET l_ljp.ljp09 = '0'           #优惠类型  0.无,1.租金优惠，2.面积优惠，3.租期优惠，4.单价优惠
            LET l_ljp.ljpplant = gs_lji.ljiplant   #门店编号
            LET l_ljp.ljplegal = gs_lji.ljilegal   #法人
            IF p_type = '3' THEN
               SELECT SUM(ljp06) INTO l_ljp06 FROM ljp_file
                WHERE ljp01 = gs_lji.lji01
                  AND ljp04 = l_date
                  AND ljp05 = p_lij02
                  AND ljp07 = l_lim.lim01
                  AND ljp08 = '1'
                  AND ljpplant = gs_lji.ljiplant
               IF cl_null(l_ljp06) THEN LET l_ljp06 = 0 END IF
               LET l_ljp.ljp06 = l_ljp.ljp06 - l_ljp06
            END IF
           #IF l_ljp.ljp06 <> 0 THEN                  #FUN-C20078
            IF l_ljp.ljp06 <> 0 OR l_lil11 = '5' THEN #FUN-C20078
               INSERT INTO ljp_file VALUES l_ljp.*
               IF SQLCA.sqlcode THEN
                  LET g_showmsg = gs_lji.lji01,'/',l_date,' '
                  CALL s_errmsg('ljp01,ljp04',g_showmsg,'ins lip',SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
            END IF
         END IF
         IF l_date = l_lim.lim04 THEN
            EXIT WHILE
         END IF
         LET l_date = l_date + 1
         IF MONTH(l_date) <> MONTH(l_date-1) THEN
            CALL s_mothck(l_date) RETURNING l_month_first_date,l_month_last_date
            LET l_month_days = s_months(l_date)
            IF YEAR(l_date) <> YEAR(l_date-1) THEN
               LET l_year_days = i400sub_get_year_days(l_date) 
               LET l_year_first_date = MDY(1,1,YEAR(l_date))
               LET l_year_last_date = MDY(12,31,YEAR(l_date))
            END IF
         END IF
      END WHILE
      #日核算差异计算，有问题：lla01差异放在月首还是月尾？差异，怎么算？
      #例如日核算按年，sum一年日核算 与 一年总金额之间的差异放在首尾？如果单身日期不足一年
      #现在放在这一时间的第一天或者最后一天

   END FOREACH
   IF l_date_t-1 <> gs_tmp.edate AND p_type <> '3' THEN
      #提示：费用编号p_lij02在l_date_t ~ gs_tmp.edate时间段内无费用标准方案设置！
      LET g_showmsg = p_lij02,'/',l_lim.lim01,'IN(',l_date_t,'~',gs_tmp.edate,')'
      CALL s_errmsg('lij02,lim01',g_showmsg,'','alm1169',2)
   END IF
  ##如果收付实现制，则产生到合同第一天
  #IF p_type = '1' THEN
  #   SELECT liu08 INTO l_liu08 FROM liu_file
  #    WHERE liu01 = gs_lnt.lnt01
  #      AND liu04 = p_lij02
  #   IF l_liu08 = '1' THEN
  #      SELECT SUM(liv06) INTO l_liv.liv06 FROM liv_file
  #       WHERE liv01 = gs_lnt.lnt01
  #         AND liv02 = gs_lnt.lnt02
  #         AND liv05 = p_lij02
  #         AND liv08 = '1'
  #         AND livplant = gs_lnt.lntplant
  #      IF l_liv.liv06 <> 0 THEN
  #         DELETE FROM liv_file WHERE liv01 = gs_lnt.lnt01
  #                                AND liv02 = gs_lnt.lnt02
  #                                AND liv05 = p_lij02
  #                                AND liv08 = '1'
  #                                AND livplant = gs_lnt.lntplant
  #         IF SQLCA.sqlcode THEN
  #            LET g_showmsg = gs_lnt.lnt01,'/',p_lij02,' '
  #            CALL s_errmsg('liv01,liv05',g_showmsg,'del liv',SQLCA.sqlcode,1)
  #            LET g_success = 'N'
  #         END IF
  #         LET l_liv.liv04 = gs_lnt.lnt21       #分摊日期
  #         INSERT INTO liv_file VALUES l_liv.*
  #         IF SQLCA.sqlcode THEN
  #            LET g_showmsg = gs_lnt.lnt01,'/',l_liv.liv03,'/',l_date,' '
  #            CALL s_errmsg('liv01,liv03,liv04',g_showmsg,'ins liv',SQLCA.sqlcode,1)
  #            LET g_success = 'N'
  #         END IF
  #      END IF
  #   END IF
  #ELSE
  #   SELECT ljm08 INTO l_liu08 FROM ljm_file
  #    WHERE ljm01 = gs_lnt.lnt01
  #      AND ljm04 = p_lij02
  #   IF l_liu08 = '1' THEN
  #      SELECT SUM(ljp06) INTO l_ljp06 FROM ljp_file
  #       WHERE ljp01 = gs_lji.lji01
  #         AND ljp02 = gs_lji.lji02
  #         AND ljp05 = p_lij02
  #         AND ljp07 = l_lim.lim01
  #         AND ljp08 = '1'
  #         AND ljpplant = gs_lji.ljiplant
  #      IF l_ljp.ljp06 <> 0 THEN
  #         DELETE FROM ljp_file WHERE ljp01 = gs_lji.lji01
  #                                AND ljp02 = gs_lji.lji02
  #                                AND ljp05 = p_lij02
  #                                AND ljp07 = l_lim.lim01
  #                                AND ljp08 = '1'
  #                                AND ljpplant = gs_lji.ljiplant
  #         IF SQLCA.sqlcode THEN
  #            LET g_showmsg = gs_lji.lji01,'/',p_lij02,' '
  #            CALL s_errmsg('ljp01,ljp05',g_showmsg,'del lip',SQLCA.sqlcode,1)
  #            LET g_success = 'N'
  #         END IF

  #         LET ljp.ljp04 = gs_tmp.bdate
  #         INSERT INTO ljp_file VALUES l_ljp.*
  #         IF SQLCA.sqlcode THEN
  #            LET g_showmsg = gs_lji.lji01,'/',l_date,' '
  #            CALL s_errmsg('ljp01,ljp04',g_showmsg,'ins lip',SQLCA.sqlcode,1)
  #            LET g_success = 'N'
  #         END IF
  #      END IF
  #   END IF
  #END IF
END FUNCTION

FUNCTION i400sub_get_year_days(p_date)
 DEFINE p_date    LIKE type_file.dat
 DEFINE l_year    LIKE type_file.num5
 DEFINE l_days    LIKE type_file.num5
 
   LET l_days = 365
   LET l_year = YEAR(p_date)
   IF l_year mod 100 = 0 THEN
      IF l_year mod 400 = 0 THEN
         LET l_days = 366
      END IF
   ELSE
      IF l_year mod 4 = 0 THEN
         LET l_days = 366
      END IF
   END IF
   RETURN l_days
END FUNCTION

FUNCTION i400sub_inslnv(p_type,p_lij02)
 DEFINE p_type          LIKE type_file.chr1
 DEFINE p_lij02         LIKE lij_file.lij02
 DEFINE l_lnv           RECORD LIKE lnv_file.*
 DEFINE l_ljj           RECORD LIKE ljj_file.*

   IF p_type = '1' THEN
      LET l_lnv.lnv01 = gs_lnt.lnt01    #合同编号
      LET l_lnv.lnv02 = gs_lnt.lnt02    #合同版本号
                                        #项次
      SELECT MAX(lnv03)+1 INTO l_lnv.lnv03 FROM lnv_file
       WHERE lnv01 = gs_lnt.lnt01
      IF cl_null(l_lnv.lnv03) THEN
         LET l_lnv.lnv03 = 1
      END IF
      LET l_lnv.lnv04 = p_lij02         #费用编号
                                        #费用标准
      SELECT SUM(liv06) INTO l_lnv.lnv07 FROM liv_file
       WHERE liv01 = gs_lnt.lnt01
         AND liv02 = gs_lnt.lnt02
         AND liv04 BETWEEN gs_tmp.bdate AND gs_tmp.edate
         AND liv05 = p_lij02
         AND liv07 = gs_tmp.no
         AND liv071= gs_tmp.version
         AND liv08 = '1'
      LET l_lnv.lnv18 = gs_tmp.no       #费用方案
      LET l_lnv.lnv181= gs_tmp.version  #方案版本号
      LET l_lnv.lnv16 = gs_tmp.bdate    #开始日期
      LET l_lnv.lnv17 = gs_tmp.edate    #结束日期
      LET l_lnv.lnvplant = gs_lnt.lntplant
      LET l_lnv.lnvlegal = gs_lnt.lntlegal
      INSERT INTO lnv_file VALUES l_lnv.*
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_lnv.lnv01,'/',l_lnv.lnv04,'/',l_lnv.lnv18
         CALL s_errmsg('lnv01,lnv04,lnv18',g_showmsg,'ins lnv',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   IF p_type = '2' OR p_type = '3' THEN
      LET l_ljj.ljj01 = gs_lji.lji01    #合同编号
      LET l_ljj.ljj02 = gs_lji.lji05    #合同版本号
                                        #项次
      SELECT MAX(ljj03)+1 INTO l_ljj.ljj03 FROM ljj_file
       WHERE ljj01 = gs_lji.lji01
      IF cl_null(l_ljj.ljj03) THEN
         LET l_ljj.ljj03 = 1
      END IF
      LET l_ljj.ljj04 = p_lij02         #费用编号
                                        #费用标准
      SELECT SUM(ljp06) INTO l_ljj.ljj08 FROM ljp_file
       WHERE ljp01 = gs_lji.lji01
         AND ljp02 = gs_lji.lji05
         AND ljp04 BETWEEN gs_tmp.bdate AND gs_tmp.edate
         AND ljp05 = p_lij02
         AND ljp07 = gs_tmp.no
         AND ljp071= gs_tmp.version
         AND ljp08 = '1'
      LET l_ljj.ljj05 = gs_tmp.no       #费用方案
      LET l_ljj.ljj051= gs_tmp.version  #方案版本号
      LET l_ljj.ljj06 = gs_tmp.bdate    #开始日期
      LET l_ljj.ljj07 = gs_tmp.edate    #结束日期
      LET l_ljj.ljjplant = gs_lji.ljiplant
      LET l_ljj.ljjlegal = gs_lji.ljilegal
      INSERT INTO ljj_file VALUES l_ljj.*
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_ljj.ljj01,'/',l_ljj.ljj04,'/',l_ljj.ljj05
         CALL s_errmsg('ljj01,ljj04,ljj05',g_showmsg,'ins ljj',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
 
END FUNCTION

#判断延用时，如果上一个方案是摊位个别计价且不延用，判断有没有标准费用方案可延用的
FUNCTION i400sub_use_last(p_type,p_lij02,p_bdate,p_edate)
 DEFINE p_type          LIKE type_file.chr1
 DEFINE p_lij02         LIKE lij_file.lij02
 DEFINE p_bdate         LIKE type_file.dat
 DEFINE p_edate         LIKE type_file.dat
 DEFINE l_lil01         LIKE lil_file.lil01
 DEFINE l_lil02         LIKE lil_file.lil02
 DEFINE l_lil14         LIKE lil_file.lil14
 DEFINE l_lnl03         LIKE lnl_file.lnl03
 DEFINE l_lnl04         LIKE lnl_file.lnl04
 DEFINE l_lnl05         LIKE lnl_file.lnl05
 DEFINE l_lnl09         LIKE lnl_file.lnl09

   #先抓取almi350中的设置
   SELECT lnl03,lnl04,lnl05,lnl09 INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
     FROM lnl_file
    WHERE lnl01 = p_lij02
      AND lnlstore = gs_lnt.lntplant
   #如果上一个方案是摊位个别计价且不延用，看有没有结束日期=摊位个别计价结束日期的费用标准方案
   #如果有看是否延用，是则延用费用标准方案INSERT 到临时表 flg2='Y'
   LET gs_sql = "SELECT lil01,lil02,lil14 FROM lil_file ",
                " WHERE lil04 = '",p_lij02,"'",           #费用编号
                "   AND lilplant = '",gs_lnt.lntplant,"'", #门店编号
                "   AND lil09 = '",gs_lnt.lnt55,"'",       #摊位用途
                "   AND lil13 = '",p_bdate-1,"'",     #结束日期
                "   AND lilconf = 'Y' "
   IF l_lnl03 = 'Y' THEN #按照楼栋设置费用标准
      LET gs_sql = gs_sql CLIPPED,"   AND lil05 = '",gs_lnt.lnt08,"'"
   ELSE
      LET gs_sql = gs_sql CLIPPED,"   AND lil05 IS NULL "
   END IF
   IF l_lnl04 = 'Y' THEN #按照楼层设置费用标准
      LET gs_sql = gs_sql CLIPPED,"   AND lil06 = '",gs_lnt.lnt09,"'"
   ELSE
      LET gs_sql = gs_sql CLIPPED,"   AND lil06 IS NULL "
   END IF
   IF l_lnl05 = 'Y' THEN #按照区域设置费用标准
      LET gs_sql = gs_sql CLIPPED,"   AND lil07 = '",gs_lnt.lnt60,"'"
   ELSE
      LET gs_sql = gs_sql CLIPPED,"   AND lil07 IS NULL "
   END IF
   IF l_lnl09 = 'Y' THEN #按照小类设置费用标准
      LET gs_sql = gs_sql CLIPPED,"   AND lil08 = '",gs_lnt.lnt33,"'"
   ELSE
      LET gs_sql = gs_sql CLIPPED,"   AND lil08 IS NULL "
   END IF
   LET gs_sql = gs_sql CLIPPED," ORDER BY lil12"
   PREPARE i400sub_cs5 FROM gs_sql
   EXECUTE i400sub_cs5 INTO l_lil01,l_lil02,l_lil14
   IF l_lil14 = 'Y' THEN
      INSERT INTO i400_tmp VALUES ('1',l_lil01,l_lil02,
                                  p_bdate,p_edate,
                                  l_lil14,'Y')
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','ins i400_tmp',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
       LET g_success1 = 'N'
   ELSE
      #报错，费用编号p_lij02在p_bdate ~ p_edate时间段内无费用标准方案设置！
      LET g_showmsg = p_lij02,' IN(',p_bdate,'~',p_edate,')'
      CALL s_errmsg('lij02',g_showmsg,'','alm1145',1)
      LET g_success = 'N'
   END IF

END FUNCTION

#合同或者延期日期区间没有抓到almi365和almi360的方案，看上期是否可以延用
FUNCTION i400sub_use_last1(p_type,p_lij02,p_bdate,p_edate)
 DEFINE p_type          LIKE type_file.chr1
 DEFINE p_lij02         LIKE lij_file.lij02
 DEFINE p_bdate         LIKE type_file.dat
 DEFINE p_edate         LIKE type_file.dat
 DEFINE l_lil01         LIKE lil_file.lil01
 DEFINE l_lil02         LIKE lil_file.lil02
 DEFINE l_lil13         LIKE lil_file.lil13
 DEFINE l_lil14         LIKE lil_file.lil14
 DEFINE l_lip01         LIKE lip_file.lip01
 DEFINE l_lip02         LIKE lip_file.lip02
 DEFINE l_lip15         LIKE lip_file.lip15
 DEFINE l_lip16         LIKE lip_file.lip16
 DEFINE l_tmp           RECORD
         type           LIKE type_file.chr1,     #类型 1.almi360,2.almi365
         no             LIKE lil_file.lil01,     #方案编号
         version        LIKE lil_file.lil02,     #方案版本号
         bdate          LIKE type_file.dat,      #开始时间
         edate          LIKE type_file.dat,      #结束时间
         flg1           LIKE type_file.chr1,     #方案是否延用
         flg2           LIKE type_file.chr1      #是否为延用的方案
                        END RECORD
 DEFINE l_success       LIKE type_file.chr1
 DEFINE l_lnl03         LIKE lnl_file.lnl03
 DEFINE l_lnl04         LIKE lnl_file.lnl04
 DEFINE l_lnl05         LIKE lnl_file.lnl05
 DEFINE l_lnl09         LIKE lnl_file.lnl09
 DEFINE l_ljp07         LIKE ljp_file.ljp07

   #先抓取almi350中的设置
   SELECT lnl03,lnl04,lnl05,lnl09 INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
     FROM lnl_file
    WHERE lnl01 = p_lij02
      AND lnlstore = gs_lnt.lntplant
 

   #如果合同期内，或者延期的日期内，如果没有设置方案，抓取方案的规则如下：
   #1.合同，抓取almi360和almi365中距离合同计租起日，最近的方案(方案的开始日期最接近合同计租起日)
   #  如果只抓到一笔方案，则判断标准可延用是否打钩，如果打钩则可延用，写入临时表
   #  如果这倒2笔，先判断almi365中的标准可延用是否打钩，是则延用almi365的方案，否则看almi360是否可延用
   #  如果抓到的方案都不可以延用，则报错，合同计租期内抓不到对应的方案
   #2.变更单延期，抓取原合同中日期=合同计租止日的那笔方案，判断是否可延用，是则延用
   #  否则判断是否是almi365方案，然后再判读有没有方案结束日期=合同计租止日的almi360对应的方案，判断是否可延用
   #  如果都不可延用，则报错，延期区间内抓不到对应的方案
   #20120223 BY shi:2点延期时规格调整：按照1的方式处理

   LET l_success = 'Y'
  #IF p_type = '1' THEN                 #TQC-C20395
   IF p_type = '1' OR p_type = '2' THEN #TQC-C20395
      #先抓almi365中的方案
      LET gs_sql = "SELECT lip01,lip02,lip16,MAX(lip15) FROM lip_file,liq_file",
                   " WHERE lip01 = liq01 ",
                   "   AND lip06 = '",p_lij02,"'",            #费用编号
                   "   AND lipplant = '",gs_lnt.lntplant,"'", #门店编号
                   "   AND lip11 = '",gs_lnt.lnt55,"'",       #摊位用途
                   "   AND liq03 = '",gs_lnt.lnt06,"'",       #摊位编号
                   "   AND lip15 < '",p_bdate,"'",            #方案结束时间
                   "   AND lipconf = 'Y' ",
                   " GROUP BY lip01,lip02,lip16"
      PREPARE i400sub_pre6 FROM gs_sql
      EXECUTE i400sub_pre6 INTO l_lip01,l_lip02,l_lip16,l_lip15

      LET gs_sql = "SELECT lil01,lil02,lil14,MAX(lil13) FROM lil_file ",
                   " WHERE lil04 = '",p_lij02,"'",           #费用编号
                   "   AND lilplant = '",gs_lnt.lntplant,"'", #门店编号
                   "   AND lil09 = '",gs_lnt.lnt55,"'",       #摊位用途
                   "   AND lil13 < '",p_bdate,"'",            #结束日期
                   "   AND lilconf = 'Y' "
      IF l_lnl03 = 'Y' THEN #按照楼栋设置费用标准
         LET gs_sql = gs_sql CLIPPED,"   AND lil05 = '",gs_lnt.lnt08,"'"
      ELSE
         LET gs_sql = gs_sql CLIPPED,"   AND lil05 IS NULL "
      END IF
      IF l_lnl04 = 'Y' THEN #按照楼层设置费用标准
         LET gs_sql = gs_sql CLIPPED,"   AND lil06 = '",gs_lnt.lnt09,"'"
      ELSE
         LET gs_sql = gs_sql CLIPPED,"   AND lil06 IS NULL "
      END IF
      IF l_lnl05 = 'Y' THEN #按照区域设置费用标准
         LET gs_sql = gs_sql CLIPPED,"   AND lil07 = '",gs_lnt.lnt60,"'"
      ELSE
         LET gs_sql = gs_sql CLIPPED,"   AND lil07 IS NULL "
      END IF
      IF l_lnl09 = 'Y' THEN #按照小类设置费用标准
         LET gs_sql = gs_sql CLIPPED,"   AND lil08 = '",gs_lnt.lnt33,"'"
      ELSE
         LET gs_sql = gs_sql CLIPPED,"   AND lil08 IS NULL "
      END IF
      LET gs_sql = gs_sql CLIPPED," GROUP BY lil01,lil02,lil14"
      PREPARE i400sub_pre61 FROM gs_sql
      EXECUTE i400sub_pre61 INTO l_lil01,l_lil02,l_lil14,l_lil13

      IF l_lip15 > l_lil13 THEN
         IF l_lip16 = 'Y' THEN
            #新增到临时表
            LET l_tmp.type = '2'
            LET l_tmp.no   = l_lip01
            LET l_tmp.version = l_lip02
            LET l_tmp.bdate = p_bdate
            LET l_tmp.edate = p_edate
            LET l_tmp.flg1 = 'Y'
            LET l_tmp.flg2 = 'Y'
         ELSE
            #报错抓不到方案
            LET l_success = 'N'
         END IF
      END IF
      
      IF l_lip15 < l_lil13 THEN
         IF l_lil14 = 'Y' THEN
            #新增到临时表
            LET l_tmp.type = '1'
            LET l_tmp.no   = l_lil01
            LET l_tmp.version = l_lil02
            LET l_tmp.bdate = p_bdate
            LET l_tmp.edate = p_edate
            LET l_tmp.flg1 = 'Y'
            LET l_tmp.flg2 = 'Y'
         ELSE
            #报错抓不到方案
            LET l_success = 'N'
         END IF
      END IF

      IF l_lip15 = l_lil13 THEN
         IF l_lip16 = 'Y' THEN
            #新增到临时表
            LET l_tmp.type = '2'
            LET l_tmp.no   = l_lip01
            LET l_tmp.version = l_lip02
            LET l_tmp.bdate = p_bdate
            LET l_tmp.edate = p_edate
            LET l_tmp.flg1 = 'Y'
            LET l_tmp.flg2 = 'Y'
         ELSE
            IF l_lil14 = 'Y' THEN
               #新增到临时表
               LET l_tmp.type = '1'
               LET l_tmp.no   = l_lil01
               LET l_tmp.version = l_lil02
               LET l_tmp.bdate = p_bdate
               LET l_tmp.edate = p_edate
               LET l_tmp.flg1 = 'Y'
               LET l_tmp.flg2 = 'Y'
            ELSE
               #报错抓不到方案
               LET l_success = 'N'
            END IF
         END IF
      END IF
   END IF

  #TQC-C20395 Begin---
  #IF p_type = '2' THEN
  #   SELECT DISTINCT ljp07 INTO l_ljp07 FROM ljp_file
  #    WHERE ljj01 = gs_lji.lji01
  #      AND ljp08 = '1'
  #      AND ljp04 = p_bdate-1
  #   #看这个方案是属于almi360还是almi365的
  #   SELECT COUNT(*) INTO g_cnt FROM lil_file
  #    WHERE lil01 = l_ljp07
  #   IF g_cnt = 1 THEN
  #      SELECT lil02,lil14 INTO l_lil02,l_lil14 FROM lil_file
  #       WHERE lil01 = l_ljp07
  #      IF l_lil14 = 'Y' THEN
  #         #可以延用,新增到临时表
  #         LET l_tmp.type = '1'
  #         LET l_tmp.no   = l_lil01
  #         LET l_tmp.version = l_lil02
  #         LET l_tmp.bdate = p_bdate
  #         LET l_tmp.edate = p_edate
  #         LET l_tmp.flg1 = 'Y'
  #         LET l_tmp.flg2 = 'Y'
  #      ELSE
  #         #报错
  #         LET l_success = 'N'
  #      END IF
  #   ELSE
  #      SELECT lip02,lip16 INTO l_lip02,l_lip16 FROM lip_file
  #       WHERE lip01 = l_ljp07
  #      IF l_lip16 = 'Y' THEN
  #         #可以延用,新增到临时表
  #         LET l_tmp.type = '2'
  #         LET l_tmp.no   = l_lip01
  #         LET l_tmp.version = l_lip02
  #         LET l_tmp.bdate = p_bdate
  #         LET l_tmp.edate = p_edate
  #         LET l_tmp.flg1 = 'Y'
  #         LET l_tmp.flg2 = 'Y'
  #      ELSE
  #         #看有没有almi360的费用
  #         LET gs_sql = "SELECT lil01,lil02,lil14 FROM lil_file ",
  #                      " WHERE lil04 = '",p_lij02,"'",            #费用编号
  #                      "   AND lilplant = '",gs_lnt.lntplant,"'", #门店编号
  #                      "   AND lil09 = '",gs_lnt.lnt55,"'",       #摊位用途
  #                      "   AND lil13 = '",p_bdate-1,"'",            #结束日期
  #                      "   AND lilconf = 'Y' "
  #         IF l_lnl03 = 'Y' THEN #按照楼栋设置费用标准
  #            LET gs_sql = gs_sql CLIPPED,"   AND lil05 = '",gs_lnt.lnt08,"'"
  #         ELSE
  #            LET gs_sql = gs_sql CLIPPED,"   AND lil05 IS NULL "
  #         END IF
  #         IF l_lnl04 = 'Y' THEN #按照楼层设置费用标准
  #            LET gs_sql = gs_sql CLIPPED,"   AND lil06 = '",gs_lnt.lnt09,"'"
  #         ELSE
  #            LET gs_sql = gs_sql CLIPPED,"   AND lil06 IS NULL "
  #         END IF
  #         IF l_lnl05 = 'Y' THEN #按照区域设置费用标准
  #            LET gs_sql = gs_sql CLIPPED,"   AND lil07 = '",gs_lnt.lnt60,"'"
  #         ELSE
  #            LET gs_sql = gs_sql CLIPPED,"   AND lil07 IS NULL "
  #         END IF
  #         IF l_lnl09 = 'Y' THEN #按照小类设置费用标准
  #            LET gs_sql = gs_sql CLIPPED,"   AND lil08 = '",gs_lnt.lnt33,"'"
  #         ELSE
  #            LET gs_sql = gs_sql CLIPPED,"   AND lil08 IS NULL "
  #         END IF
  #         PREPARE i400sub_pre62 FROM gs_sql
  #         EXECUTE i400sub_pre62 INTO l_lil01,l_lil02,l_lil14
  #         IF l_lil14 = 'Y' THEN
  #            #新增到临时表
  #            LET l_tmp.type = '1'
  #            LET l_tmp.no   = l_lil01
  #            LET l_tmp.version = l_lil02
  #            LET l_tmp.bdate = p_bdate
  #            LET l_tmp.edate = p_edate
  #            LET l_tmp.flg1 = 'Y'
  #            LET l_tmp.flg2 = 'Y'
  #         ELSE
  #            LET l_success = 'N'
  #         END IF
  #      END IF
  #   END IF
  #END IF
  #TQC-C20395 End-----

   IF l_success = 'Y' THEN
      INSERT INTO i400_tmp VALUES(l_tmp.*)
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','ins i400_tmp',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
      LET g_success1 = 'N'
   ELSE
      #报错，费用编号p_lij02在p_bdate ~ p_edate时间段内无费用标准方案设置！
      LET g_showmsg = p_lij02,' IN(',p_bdate,'~',p_edate,')'
      CALL s_errmsg('lij02',g_showmsg,'','alm1145',1)
      LET g_success = 'N'
   END IF
END FUNCTION

FUNCTION i400sub_check()
   #合同已初审或者终审,不可以重新产生标准费用
   IF gs_lnt.lnt26 <> 'N' THEN
      CALL cl_err(gs_lnt.lnt01,'alm1146',0)
      LET g_success = 'N'
      RETURN
   END IF
   #已经产生费用单不可重新产生标准费用
   SELECT COUNT(*) INTO g_cnt FROM liw_file
    WHERE liw01 = gs_lnt.lnt01
      AND liw16 IS NOT NULL
   IF g_cnt > 0 THEN
      CALL cl_err(gs_lnt.lnt01,'alm1147',0)
      LET g_success = 'N'
      RETURN
   END IF

   #单头合同费用项方案必须设置
   IF cl_null(gs_lnt.lnt71) THEN
      CALL cl_err(gs_lnt.lnt01,'alm1148',0)
      LET g_success = 'N'
      RETURN
   END IF

   #合同费用项方案需设置正确,需要存在标准费用，摊位用途须一致
   LET g_cnt = 0
   SELECT COUNT(*) INTO g_cnt FROM lii_file,lij_file
    WHERE lii01 = lij01
      AND lii01 = gs_lnt.lnt71
      AND lii05 = gs_lnt.lnt55
      AND liiplant = gs_lnt.lntplant
      AND lij06 = 'Y'
      AND liiconf <> 'X'  #CHI-C80041
   IF g_cnt = 0 THEN
      CALL cl_err('','alm1149',0)
      LET g_success = 'N'
      RETURN
   END IF
END FUNCTION

FUNCTION i400sub_delliv(p_type,p_bdate,p_edate)
 DEFINE p_type          LIKE type_file.chr1
 DEFINE p_bdate         LIKE type_file.dat
 DEFINE p_edate         LIKE type_file.dat

   IF p_type = '1' THEN
      #删除原来的日核算
      DELETE FROM liv_file
       WHERE liv01 = gs_lnt.lnt01
         AND liv02 = gs_lnt.lnt02
         AND liv08 = '1'
         AND liv05 IN (SELECT lij02 FROM lij_file
                        WHERE lij01 = gs_lnt.lnt71
                          AND lij06 = 'Y')
      IF SQLCA.sqlcode THEN
         CALL cl_err('Del liv_file',SQLCA.sqlcode,0)
         LET g_success = 'N'
         RETURN
      END IF
      
      #删除标准费用单身
      DELETE FROM lnv_file
       WHERE lnv01 = gs_lnt.lnt01
         AND lnv02 = gs_lnt.lnt02
      IF SQLCA.sqlcode THEN
         CALL cl_err('Del lnv_file',SQLCA.sqlcode,0)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
   IF p_type = '2' OR p_type = '3' THEN
      DELETE FROM ljp_file WHERE ljp01 = gs_lji.lji01
                             AND ljp02 = gs_lji.lji05
      IF SQLCA.sqlcode THEN
         CALL cl_err('Del ljp_file',SQLCA.sqlcode,0)
         LET g_success = 'N'
         RETURN
      END IF
      DELETE FROM ljj_file WHERE ljj01 = gs_lji.lji01
                             AND ljj02 = gs_lji.lji05
      IF SQLCA.sqlcode THEN
         CALL cl_err('Del ljj_file',SQLCA.sqlcode,0)
         LET g_success = 'N'
         RETURN
      END IF
   END IF
END FUNCTION

FUNCTION i400sub_create_tmp_table()

   DROP TABLE i400_tmp
   CREATE TEMP TABLE i400_tmp(
      type LIKE type_file.chr1,     #类型 1.almi360,2.almi365
      no LIKE lil_file.lil01,       #方案编号
      version LIKE lil_file.lil02,  #方案版本号
      bdate LIKE type_file.dat,     #开始时间
      edate LIKE type_file.dat,     #结束时间
      flg1 LIKE type_file.chr1,     #方案是否延用
      flg2 LIKE type_file.chr1      #是否为延用的方案
     );
   IF SQLCA.sqlcode THEN
      CALL cl_err('CREATE TEMP TABLE fail',SQLCA.sqlcode,0)
      LET g_success = 'N'
   END IF
    
END FUNCTION

FUNCTION i400sub_area(p_type,p_no,p_bdate,p_edate)
 DEFINE p_type          LIKE type_file.chr1
 DEFINE p_no            LIKE lnt_file.lnt01
 DEFINE p_bdate         LIKE lnt_file.lnt17
 DEFINE p_edate         LIKE lnt_file.lnt18
 DEFINE l_lil00         LIKE lil_file.lil00
 DEFINE l_lil11         LIKE lil_file.lil11
 DEFINE l_lil13         LIKE lil_file.lil13
 DEFINE l_lij04         LIKE lij_file.lij04
 DEFINE l_lij05         LIKE lij_file.lij05
 DEFINE l_ljj           RECORD LIKE ljj_file.*

   INITIALIZE gs_tmp.* TO NULL
   DECLARE i400sub_cs9 CURSOR FOR
    SELECT * FROM ljj_file
     WHERE ljj01 = gs_lji.lji01
       AND ljj07 >= p_bdate
    ORDER BY ljj04,ljj02
   FOREACH i400sub_cs9 INTO l_ljj.*
      IF STATUS THEN
         CALL s_errmsg('','','i400sub_cs9',STATUS,1)
         LET g_success = 'N'
         EXIT FOREACH
      END IF

      #面积变更暂时是根据标准费用单身逐笔去算对应的方案日核算,然后减去这一天的,
      #前几个版本的日核算之和，最后得到新的日核算,
      #如果进行多次面积变更，资料会重复,(同一个日期区间内方案是一样的)
      #所有这边判断：如果这个区间内已经有新版本日核算了，就不要产生了
      LET g_cnt = 0
      SELECT COUNT(*) INTO g_cnt FROM ljp_file
       WHERE ljp01 = gs_lji.lji01
         AND ljp02 = gs_lji.lji05
         AND ljp04 BETWEEN l_ljj.ljj06 AND l_ljj.ljj07
         AND ljp07 = l_ljj.ljj05
      IF g_cnt > 0 THEN
         CONTINUE FOREACH
      END IF

      SELECT lil00,lil11,lil13 INTO l_lil00,l_lil11,l_lil13 FROM lil_file
       WHERE lil01 = l_ljj.ljj05
      IF SQLCA.sqlcode = 100 THEN
         LET gs_tmp.type = '2'
         SELECT lip04,lip13,lip15 INTO l_lil00,l_lil11,l_lil13 FROM lip_file
          WHERE lip01 = l_ljj.ljj05
      ELSE
         LET gs_tmp.type = '1'
      END IF
      #判断方案标准是否按照面积计算
      #方案类型是分段默认定义方式只能是1或者2,默认分段的计算基准只有1-按面积
      IF l_lil11 NOT MATCHES '[12]' THEN
         CONTINUE FOREACH
      END IF
      LET gs_tmp.no = l_ljj.ljj05
      LET gs_tmp.version = l_ljj.ljj051
      LET gs_tmp.bdate = l_ljj.ljj06
      IF l_ljj.ljj06 < p_bdate THEN
         LET gs_tmp.bdate = p_bdate
      END IF
      LET gs_tmp.edate = l_ljj.ljj07
      LET gs_tmp.flg1 = 'N'
      LET gs_tmp.flg2 = 'N'
      IF l_ljj.ljj07 > l_lil13 THEN #表示延期的费用
         LET gs_tmp.flg2 = 'Y'
      END IF
      SELECT lij04,lij05 INTO l_lij04,l_lij05 FROM lij_file
       WHERE lij01 = gs_lji.lji40
         AND lij02 = l_ljj.ljj04
      CALL i400sub_insliv(p_type,l_ljj.ljj04,l_lij04,l_lij05) #写日核算
      CALL i400sub_inslnv(p_type,l_ljj.ljj04)             #写合同标准费用单身
     #INSERT INTO i400_tmp VALUES (gs_tmp.*)
     #IF SQLCA.sqlcode THEN
     #   CALL s_errmsg('','','ins i400_tmp',SQLCA.sqlcode,1)
     #   LET g_success = 'N'
     #END IF
   END FOREACH

END FUNCTION

#产生费用单
FUNCTION i400sub_gen_expense_bill(p_lnt01,p_liw05,p_liw06,p_plant)
 DEFINE p_lnt01              LIKE lnt_file.lnt01
 DEFINE p_liw05              LIKE liw_file.liw05
 DEFINE p_liw06              LIKE liw_file.liw06
 DEFINE p_plant              LIKE lnt_file.lntplant
 DEFINE l_liw                RECORD LIKE liw_file.*
 DEFINE l_lua                RECORD LIKE lua_file.*
 DEFINE l_lub                RECORD LIKE lub_file.*
 DEFINE l_lne05              LIKE lne_file.lne05
 DEFINE li_result            LIKE type_file.num5
 DEFINE l_ooz09              LIKE ooz_file.ooz09
 DEFINE l_lua08t             LIKE lua_file.lua08t
 DEFINE l_lub04t_amt         LIKE lub_file.lub04t
 DEFINE l_year               LIKE type_file.num5
 DEFINE l_month              LIKE type_file.num5
 DEFINE l_lij05              LIKE lij_file.lij05

   IF g_success='N' OR cl_null(p_lnt01) THEN
      RETURN
   END IF
   IF cl_null(p_plant) THEN LET p_plant = g_plant END IF
   LET gs_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'lnt_file'),
               " WHERE lnt01 = '",p_lnt01,"'"
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE i400sub_exp1 FROM gs_sql
   EXECUTE i400sub_exp1 INTO gs_lnt.*
   LET gs_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'liw_file'),
               " WHERE liw01 = '",gs_lnt.lnt01,"'",
               "   AND liw05 = '",p_liw05,"'",
               "   AND liw06 = '",p_liw06,"'",
               "   AND liw17 = 'N' ",
               "   AND liw16 IS NULL"
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE i400sub_exp2 FROM gs_sql
   EXECUTE i400sub_exp2 INTO g_cnt
   IF g_cnt = 0 THEN                           #合同无此帐期，或者已经产生过费用单！
      LET g_showmsg = p_lnt01,'/',p_liw05,'/',p_liw06
      CALL s_errmsg('lnt01,liw05,liw06',g_showmsg,'sel liw','alm1260',1)
      LET g_success = 'N'
      RETURN
   END IF

   #根据合同，出账日，帐期，抓取所有的账单，如果sum应付金额=0，直接把对应的账单结案，不产生费用单
   LET gs_sql="SELECT SUM(liw13) FROM ",cl_get_target_table(p_plant,'liw_file'),
             " WHERE liw01 = '",gs_lnt.lnt01,"'",
             "   AND liw05 = '",p_liw05,"'",
             "   AND liw06 = '",p_liw06,"'",
             "   AND liw17 = 'N' ",
             "   AND liw16 IS NULL",
             " ORDER BY liw06,liw04,liw07,liw02"
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE i400sub_exp14_p FROM gs_sql
   EXECUTE i400sub_exp14_p INTO l_lua08t
   IF l_lua08t = 0 AND SQLCA.sqlcode = 0 THEN
      LET gs_sql = "UPDATE ",cl_get_target_table(p_plant,'liw_file'),
                   "   SET liw17 = 'Y' ",
                   " WHERE liw01 = '",gs_lnt.lnt01,"'",
                   "   AND liw05 = '",p_liw05,"'",
                   "   AND liw06 = '",p_liw06,"'",
                   "   AND liw17 = 'N' ",
                   "   AND liw16 IS NULL"
      CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
      CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
      PREPARE i400sub_exp15_p FROM gs_sql
      EXECUTE i400sub_exp15_p
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('','','upd liw13',SQLCA.sqlcode,1)
         LET g_success = 'N'
         RETURN
      END IF
   END IF

   LET gs_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'lla_file'),
                " WHERE llastore = '",p_plant,"'"
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE i400sub_exp22 FROM gs_sql
   EXECUTE i400sub_exp22 INTO gs_lla.*
    
   #定义回写费用单号到账单的CURSOR
   LET gs_sql = "UPDATE ",cl_get_target_table(p_plant,'liw_file'),
                "   SET liw16 = ?",
                " WHERE liw01 = '",gs_lnt.lnt01,"'",
                "   AND liw03 = ? "
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE i400sub_exp12 FROM gs_sql

   #根据合同，出账日，帐期，抓取所有的账单，产生费用单
   LET gs_sql="SELECT * FROM ",cl_get_target_table(p_plant,'liw_file'),
             " WHERE liw01 = '",gs_lnt.lnt01,"'",
             "   AND liw05 = '",p_liw05,"'",
             "   AND liw06 = '",p_liw06,"'",
             "   AND liw17 = 'N' ",
             "   AND liw16 IS NULL",
             " ORDER BY liw06,liw04,liw07,liw02"
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE i400sub_exp3_p FROM gs_sql
   DECLARE i400sub_exp3 CURSOR FOR i400sub_exp3_p
   
   FOREACH i400sub_exp3 INTO l_liw.*
   
      IF cl_null(l_lua.lua01) THEN
         #费用单单别
         #FUN-C90050 mark begin---
         #LET gs_sql = "SELECT rye03 FROM ",cl_get_target_table(p_plant,'rye_file'),
         #            " WHERE rye01 = 'art'",
         #            "   AND rye02 = 'B9'",
         #CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
         #CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
         #PREPARE i400sub_exp4 FROM gs_sql
         #EXECUTE i400sub_exp4 INTO l_lua.lua01
         #FUN-C90050 mark end-----
         CALL s_get_defslip('art','B9',p_plant,'N') RETURNING l_lua.lua01    #UFN-C90050 add
        
         IF cl_null(l_lua.lua01) THEN
            CALL s_errmsg('','','sel rye03','art-330',1)
            LET g_success = 'N'
            RETURN
         END IF 
         
         #费用单单号
         CALL s_auto_assign_no("art",l_lua.lua01,g_today,'B9',"lua_file","lua01","","","")
             RETURNING li_result,l_lua.lua01
         IF NOT li_result THEN
            CALL s_errmsg('','','auto lua01','abm-621',1)
            LET g_success = 'N'
            RETURN
         END IF
         
         LET l_lua.lua01 = l_lua.lua01   #費用單編號
         LET l_lua.lua02 = ' '           #費用單類型
         LET l_lua.lua03 = ' '           #費用單來源
         LET l_lua.lua04 = gs_lnt.lnt01  #合約編號
        #LET l_lua.lua05 = ' '           #内部客户
         IF s_chk_own(gs_lnt.lnt04) THEN
            LET l_lua.lua05 = 'Y'
         ELSE
            LET l_lua.lua05 = 'N'
         END IF
         LET l_lua.lua06 = gs_lnt.lnt04  #客戶編號
         LET gs_sql = "SELECT lne05 FROM ",cl_get_target_table(p_plant,'lne_file'),
                     " WHERE lne01 = '",gs_lnt.lnt04,"'"
         CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
         CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
         PREPARE i400sub_exp9 FROM gs_sql
         EXECUTE i400sub_exp9 INTO l_lne05
         LET l_lua.lua061= l_lne05       #客戶簡稱
         LET l_lua.lua07 = gs_lnt.lnt06  #攤位號
         LET l_lua.lua08 = 0             #未稅總金額
         LET l_lua.lua08t= 0             #含稅總金額
         LET l_lua.lua09 = g_today       #單據日期
         LET l_lua.lua10 = 'Y'           #系統自動生成
         LET l_lua.lua11 = '5'           #來源作業
         LET l_lua.lua12 = gs_lnt.lnt01  #單據號
         LET l_lua.lua13 = 'N'           #是否簽核
         LET l_lua.lua14 = '0'           #簽核狀態
         LET l_lua.lua15 = 'N'           #確認碼
         LET l_lua.lua16 = NULL          #確認人
         LET l_lua.lua17 = NULL          #確認日期
         LET l_lua.lua18 = NULL          #備注
         LET l_lua.lua19 = p_plant       #來源營運中心
         LET l_lua.lua20 = gs_lnt.lnt02  #合同版本號
         LET l_lua.lua21 = gs_lnt.lnt35  #稅種
         LET l_lua.lua22 = gs_lnt.lnt36  #稅率
         LET l_lua.lua23 = gs_lnt.lnt37  #含稅否
         LET l_lua.lua24 = NULL          #財務單號
         LET l_lua.lua27 = NULL          #大月結日期
         LET l_lua.lua28 = NULL          #應收報表計租起始日期
         LET l_lua.lua29 = NULL          #應收報表計租截止日期
         LET l_lua.lua30 = NULL          #費用起始日期
         LET l_lua.lua31 = NULL          #費用截止日期
         LET l_lua.luaacti = 'Y'         #資料有效碼
         LET l_lua.luacrat = g_today         #資料創建日
         LET l_lua.luadate = g_today         #最近修改日
         LET l_lua.luagrup = g_grup          #資料所有群
         LET l_lua.lualegal= gs_lnt.lntlegal #所屬法人
         LET l_lua.luamodu = NULL            #資料修改者
         LET l_lua.luaplant= gs_lnt.lntplant #所屬營運中心
         LET l_lua.luauser = g_user          #資料所有者
         LET l_lua.luaoriu = g_user          #資料建立者
         LET l_lua.luaorig = g_grup          #資料建立部門
         LET l_lua.lua32 = '3'           #客戶來源
         LET l_lua.lua33 = p_liw05       #帐期
         LET l_lua.lua34 = p_liw06       #出账日
         LET l_lua.lua35 = 0             #已收金额
         LET l_lua.lua36 = 0             #清算金额
         LET l_lua.lua37 = 'N'           #直接收款
         LET l_lua.lua38 = g_user        #业务人员
         LET l_lua.lua39 = g_grup        #部门编号
         LET gs_sql = "INSERT INTO ",cl_get_target_table(p_plant, 'lua_file'),
                     "(lua01,lua02,lua03,lua04,lua05, lua06,lua061,lua07,lua08,lua08t,",
                     " lua09,lua10,lua11,lua12,lua13, lua14,lua15,lua16,lua17,lua18,",
                     " lua19,lua20,lua21,lua22,lua23, lua24,lua27,lua28,lua29,lua30,",
                     " lua31,luaacti,luacrat,luadate,luagrup, lualegal,luamodu,luaplant,luauser,luaoriu,",
                     " luaorig,lua32,lua33,lua34,lua35, lua36,lua37,lua38,lua39)",
                     " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                     "        ?,?,?,?,?, ?,?,?,?,?,",
                     "        ?,?,?,?,?, ?,?,?,?,?,",
                     "        ?,?,?,?,?, ?,?,?,?,?,",
                     "        ?,?,?,?,?, ?,?,?,?)"
         CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
         CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
         PREPARE i400sub_exp5 FROM gs_sql
         EXECUTE i400sub_exp5 USING l_lua.lua01,l_lua.lua02,l_lua.lua03,l_lua.lua04,l_lua.lua05,
                                    l_lua.lua06,l_lua.lua061,l_lua.lua07,l_lua.lua08,l_lua.lua08t,
                                    l_lua.lua09,l_lua.lua10,l_lua.lua11,l_lua.lua12,l_lua.lua13,
                                    l_lua.lua14,l_lua.lua15,l_lua.lua16,l_lua.lua17,l_lua.lua18,
                                    l_lua.lua19,l_lua.lua20,l_lua.lua21,l_lua.lua22,l_lua.lua23,
                                    l_lua.lua24,l_lua.lua27,l_lua.lua28,l_lua.lua29,l_lua.lua30,
                                    l_lua.lua31,l_lua.luaacti,l_lua.luacrat,l_lua.luadate,l_lua.luagrup,
                                    l_lua.lualegal,l_lua.luamodu,l_lua.luaplant,l_lua.luauser,l_lua.luaoriu,
                                    l_lua.luaorig,l_lua.lua32,l_lua.lua33,l_lua.lua34,l_lua.lua35,
                                    l_lua.lua36,l_lua.lua37,l_lua.lua38,l_lua.lua39
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('lua01',l_lua.lua01,'ins lua_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF
      
      LET l_lub.lub01 = l_lua.lua01  #費用單單號
      LET l_lub.lub03 = l_liw.liw04  #费用编号
      LET l_lub.lub04 = l_liw.liw13  #未稅金額
      LET l_lub.lub04t= l_liw.liw13  #含稅金額
      IF l_lua.lua23 = 'Y' THEN
         LET l_lub.lub04 = l_liw.liw13/(1+l_lua.lua22/100)
      ELSE
         LET l_lub.lub04 = l_liw.liw13/(1+l_lua.lua22/100)      #CHI-C80016 mark
        #LET l_lub.lub04 = l_liw.liw13/(1/100)                  #CHI-C80016 add
      END IF
      LET gs_sql = "SELECT azi04 FROM ",cl_get_target_table(p_plant,'azi_file'),",",
                                        cl_get_target_table(p_plant,'aza_file'),
                  " WHERE azi01 =  aza17 AND aza01= '0'"
      CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
      CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
      PREPARE i400sub_exp14 FROM gs_sql
      EXECUTE i400sub_exp14 INTO g_azi04
      LET l_lub.lub04 = cl_digcut(l_lub.lub04,g_azi04)
      LET l_lub.lub05 = NULL         #備注
      LET l_lub.lub06 = ''           #no use 原門店編號
      LET l_lub.lub07 = l_liw.liw07  #起始日期
      LET l_lub.lub08 = l_liw.liw08  #截止日期
      LET l_lub.lublegal = gs_lnt.lntlegal #所屬法人
      LET l_lub.lubplant = gs_lnt.lntplant #所屬營運中心
     #LET l_lub.lub09	=            #费用类型
      LET gs_sql = "SELECT oaj05 FROM ",cl_get_target_table(p_plant,'oaj_file'),
                   " WHERE oaj01 = '",l_liw.liw04,"'"
      CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
      CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
      PREPARE i400sub_exp7 FROM gs_sql
      EXECUTE i400sub_exp7 INTO l_lub.lub09
      LET l_lub.lub10 = l_liw.liw07  #立账日
      LET gs_sql = "SELECT ooz09 FROM ",cl_get_target_table(p_plant,'ooz_file'),
                   " WHERE ooz01 = '0'"
      CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
      CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
      PREPARE i400sub_exp13 FROM gs_sql
      EXECUTE i400sub_exp13 INTO l_ooz09
      IF NOT cl_null(l_ooz09) AND l_lub.lub10 <= l_ooz09 THEN
         LET l_lub.lub10 = l_ooz09 + 1
      END IF
      LET l_lub.lub11 = 0            #已收金额
      LET l_lub.lub12 = 0            #清算金额
      LET l_lub.lub13 = 'N'          #结案否
      LET l_lub.lub14 = NULL         #财务单号
      LET l_lub.lub15 = NULL         #财务待抵单号
      LET l_lub.lub16 = l_liw.liw02  #合同版本号
      LET gs_sql = "INSERT INTO ",cl_get_target_table(p_plant, 'lub_file'),
                  "(lub01,lub02,lub03,lub04,lub04t, lub05,lub06,lub07,lub08,lublegal,",
                  " lubplant,lub09,lub10,lub11,lub12, lub13,lub14,lub15,lub16)",
                  " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                  "        ?,?,?,?,?, ?,?,?,?)"
      CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
      CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
      PREPARE i400sub_exp8 FROM gs_sql

      LET gs_sql = "SELECT lij05 FROM ",cl_get_target_table(p_plant, 'lij_file'),
                   " WHERE lij01 = '",gs_lnt.lnt71,"'",
                   "   AND lij02 = '",l_liw.liw04,"'"
      PREPARE i400sub_exp25 FROM gs_sql
      EXECUTE i400sub_exp25 INTO l_lij05  #收付实现制也不拆分
      #账单按自然月不拆分，产生一笔费用单单身，否则按自然月拆分产生多笔费用单单身
      IF gs_lla.lla05 = 'Y' OR l_lij05 = '1' THEN
        #LET l_lub.lub02 =              #項次
         LET gs_sql = "SELECT MAX(lub02)+1 FROM ",cl_get_target_table(p_plant,'lub_file'),
                      " WHERE lub01 = '",l_lua.lua01,"'"
         CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
         CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
         PREPARE i400sub_exp6 FROM gs_sql
         EXECUTE i400sub_exp6 INTO l_lub.lub02
         IF cl_null(l_lub.lub02) THEN LET l_lub.lub02 = 1 END IF
         EXECUTE i400sub_exp8 USING l_lub.lub01,l_lub.lub02,l_lub.lub03,l_lub.lub04,l_lub.lub04t,
                                    l_lub.lub05,l_lub.lub06,l_lub.lub07,l_lub.lub08,l_lub.lublegal,
                                    l_lub.lubplant,l_lub.lub09,l_lub.lub10,l_lub.lub11,l_lub.lub12,
                                    l_lub.lub13,l_lub.lub14,l_lub.lub15,l_lub.lub16
         IF SQLCA.sqlcode THEN
            LET g_showmsg = l_lub.lub01,'/',l_lub.lub02
            CALL s_errmsg('lub01,lub02',l_lub.lub02,'ins lub_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            CONTINUE FOREACH
         END IF
      ELSE
	 LET l_year = YEAR(l_liw.liw07)
         LET l_month= MONTH(l_liw.liw07)
         LET l_lub04t_amt = 0
         WHILE TRUE
            LET gs_sql = "SELECT MAX(lub02)+1 FROM ",cl_get_target_table(p_plant,'lub_file'),
                         " WHERE lub01 = '",l_lua.lua01,"'"
            CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
            CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
            PREPARE i400sub_exp23 FROM gs_sql
            EXECUTE i400sub_exp23 INTO l_lub.lub02   #項次
            IF cl_null(l_lub.lub02) THEN LET l_lub.lub02 = 1 END IF
             IF l_year = YEAR(l_liw.liw07) AND l_month = MONTH(l_liw.liw07) THEN
               LET l_lub.lub07 = l_liw.liw07
            ELSE
               LET l_lub.lub07 = MDY(l_month,1,l_year)
            END IF
            IF l_year = YEAR(l_liw.liw08) AND l_month = MONTH(l_liw.liw08) THEN
               LET l_lub.lub08 = l_liw.liw08
            ELSE
               LET l_lub.lub08 = MDY(l_month,cl_days(l_year,l_month),l_year)
            END IF
            LET gs_sql = "SELECT SUM(liv06) FROM ",cl_get_target_table(p_plant,'liv_file'),
                         " WHERE liv01 = '",gs_lnt.lnt01,"'",
                         "   AND liv02 = '",l_liw.liw02,"'",
                         "   AND liv04 BETWEEN '",l_lub.lub07,"' AND '",l_lub.lub08,"' ",
                         "   AND liv05 = '",l_liw.liw04,"'"
            CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
            CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
            PREPARE i400sub_exp24 FROM gs_sql
            EXECUTE i400sub_exp24 INTO l_lub.lub04t           #含稅金額
            IF cl_null(l_lub.lub04t) THEN LET l_lub.lub04t=0 END IF
            LET l_lub.lub04t = cl_digcut(l_lub.lub04t,g_azi04)
            #账单不按自然月拆分，费用单拆分时，因为没有抹零金额，所以，最后一个月
            #金额=账单总应收liw13-前几个月费用单含税金额汇总
            IF l_year = YEAR(l_liw.liw08) AND l_month = MONTH(l_liw.liw08) THEN
               LET l_lub.lub04t = l_liw.liw13 - l_lub04t_amt
            ELSE
               LET l_lub04t_amt = l_lub04t_amt + l_lub.lub04t
            END IF
            LET l_lub.lub04 = l_lub.lub04t/(1+l_lua.lua22/100) #未稅金額
            LET l_lub.lub04 = cl_digcut(l_lub.lub04,g_azi04)

            LET l_lub.lub10 = l_lub.lub07  #立账日
            IF NOT cl_null(l_ooz09) AND l_lub.lub10 <= l_ooz09 THEN
               LET l_lub.lub10 = l_ooz09 + 1
            END IF
            
            IF l_lub.lub04t <> 0 THEN
               EXECUTE i400sub_exp8 USING l_lub.lub01,l_lub.lub02,l_lub.lub03,l_lub.lub04,l_lub.lub04t,
                                          l_lub.lub05,l_lub.lub06,l_lub.lub07,l_lub.lub08,l_lub.lublegal,
                                          l_lub.lubplant,l_lub.lub09,l_lub.lub10,l_lub.lub11,l_lub.lub12,
                                          l_lub.lub13,l_lub.lub14,l_lub.lub15,l_lub.lub16
               IF SQLCA.sqlcode THEN
                  LET g_showmsg = l_lub.lub01,'/',l_lub.lub02
                  CALL s_errmsg('lub01,lub02',l_lub.lub02,'ins lub_file',SQLCA.sqlcode,1)
                  LET g_success = 'N'
               END IF
            END IF
            IF l_year = YEAR(l_liw.liw08) AND l_month = MONTH(l_liw.liw08) THEN
               EXIT WHILE
            END IF
            IF l_month = 12 THEN
               LET l_year = l_year + 1
               LET l_month = 1
            ELSE
               LET l_month = l_month + 1
            END IF
         END WHILE
      END IF
      
      #回写费用单号到账单
      EXECUTE i400sub_exp12 USING l_lub.lub01,l_liw.liw03
      IF SQLCA.sqlcode THEN
         LET g_showmsg = l_liw.liw01,'/',l_liw.liw03
         CALL s_errmsg('liw01,liw03',g_showmsg,'upd liw16/18',SQLCA.sqlcode,1)
         CALL s_errmsg('','','upd liw_file',SQLCA.sqlcode,1)
         LET g_success = 'N'
         CONTINUE FOREACH
      END IF
   END FOREACH
    
   #更新单头金额
   LET gs_sql = "SELECT SUM(lub04),SUM(lub04t) FROM ",cl_get_target_table(p_plant,'lub_file'),
               " WHERE lub01 = '",l_lua.lua01,"'"
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE i400sub_exp10 FROM gs_sql
   EXECUTE i400sub_exp10 INTO l_lua.lua08,l_lua.lua08t
   LET gs_sql = "UPDATE ",cl_get_target_table(p_plant,'lua_file'),
               "   SET lua08 = '",l_lua.lua08,"',",
               "       lua08t = '",l_lua.lua08t,"'",
               " WHERE lua01 = '",l_lua.lua01,"'"
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE i400sub_exp11 FROM gs_sql
   EXECUTE i400sub_exp11
   IF SQLCA.sqlcode THEN
      CALL s_errmsg('','','upd lua_file',SQLCA.sqlcode,1)
      LET g_success = 'N'
      RETURN
   END IF
   #回写费用单号到账单
  #LET gs_sql = "UPDATE ",cl_get_target_table(p_plant,'liw_file'),
  #            "   SET liw16 = '",l_lua.lua01,"'",
  #            " WHERE liw01 = '",gs_lnt.lnt01,"'",
  #            "   AND liw05 = '",p_liw05,"'",
  #            "   AND liw06 = '",p_liw06,"'",
  #            "   AND liw16 IS NULL"
  #CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
  #CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
  #PREPARE i400sub_exp12 FROM gs_sql
  #EXECUTE i400sub_exp12
  #IF SQLCA.sqlcode THEN
  #   CALL s_errmsg('','','upd liw_file',SQLCA.sqlcode,1)
  #   LET g_success = 'N'
  #   RETURN
  #END IF
END FUNCTION

#合同终止更新合同状态，场地状态以及产生所有未产生的费用单
#p_type=1,almt410终止变更 变更发出时调用；p_type=2,almp100调用
FUNCTION i400sub_upd_lnt(p_type,p_lji01,p_date,p_plant)
 DEFINE p_type       LIKE type_file.chr1
 DEFINE p_date       LIKE type_file.dat
 DEFINE p_lji01      LIKE lji_file.lji01
 DEFINE p_plant      LIKE lji_file.ljiplant
 DEFINE l_liw05      LIKE liw_file.liw05
 DEFINE l_liw06      LIKE liw_file.liw06

   IF cl_null(p_lji01) OR cl_null(p_date) THEN
      RETURN
   END IF

   LET gs_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'lji_file'),
                " WHERE lji01 = '",p_lji01,"'"
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE i400sub_exp20 FROM gs_sql
   EXECUTE i400sub_exp20 INTO gs_lji.*

   IF gs_lji.lji02 <> '5' THEN
      RETURN
   END IF

   IF gs_lji.lji29 <> p_date THEN
      RETURN
   END IF

   CALL p101_upd_ratio_bill(gs_lji.lji04,p_date,'',p_plant,'3') #FUN-C20078

   LET gs_sql = "SELECT DISTINCT liw05,liw06 FROM ",cl_get_target_table(p_plant,'liw_file'),
                " WHERE liw01 = '",gs_lji.lji04,"'",
                "   AND liw16 IS NULL ",
                "   AND liw17 = 'N' ",
                " ORDER BY liw05,liw06"
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE i400sub_exp21 FROM gs_sql
   DECLARE i400sub_exp21_cs CURSOR FOR i400sub_exp21
   FOREACH i400sub_exp21_cs INTO l_liw05,l_liw06
      IF STATUS THEN
         CALL s_errmsg('','','i400sub_exp21_cs',STATUS,1)
         LET g_success = 'N'
         RETURN
      END IF

      CALL i400sub_gen_expense_bill(gs_lji.lji04,l_liw05,l_liw06,p_plant)
   END FOREACH
   IF p_type = '1' THEN
      LET gs_sql = "UPDATE ",cl_get_target_table(p_plant,'lnt_file'),
                   "   SET lnt26 = 'S' ",
                   " WHERE lnt01 = '",gs_lji.lji04,"'"
      PREPARE i400sub_exp26 FROM gs_sql
      EXECUTE i400sub_exp26
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('lnt01',gs_lji.lji04,'upd lnt',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
      LET gs_sql = "UPDATE ",cl_get_target_table(p_plant,'lmf_file'),
                   "   SET lmf05 = '1' ",
                   " WHERE lmf01 = '",gs_lji.lji08,"'"
      PREPARE i400sub_exp27 FROM gs_sql
      EXECUTE i400sub_exp27
      IF SQLCA.sqlcode THEN
         CALL s_errmsg('lmf01',gs_lji.lji08,'upd lmf05',SQLCA.sqlcode,1)
         LET g_success = 'N'
      END IF
   END IF
   CALL i400sub_Termination_cost(p_lji01,p_plant,p_date)     #TQC-C30027 add 
END FUNCTION

#TQC-C30027--start add---------------------------------------------------------
FUNCTION i400sub_Termination_cost(p_lji01,p_plant,p_date)
   DEFINE l_gec04       LIKE gec_file.gec04
   DEFINE l_gec07       LIKE gec_file.gec07
   DEFINE l_cnt         LIKE type_file.num5
   DEFINE p_lji01       LIKE lji_file.lji01
   DEFINE p_date        LIKE type_file.dat
   DEFINE p_plant       LIKE lji_file.ljiplant
   DEFINE li_result     LIKE type_file.num5
   DEFINE l_lji03       LIKE lji_file.lji03
   DEFINE l_lji05       LIKE lji_file.lji05
   DEFINE l_ljilegal    LIKE lji_file.ljilegal
   DEFINE l_azi04       LIKE azi_file.azi04
   DEFINE l_ooz09       LIKE ooz_file.ooz09
   DEFINE l_lua  RECORD LIKE lua_file.*
   DEFINE l_lub  RECORD LIKE lub_file.*
   DEFINE l_lje  RECORD LIKE lje_file.*

   LET gs_sql = "SELECT azi04 FROM ",cl_get_target_table(p_plant,'azi_file'),
                " WHERE azi01 = '",g_aza.aza17,"'"
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE i400sub_cost1 FROM gs_sql
   EXECUTE i400sub_cost1 INTO l_azi04

   LET gs_sql = "SELECT lji03,lji05,ljilegal FROM ",cl_get_target_table(p_plant,'lji_file'),
                " WHERE lji01 = '",p_lji01,"'"
   CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
   CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
   PREPARE i400sub_cost2 FROM gs_sql
   EXECUTE i400sub_cost2 INTO l_lji03,l_lji05,l_ljilegal

   IF NOT cl_null (l_lji03) THEN
      LET gs_sql = "SELECT * FROM ",cl_get_target_table(p_plant,'lje_file'),
                   " WHERE lje01 = '",l_lji03,"'"
      CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
      CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
      PREPARE i400sub_cost3 FROM gs_sql
      EXECUTE i400sub_cost3 INTO l_lje.*

      IF cl_null(l_lje.lje20) OR cl_null(l_lje.lje21) THEN
         RETURN 
      END IF 

      LET l_cnt = 0
      LET gs_sql = "SELECT COUNT(*) FROM ",cl_get_target_table(p_plant,'lua_file'),
                   " WHERE lua12 = '",l_lji03,"'"
      CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
      CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
      PREPARE i400sub_cost4 FROM gs_sql
      EXECUTE i400sub_cost4 INTO l_cnt

      IF l_cnt = 0 THEN 
         #FUN-C90050 mark begin---
         #LET gs_sql = "SELECT rye03 FROM ",cl_get_target_table(p_plant,'rye_file'),
         #             " WHERE rye01 = 'art'",
         #             "   AND rye02 = 'B9'",
         #CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
         #CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
         #PREPARE i400sub_cost5 FROM gs_sql
         #EXECUTE i400sub_cost5 INTO l_lua.lua01
         #FUN-C90050 mark end----

         CALL s_get_defslip('art','B9',p_plant,'N') RETURNING l_lua.lua01    #FUN-C90050 add
         ####自動編號###############################
         CALL s_check_no("art",l_lua.lua01,"",'B9',"lua_file","lua01","")
             RETURNING li_result,l_lua.lua01

         CALL s_auto_assign_no("art",l_lua.lua01,p_date,'B9',"lua_file","lua01","","","")
             RETURNING li_result,l_lua.lua01  
         IF NOT li_result THEN
            CALL s_errmsg('','','insert lua_file:','alm-859',1)
            LET g_success = 'N'
         END IF
         
         LET gs_sql = "SELECT occ02,occ41 FROM ",cl_get_target_table(p_plant,'occ_file'),
                      " WHERE occ01 = '",l_lje.lje06,"'"
         CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
         CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
         PREPARE i400sub_cost6 FROM gs_sql
         EXECUTE i400sub_cost6 INTO l_lua.lua061,l_lua.lua21

         LET gs_sql = "SELECT gec04,gec07 FROM ",cl_get_target_table(p_plant,'gec_file'),
                      " WHERE gec01 = '",l_lua.lua21,"'"
         CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
         CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
         PREPARE i400sub_cost7 FROM gs_sql
         EXECUTE i400sub_cost7 INTO l_gec04,l_gec07

         IF l_lje.lje18 = '2' THEN
            LET l_lub.lub04t = 0 - l_lje.lje20 
         ELSE
            LET l_lub.lub04t = l_lje.lje20
         END IF           
         LET l_lub.lub04 = l_lub.lub04t/(1 + l_gec04/100)
         CALL cl_digcut(l_lub.lub04,l_azi04) RETURNING l_lub.lub04

         LET gs_sql = "SELECT oaj05 FROM ",cl_get_target_table(p_plant,'oaj_file'),
                      " WHERE oaj01 = '",l_lje.lje21,"'"
         CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
         CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
         PREPARE i400sub_cost8 FROM gs_sql
         EXECUTE i400sub_cost8 INTO l_lub.lub09

         LET gs_sql = "SELECT ooz09 FROM ",cl_get_target_table(p_plant,'ooz_file'),
                      " WHERE ooz01 = '0'"
         CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
         CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
         PREPARE i400sub_cost11 FROM gs_sql
         EXECUTE i400sub_cost11 INTO l_ooz09
 

         LET l_lub.lub10 = p_date
         IF l_lub.lub10 <= l_ooz09 THEN
            LET l_lub.lub10 = l_ooz09 + 1
         END IF  
         IF s_chk_own(l_lje.lje06) THEN
            LET l_lua.lua05 = 'Y'
            LET l_lua.lua37 = 'N'
         ELSE 
            LET l_lua.lua05 = 'N'
            LET l_lua.lua37 = 'N'        
         END IF      
  
         LET l_lua.lua02 = ' '
         LET l_lua.lua04 = l_lje.lje04
         LET l_lua.lua20 = l_lji05
         LET l_lua.lua06 = l_lje.lje06
         LET l_lua.lua07 = l_lje.lje05
         LET l_lua.lua08 = l_lub.lub04
         LET l_lua.lua08t = l_lub.lub04t
         LET l_lua.lua09 = p_date
         LET l_lua.lua10 = 'Y'
         LET l_lua.lua11= '7'
         LET l_lua.lua12 = l_lje.lje01
         LET l_lua.lua13 = 'N'
         LET l_lua.lua14 = '0'
         LET l_lua.lua15 = 'N'
         LET l_lua.lua17 = ''
         LET l_lua.lua19 = p_plant
         LET l_lua.lua22 = l_gec04
         LET l_lua.lua23 = l_gec07
         LET l_lua.luaacti = 'Y'
         LET l_lua.luacrat =p_date
         LET l_lua.luadate = p_date
         LET l_lua.luagrup = g_grup
         LET l_lua.lualegal = l_ljilegal
         LET l_lua.luaplant = p_plant
         LET l_lua.luauser = g_user
         LET l_lua.luaoriu = g_user
         LET l_lua.luaorig = g_grup
         LET l_lua.lua32 = '3'
         LET l_lua.lua33 = ''
         LET l_lua.lua34 = ''
         LET l_lua.lua35 = 0
         LET l_lua.lua36 = 0
         LET l_lua.lua38 = g_user
         LET l_lua.lua39 = g_grup

         LET gs_sql = "INSERT INTO ",cl_get_target_table(p_plant, 'lua_file'),
                      "(lua01,lua02,lua03,lua04,lua05, lua06,lua061,lua07,lua08,lua08t,",
                      " lua09,lua10,lua11,lua12,lua13, lua14,lua15,lua16,lua17,lua18,",
                      " lua19,lua20,lua21,lua22,lua23, lua24,lua27,lua28,lua29,lua30,",
                      " lua31,luaacti,luacrat,luadate,luagrup, lualegal,luamodu,luaplant,luauser,luaoriu,",
                      " luaorig,lua32,lua33,lua34,lua35, lua36,lua37,lua38,lua39)",
                      " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                      "        ?,?,?,?,?, ?,?,?,?,?,",
                      "        ?,?,?,?,?, ?,?,?,?,?,",
                      "        ?,?,?,?,?, ?,?,?,?,?,",
                      "        ?,?,?,?,?, ?,?,?,?)"
         CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
         CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
         PREPARE i400sub_cost9 FROM gs_sql
         EXECUTE i400sub_cost9 USING l_lua.lua01,l_lua.lua02,l_lua.lua03,l_lua.lua04,l_lua.lua05,
                                    l_lua.lua06,l_lua.lua061,l_lua.lua07,l_lua.lua08,l_lua.lua08t,
                                    l_lua.lua09,l_lua.lua10,l_lua.lua11,l_lua.lua12,l_lua.lua13,
                                    l_lua.lua14,l_lua.lua15,l_lua.lua16,l_lua.lua17,l_lua.lua18,
                                    l_lua.lua19,l_lua.lua20,l_lua.lua21,l_lua.lua22,l_lua.lua23,
                                    l_lua.lua24,l_lua.lua27,l_lua.lua28,l_lua.lua29,l_lua.lua30,
                                    l_lua.lua31,l_lua.luaacti,l_lua.luacrat,l_lua.luadate,l_lua.luagrup,
                                    l_lua.lualegal,l_lua.luamodu,l_lua.luaplant,l_lua.luauser,l_lua.luaoriu,
                                    l_lua.luaorig,l_lua.lua32,l_lua.lua33,l_lua.lua34,l_lua.lua35,
                                    l_lua.lua36,l_lua.lua37,l_lua.lua38,l_lua.lua39
         IF SQLCA.sqlcode THEN
            CALL s_errmsg('lua01',l_lua.lua01,'ins lua_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF                   

         LET l_lub.lub01 = l_lua.lua01
         LET l_lub.lub02 = 1
         LET l_lub.lub03 = l_lje.lje21
         LET l_lub.lub07 = p_date
         LET l_lub.lub08 = p_date
         LET l_lub.lublegal = l_lua.lualegal
         LET l_lub.lubplant = l_lua.luaplant
         LET l_lub.lub11 = 0
         LET l_lub.lub12 = 0
         LET l_lub.lub13 = 'N'  
         LET l_lub.lub16 = l_lji05

         LET gs_sql = "INSERT INTO ",cl_get_target_table(p_plant, 'lub_file'),
                      "(lub01,lub02,lub03,lub04,lub04t, lub05,lub06,lub07,lub08,lublegal,",
                      " lubplant,lub09,lub10,lub11,lub12, lub13,lub14,lub15,lub16)",
                      " VALUES(?,?,?,?,?, ?,?,?,?,?,",
                      "        ?,?,?,?,?, ?,?,?,?)"
         CALL cl_replace_sqldb(gs_sql) RETURNING gs_sql
         CALL cl_parse_qry_sql(gs_sql,p_plant) RETURNING gs_sql
         PREPARE i400sub_cost10 FROM gs_sql
         EXECUTE i400sub_cost10 USING l_lub.lub01,l_lub.lub02,l_lub.lub03,l_lub.lub04,l_lub.lub04t,
                                    l_lub.lub05,l_lub.lub06,l_lub.lub07,l_lub.lub08,l_lub.lublegal,
                                    l_lub.lubplant,l_lub.lub09,l_lub.lub10,l_lub.lub11,l_lub.lub12,
                                    l_lub.lub13,l_lub.lub14,l_lub.lub15,l_lub.lub16
         IF SQLCA.sqlcode THEN
            LET g_showmsg = l_lub.lub01,'/',l_lub.lub02
            CALL s_errmsg('lub01,lub02',l_lub.lub02,'ins lub_file',SQLCA.sqlcode,1)
            LET g_success = 'N'
            RETURN
         END IF
      END IF 
   END IF 
END FUNCTION
#TQC-C30027--end add-----------------------------------------------------------

FUNCTION i400sub_chk_lij05(p_lij02)
 DEFINE p_lij02       LIKE lij_file.lij02
 DEFINE l_lnl03       LIKE lnl_file.lnl03
 DEFINE l_lnl04       LIKE lnl_file.lnl04
 DEFINE l_lnl05       LIKE lnl_file.lnl05
 DEFINE l_lnl09       LIKE lnl_file.lnl09
 DEFINE l_lik08       LIKE lik_file.lik08

   IF cl_null(p_lij02) THEN RETURN FALSE END IF
   #抓取almi350中的设置,根据参数设置判断日期类型是否为合同期
   SELECT lnl03,lnl04,lnl05,lnl09 INTO l_lnl03,l_lnl04,l_lnl05,l_lnl09
     FROM lnl_file
    WHERE lnl01 = p_lij02
      AND lnlstore = gs_lnt.lntplant
   LET gs_sql = "SELECT lik08 FROM lik_file",
               " WHERE lik01 = '",p_lij02,"'",
               "   AND likstore = '",gs_lnt.lntplant,"'",
               "   AND lik07 = '",gs_lnt.lnt55,"'"
   IF l_lnl03 = 'Y' THEN
      LET gs_sql = gs_sql CLIPPED,"   AND (lik03 = '",gs_lnt.lnt08,"' OR lik03 = '*')"
   END IF
   IF l_lnl04 = 'Y' THEN
      LET gs_sql = gs_sql CLIPPED,"   AND (lik04 = '",gs_lnt.lnt09,"' OR lik04 = '*')"
   END IF
   IF l_lnl05 = 'Y' THEN
      LET gs_sql = gs_sql CLIPPED,"   AND (lik05 = '",gs_lnt.lnt60,"' OR lik05 = '*')"
   END IF
   IF l_lnl09 = 'Y' THEN
      LET gs_sql = gs_sql CLIPPED,"   AND (lik06 = '",gs_lnt.lnt33,"' OR lik06 = '*')"
   END IF
   PREPARE i400sub_chk_lij05_p FROM gs_sql
   EXECUTE i400sub_chk_lij05_p INTO l_lik08
   IF l_lik08 = '5' THEN
      RETURN TRUE
   END IF
   RETURN FALSE
END FUNCTION
#FUN-BA0118
