/*
================================================================================
檔案代號:pmj_file
檔案名稱:采购核价单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmj_file
(
pmj01       varchar2(20) NOT NULL,   /*核价单号                               */
                                     /*核價單號                               */
pmj02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
pmj03       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
pmj031      varchar2(120),           /*品名                                   */
                                     /*品名  00/04/06 add                     */
pmj032      varchar2(120),           /*规格                                   */
pmj04       varchar2(40),            /*厂商料件                               */
pmj05       varchar2(4),             /*币种                                   */
pmj06       number(20,6),            /*原税前单价                             */
pmj07       number(20,6),            /*新税前单价                             */
pmj08       date,                    /*原核准日                               */
pmj09       date,                    /*新核准日                               */
pmj10       varchar2(6) NOT NULL,    /*作业编号                               */
pmj06t      number(20,6),            /*原含税单价                             */
pmj07t      number(20,6),            /*新含税单价                             */
pmj11       varchar2(10),            /*工艺说明                               */
pmj12       varchar2(1) NOT NULL,    /*价格类型                               */
                                     /*1.P/O  2. Subcontracting               */
pmj13       varchar2(10) NOT NULL,   /*工艺单元编号,为空代表此笔数            */
pmjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pmjlegal    varchar2(10) NOT NULL,   /*所属法人                               */
pmj14       varchar2(15),            /*电子采购序号                           */
pmjicd14    varchar2(1),             /*等级                                   */
ta_pmj01    varchar2(20),
ta_pmj02    varchar2(20),
ta_pmj03    varchar2(20),
ta_pmj04    date,
ta_pmj05    number(20,6),
ta_pmj06    number(20,6),
ta_pmj07    varchar2(20),
ta_pmj08    varchar2(20),
ta_pmj09    varchar2(20),
ta_pmj10    varchar2(20),
ta_pmj11    number(20,6),
ta_pmj12    number(20,6),
ta_pmj13    number(20,6),
ta_pmj14    date,
ta_pmj15    date
);

alter table pmj_file add  constraint pmj_pk primary key  (pmj01,pmj02,pmj10,pmj12,pmj13) enable validate;
grant select on pmj_file to tiptopgp;
grant update on pmj_file to tiptopgp;
grant delete on pmj_file to tiptopgp;
grant insert on pmj_file to tiptopgp;
grant index on pmj_file to public;
grant select on pmj_file to ods;
