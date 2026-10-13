/*
================================================================================
檔案代號:rqb_file
檔案名稱:粗略产能资源耗用明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rqb_file
(
rqb01       varchar2(10),            /*资源编号                               */
                                     /*資源代號                               */
rqb02       varchar2(10),            /*版本                                   */
rqb03       date,                    /*起始日期                               */
rqb04       date,                    /*截止日期                               */
rqb05       varchar2(2),             /*来源类型                               */
                                     /*來源類別                               */
                                     /*'64': 工單在製                         */
                                     /*'65': MPS 計劃產                       */
                                     /*'66': PLM 預計產                       */
rqb06       varchar2(20),            /*来源单号                               */
                                     /*來源單號                               */
rqb061      number(5),               /*来源项次                               */
                                     /*來源項次                               */
rqb062      date,                    /*供需日期                               */
                                     /*供需日期 (依時距推算)                  */
rqb063      date,                    /*预计开工日                             */
                                     /*預計開工日                             */
rqb064      date,                    /*预计完工日                             */
                                     /*預計完工日                             */
rqb065      varchar2(40),            /*料号                                   */
                                     /*料號                                   */
rqb08       number(15,3),            /*数量                                   */
                                     /*數量                                   */
rqb09       number(15,3),            /*耗用产能                               */
                                     /*秏用產能                               */
rqbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rqblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index rqb_01 on rqb_file (rqb01,rqb02,rqb03,rqb04);
grant select on rqb_file to tiptopgp;
grant update on rqb_file to tiptopgp;
grant delete on rqb_file to tiptopgp;
grant insert on rqb_file to tiptopgp;
grant index on rqb_file to public;
grant select on rqb_file to ods;
