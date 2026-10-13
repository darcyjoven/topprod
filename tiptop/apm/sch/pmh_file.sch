/*
================================================================================
檔案代號:pmh_file
檔案名稱:供应厂商料件对应资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pmh_file
(
pmh01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
pmh02       varchar2(10) NOT NULL,   /*供应厂商编号                           */
                                     /*供應廠商編號                           */
pmh03       varchar2(1),             /*是否为主要供应厂商                     */
                                     /*是否為主要供應廠商(Y/N)                */
pmh04       varchar2(40),            /*厂商料件编号                           */
                                     /*廠商料件編號                           */
pmh05       varchar2(1),             /*核准状况码                             */
                                     /*核准狀況碼                             */
                                     /*0: 已核准  1.核准中  2.未核准          */
pmh06       date,                    /*核准日期                               */
pmh07       varchar2(24),            /*厂牌编号                               */
                                     /*廠牌編號                               */
pmh08       varchar2(1),             /*检验否                                 */
                                     /*檢驗否                                 */
                                     /*N: 免檢  Y:需入庫檢驗                  */
pmh09       varchar2(1),             /*检验程度                               */
                                     /*檢驗程度                               */
                                     /*N.正常檢驗 T.加嚴檢驗 R.減量檢驗       */
pmh10       date,                    /*免检核准日期                           */
                                     /*免檢核准日期                           */
pmh11       number(9,4),             /*分配比率                               */
                                     /*分配比率(%)                            */
pmh12       number(20,6),            /*最近采购单价                           */
                                     /*最近採購單價(原幣)             (97/07) */
pmh13       varchar2(4) NOT NULL,    /*采购币种                               */
                                     /*採購幣別                               */
pmh14       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
pmh15       varchar2(1),             /*检验水准                               */
                                     /*檢驗水準                               */
                                     /*1.一般    2.特殊                       */
pmh16       varchar2(1),             /*级数                                   */
                                     /*級數                                   */
pmhacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
pmhuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
pmhgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
pmhmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
pmhdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
pmh17       varchar2(4),             /*最近采购税种                           */
pmh18       number(9,4),             /*税率                                   */
pmh19       number(20,6),            /*最近采购含税单价                       */
pmh20       varchar2(1),             /*No Use                                 */
pmh21       varchar2(6) NOT NULL,    /*作业编号                               */
pmh22       varchar2(1) NOT NULL,    /*价格类型                               */
                                     /*1.P/O  2. Subcontracting               */
pmh23       varchar2(10) NOT NULL,   /*工艺单元编号,为空代表此笔数            */
pmh24       varchar2(1) DEFAULT 'N', /*VMI采购                                */
pmhorig     varchar2(10),            /*资料建立部门                           */
pmhoriu     varchar2(10),            /*资料建立者                             */
pmh25       varchar2(1) DEFAULT 'N' NOT NULL, /*电子采购料件*/
ta_pmh01    varchar2(1),             /*SPEC                                   */
ta_pmh02    varchar2(1),             /*SGS                                    */
ta_pmh03    varchar2(1)              /*MSDS                                   */
);

alter table pmh_file add  constraint pmh_pk primary key  (pmh01,pmh02,pmh13,pmh21,pmh22,pmh23) enable validate;
grant select on pmh_file to tiptopgp;
grant update on pmh_file to tiptopgp;
grant delete on pmh_file to tiptopgp;
grant insert on pmh_file to tiptopgp;
grant index on pmh_file to public;
grant select on pmh_file to ods;
