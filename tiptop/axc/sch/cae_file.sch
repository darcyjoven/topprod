/*
================================================================================
檔案代號:cae_file
檔案名稱:每月人工/制费档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cae_file
(
cae01       number(5) NOT NULL,      /*年度                                   */
cae02       number(5) NOT NULL,      /*月份                                   */
cae03       varchar2(10) NOT NULL,   /*成本中心                               */
cae04       varchar2(10) NOT NULL,   /*成本项目                               */
cae05       number(20,6) NOT NULL,   /*成本                                   */
cae06       number(15,3) NOT NULL,   /*分摊基础指标总数                       */
                                     /*例如,總係數,總實際工時,總標準工時      */
cae07       number(20,6) NOT NULL,   /*单位成本                               */
                                     /*單位成本 (cae05/cae06)                 */
cae08       varchar2(1) NOT NULL,    /*分摊方式                               */
                                     /*1=Actual Work Hour                     */
                                     /*2=Standard Work Hour                   */
                                     /*3=Produce Qty                          */
caeuser     varchar2(10),            /*资料所有者                             */
caegrup     varchar2(10),            /*资料所有部门                           */
caemodu     varchar2(10),            /*资料更改者                             */
caedate     date,                    /*最近更改日                             */
cae09       varchar2(1),             /*制费类别                               */
cae10       number(15,3),            /*标准产能                               */
cae11       number(20,6),            /*闲置制费                               */
cae041      varchar2(1) NOT NULL,    /*成本分类                               */
caeorig     varchar2(10),            /*资料建立部门                           */
caeoriu     varchar2(10),            /*资料建立者                             */
caelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cae_file add  constraint cae_pk primary key  (cae01,cae02,cae03,cae04,cae041,cae08) enable validate;
grant select on cae_file to tiptopgp;
grant update on cae_file to tiptopgp;
grant delete on cae_file to tiptopgp;
grant insert on cae_file to tiptopgp;
grant index on cae_file to public;
grant select on cae_file to ods;
