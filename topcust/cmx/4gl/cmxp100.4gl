# Prog. Version..: '5.30.10-13.11.15(00010)'     #
#
# Program name...: cmxp100.4gl
# Descriptions...: 初始化资料同步
# Date & Author..:
# Modify.........: No.2021120101 21/12/01 By jc 增加仓退、工单、发料申请、发退料、出货通知、销退

DATABASE ds

GLOBALS "../../../tiptop/config/top.global"

DEFINE g_type           LIKE type_file.chr100
DEFINE g_sql            STRING 
DEFINE l_ret            RECORD
          success       LIKE type_file.chr1,
          code          LIKE type_file.chr10,
          msg           STRING
                        END RECORD

MAIN


    OPTIONS                               #改變一些系統預設值
       FORM LINE       FIRST + 2,         #畫面開始的位置
       MESSAGE LINE    LAST,              #訊息顯示的位置
       PROMPT LINE     LAST,              #提示訊息的位置
       INPUT NO WRAP                      #輸入的方式: 不打轉
    DEFER INTERRUPT                       #擷取中斷鍵, 由程式處理

    LET g_type = ARG_VAL(1)               #取外部参数,该参数用来控制本次操作用于什么类型

    IF (NOT cl_user()) THEN               #抓取部分參數(g_prog,g_user...)
       EXIT PROGRAM                       #切換成使用者預設的營運中心
    END IF

    WHENEVER ERROR CALL cl_err_msg_log

    IF (NOT cl_setup("CMX")) THEN         #抓取權限共用變數及模組變數(g_aza.*...)
       EXIT PROGRAM                       #判斷使用者執行程式權限
    END IF
    LET g_type = ARG_VAL(1)
    CALL cl_used(g_prog,g_time,1) RETURNING g_time

    LET g_bgjob = 'Y'

    CALL p100_deal()

    CALL cl_used(g_prog,g_time,2) RETURNING g_time


END MAIN



FUNCTION p100_deal()

    IF cl_null(g_type) THEN 
        DISPLAY '无类型信息'
        RETURN 
    END IF 
    
    LET g_sql = "SELECT COUNT(*) FROM tc_zmxlog_file WHERE tc_zmxlog01 = '",g_plant,"'",
                " AND tc_zmxlog07 = '",g_type,"' AND tc_zmxlog08 = 'N' AND tc_zmxlog10 <= 10 "
    DECLARE p100_count CURSOR FROM g_sql
    LET g_sql = "SELECT distinct tc_zmxlog05 ",
                " FROM tc_zmxlog_file WHERE tc_zmxlog01 = '",g_plant,"' AND tc_zmxlog07 = '",g_type,"'",
                " AND tc_zmxlog08 = 'N' AND tc_zmxlog10 <= 10 ORDER BY tc_zmxlog05"
    DECLARE p100_cs01 CURSOR WITH hold FROM g_sql

    CASE 
       WHEN g_type = '01'  #料件自动同步
           CALL p100_ima_transf2scm()
       WHEN g_type = '02'  #部门自动同步
           CALL p100_gem_transf2scm()
       WHEN g_type = '03'  #人员自动同步
           CALL p100_gen_transf2scm()
       WHEN g_type = '04'  #客户自动同步
           CALL p100_occ_transf2scm()
       WHEN g_type = '05'  #供应商初始化
           CALL p100_pmc_transf2scm()
       WHEN g_type = '06'  #作业编号对应线边仓
           CALL p100_ecd_transf2scm()
#        WHEN '60'  #部门自动同步  --ok
#            CALL p100_gem_transf2scm()
#        WHEN '61'  #人员自动同步  --ok 
#            CALL p100_gen_transf2scm()
        WHEN '62'  #料件自动同步  --ok
            CALL p100_62ima_transf2scm()
#        WHEN '63'  #供应商自动同步     
#            CALL p100_pmc_transf2scm()
#        WHEN '001' #v4.0 初始化
#            CALL p1004_deal_all()
#        WHEN '011'  #料件初始化
#            CALL p1004_deal_ima()
#        WHEN '021'  #部门初始化
#            CALL p1004_deal_gem()
#        WHEN '031'  #人员初始化
#            CALL p1004_deal_gen()
#        WHEN '041'  #供应商初始化
#            CALL p1004_deal_pmc()   
#        WHEN '051'  #理由码初始化
#            CALL p1004_deal_azf()
        WHEN g_type = '098'  #采购单同步
            CALL p1004_deal_pmm()
        WHEN g_type = '099'  #工单同步
            CALL p1004_deal_sfb()
        WHEN g_type = 'DO2' OR g_type = 'DO3' OR g_type = 'MR1' OR g_type = 'ST1' OR g_type = 'PT1' OR g_type = 'DK1' OR g_type = 'OR1'      #出货通知单、发料需求、销退、仓退、倒扣、退料
            CALL p100_deal_task()
        WHEN g_type = '200' #工单发料需求同步初始化  
            CALL p100_deal_task_csfi510()
        WHEN g_type = 'MR-DK' #定时同步倒扣发料  
            CALL p100_deal_task_asfi514()   
#        WHEN '200'  #工单发料需求同步
#            CALL p1004_deal_tc_sft()
#        WHEN '100'  #工单发料套数更新
#            CALL upd_sfb_num()
        OTHERWISE EXIT CASE 
    END CASE 

END FUNCTION 

