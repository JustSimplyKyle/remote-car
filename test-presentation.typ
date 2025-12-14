#import "@preview/numbly:0.1.0": numbly
#import "@preview/timeliney:0.4.0"
#import "@preview/colorful-boxes:1.4.3"
#import "@preview/percencode:0.1.0": percent-decode
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
#import "@preview/touying:0.6.1": *
#import "@preview/pinit:0.2.2": *
#import themes.metropolis: *
// #import "@preview/touying-unistra-pristine:1.4.2": *
#import fletcher.shapes;

#import colorful-boxes: *;

#let formal = false
#let horizontal = true

#if sys.inputs.pairs().len() == 2 {
  formal = if sys.inputs.formal == "true" { true } else { false };
  horizontal = if sys.inputs.horizontal == "true" { true } else { false };
}

#set text(
  lang: "zh",
  region: "tw",
  size: 12pt,
  font: (
    (name: "Manrope", covers: "latin-in-cjk"),
    "Source Han Sans HC",
  ),
) 
#set text(
  font: (
    (name: "Times New Roman", covers: "latin-in-cjk"),
    "TW-MOE-Std-Kai",
  ),
) if formal == true
#set page(
  numbering: numbly("{1}", "第{1}頁/共{2}頁"),
)

#show "贰":"貳"
#show "叁":"參"
#show "陆":"陸"

#show par: set par(first-line-indent: (amount: 2em, all: true))

#show selector(<nonumber>): set heading(
  numbering: none,
)
#show selector(<nooutline>): set heading(
  numbering: none,
  outlined: false,
)

#let noindent(body) = {
  set par(first-line-indent: (amount: 0em))
  body
}


#show outline.entry: it => {
  if it.at("label", default: none) == <processed> {
    return it
  }

  if it.element.at("label", default: none) == <nonumber> {
    return [#text(size: 10pt, fill: luma(100))[#outline.entry(
        it.level * 3 - 4,
        fill: it.fill,
      )[#it.element]  #label("processed")]]
  }

  it
}

#show ref: it => {
  let ele = it.element
  if ele != none and ele.func() == heading {
    let func = ele.numbering
    let depth = counter(heading).at(it.target)
    let out = func(..depth)

    let out = " " + out.trim("、 ")

    [#link(ele.location(), ele.supplement + out) #label("generated-from-ref")]
  } else {
    it
  }
}

#show link: it => {
  if it.at("label", default: none) != <generated-from-ref> {
    return text(blue)[#it]
  }
  it
}

#show bibliography: it => {
  show link: ele => {
    if ele.at("label", default: none) == <processed> {
      return ele
    }

    [#link(ele.dest, percent-decode(ele.body.text)) #label("processed")]
  }
  it
}

#show raw.where(block: false): set text(1em * (5 / 4))

#show raw.where(block: false): it => highlight(
  fill: luma(200),
  extent: 2pt,
)[#it]

#show raw.where(block: true): it => block(
  fill: luma(230),
  inset: 8pt,
  radius: 5pt,
  it,
)



#set heading(
  numbering: numbly(
    "{1:壹}、",
    "{2:一}、 ",
    "{3:（一）}",
  ),
)

#show: metropolis-theme.with(
  aspect-ratio: "4-3",
  footer: self => self.info.title,
  navigation: "none",
  config-info(
    title: [「科技實作（一）」專題課程期中報告],
    author: [薛詠謙、吳彥廷],
    date: datetime.today(),
    institution: [內壢高中],
  ),
  config-page(
    margin: (x: 4em),
  ),
  config-methods(cover: utils.semi-transparent-cover.with(alpha: 85%)),
  config-common(slide-level: 2)
)


#title-slide()

#outline(title: none, indent: 1em, depth: 1)

= 參考圖片
== 參考圖片 <nooutline>
#grid(
  columns: (1fr, 1fr),
  align: horizon + center,
)[
  #figure(
    image("vr1-inspiration.png", height: 12em),
    caption: [深降式吊車]
  )
][
  #figure(
    block(
      inset: (top: -10pt, bottom: -20pt, right: -30pt, left: -40pt),
      clip: true,
      height: 12em,
      image("wheels-powered.png", height: 100%)
    ),
    caption: [齒輪驅動式機械臂]
  ) 
]


#let ball = "任務五"
#let pyrmaid = "任務一"

= 得分策略
== 策略 <nooutline>

