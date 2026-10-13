/*
================================================================================
檔案代號:lrl_file
檔案名稱:换物单记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrl_file
(
lrl00       varchar2(10),            /*兑换方案制订营运中心                   */
lrl01       varchar2(20) DEFAULT ' ' NOT NULL, /*积分换物单编号*/
lrl02       varchar2(30),            /*卡号                                   */
lrl03       varchar2(16),            /*卡种编号                               */
lrl04       varchar2(20),            /*会员编号                               */
lrl05       varchar2(16),            /*方案编号                               */
lrl06       number(12) DEFAULT '0' NOT NULL, /*可兑换积分*/
lrl07       number(12) DEFAULT '0' NOT NULL, /*兑换积分*/
lrl071      number(12) DEFAULT '0' NOT NULL, /*总兑换积分*/
lrl08       varchar2(20),            /*兑换赠品编号                           */
lrl09       number(12) DEFAULT '0' NOT NULL, /*兑换份数*/
lrl10       number(12) DEFAULT '0' NOT NULL, /*剩余积分*/
lrl11       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lrl12       varchar2(10),            /*审核人                                 */
lrl13       date,                    /*审核日期                               */
lrlacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lrlcrat     date,                    /*资料创建日                             */
lrldate     date,                    /*最近更改日                             */
lrlgrup     varchar2(10),            /*资料所有群                             */
lrllegal    varchar2(10) NOT NULL,   /*所属法人                               */
lrlmodu     varchar2(10),            /*资料更改者                             */
lrlplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lrluser     varchar2(10),            /*资料所有者                             */
lrloriu     varchar2(10),            /*资料建立者                             */
lrlorig     varchar2(10),            /*资料建立部门                           */
lrl14       varchar2(20),            /*销售/杂发单号                          */
lrl15       varchar2(1) DEFAULT '0' NOT NULL, /*兑换来源*/
                                     /*0.积分换物, 1.累计消费额换物           */
lrl16       number(20,6) DEFAULT '0' NOT NULL, /*可兑换累计消费额*/
                                     /*0.消费日当天, 1.会员累计消费额         */
lrl17       number(5)                /*兑换方案版本号                         */
);

alter table lrl_file add  constraint lrl_pk primary key  (lrl01) enable validate;
grant select on lrl_file to tiptopgp;
grant update on lrl_file to tiptopgp;
grant delete on lrl_file to tiptopgp;
grant insert on lrl_file to tiptopgp;
grant index on lrl_file to public;
grant select on lrl_file to ods;