#FUNCTION p1004_deal_all()
#    CALL p1004_deal_ima()
#    CALL p1004_deal_gem()
#    CALL p1004_deal_gen()
#    call p1004_deal_pmc()
#    CALL p1004_deal_azf()
#END FUNCTION 


#FUNCTION p100_deal_ima()
#DEFINE l_ima01          LIKE ima_file.ima01
#
#    DECLARE p100_get_ima_cs CURSOR FOR 
#     SELECT ima01 FROM ima_file WHERE ima1010 = '1' AND imaacti = 'Y'
#
#    INITIALIZE l_ret TO NULL 
#    LET l_ret.success = 'Y'
#    LET l_ima01 = ''
#    DISPLAY ''
#    DISPLAY '-'*80
#    DISPLAY '料件资料同步开始:',g_today,' ',g_time
#    FOREACH p100_get_ima_cs INTO l_ima01
#
#        CALL cl_zmx_json_ima(l_ima01) RETURNING l_ret.*
#        IF l_ret.success = 'Y' THEN 
#            DISPLAY '料件:',l_ima01 CLIPPED,' Transf2SCM OK!'
#        ELSE 
#            DISPLAY '料件:',l_ima01 CLIPPED,' Transf2SCM FAILD!'
#        END IF 
#    END FOREACH 
#    DISPLAY '料件资料同步结束:',g_today,' ',g_time
#    DISPLAY '-'*80
#    DISPLAY ''
#
#END FUNCTION 
#
#
#FUNCTION p100_deal_gen()
#DEFINE l_gen01          LIKE gen_file.gen01
#
#    DECLARE p100_get_gen_cs CURSOR FOR 
#     SELECT gen01 FROM gen_file WHERE genacti = 'Y' 
#
#    INITIALIZE l_gen01 TO NULL
#    INITIALIZE l_ret TO NULL 
#    LET l_ret.success ='Y' 
#    
#    DISPLAY ''
#    DISPLAY '-'*80
#    DISPLAY '人员资料同步开始:',g_today,' ',g_time
#    FOREACH p100_get_gen_cs INTO l_gen01 
#
#        CALL cl_zmx_json_gen(l_gen01) RETURNING l_ret.*
#        IF l_ret.success = 'Y' THEN 
#            DISPLAY '工号:',l_gen01 CLIPPED,' Transf2SCM OK!'
#        ELSE 
#            DISPLAY '工号:',l_gen01 CLIPPED,' Transf2SCM FAILD!'
#        END IF 
#    END FOREACH 
#    DISPLAY '人员资料同步结束:',g_today,' ',g_time
#    DISPLAY '-'*80
#    DISPLAY ''
#
#END FUNCTION 
#
#FUNCTION p100_deal_gem()
#DEFINE l_gem01          LIKE gem_file.gem01
#
#    DECLARE p100_get_gem_cs CURSOR FOR 
#     SELECT gem01 FROM gem_file WHERE gemacti = 'Y' 
#
#    INITIALIZE l_gem01 TO NULL
#    INITIALIZE l_ret TO NULL 
#    LET l_ret.success ='Y' 
#    
#    DISPLAY ''
#    DISPLAY '-'*80
#    DISPLAY '部门资料同步开始:',g_today,' ',g_time
#    FOREACH p100_get_gem_cs INTO l_gem01 
#
#        CALL cl_zmx_json_gem(l_gem01) RETURNING l_ret.*
#        IF l_ret.success = 'Y' THEN 
#            DISPLAY '部门:',l_gem01 CLIPPED,' Transf2SCM OK!'
#        ELSE 
#            DISPLAY '部门:',l_gem01 CLIPPED,' Transf2SCM FAILD!'
#        END IF 
#    END FOREACH 
#    DISPLAY '部门资料同步结束:',g_today,' ',g_time
#    DISPLAY '-'*80
#    DISPLAY ''
#
#END FUNCTION 
#
#
#FUNCTION p100_deal_pmc()
#DEFINE l_pmc01          LIKE pmc_file.pmc01
#
#
#    DECLARE p100_get_pmc_cs CURSOR FOR 
#     SELECT pmc01 FROM pmc_file WHERE pmc05 = '1' AND pmcacti = 'Y'
#
#    INITIALIZE l_ret TO NULL 
#    LET l_pmc01 = ''
#    DISPLAY ''
#    DISPLAY '-'*80
#    DISPLAY '供应商资料同步开始:',g_today,' ',g_time
#    FOREACH p100_get_pmc_cs INTO l_pmc01 
#
#        CALL cl_zmx_json_pmc(l_pmc01) RETURNING l_ret.*
#        IF l_ret.success = 'Y' THEN 
#            DISPLAY '供应商:',l_pmc01 CLIPPED,' Transf2SCM OK!'
#        ELSE 
#            DISPLAY '供应商:',l_pmc01 CLIPPED,' Transf2SCM FAILD!'
#        END IF 
#
#    END FOREACH 
#    DISPLAY '供应商资料同步结束:',g_today,' ',g_time
#    DISPLAY '-'*80
#    DISPLAY ''
#
#
#END FUNCTION 


FUNCTION p100_ima_transf2scm()
DEFINE l_sql            STRING 
DEFINE l_ima01          LIKE ima_file.ima01
DEFINE l_time           LIKE type_file.chr100
DEFINE l_uptime         LIKE type_file.chr100

