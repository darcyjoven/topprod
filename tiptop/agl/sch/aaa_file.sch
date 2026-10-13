/*
================================================================================
檔案代號:aaa_file
檔案名稱:账套参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table aaa_file
(
aaa01       varchar2(5) NOT NULL,    /*帐套编号                               */
aaa02       varchar2(80),            /*帐套名称                               */
aaa03       varchar2(4),             /*使用币种                               */
aaa04       number(5),               /*现行会计年度                           */
aaa05       number(5),               /*现行期别                               */
aaa06       date,                    /*最后过帐日期                           */
aaa07       date,                    /*关帐日期                               */
aaa08       number(5),               /*No Use                                 */
aaaacti     varchar2(1),             /*资料有效码                             */
aaauser     varchar2(10),            /*资料所有者                             */
aaagrup     varchar2(10),            /*资料所有群                             */
aaamodu     varchar2(10),            /*资料更改者                             */
aaadate     date,                    /*最近更改日                             */
aaa09       varchar2(1),             /*月结方式                               */
aaa10       varchar2(1),             /*年结方式                               */
aaaoriu     varchar2(10),            /*资料建立者                             */
aaaorig     varchar2(10),            /*资料建立部门                           */
aaa11       varchar2(24),            /*汇兑损失科目                           */
aaa12       varchar2(24),            /*汇兑收益科目                           */
aaa14       varchar2(24),            /*本年利潤-表結法(收入類)                */
aaa15       varchar2(24),            /*本年利潤-表結法(成本類)                */
aaa16       varchar2(24),            /*本年利潤-賬結法                        */
aaa13       varchar2(1) DEFAULT ' ' NOT NULL, /*是否抛转立冲账明细*/
aaa17       varchar2(10) DEFAULT ' ' NOT NULL /*编制合并报表营运中心*/
);

alter table aaa_file add  constraint aaa_pk primary key  (aaa01) enable validate;
grant select on aaa_file to tiptopgp;
grant update on aaa_file to tiptopgp;
grant delete on aaa_file to tiptopgp;
grant insert on aaa_file to tiptopgp;
grant index on aaa_file to public;
grant select on aaa_file to ods;
