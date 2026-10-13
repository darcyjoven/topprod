/*
================================================================================
檔案代號:caa_file
檔案名稱:成本分摊方式资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table caa_file
(
caa01       varchar2(10) NOT NULL,   /*成本中心                               */
caa02       varchar2(10) NOT NULL,   /*成本项目                               */
                                     /*成本項目                               */
caa04       varchar2(1) NOT NULL,    /*成本分类                               */
                                     /*成本分類                               */
                                     /*1.人工成本                             */
                                     /*2.製造費用                             */
caa05       varchar2(24) NOT NULL,   /*会计科目                               */
                                     /*會計科目                               */
caa06       varchar2(1),             /*分摊方式                               */
                                     /*分攤方式                               */
                                     /*1.實際工時                             */
                                     /*2.標準工時                             */
                                     /*3.產出數量x分攤權數                    */
caa07       varchar2(1),             /*制费类别                               */
caa08       number(15,3),            /*标准产能                               */
caa09       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
caa10       varchar2(10) DEFAULT ' ' NOT NULL /*部门编号*/
);

alter table caa_file add  constraint caa_pk primary key  (caa01,caa02,caa04,caa05,caa09,caa10) enable validate;
grant select on caa_file to tiptopgp;
grant update on caa_file to tiptopgp;
grant delete on caa_file to tiptopgp;
grant insert on caa_file to tiptopgp;
grant index on caa_file to public;
grant select on caa_file to ods;