{
    LET l_sql = "SELECT COALESCE(MAX(GREATEST(NVL(CREATED_ON,TO_DATE('2000-01-01','yyyy-mm-dd hh24:mi:ss')), ",
                " NVL(UPDATED_ON,TO_DATE('2000-01-01','yyyy-mm-dd hh24:mi:ss')))),TO_DATE('2000-01-01', 'yyyy-mm-dd hh24:mi:ss')) ",
                " FROM scm4.MATERIAL"       #上线需调整用户名
    PREPARE p100_time_ima_prep1 FROM l_sql
    EXECUTE p100_time_ima_prep1 INTO l_time 

    IF cl_null(l_time) THEN LET l_time = '2000-01-01 00:00:00' END IF}

    LET l_sql = "select to_char(update_time,'yyyy-mm-dd`hh24:mi:ss'),CODE from (select CODE,update_time,row_number() over (partition by CODE order by update_time desc) rn ",
                " FROM t_material where attr1 = '0') ",
                " where rn = 1 order by update_time "
    DECLARE p100_get_ima_cs2 CURSOR FROM l_sql

    INITIALIZE l_ima01 TO NULL
    INITIALIZE l_uptime TO NULL
    FOREACH p100_get_ima_cs2 INTO l_uptime,l_ima01
        CALL cl_zmx_json_ima(l_ima01,l_uptime) RETURNING l_ret.*
        IF l_ret.success = 'Y' THEN
        	  UPDATE t_material SET attr1 = '1' WHERE code = l_ima01 AND group_code = g_plant AND attr1 = '0'
            DISPLAY '料件:',l_ima01 CLIPPED,' Transf2SCM OK!'
        ELSE
          IF l_ret.success = 'X' THEN 
          	UPDATE t_material SET attr1 = '2' WHERE code = l_ima01 AND group_code = g_plant AND attr1 = '0'
          END IF 
            DISPLAY '料件:',l_ima01 CLIPPED,' Transf2SCM FAILD!'
        END IF
    END FOREACH
    DISPLAY '料件资料同步结束:',g_today,' ',g_time
    DISPLAY '-'*80
   
END FUNCTION 


FUNCTION p100_62ima_transf2scm()
DEFINE l_sql            STRING 
DEFINE l_ima01          LIKE ima_file.ima01
DEFINE l_time           LIKE type_file.chr100
DEFINE l_uptime         LIKE type_file.chr100

    LET l_sql = "select to_char(imadate,'yyyy-mm-dd`hh24:mi:ss'),ima01 from ima_file where not exists(select 1 from scm4.MATERIAL M where m.code  = ima01 ) and ima1010 = '1' "
    DECLARE p100_get_62ima_cs2 CURSOR FROM l_sql

    INITIALIZE l_ima01 TO NULL
    INITIALIZE l_uptime TO NULL
    FOREACH p100_get_62ima_cs2 INTO l_uptime,l_ima01
         IF cl_null(l_uptime) THEN LET l_uptime = '2022-01-01 00:00:00' END IF
        CALL cl_zmx_json_ima(l_ima01,l_uptime) RETURNING l_ret.*
        IF l_ret.success = 'Y' THEN
            DISPLAY '料件:',l_ima01 CLIPPED,' Transf2SCM OK!'
        ELSE
            DISPLAY '料件:',l_ima01 CLIPPED,' Transf2SCM FAILD!'
        END IF
    END FOREACH
    DISPLAY '料件资料同步结束:',g_today,' ',g_time
    DISPLAY '-'*80
   
END FUNCTION 

FUNCTION p100_gem_transf2scm()
DEFINE l_sql            STRING 
DEFINE l_gem01          LIKE gem_file.gem01
DEFINE l_time           LIKE type_file.chr100
DEFINE l_uptime         LIKE type_file.chr100


    LET l_sql = "SELECT COALESCE(MAX(GREATEST(NVL(CREATED_ON,TO_DATE('2000-01-01','yyyy-mm-dd hh24:mi:ss')), ",
                " NVL(UPDATED_ON,TO_DATE('2000-01-01','yyyy-mm-dd hh24:mi:ss')))),TO_DATE('2000-01-01', 'yyyy-mm-dd hh24:mi:ss')) ",
                " FROM scm4.department"       #上线需调整用户名
    PREPARE p100_time_gem_prep1 FROM l_sql
    EXECUTE p100_time_gem_prep1 INTO l_time
    
    IF cl_null(l_time) THEN LET l_time = '2000-01-01 00:00:00' END IF


    LET l_sql = "select to_char(update_time,'yyyy-mm-dd`hh24:mi:ss'),CODE from (select CODE,update_time,row_number() over (partition by CODE order by update_time desc) rn ",
                " FROM t_department where update_time > to_date('",l_time,"','yyyy-mm-dd hh24:mi:ss')) ",
                " where rn = 1 order by update_time "
    DECLARE p100_get_gem_cs2 CURSOR FROM l_sql

    INITIALIZE l_gem01 TO NULL 
    INITIALIZE l_uptime TO NULL
    FOREACH p100_get_gem_cs2 INTO l_uptime,l_gem01 
        CALL cl_zmx_json_gem(l_gem01,l_uptime) RETURNING l_ret.*
        IF l_ret.success = 'Y' THEN 
            DISPLAY '部门:',l_gem01 CLIPPED,' Transf2SCM OK!'
        ELSE 
            DISPLAY '部门:',l_gem01 CLIPPED,' Transf2SCM FAILD!'
        END IF 
    END FOREACH 
    DISPLAY '部门资料同步结束:',g_today,' ',g_time
    DISPLAY '-'*80
