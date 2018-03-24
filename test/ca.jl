@testset "ECA" begin
    @testset "Construction" begin
        let eca = ECA(30)
            @test eca.code == 30
            @test isnull(eca.boundary)
        end

        let eca = ECA(110, 1, 0)
            @test eca.code == 110
            @test !isnull(eca.boundary)
            @test get(eca.boundary) == (1,0)
        end

        let eca = ECA(45, (0,1))
            @test eca.code == 45
            @test !isnull(eca.boundary)
            @test get(eca.boundary) == (0,1)
        end

        let eca = ECA(80, 2, 3)
            @test !isnull(eca.boundary)
            @test get(eca.boundary) == (0,1)
        end

        let eca = ECA(90, (2,3))
            @test !isnull(eca.boundary)
            @test get(eca.boundary) == (0,1)
        end

        @test_throws InexactError ECA(256).code
    end

    @testset "Fire" begin
        let eca = ECA(30), xs = [0,0,1,0,0]
            @test fire(eca, xs) == [0,1,1,1,0]
            @test xs == [0,0,1,0,0]
        end

        let eca = ECA(30), xs = [0,0,0,0,1]
            @test fire(eca, xs) == [1,0,0,1,1]
            @test xs == [0,0,0,0,1]
        end

        let eca = ECA(30, 0, 1), xs = [0,0,1,0,0]
            @test fire(eca, xs) == [0,1,1,1,1]
            @test xs == [0,0,1,0,0]
        end

        let eca = ECA(30, 1, 0), xs = [0,0,0,0,1]
            @test fire(eca, xs) == [1,0,0,1,1]
            @test xs == [0,0,0,0,1]
        end
    end

    @testset "fire! (in-place)" begin
        let eca = ECA(30), xs = [0,0,1,0,0], expect = [0,1,1,1,0]
            @test fire!(eca, xs) == expect
            @test xs == expect
        end

        let eca = ECA(30), xs = [0,0,0,0,1], expect = [1,0,0,1,1]
            @test fire!(eca, xs) == expect
            @test xs == expect
        end

        let eca = ECA(30, 0, 1), xs = [0,0,1,0,0], expect = [0,1,1,1,1]
            @test fire!(eca, xs) == expect
            @test xs == expect
        end

        let eca = ECA(30, 1, 0), xs = [0,0,0,0,1], expect = [1,0,0,1,1]
            @test fire!(eca, xs) == expect
            @test xs == expect
        end
    end

    @testset "fire!" begin
        let eca = ECA(30)
            input, expect = [0,0,1,0,0], [0,1,1,1,0]
            output = similar(input)

            @test fire!(eca, input, output) == expect
            @test output == expect
            @test input == [0,0,1,0,0]
        end

        let eca = ECA(30)
            input, expect = [0,0,0,0,1], [1,0,0,1,1]
            output = similar(input)

            @test fire!(eca, input, output) == expect
            @test output == expect
            @test input == [0,0,0,0,1]
        end

        let eca = ECA(30, 0, 1)
            input, expect = [0,0,1,0,0], [0,1,1,1,1]
            output = similar(input)

            @test fire!(eca, input, output) == expect
            @test output == expect
            @test input == [0,0,1,0,0]
        end

        let eca = ECA(30, 1, 0)
            input, expect = [0,0,0,0,1], [1,0,0,1,1]
            output = similar(input)

            @test fire!(eca, input, output) == expect
            @test output == expect
            @test input == [0,0,0,0,1]
        end
    end
end