#ball (@mission-5) 佔分比重最大。因此我們的策略是以『優先完成任務五』為核心，需確保#highlight(fill: blue.lighten(75%))[機械手臂]具備足夠的*垂直行程*與*穩定性*。次要目標鎖定任務一與二。

 針對平面且無障礙物的地形（@terrain），我們決定不採用四輪驅動（@four-wheels），而是利用兩輪驅動 + 一個萬向輪的三輪車組合，以減少結構複雜性（@three-wheel-blueprint）。

#grid(
  rows: 4,
  columns: 4,
  gutter: 1em,
)[
  #figure(
    image("mission-1.png"),
    caption: [任務一]
  ) #label("mission-1")
][
  #figure(
    image("mission-2.png"),
    caption: [任務二]
  ) #label("mission-2")
][
  #figure(
    image("mission-3.png"),
    caption: [任務三]
  ) #label("mission-3")
][
  #figure(
    image("mission-4.png"),
    caption: [任務四]
  ) #label("mission-4")
][
  #figure(
    image("mission-5.png"),
    caption: [任務五]
  ) #label("mission-5")
][
  #figure(
    image("terrain.png"),
    caption: [地形]
  ) <terrain>
][
  #figure(
    image("four-wheels.png"),
    caption: [四輪車]
  ) <four-wheels>
][
  #figure(
    image("blueprint.png"),
    caption: [三輪車]
  ) <three-wheel-blueprint>
]

= 材料與結構說明
== 材料

+ 300x400mm 之#pin(1)木板#pin(2)\*1
+ 輪子\*2
+ 萬向輪\*1
+ 線繩與滑輪\*1
+ 馬達 2.4Ghz 無線控制板（接收與發射各\*1）
+ esp32#pin(6)
+ TT #pin(4)馬達#pin(5)\*4

#let pinit-highlight-equation-from(height: 2em, pos: bottom, fill: rgb(0, 180, 255), highlight-pins, point-pin, body) = {
  pinit-highlight(..highlight-pins,fill: rgb(..fill.components().slice(0, -1), 50))
  pinit-point-from(
    fill: fill, pin-dx: 0em, pin-dy: if pos == bottom { 0.5em } else { -.9em }, body-dx: 0pt, body-dy: if pos == bottom { -6.2em } else { -0.7em }, offset-dx: 0em, offset-dy: if pos == bottom { 0.8em + height } else { -0.6em - height },
    point-pin,
    rect(
      inset: if pos == bottom { 0.35em } else { (x: 0.5em) },
      stroke: 0em,
      // stroke: (bottom: if pos == bottom { 0.12em + fill }, top: if pos != bottom { 0.12em + fill }),
      {
        // set text(fill: fill)
        body
      }
    )
  )
}

#pinit-point-to(6, pin-dy: -.4em, offset-dy: -.4em, body-dy: -.4em)[用於#highlight(fill: red.lighten(80%))[客製化]遙控器]

#pinit-highlight(1,2)
#pinit-highlight-equation-from((1, 2), (1, 2), height: 8em, pos: top, fill: green.lighten(10%))[
  #box(
    width: 12em,
    stickybox(fill: green.lighten(70%))[
      === 用途 <nooutline>
      + 底版
      + 齒輪（夾子）
      + 機械臂
    ]
  )
]
#pinit-highlight-equation-from((4, 5), (4, 5), height: 5em, pos: bottom, fill: yellow.darken(20%))[
  #box(
    width: 12em,
    stickybox(fill: yellow.lighten(70%))[
      + 兩顆用於後輪驅動
      + 一顆用於機械臂抬升
      + 一顆用於夾子開關
    ]
  )
]

== 機構說明

#grid(
  columns: (1fr, 1fr),
  rows: (1fr, 1pt, 1fr),
  inset: 1em,
  [
    #figure(
      image("clamp-blueprint.png"),
      caption: [夾子之 Rhino 設計稿]
    ) <clamp>
  ],
  [
    如 @clamp 所示，夾具由馬達驅動單側，並藉由*齒輪*傳動，使兩側呈對稱開合以夾取物體。
  ],
  grid.cell(
    colspan: 2,
    [
      #line(length: 100%)
      #pause
    ]
  ),
  [
    #figure(
      image("puller-blueprint.png"),
      caption: [機械臂之 Rhino 設計稿]
    ) <arm-blueprint>
  ],
  [
    如 @arm-blueprint 所示，機械臂的升降機構，是利用*對側*之馬達進行牽引帶動。
  ],
)