END FUNCTION 

FUNCTION p100_gen_transf2scm()
DEFINE l_sql            STRING
DEFINE l_gen01          LIKE gen_file.gen01
DEFINE l_time           LIKE type_file.chr100
DEFINE l_uptime         LIKE type_file.chr100

    LET l_sql = "SELECT COALESCE(MAX(GREATEST(NVL(CREATED_ON,TO_DATE('2000-01-01','yyyy-mm-dd hh24:mi:ss')), ",
                " NVL(UPDATED_ON,TO_DATE('2000-01-01','yyyy-mm-dd hh24:mi:ss')))),TO_DATE('2000-01-01', 'yyyy-mm-dd hh24:mi:ss')) ",
                " FROM scm4.staff"       #上线需调整用户名
    PREPARE p100_time_gen_prep1 FROM l_sql
    EXECUTE p100_time_gen_prep1 INTO l_time
    
    IF cl_null(l_time) THEN LET l_time = '2000-01-01 00:00:00' END IF

    LET l_sql = "select to_char(update_time,'yyyy-mm-dd`hh24:mi:ss'),CODE from (select CODE,update_time,row_number() over (partition by CODE order by update_time desc) rn ",
                " FROM t_staff where update_time > to_date('",l_time,"','yyyy-mm-dd hh24:mi:ss') ) ",
                " where rn = 1 order by update_time "
    DECLARE p100_get_gen_cs2 CURSOR FROM l_sql

    INITIALIZE l_gen01 TO NULL
    INITIALIZE l_uptime TO NULL
    FOREACH p100_get_gen_cs2 INTO l_uptime,l_gen01
        CALL cl_zmx_json_gen(l_gen01,l_uptime) RETURNING l_ret.*
        IF l_ret.success = 'Y' THEN
            DISPLAY '员工:',l_gen01 CLIPPED,' Transf2SCM OK!'
        ELSE
            DISPLAY '员工:',l_gen01 CLIPPED,' Transf2SCM FAILD!'
        END IF
    END FOREACH
    DISPLAY '员工资料同步结束:',g_today,' ',g_time
    DISPLAY '-'*80
END FUNCTION

FUNCTION p100_occ_transf2scm()
DEFINE l_sql            STRING
DEFINE l_occ01          LIKE occ_file.occ01
DEFINE l_time           LIKE type_file.chr100
DEFINE l_uptime         LIKE type_file.chr100

    LET l_sql = "SELECT COALESCE(MAX(GREATEST(NVL(CREATED_ON,TO_DATE('2000-01-01','yyyy-mm-dd hh24:mi:ss')), ",
                " NVL(UPDATED_ON,TO_DATE('2000-01-01','yyyy-mm-dd hh24:mi:ss')))),TO_DATE('2000-01-01', 'yyyy-mm-dd hh24:mi:ss')) ",
                " FROM scm4.customer"       #上线需调整用户名
    PREPARE p100_time_occ_prep1 FROM l_sql
    EXECUTE p100_time_occ_prep1 INTO l_time
    
    IF cl_null(l_time) THEN LET l_time = '2000-01-01 00:00:00' END IF

    LET l_sql = "select to_char(update_time,'yyyy-mm-dd`hh24:mi:ss'),CODE from (select CODE,update_time,row_number() over (partition by CODE order by update_time desc) rn ",
                " FROM t_customer where update_time > to_date('",l_time,"','yyyy-mm-dd hh24:mi:ss')) ",
                " where rn = 1 order by update_time "
    DECLARE p100_get_occ_cs2 CURSOR FROM l_sql

    INITIALIZE l_occ01 TO NULL
    INITIALIZE l_uptime TO NULL
    FOREACH p100_get_occ_cs2 INTO l_uptime,l_occ01
        CALL cl_zmx_json_occ(l_occ01,l_uptime) RETURNING l_ret.*
        IF l_ret.success = 'Y' THEN
            DISPLAY '客户:',l_occ01 CLIPPED,' Transf2SCM OK!'
        ELSE
            DISPLAY '客户:',l_occ01 CLIPPED,' Transf2SCM FAILD!'
        END IF
    END FOREACH
    DISPLAY '客户资料同步结束:',g_today,' ',g_time
    DISPLAY '-'*80
END FUNCTION

FUNCTION p100_pmc_transf2scm()
DEFINE l_sql            STRING 
DEFINE l_pmc01          LIKE pmc_file.pmc01
DEFINE l_time           LIKE type_file.chr100
DEFINE l_uptime         LIKE type_file.chr100

    LET l_sql = "SELECT COALESCE(MAX(GREATEST(NVL(CREATED_ON,TO_DATE('2000-01-01','yyyy-mm-dd hh24:mi:ss')), ",
                " NVL(UPDATED_ON,TO_DATE('2000-01-01','yyyy-mm-dd hh24:mi:ss')))),TO_DATE('2000-01-01', 'yyyy-mm-dd hh24:mi:ss')) ",
                " FROM scm4.supplier"       #上线需调整用户名
    PREPARE p100_time_pmc_prep1 FROM l_sql
    EXECUTE p100_time_pmc_prep1 INTO l_time
    
    IF cl_null(l_time) THEN LET l_time = '2000-01-01 00:00:00' END IF
    
    LET l_sql = "select to_char(update_time,'yyyy-mm-dd`hh24:mi:ss'),CODE from (select CODE,update_time,row_number() over (partition by CODE order by update_time desc) rn ",
                " FROM t_supplier where update_time > to_date('",l_time,"','yyyy-mm-dd hh24:mi:ss')) ",
                " where rn = 1 order by update_time "
    DECLARE p100_get_pmc_cs2 CURSOR FROM l_sql

    INITIALIZE l_pmc01 TO NULL
    INITIALIZE l_uptime TO NULL
    FOREACH p100_get_pmc_cs2 INTO l_uptime,l_pmc01
        CALL cl_zmx_json_pmc(l_pmc01,l_uptime) RETURNING l_ret.*
        IF l_ret.success = 'Y' THEN
            DISPLAY '供应商:',l_pmc01 CLIPPED,' Transf2SCM OK!'
        ELSE
            DISPLAY '供应商:',l_pmc01 CLIPPED,' Transf2SCM FAILD!'
        END IF
    END FOREACH
    DISPLAY '供应商资料同步结束:',g_today,' ',g_time
    DISPLAY '-'*80
