/*
================================================================================
檔案代號:lpq_file
檔案名稱:换物设定单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lpq_file
(
lpq01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
lpq02       varchar2(50),            /*方案说明                               */
lpq03       varchar2(20) DEFAULT ' ' NOT NULL, /*卡种编号*/
lpq04       date,                    /*起始日期                               */
lpq05       date,                    /*终止日期                               */
lpq06       varchar2(1) DEFAULT ' ' NOT NULL, /*签核否*/
lpq07       varchar2(1) DEFAULT ' ' NOT NULL, /*签核状态*/
lpq08       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lpq09       varchar2(10),            /*审核人                                 */
lpq10       date,                    /*审核日期                               */
lpq11       varchar2(50),            /*备注                                   */
lpqacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lpqcrat     date,                    /*资料创建日                             */
lpqdate     date,                    /*最近更改日                             */
lpqgrup     varchar2(10),            /*资料所有群                             */
lpqmodu     varchar2(10),            /*资料更改者                             */
lpquser     varchar2(10),            /*资料所有者                             */
lpqoriu     varchar2(10),            /*资料建立者                             */
lpqorig     varchar2(10),            /*资料建立部门                           */
lpqlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lpqplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lpqpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
lpq00       varchar2(1) DEFAULT '1' NOT NULL, /*兑换来源*/
                                     /*0.积分换物, 1.累计消费额换物           */
lpq12       varchar2(1) DEFAULT '0' NOT NULL, /*累计消费额方式*/
                                     /*0.消费日当天, 1.会员累计消费额         */
lpq13       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lpq14       number(5) DEFAULT '0' NOT NULL, /*版本号*/
lpq15       varchar2(1) DEFAULT ' ' NOT NULL, /*发布否*/
lpq16       date,                    /*发布日期                               */
lpq17       varchar2(1) DEFAULT ' ' NOT NULL, /*兑换限制*/
lpq18       number(5)                /*兑换次数                               */
);

alter table lpq_file add  constraint lpq_pk primary key  (lpq00,lpq01,lpq03,lpq13,lpqplant) enable validate;
grant select on lpq_file to tiptopgp;
grant update on lpq_file to tiptopgp;
grant delete on lpq_file to tiptopgp;
grant insert on lpq_file to tiptopgp;
grant index on lpq_file to public;
grant select on lpq_file to ods;
