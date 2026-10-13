/*
================================================================================
檔案代號:rbk_file
檔案名稱:促销变更生失效时段配置文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rbk_file
(
rbk01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rbk02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rbk03       number(5) DEFAULT '0' NOT NULL, /*变更序号*/
rbk04       number(5) DEFAULT '0' NOT NULL, /*序号*/
rbk05       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
rbk06       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
rbk07       number(5) DEFAULT '0' NOT NULL, /*组别*/
rbk08       number(5) DEFAULT '0' NOT NULL,
rbk09       date,                    /*促销开始日期                           */
rbk10       date,                    /*促销结束日期                           */
rbk11       varchar2(8),
rbk12       varchar2(8),
rbk13       varchar2(2),
rbk14       varchar2(1) DEFAULT ' ' NOT NULL,
rbkacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rbkcrdate   date,
rbkdate     date,                    /*最近更改日                             */
rbkgrup     varchar2(10),            /*资料所有群                             */
rbklegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rbkmodu     varchar2(10),            /*资料更改者                             */
rbkorig     varchar2(10),            /*资料建立部门                           */
rbkoriu     varchar2(10),            /*资料建立者                             */
rbkplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rbkpos      varchar2(1) DEFAULT ' ' NOT NULL, /*已传POS否*/
rbkuser     varchar2(10)             /*资料所有者                             */
);

alter table rbk_file add  constraint rbk_pk primary key  (rbk01,rbk02,rbk03,rbk04,rbk05,rbk06,rbk07,rbk08,rbkplant) enable validate;
grant select on rbk_file to tiptopgp;
grant update on rbk_file to tiptopgp;
grant delete on rbk_file to tiptopgp;
grant insert on rbk_file to tiptopgp;
grant index on rbk_file to public;
grant select on rbk_file to ods;