END FUNCTION 

#FUNCTION p100_pmm_transf2scm()
#DEFINE l_cnt            LIKE type_file.num5
#DEFINE l_sql            STRING
#DEFINE l_pmm01          LIKE pmm_file.pmm01
#DEFINE l_pmm18          LIKE pmm_file.pmm18
#DEFINE l_pmm25          LIKE pmm_file.pmm25
#DEFINE l_type           LIKE type_file.chr1
#
#    INITIALIZE l_cnt TO NULL 
#    INITIALIZE l_type TO NULL 
#
#    LET l_sql = "SELECT COUNT(1) FROM t_purchase_order ",
#                " WHERE group_code = '",g_plant CLIPPED,"'",
#                "   AND flag = '0'"
#    PREPARE p100_cnt_pmm_prep1 FROM l_sql
#    EXECUTE p100_cnt_pmm_prep1 INTO l_cnt 
#
#    IF l_cnt = 0 THEN
#        RETURN
#    END IF
#
#    LET l_sql = "SELECT doc_code,pro_type FROM t_purchase_order ",
#                " WHERE group_code = '",g_plant CLIPPED,"'",
#                "   AND flag = '0' "
#    DECLARE p100_get_pmm_cs2 CURSOR FROM l_sql
#
#    INITIALIZE l_pmm01 TO NULL
#    FOREACH p100_get_pmm_cs2 INTO l_pmm01,l_type
#
#        IF cl_null(l_type) THEN 
#            LET l_type = 0
#        END IF 
#
#        SELECT COUNT(1) INTO l_cnt FROM pmm_file WHERE pmm01 = l_pmm01
#        IF l_cnt = 0 THEN 
#            LET l_type  = 1
#            UPDATE t_purchase_order SET flag = '1'
#             WHERE doc_code = l_pmm01
#               AND group_code = g_plant
#            CONTINUE FOREACH
#        END IF 
#
#        SELECT pmm18,pmm25 INTO l_pmm18,l_pmm25 FROM pmm_file 
#         WHERE pmm01 = l_pmm01
#
#        IF l_pmm18 = 'Y' THEN 
#            LET l_type = 0
#        ELSE 
#            LET l_type = 1
#        END IF  
#
#        INITIALIZE l_ret TO NULL 
#        IF l_type = 0 THEN
#            CALL cl_zmx_json_pmmorder(l_pmm01) RETURNING l_ret.*
#        ELSE 
#            CALL cl_zmx_backpmm(l_pmm01) RETURNING l_ret.*
#        END IF 
#        IF l_ret.success = 'Y' THEN
#        UPDATE t_purchase_order SET flag = '1'
#         WHERE doc_code = l_pmm01
#           AND group_code = g_plant
#            DISPLAY '料件:',l_pmm01 CLIPPED,' Transf2SCM OK!'
#        ELSE
#            DISPLAY '料件:',l_pmm01 CLIPPED,' Transf2SCM FAILD!'
#        END IF
#    END FOREACH
#
#
#END FUNCTION 
#
#
#
#
#FUNCTION p1004_deal_ima()
#DEFINE l_ima01          LIKE ima_file.ima01
#
#    DECLARE p1004_get_ima_cs CURSOR FOR 
#     SELECT ima01 FROM ima_file WHERE ima1010 = '1' AND imaacti = 'Y' and ima08 
#     in ('P','M','S') AND ima01 not in (select code from  zmscm.material)
#
#    INITIALIZE l_ret TO NULL 
#    LET l_ret.success = 'Y'
#    LET l_ima01 = ''
#    DISPLAY ''
#    DISPLAY '-'*80
#    DISPLAY '料件资料同步开始:',g_today,' ',g_time
#    FOREACH p1004_get_ima_cs INTO l_ima01
#
#        CALL cjc_zmx_json_ima(l_ima01) RETURNING l_ret.*
#        IF l_ret.success = 'Y' THEN 
#            DISPLAY '料件:',l_ima01 CLIPPED,' Transf2SCM OK!'
#        ELSE 
#            DISPLAY '料件:',l_ima01 CLIPPED,' Transf2SCM FAILD!'
#        END IF 
#    END FOREACH 
#    DISPLAY '料件资料同步结束:',g_today,' ',g_time
#    DISPLAY '-'*80
#    DISPLAY ''
#
#END FUNCTION 
#
#
#FUNCTION p1004_deal_gen()
#DEFINE l_gen01          LIKE gen_file.gen01
#
#    DECLARE p1004_get_gen_cs CURSOR FOR 
#     SELECT gen01 FROM gen_file WHERE genacti = 'Y' 
#
#    INITIALIZE l_gen01 TO NULL
#    INITIALIZE l_ret TO NULL 
#    LET l_ret.success ='Y' 
#    
#    DISPLAY ''
#    DISPLAY '-'*80
#    DISPLAY '人员资料同步开始:',g_today,' ',g_time
#    FOREACH p1004_get_gen_cs INTO l_gen01 
#
#        CALL cjc_zmx_json_gen(l_gen01) RETURNING l_ret.*
#        IF l_ret.success = 'Y' THEN 
#            DISPLAY '工号:',l_gen01 CLIPPED,' Transf2SCM OK!'
#        ELSE 
#            DISPLAY '工号:',l_gen01 CLIPPED,' Transf2SCM FAILD!'
#        END IF 
#    END FOREACH 
#    DISPLAY '人员资料同步结束:',g_today,' ',g_time
#    DISPLAY '-'*80
#    DISPLAY ''
#
#END FUNCTION 
#
#FUNCTION p1004_deal_gem()
#DEFINE l_gem01          LIKE gem_file.gem01
#
#    DECLARE p1004_get_gem_cs CURSOR FOR 
#     SELECT gem01 FROM gem_file WHERE gemacti = 'Y' 
#
#    INITIALIZE l_gem01 TO NULL
#    INITIALIZE l_ret TO NULL 
#    LET l_ret.success ='Y' 
#    
#    DISPLAY ''
#    DISPLAY '-'*80
#    DISPLAY '部门资料同步开始:',g_today,' ',g_time
#    FOREACH p1004_get_gem_cs INTO l_gem01 
#
#        CALL cjc_zmx_json_gem(l_gem01) RETURNING l_ret.*
#        IF l_ret.success = 'Y' THEN 
#            DISPLAY '部门:',l_gem01 CLIPPED,' Transf2SCM OK!'
#        ELSE 
#            DISPLAY '部门:',l_gem01 CLIPPED,' Transf2SCM FAILD!'
#        END IF 
#    END FOREACH 
#    DISPLAY '部门资料同步结束:',g_today,' ',g_time
#    DISPLAY '-'*80
#    DISPLAY ''
#
#END FUNCTION 
#
#
#FUNCTION p1004_deal_pmc()
#DEFINE l_pmc01          LIKE pmc_file.pmc01
#
#
#    DECLARE p1004_get_pmc_cs CURSOR FOR 
#     SELECT pmc01 FROM pmc_file WHERE pmcacti = 'Y'
#
#    INITIALIZE l_ret TO NULL 
#    LET l_pmc01 = ''
#    DISPLAY ''
#    DISPLAY '-'*80
#    DISPLAY '供应商资料同步开始:',g_today,' ',g_time
#    FOREACH p1004_get_pmc_cs INTO l_pmc01 
#
#        CALL cjc_zmx_json_pmc(l_pmc01) RETURNING l_ret.*
#        IF l_ret.success = 'Y' THEN 
#            DISPLAY '供应商:',l_pmc01 CLIPPED,' Transf2SCM OK!'
#        ELSE 
#            DISPLAY '供应商:',l_pmc01 CLIPPED,' Transf2SCM FAILD!'
#        END IF 
#
#    END FOREACH 
#    DISPLAY '供应商资料同步结束:',g_today,' ',g_time
#    DISPLAY '-'*80
#    DISPLAY ''
#
#
#END FUNCTION 
#
#
#FUNCTION p1004_deal_azf()
#DEFINE l_azf01          LIKE azf_file.azf01
#
#
#    DECLARE p1004_get_azf_cs CURSOR FOR 
#     SELECT distinct azf01 FROM azf_file WHERE azf02 = '2' AND azfacti = 'Y' 
#    INITIALIZE l_ret TO NULL 
#    LET l_azf01 = ''
#    DISPLAY ''
#    DISPLAY '-'*80
#    DISPLAY '理由码资料同步开始:',g_today,' ',g_time
#    FOREACH p1004_get_azf_cs INTO l_azf01 
#
#        CALL cjc_zmx_json_azf(l_azf01) RETURNING l_ret.*
#        IF l_ret.success = 'Y' THEN 
#            DISPLAY '理由码:',l_azf01 CLIPPED,' Transf2SCM OK!'
#        ELSE 
#            DISPLAY '理由码:',l_azf01 CLIPPED,' Transf2SCM FAILD!'
#        END IF 
#
#    END FOREACH 
#    DISPLAY '理由码资料同步结束:',g_today,' ',g_time
#    DISPLAY '-'*80
#    DISPLAY ''
#
#
#END FUNCTION 
#
#
FUNCTION p1004_deal_pmm()
DEFINE l_pmm01          LIKE pmm_file.pmm01
    DECLARE p1004_get_pmm_cs CURSOR FOR 
    #SELECT distinct pmm01 FROM pmm_file WHERE pmm25 = '2' and pmmacti = 'Y' 
    #and pmm01 not in (select SOURCE_CODE  from zmscm.PURCHASE_ORDER ) 
    #and pmm04 >=to_date('200301','yymmdd') 
    select distinct pmm01 from pmn_file,pmm_file,pmc_file where pmn16 not in('6','7','8','9') and pmn20+pmn58+pmn55-pmn50 > 0  and pmm01= pmn01 
    -- and pmn04 like 'M%' AND pmm04>=TO_DATE('2019-01-01','yyyy-mm-dd hh24:mi:ss') 
    and pmm09 in(SELECT t_pmc01 FROM t_pmc ) and pmm09 = pmc01 and pmm02='SUB'
    -- and exists(select * from scm4.purchase_order p,scm4.PURCHASE_ORDER_D d where p.code = d.code and d.source_code = pmm01)
    order by pmm01
 
    INITIALIZE l_ret TO NULL 
    LET l_pmm01 = ''
    DISPLAY ''
    DISPLAY '-'*80
    DISPLAY '采购单资料同步开始:',g_today,' ',g_time
    FOREACH p1004_get_pmm_cs INTO l_pmm01 
        CALL cjc_zmx_json_pmmorder(l_pmm01) RETURNING l_ret.*
        IF l_ret.success = 'Y' THEN 
            DISPLAY '采购单:',l_pmm01 CLIPPED,' Transf2SCM OK!'
        ELSE 
            DISPLAY '采购单:',l_pmm01 CLIPPED,' Transf2SCM FAILD!'
        END IF 
    END FOREACH 
    DISPLAY '采购单资料同步结束:',g_today,' ',g_time
    DISPLAY '-'*80
    DISPLAY ''