= 專案管理
== 甘特圖 <nooutline>
#figure(
  caption: figure.caption(position: top)[
    #highlight(
      fill: luma(200),
    )[Nxx = Nov. xx, Dxx = Dec.xx]],
  kind: table,
)[
  #set text(size: 0.9em)
  #timeliney.timeline(
    show-grid: true,
    {
      import timeliney: *

      headerline(group(([保麗龍打樣及測試], 4)), group(([木板設計、組裝與除錯], 4)))
      headerline(
        group(..("N14", "N21", "N26", "N28", "D03", "D05", "D12", "D19")),
        // group(range(13,20).map(n => strong("10/" + str(n)))),
      )

      taskgroup(
        title: [*底版設計*],
        style: (stroke: 5pt + black),
        {
          task(
            "打樣的切割與組裝",
            (from: 0, to: 1),
            style: (stroke: 2pt + gray),
          )
          task(
            "無線控制模組",
            (from: 1, to: 2),
            style: (stroke: 2pt + gray),
          )
        },
      )

      taskgroup(
        title: [*機械臂與夾子設計*],
        style: (stroke: 5pt + blue),
        {
          task("線拉式軌道系統", (.5, 1), style: (stroke: 2pt + aqua))
          task("齒輪驅動機械臂", (1, 3), style: (stroke: 2pt + aqua))
          task("線拉式機械臂", (3, 4), style: (stroke: 2pt + aqua))
        },
      )

      taskgroup(
        // title: [*成果展現*],
        style: (stroke: 5pt + red),
        {
          task("rhino 初稿", (4, 5), style: (stroke: 2pt + maroon))
          task("木板及輪胎組裝", (5, 6), style: (stroke: 2pt + maroon))
          task("機械臂組裝", (6, 8), style: (stroke: 2pt + maroon))
        },
      )
    },
  )
]


= 打樣作品及修改記錄
== 線拉式軌道系統

#grid(
  columns: (1fr, 1fr, 1fr),
  align: horizon + center,
)[
  #figure(
    image("vr1-inspiration.png", height: 8em),
    caption: [深降式吊車]
  ) <inspiration>
][
  #figure(
    block(
      inset: (top: -10pt, bottom: -20pt, right: -30pt, left: -40pt),
      clip: true,
      height: 8em,
      image("linear-trailing-system.png", height: 100%)
    ),
    caption: [機身打樣前視圖]
  ) <linear-trailing-system-base>
][
  #figure(
    block(
      inset: (top: -20pt, bottom: -40pt, right: -67pt, left: -60pt),
      clip: true,
      height: 8em,
      image("linear-trailing-system-claw.png")
    ),
    caption: [夾子打樣式樣]
  ) <linear-trailing-system-claw>
  
]

此設計為最一開始想到的最簡可行產品(MVC)，此設計受 @inspiration 啟發，只花了我們不到一小時就組裝完成並且成功測試（見 @linear-trailing-system-base）。由 @linear-trailing-system-claw 可見，夾子*沒有*馬達驅動，我們設想單純利用*固定式*之夾子設計即可成功拿到球，但遇到以下問題：由於下降時是依靠重力，而非馬達，會受配重及摩擦力影響。

#show table: it => block(stroke: 1pt, radius: 1em, clip: true, it)

#let title(string, body) = {
  box(height: 6em, width: 100%)[
    #grid(
      // stroke: 1pt + red,
      columns: 1fr,
      inset: .8em,
      rows: (1fr, 5fr)
    )[
      #align(center + horizon)[
         === #string <nooutline>
      ]
    ][
      #set text(size: 0.8em)
      #set align(top)
      #body
    ]
  ]
}

#let swot(arr, capt) = {
  figure(
    caption: capt + "之 SWOT 分析",
    table(
      rows: 2,
      stroke: 1pt,
      align: left,
      columns: (1fr, 1fr),
      inset: 1em,
      fill: (x, y) => {
        if (x,y) == (0,0) {
          green
        } else if (x,y) == (1,0){
          blue
        } else if (x,y) == (0,1) {
          yellow
        } else if (x,y) == (1,1) {
          orange
        }.lighten(65%)
      }
    )[
      #title("優勢", arr.at(0))
    ][
      #title("劣勢", arr.at(1))
    ][
      #title("機會", arr.at(2))
    ][
      #title("威脅", arr.at(3))
    ]
  )
}

