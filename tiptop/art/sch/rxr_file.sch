/*
================================================================================
檔案代號:rxr_file
檔案名稱:押金收取/退还资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rxr_file
(
rxr00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据别 1-收取 2-退还*/
                                     /*Doc Type 1-Recall 2-Return             */
rxr01       varchar2(20) DEFAULT ' ' NOT NULL, /*押金收取/退还单号*/
rxr02       varchar2(20),            /*来源单号                               */
rxr03       varchar2(20),            /*押金收取单号(只有单据别为2-            */
rxr04       varchar2(20),            /*预收单号                               */
rxr05       date,                    /*预还日期                               */
rxr06       varchar2(10),            /*顾客姓名                               */
rxr07       varchar2(20),            /*顾客电话                               */
rxr08       varchar2(1) DEFAULT ' ' NOT NULL, /*证件类型*/
rxr09       varchar2(20),            /*证件号码                               */
rxr10       varchar2(10),            /*经办人员                               */
rxr11       number(20,6) DEFAULT '0' NOT NULL, /*押金金额*/
rxr12       number(20,6) DEFAULT '0' NOT NULL, /*已退金额*/
rxr13       number(20,6) DEFAULT '0' NOT NULL, /*退还金额(只有单据别为2-退还 */
rxr14       varchar2(10),            /*理由码                                 */
rxr15       varchar2(255),           /*備注                                   */
rxracti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
rxrcond     date,                    /*审核日期                               */
rxrconf     varchar2(1) DEFAULT 'N' NOT NULL, /*审核码 Y-审核N-未审核*/
rxrconu     varchar2(10),            /*审核人员                               */
rxrcrat     date,                    /*资料创建日                             */
rxrdate     date,                    /*最近更改日                             */
rxrgrup     varchar2(10),            /*资料所有部门                           */
rxrlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rxrmodu     varchar2(10),            /*资料更改者                             */
rxrorig     varchar2(10),            /*资料建立部门                           */
rxroriu     varchar2(10),            /*资料建立者                             */
rxrplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rxruser     varchar2(10),            /*资料所有者                             */
rxr16       varchar2(20)             /*账款单号                               */
);

create unique index rxr_01 on rxr_file (rxr00,rxr01);
alter table rxr_file add  constraint rxr_pk primary key  (rxr00,rxr01) enable validate;
grant select on rxr_file to tiptopgp;
grant update on rxr_file to tiptopgp;
grant delete on rxr_file to tiptopgp;
grant insert on rxr_file to tiptopgp;
grant index on rxr_file to public;
grant select on rxr_file to ods;