END FUNCTION 


FUNCTION p1004_deal_sfb()
DEFINE l_cnt          LIKE type_file.num5,
       l_sfb01        LIKE sfb_file.sfb01

    DECLARE p1004_get_sfb_cs CURSOR FOR 
    SELECT distinct sfb01 FROM sfb_file WHERE sfb04 in('2','3','4','5','6','7')
    AND sfb01 NOT IN(SELECT work_no FROM scm4.PRO_WORK_TASK)
 
    INITIALIZE l_ret TO NULL 
    LET l_sfb01 = ''
    DISPLAY ''
    DISPLAY '-'*80
    DISPLAY '工单资料同步开始:',g_today,' ',g_time
  INITIALIZE l_sfb01 TO NULL
  FOREACH p1004_get_sfb_cs INTO l_sfb01 
    IF STATUS THEN EXIT FOREACH END IF 
    CALL cjc_zmx_json_sfb(l_sfb01) RETURNING l_ret.*
    IF l_ret.success = 'Y' THEN 
      DISPLAY '工单:',l_sfb01 CLIPPED,' Transf2SCM OK!'
    ELSE 
      DISPLAY '工单:',l_sfb01 CLIPPED,' Transf2SCM FAILD!'
    END IF 
  END FOREACH

END FUNCTION 
#
#
#FUNCTION upd_sfb_num()
#DEFINE  l_sql STRING 
#
#drop table sfb_in
#LET l_sql = "
#create  table sfb_in as 
#select * from (
#select sfa01,sfb081,ceil(min(sfa06/sfa05*sfb08)) b from sfa_file,sfb_file where sfb01=sfa01 and sfb87 = 'Y' and sfb04 < 8 and sfa11='N' AND sfa05>0 and sfb13 >=to_date('191001','yymmdd') and sfb04 in('4','7','8')  GROUP BY SFA01,sfb081 
#) where sfb081 <> b  " 
#PREPARE execpre FROM l_sql 
#EXECUTE execpre 
#
#LET l_sql = "update sfb_file s  set sfb081 = (select b from sfb_in h where h.sfa01 = s.sfb01 ) where sfb01 in (select sfa01 from sfb_in )"
#
#PREPARE execpre1 FROM l_sql 
#EXECUTE execpre1
#
#END FUNCTION 
#
#
#FUNCTION p1004_deal_tc_sft() 
#
#DEFINE l_tc_sft01          LIKE tc_sft_file.tc_sft01
#DEFINE l_tc_sft06          LIKE tc_sft_file.tc_sft06 
#    DECLARE p1004_get_tc_sft_cs CURSOR FOR 
#   select tc_sft01 from tc_sft_file A
#  where NOT EXISTS (select  source_code from zmscm.task_sheet WHERE  source_code = A.TC_SFT01) AND tc_sft02>=to_date('200501','yymmdd')
# #  select tc_sft01 from tc_sft_file A
# #where tc_sft06='N' AND tc_sft02>=to_date('191001','yymmdd')
#    LET l_tc_sft01 = ''
#    DISPLAY ''
#    DISPLAY '-'*80
#    DISPLAY '发料资料同步开始:',g_today,' ',g_time
#    FOREACH p1004_get_tc_sft_cs INTO l_tc_sft01 
#        select tc_sft06 into l_tc_sft06 from tc_sft_file where tc_sft01=l_tc_sft01
#        IF l_tc_sft06 = 'N' THEN 
#        CALL cjc_zmx_json_task('MR1',l_tc_sft01) RETURNING l_ret.*
#        IF l_ret.success = 'Y' THEN 
#            DISPLAY '发料:',l_tc_sft01 CLIPPED,' Transf2SCM OK!'
#        ELSE 
#            DISPLAY '发料:',l_tc_sft01 CLIPPED,' Transf2SCM FAILD!'
#        END IF 
#        END IF 
#
#    END FOREACH 
#    DISPLAY '发料资料同步结束:',g_today,' ',g_time
#    DISPLAY '-'*80
#    DISPLAY ''
#END FUNCTION 