#swot(
  (
    [
      - 運動部件少，只存在拉繩馬達。
      - 較易操作，上下調整精細度高。
    ],
    [
      - 夾子的寬度需要非常剛好才可以夾起球。
      - 下降時穩定性不足，有時會卡住無法移動。
    ],
    [
      - #ball
      - #pyrmaid
      兩者皆為「將物品抬升」的任務，與此設計契合度高。
    ],
    [
      其餘任務利用此系統皆不易達成。
    ]
  ),
  "線拉式軌道系統"
)

此設計本質上就是*簡易*、*不易出錯*，但也#highlight(fill: aqua.lighten(50%))[不易擴充]。我們希望能夠達成更多的任務，因此決定從頭再來，重新設計一個更萬用的機械臂。

== 嘗試：齒輪驅動機械臂

#colorbox(
  color: (fill: luma(200)),
  stroke: 0pt,
)[
  #set align(center)
  #set text(fill: luma(50))
  線拉式軌道系統的重力下降問題困擾著我們。於是我們想：\
  『既然靠重力會卡住，那不如直接用馬達和齒輪硬轉下去吧？』
]

#grid(
  columns: (1fr, 1.5fr),
  gutter: 2em,
  align: horizon,
  [
    #figure(
      rect(width: 100%, height: 8em, fill: orange.lighten(90%), radius: 5pt)[
        #align(center+horizon)[齒輪直驅結構]
      ],
      caption: [全齒輪驅動設計]
    )
  ],
  [
    === 設計特點 <nooutline>
    利用馬達直接帶動齒輪，強制帶動機械臂上下移動。

    === 解決問題 <nooutline>
    提供穩定的下壓力量，從根本上解決了「下不來」的問題。,
    === 衍生問題 <nooutline>
    #list(marker: ([\u{26A0}]),
      [*速度過快*：齒輪比導致移動太靈敏，難以精準對齊球體。],
      [*控制僵硬*：缺乏緩衝，操作容錯率極低。]
    )
  ]
)

== 最終解：線拉式機械臂

#colorbox(
  color: (fill: blue.lighten(80%)),
  stroke: 0pt,
)[
  #set align(center)
  #set text(fill: blue.darken(30%))
  我們意識到，雖然齒輪有力，但我們第一代線的精確控制也好用。\
  於是決定：『保留線拉的精準度，融合齒輪的穩定性。』
]

#grid(
  columns: (1fr, 1.5fr),
  gutter: 2em,
  align: horizon,
  [
    // 左側放示意圖
    #figure(
      rect(width: 100%, height: 8em, fill: teal.lighten(80%), radius: 5pt)[
        #align(center+horizon)[線拉 +夾爪]
      ],
      caption: [混合式驅動設計]
    )
  ],
  [
    === 融合設計
    - 升降機構：回歸馬達拉線 -> \ 取其*精準*與細膩控制。
    - 夾持機構：保留齒輪驅動 -> \ 取其*穩定*與抓取力度。

    #v(1em)
    #block(stroke: (left: 4pt + teal), fill: teal.lighten(80%), inset: 1em)[
      此設計融合了線拉式機械臂的精準性還有齒輪驅動的穩定性，
      形成一個既易控制，也易於擴充的形態。
    ]
  ]
)

= 目前進度
== 目前進度
#grid(
  columns: (8fr, 2fr),
  column-gutter: 5pt,
  row-gutter: 5pt,
)[
  === 打樣(100%)
  於 11/14 完成 MVC，在 11/28 已完成最終草稿測試。
][
  #set text(0.5em)
  #figure(
    image("blueprint.png"),
    caption: [#link("https://touying-typ.github.io/docs/dynamic/cover")[測試影片]]
  )
  #pause
][
  === Rhino 設計稿(100%)
  於 12/03 完成初設計，12/12 Debug 完成。
][
  #set text(0.5em)
  #figure(
    image("blueprint.png"),
    caption: []
  )
  #pause
][
  === 雷切組裝(100%)
  於 12/08 完成初步組裝，12/12 Debug 完成。
][
  #set text(0.5em)
  #figure(
    image("blueprint.png"),
    caption: [#link("https://touying-typ.github.io/docs/dynamic/cover")[測試影片]]
  )
]
= 所遇困難
== fuck
arst
= 改進空間
== fuck
arst
