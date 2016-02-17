--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
import Data.Monoid (mappend, mconcat)
import Hakyll
import Text.Pandoc
import System.Environment
import System.Locale (iso8601DateFormat)
--------------------------------------------------------------------------------

-- MathJax as Math backend
pandocOptions :: WriterOptions
pandocOptions = defaultHakyllWriterOptions
    { writerHTMLMathMethod = MathJax ""
    }

myFeedConfiguration :: FeedConfiguration
myFeedConfiguration = FeedConfiguration
    { feedTitle       = "Stefano Rodighiero's blog"
    , feedDescription = ""
    , feedAuthorName  = "Stefano Rodighiero"
    , feedAuthorEmail = "stefano.rodighiero@gmail.com"
    , feedRoot        = "http://stefanorodighiero.net"
    }

main :: IO ()
main = do
  (action:_) <- getArgs
  let previewMode = action == "preview"
      posts       = if previewMode
                    then "posts/*" .||. "drafts/*"
                    else "posts/*"

  hakyll $ do
    match "images/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "js/**" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about.markdown", "talks.markdown", "log.markdown"]) $ do
        route   $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "pocketperl/**" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "projects/**.markdown" $ do
        route $ setExtension "html"
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    tags <- buildTags posts (fromCapture "tags/*.html")
  
    tagsRules tags $ \tag pattern -> do
      let title = "Posts tagged \"" ++ tag ++ "\""
      route idRoute
      compile $ do
        posts <- recentFirst =<< loadAll pattern
        let ctx = constField "title" title
                  `mappend` listField "posts" postCtx (return posts)
                  `mappend` defaultContext
        makeItem ""
          >>= loadAndApplyTemplate "templates/tag.html" ctx
          >>= loadAndApplyTemplate "templates/default.html" ctx
          >>= relativizeUrls

    match posts $ do
        route $ setExtension "html"
        compile $ pandocCompilerWith defaultHakyllReaderOptions pandocOptions
            >>= loadAndApplyTemplate "templates/post.html"    (postCtxWithTags tags)
            >>= saveSnapshot "content"
            >>= loadAndApplyTemplate "templates/default.html" (postCtxWithTags tags)
            >>= relativizeUrls

    create ["archive.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAll posts
            let archiveCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Archives"            `mappend`
                    defaultContext

            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    create ["atom.xml"] $ do
        route idRoute
        compile $ do
            let feedCtx = postCtx `mappend` bodyField "description"
            posts <- fmap (take 10) . recentFirst =<<
                loadAllSnapshots "posts/*" "content"
            renderAtom myFeedConfiguration feedCtx posts

    create ["sitemap.xml"] $ do
        route idRoute
        compile $ do
            posts <- loadAll (("pocketperl/**" .||. "posts/*" .||. "projects/**") .&&. hasNoVersion)
            itemTpl <- loadBody "templates/sitemap-item.xml"
            list <- applyTemplateList itemTpl (sitemapCtx myFeedConfiguration) posts
            makeItem list
                >>= loadAndApplyTemplate "templates/sitemap.xml" defaultContext

    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- fmap (take 10) . recentFirst =<< loadAll posts
            let indexCtx =
                    listField "posts" postCtx (return posts) `mappend`
                    constField "title" "Home"                `mappend`
                    defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateCompiler


--------------------------------------------------------------------------------
postCtx :: Context String
postCtx =
    dateField "date" "%B %e, %Y" `mappend`
    dateField "date.machine" (iso8601DateFormat Nothing) `mappend`
    modificationTimeField "updated.machine" (iso8601DateFormat Nothing) `mappend`
    defaultContext

postCtxWithTags :: Tags -> Context String
postCtxWithTags tags = tagsField "tags" tags `mappend` postCtx

feedCtx :: Context String
feedCtx = mconcat [ postCtx
                  , metadataField
                  ]

sitemapCtx :: FeedConfiguration -> Context String
sitemapCtx conf = mconcat [ constField "root" (feedRoot conf)
                          , feedCtx
                          ]