FUNCTION p100_ecd_transf2scm()
DEFINE l_sql            STRING 
DEFINE l_ecd01          LIKE ecd_file.ecd01
DEFINE l_time           LIKE type_file.chr100
DEFINE l_uptime         LIKE type_file.chr100


    LET l_sql = "SELECT COALESCE(MAX(GREATEST(NVL(CREATED_ON,TO_DATE('2000-01-01','yyyy-mm-dd hh24:mi:ss')), ",
                " NVL(UPDATED_ON,TO_DATE('2000-01-01','yyyy-mm-dd hh24:mi:ss')))),TO_DATE('2000-01-01', 'yyyy-mm-dd hh24:mi:ss')) ",
                " FROM scm4.WMS_MAH_TC"       #上线需调整用户名
    PREPARE p100_time_ecd_prep1 FROM l_sql
    EXECUTE p100_time_ecd_prep1 INTO l_time
    
    IF cl_null(l_time) THEN LET l_time = '2000-01-01 00:00:00' END IF


    LET l_sql = "select to_char(update_time,'yyyy-mm-dd`hh24:mi:ss'),CODE from (select CODE,update_time,row_number() over (partition by CODE order by update_time desc) rn ",
                " FROM t_ecd where update_time > to_date('",l_time,"','yyyy-mm-dd hh24:mi:ss')) ",
                " where rn = 1 order by update_time "
    DECLARE p100_get_ecd_cs2 CURSOR FROM l_sql

    INITIALIZE l_ecd01 TO NULL 
    INITIALIZE l_uptime TO NULL
    FOREACH p100_get_ecd_cs2 INTO l_uptime,l_ecd01 
        CALL cl_zmx_json_ecd(l_ecd01,l_uptime) RETURNING l_ret.*
        IF l_ret.success = 'Y' THEN 
            DISPLAY '作业编号:',l_ecd01 CLIPPED,' Transf2SCM OK!'
        ELSE 
            DISPLAY '作业编号:',l_ecd01 CLIPPED,' Transf2SCM FAILD!'
        END IF 
    END FOREACH 
    DISPLAY '作业编号资料同步结束:',g_today,' ',g_time
    DISPLAY '-'*80
END FUNCTION 

FUNCTION p100_deal_task()
DEFINE l_cnt          LIKE type_file.num5,
       l_doc          LIKE type_file.chr100
  OPEN p100_count
  FETCH p100_count INTO l_cnt
  IF l_cnt = 0 THEN RETURN END IF 
  INITIALIZE l_doc TO NULL
  FOREACH p100_cs01 INTO l_doc
    IF STATUS THEN EXIT FOREACH END IF 
    CALL cjc_zmx_json_task(g_type,l_doc) RETURNING l_ret.*
    IF l_ret.success = 'Y' THEN 
      DISPLAY '单据:',l_doc CLIPPED,' Transf2SCM OK!'
    ELSE 
      DISPLAY '单据:',l_doc CLIPPED,' Transf2SCM FAILD!'
    END IF 
  END FOREACH
END FUNCTION 

#工单发料初始化   注意调整需求单同步中申请量逻辑 取视图view_df
FUNCTION p100_deal_task_csfi510()
DEFINE l_cnt          LIKE type_file.num5,
       l_doc          LIKE type_file.chr100
  
DECLARE p100_deal_task_csfi510_cs CURSOR FOR 
  SELECT DISTINCT tc_sfd01 FROM view_df where tc_sfd01 not in('SQA-21071666','SQA-21061203')
 #SELECT DISTINCT tc_sfd01 FROM view_df where tc_sfd01 in('SQA-22040537')
  AND NOT EXISTS (SELECT 1 FROM scm4.task_sheet t WHERE t.source_code = tc_sfd01)
  INITIALIZE l_doc TO NULL
  FOREACH p100_deal_task_csfi510_cs INTO l_doc
    IF STATUS THEN EXIT FOREACH END IF 
    CALL cjc_zmx_json_task('MR1',l_doc) RETURNING l_ret.*
    IF l_ret.success = 'Y' THEN 
      DISPLAY '单据:',l_doc CLIPPED,' Transf2SCM OK!'
    ELSE 
      DISPLAY '单据:',l_doc CLIPPED,' Transf2SCM FAILD!'
    END IF 
  END FOREACH
END FUNCTION 

#倒扣料同步
FUNCTION p100_deal_task_asfi514()
DEFINE l_cnt          LIKE type_file.num5,
       l_doc          LIKE type_file.chr100
DECLARE p100_deal_task_asfi514_cs CURSOR FOR 
 SELECT DISTINCT sfp01 FROM sfp_file WHERE  sfp02>= to_date('220502','yymmdd') AND 
  NOT EXISTS (SELECT 1 FROM scm4.task_sheet t WHERE t.source_code = sfp01) AND sfp06='4' AND sfp04='Y'   
  #AND sfp01='MRE-2205M03X'
  INITIALIZE l_doc TO NULL
  FOREACH p100_deal_task_asfi514_cs INTO l_doc
    IF STATUS THEN EXIT FOREACH END IF 
    CALL cjc_zmx_json_task('DK1',l_doc) RETURNING l_ret.*
    IF l_ret.success = 'Y' THEN 
      DISPLAY '单据:',l_doc CLIPPED,' Transf2SCM OK!'
    ELSE 
      DISPLAY '单据:',l_doc CLIPPED,' Transf2SCM FAILD!'
    END IF 
  END FOREACH
END FUNCTION 

